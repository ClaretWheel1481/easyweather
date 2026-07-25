import 'dart:ui';
import 'import.dart';

class LayoutComponent {
  final String id;
  bool isVisible;

  LayoutComponent({required this.id, required this.isVisible});
}

class LayoutSettingsView extends StatefulWidget {
  const LayoutSettingsView({super.key});

  @override
  State<LayoutSettingsView> createState() => _LayoutSettingsViewState();
}

class _LayoutSettingsViewState extends State<LayoutSettingsView> {
  final LayoutService _layoutService = LayoutService();
  List<LayoutComponent> _components = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLayout();
  }

  Future<void> _loadLayout() async {
    final allComponentIds = _layoutService.getDefaultLayout();
    final visibleComponentIds = await _layoutService.getLayout();

    setState(() {
      _components = allComponentIds.map((id) {
        return LayoutComponent(
            id: id, isVisible: visibleComponentIds.contains(id));
      }).toList();

      _components.sort((a, b) {
        final aIndex = visibleComponentIds.indexOf(a.id);
        final bIndex = visibleComponentIds.indexOf(b.id);
        if (a.isVisible && b.isVisible) {
          return aIndex.compareTo(bIndex);
        }
        if (a.isVisible) return -1;
        if (b.isVisible) return 1;
        return 0;
      });

      _isLoading = false;
    });
  }

  Future<void> _saveLayout() async {
    final visibleLayout =
        _components.where((c) => c.isVisible).map((c) => c.id).toList();
    await _layoutService.saveLayout(visibleLayout);
    if (mounted) {
      NotificationUtils.showSnackBar(
          context, AppLocalizations.of(context).customizeHomepageSaved);
      Navigator.of(context).pop();
    }
  }

  IconData _getComponentIcon(String id) {
    switch (id) {
      case 'hourly_forecast':
        return Icons.access_time_rounded;
      case 'rainfall_chart':
        return Icons.water_drop_rounded;
      case 'daily_forecast':
        return Icons.calendar_today_rounded;
      case 'ai_advice':
        return Icons.psychology_rounded;
      case 'details':
        return Icons.info_outline_rounded;
      case 'weather_map':
        return Icons.map_rounded;
      default:
        return Icons.dashboard_customize_rounded;
    }
  }

  Map<String, String> _getComponentNames(BuildContext context) {
    return {
      'hourly_forecast': AppLocalizations.of(context).hourlyForecast,
      'rainfall_chart': AppLocalizations.of(context).precipitation,
      'daily_forecast': AppLocalizations.of(context).next7Days,
      'ai_advice': AppLocalizations.of(context).aiAdviceTitle,
      'details': AppLocalizations.of(context).detailedData,
      'weather_map': AppLocalizations.of(context).weatherMap,
    };
  }

  @override
  Widget build(BuildContext context) {
    final componentNames = _getComponentNames(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: colorScheme.surfaceTint,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              AppLocalizations.of(context).customizeHomepage,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton.icon(
              onPressed: _saveLayout,
              icon: const Icon(Icons.check_rounded, size: 20),
              label: Text(MaterialLocalizations.of(context).saveButtonLabel),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colorScheme.primary,
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    border: Border(
                      bottom: BorderSide(
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)
                                  .customizeHomepageDesc,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                              maxLines: 3,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _components.length,
                    proxyDecorator: (child, index, animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          final animValue =
                              Curves.easeInOut.transform(animation.value);
                          final elevation = lerpDouble(0, 8, animValue)!;
                          final scale = lerpDouble(1, 1.02, animValue)!;
                          return Transform.scale(
                            scale: scale,
                            child: Material(
                              elevation: elevation,
                              borderRadius: BorderRadius.circular(16),
                              child: child,
                            ),
                          );
                        },
                        child: child,
                      );
                    },
                    itemBuilder: (context, index) {
                      final component = _components[index];
                      final isVisible = component.isVisible;

                      return Padding(
                        key: Key(component.id),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(16),
                          color: isVisible
                              ? colorScheme.surfaceContainerHigh
                              : colorScheme.surfaceContainerLowest,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                component.isVisible = !component.isVisible;
                                final visibleItems = _components
                                    .where((c) => c.isVisible)
                                    .toList();
                                final invisibleItems = _components
                                    .where((c) => !c.isVisible)
                                    .toList();
                                _components = [
                                  ...visibleItems,
                                  ...invisibleItems
                                ];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isVisible
                                      ? colorScheme.primary
                                          .withValues(alpha: 0.3)
                                      : colorScheme.outlineVariant
                                          .withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.drag_handle_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isVisible
                                          ? colorScheme.primaryContainer
                                          : colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getComponentIcon(component.id),
                                      color: isVisible
                                          ? colorScheme.onPrimaryContainer
                                          : colorScheme.onSurfaceVariant,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          componentNames[component.id] ??
                                              component.id,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: component.isVisible,
                                    onChanged: (bool value) {
                                      setState(() {
                                        component.isVisible = value;
                                        final visibleItems = _components
                                            .where((c) => c.isVisible)
                                            .toList();
                                        final invisibleItems = _components
                                            .where((c) => !c.isVisible)
                                            .toList();
                                        _components = [
                                          ...visibleItems,
                                          ...invisibleItems
                                        ];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onReorderItem: (int oldIndex, int newIndex) {
                      setState(() {
                        // onReorderItem already adjusts newIndex after removal.
                        final LayoutComponent item =
                            _components.removeAt(oldIndex);
                        _components.insert(newIndex, item);
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
