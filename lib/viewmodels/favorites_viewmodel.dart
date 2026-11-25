import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../models/weather.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

/// ViewModel sumber tunggal daftar kota favorit dan cuaca terkininya.
class FavoritesViewModel extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  final StorageService _storage = StorageService();

  List<Location> favorites = [];
  Map<Location, Weather> weathers = {};
  Set<Location> failed = {};

  /// Memuat daftar kota favorit dari penyimpanan lokal.
  Future<void> load() async {
    favorites = await _storage.getFavorites();
    notifyListeners();
  }

  /// Mengecek apakah lokasi sudah ada di daftar favorit.
  bool isFavorite(Location loc) {
    return favorites.contains(loc);
  }

  /// Menambah atau menghapus lokasi dari daftar favorit.
  Future<void> toggle(Location loc) async {
    if (isFavorite(loc)) {
      favorites = favorites.where((e) => e != loc).toList();
    } else {
      favorites = [...favorites, loc];
    }
    await _storage.saveFavorites(favorites);
    notifyListeners();
  }

  /// Menghapus satu lokasi dari daftar favorit.
  Future<void> remove(Location loc) async {
    favorites = favorites.where((e) => e != loc).toList();
    await _storage.saveFavorites(favorites);
    notifyListeners();
  }

  /// Menghapus seluruh kota favorit.
  Future<void> clearAll() async {
    favorites = [];
    weathers = {};
    failed = {};
    await _storage.saveFavorites(favorites);
    notifyListeners();
  }

  /// Memuat cuaca terkini seluruh kota favorit secara paralel.
  Future<void> loadAllWeather() async {
    failed = {};
    await Future.wait(favorites.map(_loadOne));
    notifyListeners();
  }

  Future<void> _loadOne(Location loc) async {
    try {
      weathers[loc] = await _service.getWeather(loc);
    } catch (_) {
      failed.add(loc);
    }
  }
}
