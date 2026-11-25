# MeteoPulse

Aplikasi cuaca mobile berbahasa Indonesia berbasis Flutter dengan arsitektur MVVM, desain kartu pastel lembut, maskot interaktif, dan data real-time dari Open-Meteo API.

## Fitur Utama

### Wajib
- **Cuaca Terkini**: menampilkan kota terpilih, kondisi cuaca, suhu saat ini, terasa seperti, kelembapan, kecepatan angin, dan peluang hujan.
- **Prakiraan 3 Hari & 7 Hari**: ringkasan 3 hari di Beranda dan prakiraan lengkap 7 hari pada layar khusus.
- **Cari Kota**: pencarian kota real-time via Open-Meteo Geocoding API (debounce 500 ms, minimal 2 karakter).
- **Favorit**: simpan dan hapus kota favorit dengan sinkronisasi lintas layar.
- **Penanganan State**: state loading, data kosong, dan error dengan tombol Coba Lagi.

### Tambahan
- **Splash Screen**: memuat pengaturan, favorit, dan riwayat saat aplikasi dibuka.
- **Navigasi 3 Tab**: Beranda, Favorit, Pengaturan dengan bar kapsul mengambang.
- **Prakiraan Per Jam**: daftar horizontal 24 jam ke depan mulai dari jam kota terpilih.
- **Detail Cuaca & Saran**: grid 6 metrik (terasa seperti, kelembapan, angin, tekanan, jarak pandang, curah hujan), kartu matahari (terbit, terbenam, UV), dan saran aktivitas.
- **Pengaturan**: ubah satuan suhu (°C / °F), satuan angin (km/h / m/s), hapus riwayat, dan hapus favorit.

## Teknologi

- Flutter & Dart
- `provider` (State management MVVM)
- `http` (REST API Open-Meteo)
- `shared_preferences` (Penyimpanan lokal)
- `google_fonts` (Tipografi Poppins)
- `intl` (Pemformatan tanggal dan jam)

## Daftar 7 Layar

1. **Splash (`splash_screen.dart`)**: tampilan pembuka dan pemuatan data awal.
2. **Home (`home_screen.dart`)**: cuaca saat ini, 3 chip info, saran hari ini, prakiraan 24 jam, dan 3 hari ke depan.
3. **Cari Kota (`search_screen.dart`)**: pencarian kota, daftar favorit, dan riwayat pencarian (maksimal 5 kota).
4. **Favorit (`favorites_screen.dart`)**: grid kota favorit beserta suhu terkini masing-masing.
5. **Forecast 7 Hari (`forecast_screen.dart`)**: pilihan kapsul 7 hari, kartu hari terpilih, 4 chip detail, dan daftar semua hari.
6. **Detail Cuaca (`detail_screen.dart`)**: ringkasan kondisi, grid 6 metrik, kartu matahari, dan saran aktivitas.
7. **Pengaturan (`settings_screen.dart`)**: ubah satuan suhu/angin dan hapus data lokal.

## Struktur Folder

```text
lib/
  main.dart
  theme/
    app_theme.dart
  models/
    location.dart
    weather.dart
  services/
    weather_service.dart
    storage_service.dart
  viewmodels/
    weather_viewmodel.dart
    search_viewmodel.dart
    favorites_viewmodel.dart
    settings_viewmodel.dart
  views/
    splash_screen.dart
    main_shell.dart
    home_screen.dart
    search_screen.dart
    favorites_screen.dart
    forecast_screen.dart
    detail_screen.dart
    settings_screen.dart
  widgets/
    weather_card.dart
    weather_icon.dart
    mascot_blob.dart
    info_chip.dart
    hourly_item.dart
    daily_tile.dart
    city_tile.dart
    detail_tile.dart
    tip_card.dart
    state_message.dart
    floating_nav_bar.dart
  utils/
    weather_code.dart
    weather_tips.dart
    units.dart
    day_name.dart
    error_message.dart
```

## Arsitektur MVVM

```text
View  ──(panggil method, baca state)──▶  ViewModel  ──▶  Service  ──▶  API / Storage
  ▲                                         │
  └────────── notifyListeners() ◀───────────┘
```

- `WeatherViewModel`: mengelola lokasi aktif, data cuaca, status loading/error, dan lokasi terakhir.
- `SearchViewModel`: mengelola hasil pencarian kota dan riwayat pencarian (maksimal 5).
- `FavoritesViewModel`: sumber tunggal daftar kota favorit dan cuaca terkininya.
- `SettingsViewModel`: mengelola satuan suhu (°C/°F) dan satuan angin (km/h, m/s).

## Implementasi API

- **Geocoding API**: `https://geocoding-api.open-meteo.com/v1/search?name={query}&count=10&language=id&format=json`
- **Forecast API**: `https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=...&daily=...&hourly=...&forecast_days=7&timezone=auto`

## Penyimpanan Lokal (`shared_preferences`)

| Key | Tipe | Isi |
| --- | --- | --- |
| `favorites` | `List<String>` | Daftar lokasi favorit dalam JSON |
| `history` | `List<String>` | Maksimal 5 riwayat lokasi dalam JSON |
| `last_location` | `String` | Lokasi terakhir yang dipilih dalam JSON |
| `temp_unit` | `String` | `celsius` atau `fahrenheit` |
| `wind_unit` | `String` | `kmh` atau `ms` |

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Screenshot

- `![Splash](screenshots/splash.png)`
- `![Home](screenshots/home.png)`
- `![Search](screenshots/search.png)`
- `![Favorit](screenshots/favorites.png)`
- `![Forecast](screenshots/forecast.png)`
- `![Detail](screenshots/detail.png)`
- `![Pengaturan](screenshots/settings.png)`
- `![Error](screenshots/error.png)`
