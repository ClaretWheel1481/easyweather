import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zephyr/app_constants.dart';
import 'package:zephyr/core/models/city.dart';
import 'package:zephyr/core/services/map_tile_cache.dart';
import 'package:zephyr/core/services/rainviewer_service.dart';
import 'package:zephyr/core/services/weather_cache.dart';
import 'package:zephyr/l10n/generated/app_localizations.dart';

class WeatherMap extends StatelessWidget {
  final City city;

  const WeatherMap({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 200,
        child: OpenContainer(
          transitionType: ContainerTransitionType.fade,
          closedElevation: 3,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          closedColor: colorScheme.surface,
          openColor: colorScheme.surface,
          closedBuilder: (context, openContainer) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // The preview is visual only so its map gestures cannot
                  // prevent OpenContainer from receiving the tap.
                  IgnorePointer(
                    child: _WeatherMapContent(
                      key: ValueKey('${city.lat}_${city.lon}_preview'),
                      city: city,
                      interactive: false,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: openContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ],
              ),
            );
          },
          openBuilder: (context, _) => WeatherMapFullPage(city: city),
        ),
      ),
    );
  }
}

class WeatherMapFullPage extends StatelessWidget {
  final City city;

  const WeatherMapFullPage({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).weatherMap)),
      body: _WeatherMapContent(
        key: ValueKey('${city.lat}_${city.lon}_full'),
        city: city,
        interactive: true,
      ),
    );
  }
}

class _WeatherMapContent extends StatefulWidget {
  final City city;
  final bool interactive;

  const _WeatherMapContent({
    super.key,
    required this.city,
    required this.interactive,
  });

  @override
  State<_WeatherMapContent> createState() => _WeatherMapContentState();
}

class _WeatherMapContentState extends State<_WeatherMapContent> {
  static const _fullMapMinZoom = 3.0;
  static const _fullMapMaxZoom = 12.0;
  late final Future<String?> _radarTileTemplate;
  late final Future<CacheStore> _tileCacheStore;
  late final MapController _mapController;
  Dio? _tileDio;
  CachedTileProvider? _tileProvider;
  double _zoom = 7;

  @override
  void initState() {
    super.initState();
    // Loads a single current RainViewer frame for this map instance.
    _radarTileTemplate = RainViewerService.getLatestRadarTileTemplate();
    // Opens the shared file cache before either map layer requests tiles.
    _tileCacheStore = MapTileCache.store;
    _mapController = MapController();
  }

  @override
  void dispose() {
    // Closes the tile HTTP client when this map leaves the widget tree.
    _tileDio?.close(force: true);
    super.dispose();
  }

  CachedTileProvider _getTileProvider(CacheStore store) {
    return _tileProvider ??= CachedTileProvider(
      store: store,
      dio: _tileDio ??= Dio(),
      maxStale: weatherCacheMaxAge,
      hitCacheOnNetworkFailure: true,
      headers: {
        'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}'
      },
    );
  }

  // Moves the full-screen map while keeping slider and gesture zoom in sync.
  void _setZoom(double zoom) {
    final targetZoom = zoom.clamp(_fullMapMinZoom, _fullMapMaxZoom).toDouble();
    _mapController.move(_mapController.camera.center, targetZoom);
  }

  void _handlePositionChanged(MapCamera camera, bool _) {
    if (!widget.interactive || (camera.zoom - _zoom).abs() < 0.01) return;
    setState(() => _zoom = camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final center = LatLng(widget.city.lat, widget.city.lon);
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<CacheStore>(
      future: _tileCacheStore,
      builder: (context, cacheSnapshot) {
        if (!cacheSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tileProvider = _getTileProvider(cacheSnapshot.data!);

        return FutureBuilder<String?>(
          future: _radarTileTemplate,
          builder: (context, snapshot) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: widget.interactive ? 7 : 5,
                    minZoom: widget.interactive ? _fullMapMinZoom : null,
                    maxZoom: widget.interactive ? _fullMapMaxZoom : null,
                    onPositionChanged: _handlePositionChanged,
                    interactionOptions: InteractionOptions(
                      // Keeps pan and zoom gestures while preventing rotation.
                      flags: widget.interactive
                          ? InteractiveFlag.all & ~InteractiveFlag.rotate
                          : InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppConstants.openStreetMapTileUrl,
                      userAgentPackageName: 'space.claret.zephyr',
                      tileProvider: tileProvider,
                      // Combines higher-zoom OSM tiles to keep high-DPI maps sharp.
                      retinaMode: RetinaMode.isHighDensity(context),
                    ),
                    if (snapshot.data != null)
                      Opacity(
                        // Keeps the base map readable beneath radar imagery.
                        opacity: 0.55,
                        child: TileLayer(
                          urlTemplate: snapshot.data!,
                          maxNativeZoom: 7,
                          tileProvider: tileProvider,
                        ),
                      ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: center,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.red,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: CircularProgressIndicator()),
                if (widget.interactive)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Material(
                      color: colorScheme.surfaceContainerHigh
                          .withValues(alpha: 0.82),
                      elevation: 3,
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: 48,
                        height: 216,
                        child: Column(
                          children: [
                            IconButton(
                              tooltip: 'Zoom in',
                              onPressed: _zoom >= _fullMapMaxZoom
                                  ? null
                                  : () => _setZoom(_zoom + 1),
                              icon: const Icon(Icons.add),
                            ),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  value: _zoom,
                                  min: _fullMapMinZoom,
                                  max: _fullMapMaxZoom,
                                  divisions: 18,
                                  label: _zoom.toStringAsFixed(1),
                                  onChanged: _setZoom,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Zoom out',
                              onPressed: _zoom <= _fullMapMinZoom
                                  ? null
                                  : () => _setZoom(_zoom - 1),
                              icon: const Icon(Icons.remove),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Material(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => launchUrl(
                        Uri.parse('https://www.rainviewer.com/'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        child: Text(
                          '© OpenStreetMap contributors · RainViewer',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
