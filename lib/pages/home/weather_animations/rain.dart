import 'dart:ui' as ui;

import '../import.dart';

/// Tracks rendered Home components that can intercept rain drops.
class RainCollisionController {
  final Set<_RainCollisionRenderBox> _surfaces = <_RainCollisionRenderBox>{};

  void _register(_RainCollisionRenderBox surface) => _surfaces.add(surface);

  void _unregister(_RainCollisionRenderBox surface) =>
      _surfaces.remove(surface);

  List<_RainCollisionRegion> _regionsFor(RenderBox rainBox) {
    final viewport = Offset.zero & rainBox.size;
    final regions = <_RainCollisionRegion>[];

    // Resolve positions from the current render tree on every frame so
    // scrolling and layout changes never require hard-coded coordinates.
    for (final surface in List<_RainCollisionRenderBox>.of(_surfaces)) {
      if (!surface.attached || !surface.hasSize || surface.size.isEmpty) {
        continue;
      }

      final topLeft = rainBox.globalToLocal(
        surface.localToGlobal(Offset.zero),
      );
      final bottomRight = rainBox.globalToLocal(
        surface.localToGlobal(surface.size.bottomRight(Offset.zero)),
      );
      var rect = Rect.fromPoints(topLeft, bottomRight);

      // A scrolled child can remain laid out outside its visible ListView.
      final scrollViewport = RenderAbstractViewport.maybeOf(surface);
      if (scrollViewport case final RenderBox scrollBox
          when scrollBox.hasSize) {
        rect = rect.intersect(
          MatrixUtils.transformRect(
            scrollBox.getTransformTo(rainBox),
            Offset.zero & scrollBox.size,
          ),
        );
      }

      if (rect.width > 0 && rect.height > 0 && rect.overlaps(viewport)) {
        regions.add(_RainCollisionRegion(rect));
      }
    }

    return regions;
  }
}

/// Marks a widget's actual rendered bounds as a rain collision surface.
class RainCollisionSurface extends SingleChildRenderObjectWidget {
  final RainCollisionController controller;

  const RainCollisionSurface({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RainCollisionRenderBox(controller);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) {
    (renderObject as _RainCollisionRenderBox).controller = controller;
  }
}

class _RainCollisionRenderBox extends RenderProxyBox {
  _RainCollisionRenderBox(this._controller);

  RainCollisionController _controller;

  set controller(RainCollisionController value) {
    if (identical(value, _controller)) return;
    if (attached) _controller._unregister(this);
    _controller = value;
    if (attached) _controller._register(this);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller._register(this);
  }

  @override
  void detach() {
    _controller._unregister(this);
    super.detach();
  }
}

class RainAnimation extends StatefulWidget {
  final int dropCount;
  final double maxHeight;
  final RainCollisionController? collisionController;

  const RainAnimation({
    super.key,
    this.dropCount = 64,
    required this.maxHeight,
    this.collisionController,
  });

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  final GlobalKey _paintKey = GlobalKey();
  final Random _random = Random();
  late final AnimationController _controller;
  late final _RainSimulation _simulation;

  @override
  void initState() {
    super.initState();
    _simulation = _RainSimulation(_random, widget.dropCount);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant RainAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dropCount != widget.dropCount) {
      _simulation.setDropCount(widget.dropCount);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_RainCollisionRegion> _collisionRegions() {
    final rainBox = _paintKey.currentContext?.findRenderObject();
    if (rainBox is! RenderBox || !rainBox.hasSize) {
      return const <_RainCollisionRegion>[];
    }
    return widget.collisionController?._regionsFor(rainBox) ??
        const <_RainCollisionRegion>[];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.maxHeight,
      child: RepaintBoundary(
        child: CustomPaint(
          key: _paintKey,
          isComplex: true,
          willChange: true,
          painter: _RainPainter(
            simulation: _simulation,
            controller: _controller,
            collisionRegions: _collisionRegions,
          ),
        ),
      ),
    );
  }
}

/// Advances independent drops with gravity, wind, first-hit collision, and
/// short-lived impact spray. State is retained across painter instances.
class _RainSimulation {
  _RainSimulation(Random random, int dropCount)
      : _random = random,
        _targetDropCount = dropCount < 0 ? 0 : dropCount,
        _baseWind = (random.nextDouble() - 0.5) * 110;

