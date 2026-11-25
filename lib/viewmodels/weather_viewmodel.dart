import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../models/weather.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/error_message.dart';

/// Status tampilan data pada ViewModel.
enum ViewState { loading, success, empty, error }

/// ViewModel utama untuk cuaca kota yang sedang aktif.
class WeatherViewModel extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  final StorageService _storage = StorageService();

  Location? location;
  Weather? weather;
  ViewState state = ViewState.loading;
  String errorMessage = '';

  /// Membaca lokasi terakhir (default Jakarta) lalu memuat cuaca di latar.
  Future<void> init() async {
    final saved = await _storage.getLastLocation();
    final target = saved ?? Location.jakarta;
    unawaited(loadWeather(target));
  }

  /// Memuat data cuaca untuk lokasi terpilih dan menyimpannya sebagai lokasi terakhir.
  Future<void> loadWeather(Location loc) async {
    location = loc;
    state = ViewState.loading;
    notifyListeners();

    await _storage.saveLastLocation(loc);
    try {
      weather = await _service.getWeather(loc);
      state = ViewState.success;
    } catch (e) {
      errorMessage = friendlyError(e);
      state = ViewState.error;
    }
    notifyListeners();
  }

  /// Memuat ulang cuaca untuk lokasi aktif saat ini.
  Future<void> refresh() async {
    if (location == null) return;
    await loadWeather(location!);
  }
}
