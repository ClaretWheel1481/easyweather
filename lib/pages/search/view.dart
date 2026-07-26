import 'import.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  List<City> _results = [];
  bool _loading = false;
  String _error = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final query = _controller.text.trim();
      if (query.isEmpty) {
        setState(() {
          _results = [];
          _error = '';
        });
        return;
      }
      _searchCities(query);
    });
  }

  void _searchCities(String query) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final results = await AppDependencies.searchCities(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        if (results.isEmpty) {
          _error = AppLocalizations.of(context).noResults;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).searchError;
      });
    }
  }

  void _selectCity(City city) {
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: SearchBarWidget(
        controller: _controller,
        onBack: () => Navigator.of(context).pop(),
      ),
      backgroundColor: colorScheme.onInverseSurface,
      body: Column(
        children: [
          if (_loading)
            LinearProgressIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.onInverseSurface,
              minHeight: 3,
            ),
          if (_error.isNotEmpty)
            SearchErrorWidget(
              error: _error,
              onRetry: () => _searchCities(_controller.text.trim()),
            ),
          Expanded(
            child: SearchResultsWidget(
              results: _results,
              loading: _loading,
              isEmpty: _results.isEmpty && !_loading && _error.isEmpty,
              onCityTap: _selectCity,
            ),
          ),
        ],
      ),
    );
  }
}
