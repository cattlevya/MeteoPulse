import 'package:flutter_test/flutter_test.dart';
import 'package:meteopulse/utils/units.dart';
import 'package:meteopulse/utils/weather_code.dart';

void main() {
  test('formatTemp converts Celsius and Fahrenheit accurately', () {
    expect(formatTemp(27.4, TempUnit.celsius), '27°');
    expect(formatTemp(0, TempUnit.fahrenheit), '32°');
  });

  test('formatWind converts km/h and m/s accurately', () {
    expect(formatWind(12.2, WindUnit.kmh), '12 km/h');
    expect(formatWind(3.6, WindUnit.ms), '1.0 m/s');
  });

  test('weatherInfo maps WMO codes', () {
    expect(weatherInfo(0, true).text, 'Cerah');
    expect(weatherInfo(63, true).visual, WeatherVisual.rain);
    expect(weatherInfo(0, false).visual, WeatherVisual.night);
  });
}