  static const double _dropGravity = 820;
  static const double _sprayGravity = 520;
  static const int _maxSplashes = 80;

  final Random _random;
  final double _baseWind;
  final List<_RainDrop> _drops = <_RainDrop>[];
  final List<_RainSplash> _splashes = <_RainSplash>[];
  int _targetDropCount;
  Duration? _lastElapsed;
  Size _canvasSize = Size.zero;
  double _elapsedSeconds = 0;

  void setDropCount(int value) {
    _targetDropCount = value < 0 ? 0 : value;
    if (_drops.length > _targetDropCount) {
      _drops.removeRange(_targetDropCount, _drops.length);
    }
  }

  void paint(
    Canvas canvas,
    Size size,
    Duration elapsed,
    List<_RainCollisionRegion> collisionRegions,
  ) {
    if (size.isEmpty) return;

    _resizeIfNeeded(size);
    _syncDropCount(size);
    final deltaSeconds = _frameDelta(elapsed);
    if (deltaSeconds > 0) {
      _elapsedSeconds += deltaSeconds;
      _advanceDrops(deltaSeconds, size, collisionRegions);
      _advanceSplashes(deltaSeconds);
    }

    _drawDrops(canvas);
    _drawSplashes(canvas);
  }

  void _resizeIfNeeded(Size size) {
    if (_canvasSize == size) return;
    if (!_canvasSize.isEmpty) {
      final scaleX = size.width / _canvasSize.width;
      final scaleY = size.height / _canvasSize.height;
      for (final drop in _drops) {
        drop.position = Offset(
          drop.position.dx * scaleX,
          drop.position.dy * scaleY,
        );
      }
      _splashes.clear();
    }
    _canvasSize = size;
  }

  void _syncDropCount(Size size) {
    final isInitialFrame = _lastElapsed == null;
    while (_drops.length < _targetDropCount) {
      _drops.add(
        _RainDrop.spawn(
          _random,
          size,
          _baseWind,
          initial: isInitialFrame,
        ),
      );
    }
  }

  double _frameDelta(Duration elapsed) {
    final previous = _lastElapsed;
    _lastElapsed = elapsed;
    if (previous == null || elapsed < previous) return 0;
    final seconds = (elapsed - previous).inMicroseconds / 1000000;
    return min(seconds, 1 / 30).toDouble();
  }

  void _advanceDrops(
    double deltaSeconds,
    Size size,
    List<_RainCollisionRegion> collisionRegions,
  ) {
    for (var i = 0; i < _drops.length; i++) {
      final drop = _drops[i];
      if (drop.delay > 0) {
        drop.delay -= deltaSeconds;
        continue;
      }

      final gust = sin(_elapsedSeconds * 1.35 + drop.gustPhase) * 22 +
          sin(_elapsedSeconds * 0.48 + drop.gustPhase * 0.37) * 14;
      final targetWind =
          _baseWind * (0.55 + drop.depth * 0.45) + drop.windBias + gust;
      final windBlend = min(1.0, deltaSeconds * (1.4 + drop.depth));
      final velocityX =
          drop.velocity.dx + (targetWind - drop.velocity.dx) * windBlend;
      final velocityY = min(
        drop.terminalSpeed,
        drop.velocity.dy + _dropGravity * deltaSeconds,
      ).toDouble();
      drop.velocity = Offset(velocityX, velocityY);

      final previousPosition = drop.position;
      final nextPosition = previousPosition + drop.velocity * deltaSeconds;
      final hit = _firstRainHit(
        previousPosition,
        nextPosition,
        collisionRegions,
      );

      if (hit != null) {
        if (hit.position.dy >= -4 && hit.position.dy <= size.height + 4) {
          _addSplash(hit, drop);
        }
        _drops[i] = _RainDrop.spawn(
          _random,
          size,
          _baseWind,
        );
        continue;
      }

      drop.position = nextPosition;
      final isOutside = drop.position.dy - drop.length > size.height + 24 ||
          drop.position.dx < -64 ||
          drop.position.dx > size.width + 64;
      if (isOutside) {
        _drops[i] = _RainDrop.spawn(
          _random,
          size,
          _baseWind,
        );
      }
    }
  }

