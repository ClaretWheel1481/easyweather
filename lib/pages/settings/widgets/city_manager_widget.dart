import '../import.dart';

class CityManagerWidget extends StatelessWidget {
  final List<City> cities;
  final int mainCityIndex;
  final bool currentLocationEnabled;
  final bool cityLoading;
  final bool cityManagerExpanded;
  final ValueChanged<bool> onCurrentLocationChanged;
  final ValueChanged<int> onSetMainCity;
  final ValueChanged<int> onRemoveCity;
  final VoidCallback onToggleExpand;

  const CityManagerWidget({
    super.key,
    required this.cities,
    required this.mainCityIndex,
    required this.currentLocationEnabled,
    required this.cityLoading,
    required this.cityManagerExpanded,
    required this.onCurrentLocationChanged,
    required this.onSetMainCity,
    required this.onRemoveCity,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: onToggleExpand,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.location_city, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.cityManager, style: textTheme.titleMedium),
                          if (cities.isNotEmpty)
                            Text(
                              '${cities.length} ${l10n.cities}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      cityManagerExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.linearToEaseOut,
            child: cityManagerExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // This fixed page stays outside the sortable city list.
                        Material(
                          color: currentLocationEnabled
                              ? colorScheme.primaryContainer
                                  .withValues(alpha: 0.3)
                              : colorScheme.surface.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                          child: SwitchListTile(
                            value: currentLocationEnabled,
                            onChanged: cityLoading
                                ? null
                                : onCurrentLocationChanged,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            secondary: Icon(
                              Icons.my_location,
                              color: currentLocationEnabled
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                            title: Text(
                              l10n.currentLocation,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: currentLocationEnabled
                                    ? colorScheme.primary
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        cityLoading
                            ? Container(
                                padding: const EdgeInsets.all(16),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : cities.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Align(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.location_off_outlined,
                                            size: 48,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            l10n.noCitiesAdded,
                                            style:
                                                textTheme.bodyLarge?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children:
                                        cities.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final city = entry.value;
                                      final isMain = index == mainCityIndex;

                                      Widget cityCard = Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            onTap: !isMain
                                                ? () => onSetMainCity(index)
                                                : null,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 550),
                                              curve: Curves.ease,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: isMain
                                                    ? colorScheme
                                                        .primaryContainer
                                                        .withValues(alpha: 0.3)
                                                    : colorScheme.surface
                                                        .withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: isMain
                                                    ? Border.all(
                                                        color: colorScheme
                                                            .primary
                                                            .withValues(
                                                                alpha: 0.2),
                                                        width: 1,
                                                      )
                                                    : null,
                                              ),
                                              child: Row(
                                                children: [
                                                  // 城市图标
                                                  AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 550),
                                                    curve: Curves.ease,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: isMain
                                                          ? colorScheme.primary
                                                          : colorScheme
                                                              .onInverseSurface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Icon(
                                                      isMain
                                                          ? Icons.star
                                                          : Icons.location_city,
                                                      color: isMain
                                                          ? colorScheme
                                                              .onPrimary
                                                          : colorScheme
                                                              .onSurfaceVariant,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  // 城市信息
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                city.name,
                                                                style: textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: isMain
                                                                      ? colorScheme
                                                                          .primary
                                                                      : colorScheme
                                                                          .onSurface,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          '${city.admin}, ${city.country}',
                                                          style: textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                            color: colorScheme
                                                                .onSurfaceVariant,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // 操作按钮
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      if (!isMain)
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            onTap: () =>
                                                                onSetMainCity(
                                                                    index),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    colorScheme
                                                                        .surface,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border:
                                                                    Border.all(
                                                                  color: colorScheme
                                                                      .outline
                                                                      .withValues(
                                                                          alpha:
                                                                              0.3),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .star_outline,
                                                                color:
                                                                    colorScheme
                                                                        .primary,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      const SizedBox(width: 8),
                                                      if (isMain)
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: colorScheme
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Text(
                                                            l10n.main,
                                                            style: textTheme
                                                                .labelSmall
                                                                ?.copyWith(
                                                              color: colorScheme
                                                                  .onPrimary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      const SizedBox(width: 8),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          onTap: isMain &&
                                                                  cities.length ==
                                                                      1
                                                              ? null
                                                              : () =>
                                                                  onRemoveCity(
                                                                      index),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isMain &&
                                                                      cities.length ==
                                                                          1
                                                                  ? colorScheme
                                                                      .onInverseSurface
                                                                      .withValues(
                                                                          alpha:
                                                                              0.5)
                                                                  : colorScheme
                                                                      .surface,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border:
                                                                  Border.all(
                                                                color: isMain &&
                                                                        cities.length ==
                                                                            1
                                                                    ? colorScheme
                                                                        .outline
                                                                        .withValues(
                                                                            alpha:
                                                                                0.2)
                                                                    : colorScheme
                                                                        .outline
                                                                        .withValues(
                                                                            alpha:
                                                                                0.3),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color: isMain &&
                                                                      cities.length ==
                                                                          1
                                                                  ? colorScheme
                                                                      .onSurface
                                                                      .withValues(
                                                                          alpha:
                                                                              0.38)
                                                                  : colorScheme
                                                                      .error,
                                                              size: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                      return cityCard;
                                    }).toList(),
                                  ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
