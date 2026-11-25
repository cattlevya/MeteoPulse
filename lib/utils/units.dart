/// Satuan suhu yang didukung.
enum TempUnit { celsius, fahrenheit }

/// Satuan kecepatan angin yang didukung.
enum WindUnit { kmh, ms }

/// Memformat suhu dari Celcius ke °C atau °F (dibulatkan).
String formatTemp(double celsius, TempUnit unit) {
  final value = unit == TempUnit.fahrenheit ? celsius * 9 / 5 + 32 : celsius;
  return '${value.round()}°';
}

/// Memformat kecepatan angin dari km/h ke km/h atau m/s.
String formatWind(double kmh, WindUnit unit) {
  if (unit == WindUnit.ms) {
    return '${(kmh / 3.6).toStringAsFixed(1)} m/s';
  }
  return '${kmh.round()} km/h';
}
