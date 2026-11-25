import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';

/// Service penyimpanan lokal memakai SharedPreferences.
class StorageService {
  static const String keyFavorites = 'favorites';
  static const String keyHistory = 'history';
  static const String keyLastLocation = 'last_location';
  static const String keyTempUnit = 'temp_unit';
  static const String keyWindUnit = 'wind_unit';

  /// Membaca daftar kota favorit dari penyimpanan lokal.
  Future<List<Location>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(keyFavorites) ?? [];
    return list
        .map((s) => Location.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  /// Menyimpan daftar kota favorit ke penyimpanan lokal.
  Future<void> saveFavorites(List<Location> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(keyFavorites, encoded);
  }

  /// Membaca riwayat pencarian kota dari penyimpanan lokal.
  Future<List<Location>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(keyHistory) ?? [];
    return list
        .map((s) => Location.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  /// Menyimpan riwayat pencarian kota ke penyimpanan lokal.
  Future<void> saveHistory(List<Location> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = items.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(keyHistory, encoded);
  }

  /// Membaca lokasi terakhir yang dipilih pengguna.
  Future<Location?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(keyLastLocation);
    if (raw == null) return null;
    return Location.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Menyimpan lokasi terakhir yang dipilih pengguna.
  Future<void> saveLastLocation(Location loc) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLastLocation, jsonEncode(loc.toJson()));
  }

  /// Membaca nilai string pengaturan berdasarkan key.
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Menyimpan nilai string pengaturan berdasarkan key.
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
