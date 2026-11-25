/// Model prakiraan cuaca harian (7 hari).
class DailyForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final int rainChance;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;

  const DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
  });
}

/// Model prakiraan cuaca per jam.
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });
}

/// Model data cuaca lengkap dari Open-Meteo Forecast API.
class Weather {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final double precipitation;
  final double pressure;
  final double visibility;
  final int weatherCode;
  final bool isDay;
  final int rainChance;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final List<DailyForecast> daily;
  final List<HourlyForecast> hourly;

  const Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.pressure,
    required this.visibility,
    required this.weatherCode,
    required this.isDay,
    required this.rainChance,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.daily,
    required this.hourly,
  });

  /// Memetakan respons JSON Forecast API Open-Meteo ke model Weather.
  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;
    final hourlyJson = json['hourly'] as Map<String, dynamic>;

    final dailyList = _parseDaily(dailyJson);
    final currentTimeStr = current['time'] as String;
    final hourlyList = _parseHourly(hourlyJson, currentTimeStr);

    final firstDay = dailyList.first;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      pressure: (current['surface_pressure'] as num).toDouble(),
      visibility: (current['visibility'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: (current['is_day'] as num).toInt() == 1,
      rainChance: firstDay.rainChance,
      uvIndex: firstDay.uvIndex,
      sunrise: firstDay.sunrise,
      sunset: firstDay.sunset,
      daily: dailyList,
      hourly: hourlyList,
    );
  }

  static List<DailyForecast> _parseDaily(Map<String, dynamic> d) {
    final times = d['time'] as List<dynamic>;
    final codes = d['weather_code'] as List<dynamic>;
    final maxTemps = d['temperature_2m_max'] as List<dynamic>;
    final minTemps = d['temperature_2m_min'] as List<dynamic>;
    final rainChances = d['precipitation_probability_max'] as List<dynamic>;
    final uvIndexes = d['uv_index_max'] as List<dynamic>;
    final sunrises = d['sunrise'] as List<dynamic>;
    final sunsets = d['sunset'] as List<dynamic>;

    final result = <DailyForecast>[];
    for (var i = 0; i < times.length; i++) {
      result.add(
        DailyForecast(
          date: DateTime.parse(times[i] as String),
          weatherCode: (codes[i] as num).toInt(),
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          rainChance: (rainChances[i] as num?)?.toInt() ?? 0,
          uvIndex: (uvIndexes[i] as num?)?.toDouble() ?? 0.0,
          sunrise: DateTime.parse(sunrises[i] as String),
          sunset: DateTime.parse(sunsets[i] as String),
        ),
      );
    }
    return result;
  }

  static List<HourlyForecast> _parseHourly(
    Map<String, dynamic> h,
    String currentTimeStr,
  ) {
    final times = h['time'] as List<dynamic>;
    final temps = h['temperature_2m'] as List<dynamic>;
    final codes = h['weather_code'] as List<dynamic>;

    final currentParsed = DateTime.parse(currentTimeStr);
    final currentHour = DateTime(
      currentParsed.year,
      currentParsed.month,
      currentParsed.day,
      currentParsed.hour,
    );

    var startIndex = 0;
    for (var i = 0; i < times.length; i++) {
      final t = DateTime.parse(times[i] as String);
      if (!t.isBefore(currentHour)) {
        startIndex = i;
        break;
      }
    }

    final result = <HourlyForecast>[];
    final endIndex = (startIndex + 24).clamp(0, times.length);
    for (var i = startIndex; i < endIndex; i++) {
      result.add(
        HourlyForecast(
          time: DateTime.parse(times[i] as String),
          temperature: (temps[i] as num).toDouble(),
          weatherCode: (codes[i] as num).toInt(),
        ),
      );
    }
    return result;
  }
}
