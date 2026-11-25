import 'package:flutter/foundation.dart';
import '../models/location.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/error_message.dart';
import 'weather_viewmodel.dart';

/// ViewModel untuk pencarian kota dan pengelolaan riwayat pencarian.
class SearchViewModel extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  final StorageService _storage = StorageService();

  List<Location> results = [];
  List<Location> history = [];
  ViewState? state;
  String errorMessage = '';

  /// Memuat riwayat pencarian dari penyimpanan lokal.
  Future<void> loadHistory() async {
    history = await _storage.getHistory();
    notifyListeners();
  }

  /// Mencari kota melalui Geocoding API jika panjang input minimal 2 karakter.
  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      results = [];
      state = null;
      notifyListeners();
      return;
    }

    state = ViewState.loading;
    notifyListeners();

    try {
      results = await _service.searchCity(trimmed);
      state = results.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      errorMessage = friendlyError(e);
      state = ViewState.error;
    }
    notifyListeners();
  }

  /// Menyimpan kota ke riwayat (maksimal 5, terbaru di depan, tanpa duplikat).
  Future<void> addToHistory(Location loc) async {
    final updated = [loc, ...history.where((e) => e != loc)].take(5).toList();
    history = updated;
    await _storage.saveHistory(history);
    notifyListeners();
  }

  /// Menghapus seluruh riwayat pencarian.
  Future<void> clearHistory() async {
    history = [];
    await _storage.saveHistory(history);
    notifyListeners();
  }

  /// Mengosongkan hasil pencarian aktif.
  void clear() {
    results = [];
    state = null;
    notifyListeners();
  }
}
