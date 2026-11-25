import 'package:material_ui/material_ui.dart';
import '../theme/app_theme.dart';

/// Jenis kondisi visual untuk menentukan ikon dan pasangan warna kartu.
enum WeatherVisual { clear, partlyCloudy, cloudy, rain, storm, snow, night }

/// Hasil pemetaan kode cuaca WMO ke teks Indonesia dan jenis visual.
class WeatherInfo {
  final String text;
  final WeatherVisual visual;

  const WeatherInfo({required this.text, required this.visual});
}

/// Memetakan weather_code WMO dan status siang/malam ke informasi cuaca.
WeatherInfo weatherInfo(int code, bool isDay) {
  if (!isDay && (code == 0 || code == 1 || code == 2)) {
    return WeatherInfo(
      text: code == 0 ? 'Cerah Malam' : 'Berawan Malam',
      visual: WeatherVisual.night,
    );
  }
  switch (code) {
    case 0:
      return const WeatherInfo(text: 'Cerah', visual: WeatherVisual.clear);
    case 1:
      return const WeatherInfo(
        text: 'Cerah Berawan',
        visual: WeatherVisual.partlyCloudy,
      );
    case 2:
      return const WeatherInfo(
        text: 'Berawan Sebagian',
        visual: WeatherVisual.partlyCloudy,
      );
    case 3:
      return const WeatherInfo(text: 'Berawan', visual: WeatherVisual.cloudy);
    case 45:
    case 48:
      return const WeatherInfo(text: 'Berkabut', visual: WeatherVisual.cloudy);
    case 51:
    case 53:
    case 55:
      return const WeatherInfo(text: 'Gerimis', visual: WeatherVisual.rain);
    case 56:
    case 57:
    case 61:
      return const WeatherInfo(
        text: 'Hujan Ringan',
        visual: WeatherVisual.rain,
      );
    case 63:
      return const WeatherInfo(
        text: 'Hujan Sedang',
        visual: WeatherVisual.rain,
      );
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return const WeatherInfo(
        text: 'Hujan Lebat',
        visual: WeatherVisual.rain,
      );
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return const WeatherInfo(text: 'Salju', visual: WeatherVisual.snow);
    case 95:
    case 96:
    case 99:
      return const WeatherInfo(
        text: 'Badai Petir',
        visual: WeatherVisual.storm,
      );
    default:
      return const WeatherInfo(
        text: 'Tidak Diketahui',
        visual: WeatherVisual.cloudy,
      );
  }
}

/// Warna kartu utama untuk Sistem A (Home & Forecast): kartu berwarna cuaca.
Color weatherCardColor(WeatherVisual visual) {
  switch (visual) {
    case WeatherVisual.clear:
    case WeatherVisual.partlyCloudy:
      return AppColors.sunYellow;
    case WeatherVisual.rain:
    case WeatherVisual.snow:
      return AppColors.skyBlue;
    case WeatherVisual.storm:
      return AppColors.mint;
    case WeatherVisual.cloudy:
    case WeatherVisual.night:
      return AppColors.cloudGrey;
  }
}

/// Warna MascotBlob untuk Favorit & Detail Cuaca (Sistem B).
Color mascotWeatherColor(WeatherVisual visual) {
  switch (visual) {
    case WeatherVisual.clear:
    case WeatherVisual.partlyCloudy:
      return AppColors.sunYellow;
    case WeatherVisual.rain:
    case WeatherVisual.snow:
      return AppColors.skyBlue;
    case WeatherVisual.storm:
      return AppColors.blushPink;
    case WeatherVisual.cloudy:
    case WeatherVisual.night:
      return AppColors.cloudGrey;
  }
}

/// Warna kartu pasangan untuk Sistem B (Detail Cuaca): kontras dengan warna MascotBlob.
Color detailSummaryCardColor(WeatherVisual visual) {
  switch (visual) {
    case WeatherVisual.clear:
    case WeatherVisual.partlyCloudy:
      return AppColors.skyBlue;
    case WeatherVisual.rain:
    case WeatherVisual.snow:
    case WeatherVisual.storm:
      return AppColors.mint;
    case WeatherVisual.cloudy:
    case WeatherVisual.night:
      return AppColors.sunYellow;
  }
}
