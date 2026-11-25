import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';
import '../models/weather.dart';

/// Service untuk mengambil data lokasi dan cuaca dari Open-Meteo API.
class WeatherService {
  static const _timeout = Duration(seconds: 10);

  /// Mencari kota berdasarkan nama melalui Open-Meteo Geocoding API.
  Future<List<Location>> searchCity(String query) async {
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${res.statusCode}).');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (json['results'] as List<dynamic>?) ?? [];
    return results
        .map((item) => Location.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Mengambil data cuaca terkini, per jam, dan 7 hari dari Open-Meteo Forecast API.
  Future<Weather> getWeather(Location loc) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': loc.latitude.toString(),
      'longitude': loc.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day,surface_pressure,visibility',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max,sunrise,sunset',
      'hourly': 'temperature_2m,weather_code',
      'forecast_days': '7',
      'timezone': 'auto',
    });

    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${res.statusCode}).');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(json);
  }
}
