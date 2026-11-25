import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../utils/units.dart';

/// ViewModel untuk menyimpan dan mengubah satuan suhu serta angin.
class SettingsViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  TempUnit tempUnit = TempUnit.celsius;
  WindUnit windUnit = WindUnit.kmh;

  /// Memuat pengaturan satuan dari penyimpanan lokal.
  Future<void> load() async {
    final savedTemp = await _storage.getString(StorageService.keyTempUnit);
    final savedWind = await _storage.getString(StorageService.keyWindUnit);

    tempUnit = TempUnit.values.firstWhere(
      (e) => e.name == savedTemp,
      orElse: () => TempUnit.celsius,
    );
    windUnit = WindUnit.values.firstWhere(
      (e) => e.name == savedWind,
      orElse: () => WindUnit.kmh,
    );
    notifyListeners();
  }

  /// Mengubah satuan suhu dan menyimpannya ke storage.
  Future<void> setTempUnit(TempUnit unit) async {
    if (tempUnit == unit) return;
    tempUnit = unit;
    await _storage.setString(StorageService.keyTempUnit, unit.name);
    notifyListeners();
  }

  /// Mengubah satuan kecepatan angin dan menyimpannya ke storage.
  Future<void> setWindUnit(WindUnit unit) async {
    if (windUnit == unit) return;
    windUnit = unit;
    await _storage.setString(StorageService.keyWindUnit, unit.name);
    notifyListeners();
  }
}
