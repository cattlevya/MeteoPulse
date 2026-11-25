import '../models/weather.dart';

/// Jenis ikon saran cuaca.
enum TipKind { storm, rain, uv, hot, cold, wind, fog, comfortable }

/// Satu saran aktivitas harian berdasarkan kondisi cuaca.
class WeatherTip {
  final TipKind kind;
  final String text;

  const WeatherTip({required this.kind, required this.text});
}

/// Menghasilkan maksimal 3 saran aktivitas sesuai urutan prioritas.
List<WeatherTip> getTips(Weather w) {
  final tips = <WeatherTip>[];

  if (w.weatherCode == 95 || w.weatherCode == 96 || w.weatherCode == 99) {
    tips.add(
      const WeatherTip(
        kind: TipKind.storm,
        text: 'Ada petir, hindari area terbuka.',
      ),
    );
  }
  if (w.rainChance >= 60 ||
      (w.weatherCode >= 51 && w.weatherCode <= 67) ||
      (w.weatherCode >= 80 && w.weatherCode <= 82)) {
    tips.add(
      const WeatherTip(
        kind: TipKind.rain,
        text: 'Bawa payung, kemungkinan hujan tinggi.',
      ),
    );
  }
  if (w.uvIndex >= 6) {
    tips.add(
      const WeatherTip(
        kind: TipKind.uv,
        text: 'Indeks UV tinggi, pakai tabir surya dan topi.',
      ),
    );
  }
  if (w.temperature >= 33) {
    tips.add(
      const WeatherTip(
        kind: TipKind.hot,
        text: 'Cuaca panas, perbanyak minum air.',
      ),
    );
  }
  if (w.temperature <= 20) {
    tips.add(
      const WeatherTip(
        kind: TipKind.cold,
        text: 'Cuaca sejuk, bawa jaket.',
      ),
    );
  }
  if (w.windSpeed >= 30) {
    tips.add(
      const WeatherTip(
        kind: TipKind.wind,
        text: 'Angin kencang, hati-hati di luar ruangan.',
      ),
    );
  }
  if (w.visibility < 2000) {
    tips.add(
      const WeatherTip(
        kind: TipKind.fog,
        text: 'Jarak pandang rendah, hati-hati berkendara.',
      ),
    );
  }
  if (tips.isEmpty) {
    tips.add(
      const WeatherTip(
        kind: TipKind.comfortable,
        text: 'Cuaca nyaman, cocok untuk beraktivitas di luar ruangan.',
      ),
    );
  }

  return tips.take(3).toList();
}