  void _addSplash(_RainHit hit, _RainDrop drop) {
    if (_splashes.length >= _maxSplashes) {
      _splashes.removeAt(0);
    }
    _splashes.add(
      _RainSplash.fromImpact(
        random: _random,
        origin: hit.position,
        normal: hit.normal,
        incomingVelocity: drop.velocity,
        depth: drop.depth,
      ),
    );
  }

  void _advanceSplashes(double deltaSeconds) {
    for (final splash in _splashes) {
      splash.age += deltaSeconds;
    }
    _splashes.removeWhere((splash) => splash.age >= splash.lifetime);
  }

  void _drawDrops(Canvas canvas) {
    final trailPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final highlightPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final drop in _drops) {
      if (drop.delay > 0 || drop.velocity.distanceSquared < 1) continue;

      final direction = drop.velocity / drop.velocity.distance;
      final tail = drop.position - direction * drop.length;
      final color = Color.lerp(
        const Color(0xFF8CA8B8),
        const Color(0xFFDDEEF5),
        drop.depth,
      )!;
      trailPaint
        ..strokeWidth = drop.thickness * 1.12
        ..shader = ui.Gradient.linear(
          tail,
          drop.position,
          <Color>[
            color.withValues(alpha: 0),
            color.withValues(alpha: drop.opacity * 0.12),
            color.withValues(alpha: drop.opacity * 0.68),
          ],
          <double>[0, 0.46, 1],
        );
      canvas.drawLine(tail, drop.position, trailPaint);

      // A short, fine highlight suggests refraction without turning the
      // entire streak into an opaque, plastic-looking capsule.
      final highlightLength = drop.length * _lerp(0.2, 0.34, drop.depth);
      final highlightColor = Color.lerp(
        color,
        const Color(0xFFF7FCFF),
        0.58,
      )!;
      highlightPaint
        ..strokeWidth = max(0.28, drop.thickness * 0.34).toDouble()
        ..color = highlightColor.withValues(alpha: drop.opacity * 0.5);
      canvas.drawLine(
        drop.position - direction * highlightLength,
        drop.position,
        highlightPaint,
      );
    }
  }

  void _drawSplashes(Canvas canvas) {
    // Reuse mutable paints across fragments to avoid per-frame allocations.
    final footprintPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.7;
    final fragmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final splash in _splashes) {
      final progress = splash.age / splash.lifetime;
      final opacity = pow(1 - progress, 2).toDouble();
      final tangent = Offset(-splash.normal.dy, splash.normal.dx);
      final spread = (3 + splash.impact * 7) * (0.35 + progress * 0.65);
      footprintPaint.color =
          const Color(0xFFD9F1FC).withValues(alpha: opacity * 0.55);
      canvas.drawLine(
        splash.origin - tangent * spread,
        splash.origin + tangent * spread,
        footprintPaint,
      );

      final gravityOffset =
          Offset(0, 0.5 * _sprayGravity * splash.age * splash.age);
      fragmentPaint.color =
          const Color(0xFFE3F6FF).withValues(alpha: opacity * 0.8);
      for (final fragment in splash.fragments) {
        final position =
            splash.origin + fragment.velocity * splash.age + gravityOffset;
        final speed = fragment.velocity.distance;
        final direction = speed > 0 ? fragment.velocity / speed : Offset.zero;
        fragmentPaint.strokeWidth = fragment.thickness;
        canvas.drawLine(
          position - direction * (1.5 + fragment.thickness),
          position,
          fragmentPaint,
        );
      }
    }
  }
}

class _RainDrop {
  _RainDrop({
    required this.position,
    required this.velocity,
    required this.terminalSpeed,
    required this.length,
    required this.thickness,
    required this.opacity,
    required this.depth,
    required this.windBias,
    required this.gustPhase,
    required this.delay,
  });

