import 'package:zephyr/core/import.dart';

import 'import.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppLifecycleListener _listener;
  List<City> _savedCities = [];
  List<City> cities = [];
  City? _currentLocationCity;
  bool _currentLocationEnabled = false;
  bool _locationRefreshInProgress = false;
  int pageIndex = 0;
  Map<String, WeatherData?> weatherMap = {};
  Map<String, List<WeatherWarning>> warningsMap = {};
  Map<String, bool> loadingMap = {};
  PageController? _pageController;
  final ValueNotifier<bool> _isFabVisibleNotifier = ValueNotifier(true);

  String _weatherMapKey(City city) {
    return '${city.lat}_${city.lon}_${weatherSourceNotifier.value}';
  }

  bool get _hasCurrentLocationPage =>
      _currentLocationEnabled && _currentLocationCity != null;

  List<City> _buildVisibleCities() {
    // The live location is a fixed first page, outside saved city ordering.
    return [
      if (_hasCurrentLocationPage) _currentLocationCity!,
      ..._savedCities,
    ];
  }

  @override
  void initState() {
    super.initState();
    tempUnitNotifier.addListener(_onUnitChanged);
    weatherSourceNotifier.addListener(_onSourceChanged);
    _loadCities(refreshLocation: true);

    _listener = AppLifecycleListener(
      onResume: () {
        _refreshForForeground();
      },
    );
  }

  @override
  void dispose() {
    _listener.dispose();
    _isFabVisibleNotifier.dispose();
    tempUnitNotifier.removeListener(_onUnitChanged);
    weatherSourceNotifier.removeListener(_onSourceChanged);
    _pageController?.dispose();
    super.dispose();
  }

  void _onSourceChanged() {
    if (!mounted) return;
    for (var city in cities) {
      _loadWeather(city, force: false);
    }
  }

  void _onUnitChanged() {
    if (!mounted) return;
    for (var city in cities) {
      _loadWeather(city, force: true);
    }
  }

  Future<void> _loadCities({bool refreshLocation = false}) async {
    final savedCities = await AppDependencies.loadSavedCities();
    final locationEnabled =
        await AppDependencies.cityRepository.loadCurrentLocationEnabled();
    final locationCity = locationEnabled
        ? await AppDependencies.cityRepository.loadCurrentLocationCity()
        : null;
    if (!mounted) return;

    setState(() {
      _savedCities = savedCities;
      _currentLocationEnabled = locationEnabled;
      _currentLocationCity = locationCity;
      cities = _buildVisibleCities();
      pageIndex = 0;
      if (_pageController == null || _pageController!.hasClients == false) {
        _pageController = PageController(initialPage: 0);
      }
    });

    for (var index = 0; index < cities.length; index++) {
      // Resolve the fresh coordinates before loading the location page once.
      final waitsForLocation =
          refreshLocation && _hasCurrentLocationPage && index == 0;
      if (!waitsForLocation) {
        _loadWeather(cities[index]);
      }
    }

    if (cities.isNotEmpty) {
      final mainCity = cities.first;
      final weather = weatherMap[_weatherMapKey(mainCity)];
      if (weather != null) {
        await ForecastWidgetService.updateAllWidgets(
          city: mainCity,
          weatherData: weather,
        );
      }
    }

    if (locationEnabled && refreshLocation) {
      final locationUpdated = await _refreshCurrentLocation();
      if (!locationUpdated && locationCity != null) {
        _loadWeather(locationCity, force: false);
      }
    }
  }

  Future<void> _refreshForForeground() async {
    final locationEnabled =
        await AppDependencies.cityRepository.loadCurrentLocationEnabled();
    if (!mounted) return;

    if (locationEnabled != _currentLocationEnabled) {
      await _loadCities(refreshLocation: locationEnabled);
      return;
    }

    if (locationEnabled) {
      final locationUpdated = await _refreshCurrentLocation();
      if (!locationUpdated && _currentLocationCity != null) {
        // Keep refreshing the last coordinates when a new fix is unavailable.
        _loadWeather(_currentLocationCity!, force: false);
      }
    }
    for (final city in _savedCities) {
      _loadWeather(city, force: false);
    }
  }

  Future<void> _loadWeather(City city, {bool force = false}) async {
    if (!mounted) return;
    setState(() {
      loadingMap[_weatherMapKey(city)] = true;
    });
    final snapshot =
        await AppDependencies.loadWeather(city, forceRefresh: force);
    if (!mounted) return;
    if (snapshot != null) {
      setState(() {
        weatherMap[_weatherMapKey(city)] = snapshot.weather;
        warningsMap[_weatherMapKey(city)] = snapshot.warnings;
        loadingMap[_weatherMapKey(city)] = false;
      });
    }
  }

  Future<void> _refreshWeather(City city) async {
    WeatherData? weather;
    List<WeatherWarning> warnings = [];
    try {
      final snapshot =
          await AppDependencies.loadWeather(city, forceRefresh: true);
      weather = snapshot?.weather;
      warnings = snapshot?.warnings ?? [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to refresh weather: $e');
      }
    }

    if (!mounted) return;
    setState(() {
      weatherMap[_weatherMapKey(city)] = weather;
      warningsMap[_weatherMapKey(city)] = warnings;
      loadingMap[_weatherMapKey(city)] = false;
    });
  }

  void _onPageChanged(int idx) async {
    if (!mounted) return;
    if (idx >= 0 && idx < cities.length) {
      setState(() {
        pageIndex = idx;
      });
    }
  }

  Future<void> _onAddCity() async {
    final result = await Navigator.pushNamed(context, '/search');
    if (result is City) {
      await AppDependencies.saveCity(result);
      await _loadCities();
      final newIdx = cities.indexWhere(
        (city) => city.lat == result.lat && city.lon == result.lon,
      );

      if (newIdx >= 0 && newIdx < cities.length) {
        setState(() {
          pageIndex = newIdx;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              newIdx,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  Future<void> _onOpenSettings() async {
    await Navigator.pushNamed(context, '/settings');
    await _loadCities(refreshLocation: true);
    if (!mounted) return;
    setState(() {
      pageIndex = 0;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cities.isNotEmpty) {
        _pageController?.jumpToPage(0);
      }
    });
  }

  Future<bool> _refreshCurrentLocation({
    bool enableLocation = false,
    bool showFeedback = false,
    bool moveToFirst = false,
    bool forceActiveLocation = false,
  }) async {
    if (_locationRefreshInProgress) return true;
    _locationRefreshInProgress = true;

    try {
      if (showFeedback) {
        NotificationUtils.showSnackBar(
          context,
          AppLocalizations.of(context).locating,
        );
      }

      final repository = AppDependencies.cityRepository;
      final previousCity =
          _currentLocationCity ?? await repository.loadCurrentLocationCity();
      final locationUpdatedAt =
          await repository.loadCurrentLocationUpdatedAt();

      Position? position;
      var useStoredCity = false;
      if (forceActiveLocation) {
        position = await LocationService.getCurrentPosition();
      } else {
        final lastKnown = await LocationService.getLastKnownPosition();
        final lastKnownIsNewer = lastKnown != null &&
            LocationService.isNewerPosition(lastKnown, locationUpdatedAt);
        final lastKnownChanged = lastKnown != null &&
            previousCity != null &&
            LocationService.hasMeaningfulLocationChange(
              previousCity,
              lastKnown,
            );

        if (lastKnown != null &&
            lastKnownIsNewer &&
            (lastKnownChanged ||
                LocationService.isLocationFixFresh(lastKnown.timestamp))) {
          position = lastKnown;
        } else if (previousCity != null &&
            LocationService.isLocationFixFresh(locationUpdatedAt)) {
          useStoredCity = true;
        } else {
          position = await LocationService.getCurrentPosition();
        }
      }

      if (!useStoredCity && position == null) {
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          NotificationUtils.showSnackBar(
            context,
            AppLocalizations.of(context).locationPermissionDenied,
          );
        }
        return false;
      }

      var locationChanged = false;
      City? city = previousCity;
      DateTime? acceptedPositionAt;
      if (!useStoredCity) {
        final resolvedPosition = position!;
        locationChanged = previousCity == null ||
            LocationService.hasMeaningfulLocationChange(
              previousCity,
              resolvedPosition,
            );
        city = locationChanged
            ? await LocationService.getCityFromPosition(resolvedPosition)
            : previousCity;
        acceptedPositionAt = resolvedPosition.timestamp;
      }

      final resolvedCity = city;
      if (resolvedCity == null) {
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          NotificationUtils.showSnackBar(
            context,
            AppLocalizations.of(context).locationNotRecognized,
          );
        }
        return false;
      }

      if (locationChanged) {
        await repository.saveCurrentLocationCity(resolvedCity);
      }
      if (acceptedPositionAt != null) {
        await repository.saveCurrentLocationUpdatedAt(acceptedPositionAt);
      }
      if (enableLocation) {
        // Choosing location from the first-run screen enables it persistently.
        await repository.saveCurrentLocationEnabled(true);
      }
      if (!mounted) return false;

      setState(() {
        _currentLocationEnabled =
            enableLocation || _currentLocationEnabled;
        _currentLocationCity = resolvedCity;
        cities = _buildVisibleCities();
        if (moveToFirst) pageIndex = 0;
      });

      if (showFeedback) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        NotificationUtils.showSnackBar(
          context,
          AppLocalizations.of(context).locatingSuccess,
        );
      }

      if (moveToFirst) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController != null && _pageController!.hasClients) {
            _pageController!.animateToPage(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }

      await _loadWeather(resolvedCity, force: locationChanged);
      return true;
    } finally {
      _locationRefreshInProgress = false;
    }
  }

  Future<void> _onLocate() async {
    await _refreshCurrentLocation(
      enableLocation: true,
      showFeedback: true,
      moveToFirst: true,
      forceActiveLocation: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCity = cities.isNotEmpty && pageIndex < cities.length
        ? cities[pageIndex]
        : null;
    final currentWeather =
        currentCity != null ? weatherMap[_weatherMapKey(currentCity)] : null;
    final weatherCode = currentWeather?.current?.weatherCode;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBarWidget(
        currentCityName: currentCity?.name,
        citiesLength: cities.length,
        pageIndex: pageIndex,
        hasCurrentLocation: _hasCurrentLocationPage,
        onAddCity: _onAddCity,
        onOpenSettings: _onOpenSettings,
        onLocate: _onLocate,
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _isFabVisibleNotifier,
        builder: (context, isVisible, child) {
          return AnimatedScale(
            scale: isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              onPressed: _onAddCity,
              child: const Icon(Icons.search),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            // Keep the transition unkeyed so AnimatedSwitcher can assign a
            // unique entry key when the same weather code reappears quickly.
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: cities.isEmpty
                ? const SizedBox.shrink()
                : WeatherBg(
                    key: ValueKey(weatherCode),
                    weatherCode: weatherCode,
                  ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is UserScrollNotification &&
                  notification.metrics.axis == Axis.vertical) {
                final direction = notification.direction;
                if (direction == ScrollDirection.reverse) {
                  if (_isFabVisibleNotifier.value) {
                    _isFabVisibleNotifier.value = false;
                  }
                } else if (direction == ScrollDirection.forward) {
                  if (!_isFabVisibleNotifier.value) {
                    _isFabVisibleNotifier.value = true;
                  }
                }
              }
              return false;
            },
            child: cities.isEmpty
                ? EmptyCityTip(onAdd: _onAddCity, onLocate: _onLocate)
                : PageView.builder(
                    controller: _pageController,
                    itemCount: cities.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, idx) {
                      final city = cities[idx];
                      final weather = weatherMap[_weatherMapKey(city)];
                      final warnings = warningsMap[_weatherMapKey(city)] ?? [];
                      final loading = loadingMap[_weatherMapKey(city)] ?? true;

                      return HomePageContentWidget(
                        city: city,
                        weather: weather,
                        loading: loading,
                        onRefresh: () => _refreshWeather(city),
                        warnings: warnings,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
