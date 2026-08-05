import '../import.dart';

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color foregroundColor;
  const WeatherInfoTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      required this.unit,
      required this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final displayValue = '$value$unit';
    final textShadows = foregroundColor.computeLuminance() > 0.5
        ? <Shadow>[
            Shadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ]
        : const <Shadow>[];

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: '$label: $displayValue',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Match the flat icon-and-value language used by Home forecasts.
            Icon(
              icon,
              size: 24,
              color: foregroundColor.withValues(alpha: 0.82),
              shadows: textShadows,
            ),
            const SizedBox(height: 6),
            Text(
              displayValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                shadows: textShadows,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.labelMedium?.copyWith(
                color: foregroundColor.withValues(alpha: 0.72),
                shadows: textShadows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