  Offset position;
  Offset velocity;
  final double terminalSpeed;
  final double length;
  final double thickness;
  final double opacity;
  final double depth;
  final double windBias;
  final double gustPhase;
  double delay;

  factory _RainDrop.spawn(
    Random random,
    Size size,
    double baseWind, {
    bool initial = false,
  }) {
    // Most streaks stay fine and distant while a small foreground layer
    // supplies the occasional large drop found in natural rainfall.
    final isForeground = random.nextDouble() < 0.18;
    final depth = isForeground
        ? _lerp(
            0.68,
            1,
            pow(random.nextDouble(), 0.75).toDouble(),
          )
        : pow(random.nextDouble(), 1.35).toDouble() * 0.86;
    final terminalSpeed =
        _lerp(680, 1450, depth) * _lerp(0.88, 1.12, random.nextDouble());
    final windBias = _lerp(-38, 38, random.nextDouble());
    final margin = max(28.0, size.width * 0.12).toDouble();
    final respawnRange = min(360.0, max(180.0, size.height * 0.45)).toDouble();
    final positionY = initial
        ? -random.nextDouble() * (size.height + 160)
        : -_lerp(
            12,
            respawnRange,
            pow(random.nextDouble(), 1.6).toDouble(),
          );
    final exposure = _lerp(0.014, 0.024, random.nextDouble());

    return _RainDrop(
      position: Offset(
        -margin + random.nextDouble() * (size.width + margin * 2),
        positionY,
      ),
      velocity: Offset(
        baseWind * (0.55 + depth * 0.45) + windBias,
        terminalSpeed * _lerp(0.66, 0.94, random.nextDouble()),
      ),
      terminalSpeed: terminalSpeed,
      // Tie motion-blur length to velocity so faster foreground drops leave
      // longer streaks instead of uniformly sized lines.
      length: terminalSpeed * exposure * _lerp(0.9, 1.1, random.nextDouble()),
      thickness:
          _lerp(0.46, 1.65, depth) * _lerp(0.86, 1.12, random.nextDouble()),
      opacity: (_lerp(0.12, 0.4, depth) * _lerp(0.84, 1.1, random.nextDouble()))
          .clamp(0.1, 0.42)
          .toDouble(),
      depth: depth,
      windBias: windBias,
      gustPhase: random.nextDouble() * pi * 2,
      delay: initial ? 0 : _sampleRainSpawnDelay(random),
    );
  }
}

class _RainSplash {
  _RainSplash({
    required this.origin,
    required this.normal,
    required this.fragments,
    required this.lifetime,
    required this.impact,
  });

  final Offset origin;
  final Offset normal;
  final List<_RainSplashFragment> fragments;
  final double lifetime;
  final double impact;
  double age = 0;

  factory _RainSplash.fromImpact({
    required Random random,
    required Offset origin,
    required Offset normal,
    required Offset incomingVelocity,
    required double depth,
  }) {
    final dot =
        incomingVelocity.dx * normal.dx + incomingVelocity.dy * normal.dy;
    final reflected = incomingVelocity - normal * (2 * dot);
    final reflectedDirection = reflected.distanceSquared > 0
        ? reflected / reflected.distance
        : -normal;
    final baseAngle = atan2(reflectedDirection.dy, reflectedDirection.dx);
    final fragmentCount = 3 + (depth * 4).round() + random.nextInt(2);
    final fragments = List<_RainSplashFragment>.generate(fragmentCount, (_) {
      final angle = baseAngle + _lerp(-0.72, 0.72, random.nextDouble());
      final speed =
          _lerp(42, 132, depth) * _lerp(0.65, 1.12, random.nextDouble());
      return _RainSplashFragment(
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        thickness:
            _lerp(0.45, 1.05, depth) * _lerp(0.78, 1.15, random.nextDouble()),
      );
    });

    return _RainSplash(
      origin: origin,
      normal: normal,
      fragments: fragments,
      lifetime: _lerp(0.2, 0.32, random.nextDouble()),
      impact: depth,
    );
  }
}

