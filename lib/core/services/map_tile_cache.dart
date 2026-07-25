import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:path_provider/path_provider.dart';

class MapTileCache {
  static const maxSizeBytes = 48 * 1024 * 1024;
  static Future<CacheStore>? _storeFuture;

  // Shares one persistent cache between OSM and RainViewer map tile layers.
  static Future<CacheStore> get store => _storeFuture ??= _createStore();

  static Future<CacheStore> _createStore() async {
    final directory = await getTemporaryDirectory();
    final store = _LimitedFileCacheStore(
      '${directory.path}/weather_map_tiles',
      maxSizeBytes: maxSizeBytes,
    );
    await store.maintain();
    return store;
  }
}

class _LimitedFileCacheStore extends FileCacheStore {
  final Directory _directory;
  final int maxSizeBytes;
  int _writesSinceMaintenance = 0;
  bool _maintenanceRunning = false;

  _LimitedFileCacheStore(
    super.directory, {
    required this.maxSizeBytes,
  }) : _directory = Directory(directory);

  @override
  Future<void> set(CacheResponse response) async {
    await super.set(response);
    _writesSinceMaintenance++;
    if (_writesSinceMaintenance >= 20 && !_maintenanceRunning) {
      _writesSinceMaintenance = 0;
      _maintenanceRunning = true;
      try {
        await maintain();
      } finally {
        _maintenanceRunning = false;
      }
    }
  }

  // Removes expired entries first, then evicts the oldest files by size.
  Future<void> maintain() async {
    await clean(staleOnly: true);
    if (!await _directory.exists()) return;

    final files = <File>[];
    var totalSize = 0;
    await for (final entity in _directory.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
        files.add(entity);
      }
    }
    if (totalSize <= maxSizeBytes) return;

    files
        .sort((a, b) => a.statSync().modified.compareTo(b.statSync().modified));
    for (final file in files) {
      if (totalSize <= maxSizeBytes) break;
      final size = await file.length();
      await file.delete();
      totalSize -= size;
    }
  }
}