class _RainSplashFragment {
  const _RainSplashFragment({
    required this.velocity,
    required this.thickness,
  });

  final Offset velocity;
  final double thickness;
}

/// Repaints the retained simulation directly from the animation ticker.
class _RainPainter extends CustomPainter {
  _RainPainter({
    required this.simulation,
    required this.controller,
    required this.collisionRegions,
  }) : super(repaint: controller);

  final _RainSimulation simulation;
  final AnimationController controller;
  final List<_RainCollisionRegion> Function() collisionRegions;

  @override
  void paint(Canvas canvas, Size size) {
    simulation.paint(
      canvas,
      size,
      controller.lastElapsedDuration ?? Duration.zero,
      collisionRegions(),
    );
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) {
    return !identical(simulation, oldDelegate.simulation) ||
        !identical(controller, oldDelegate.controller) ||
        collisionRegions != oldDelegate.collisionRegions;
  }
}

class _RainCollisionRegion {
  const _RainCollisionRegion(this.rect);

  final Rect rect;
}

class _RainHit {
  const _RainHit({
    required this.position,
    required this.normal,
    required this.progress,
  });

  final Offset position;
  final Offset normal;
  final double progress;
}

/// Returns only the earliest surface crossed by a drop, which prevents a
/// blocked drop from reaching any component below that surface.
_RainHit? _firstRainHit(
  Offset start,
  Offset end,
  List<_RainCollisionRegion> regions,
) {
  _RainHit? firstHit;
  for (final region in regions) {
    final hit = _segmentRectHit(start, end, region.rect);
    if (hit != null && (firstHit == null || hit.progress < firstHit.progress)) {
      firstHit = hit;
    }
  }
  return firstHit;
}

_RainHit? _segmentRectHit(Offset start, Offset end, Rect rect) {
  final delta = end - start;
  if (rect.contains(start)) {
    return _RainHit(
      position: start,
      normal: delta.dy >= 0 ? const Offset(0, -1) : const Offset(0, 1),
      progress: 0,
    );
  }

  var entry = 0.0;
  var exit = 1.0;
  var entryNormal = Offset.zero;

  bool clipAxis(
    double origin,
    double movement,
    double minimum,
    double maximum,
    Offset minimumNormal,
    Offset maximumNormal,
  ) {
    if (movement.abs() < 0.000001) {
      return origin >= minimum && origin <= maximum;
    }

    var near = (minimum - origin) / movement;
    var far = (maximum - origin) / movement;
    var nearNormal = minimumNormal;
    var farNormal = maximumNormal;
    if (near > far) {
      final oldNear = near;
      near = far;
      far = oldNear;
      final oldNormal = nearNormal;
      nearNormal = farNormal;
      farNormal = oldNormal;
    }

    if (near > entry) {
      entry = near;
      entryNormal = nearNormal;
    }
    exit = min(exit, far).toDouble();
    return entry <= exit;
  }

  final crossesX = clipAxis(
    start.dx,
    delta.dx,
    rect.left,
    rect.right,
    const Offset(-1, 0),
    const Offset(1, 0),
  );
  final crossesY = clipAxis(
    start.dy,
    delta.dy,
    rect.top,
    rect.bottom,
    const Offset(0, -1),
    const Offset(0, 1),
  );
  if (!crossesX || !crossesY || entry < 0 || entry > 1) return null;

  if (entryNormal == Offset.zero) {
    entryNormal = delta.dy >= 0 ? const Offset(0, -1) : const Offset(0, 1);
  }
  return _RainHit(
    position: start + delta * entry,
    normal: entryNormal,
    progress: entry,
  );
}

double _lerp(double start, double end, double progress) {
  return start + (end - start) * progress;
}

double _sampleRainSpawnDelay(Random random) {
  // Independent exponential waits are memoryless, preventing completed drops
  // from respawning together in visible waves while retaining natural clumps.
  const meanDelay = 0.18;
  const maxDelay = 1.4;
  final delay = -log(1 - random.nextDouble()) * meanDelay;
  return min(delay, maxDelay).toDouble();
}
