# 03 — PROMPT PEMBUATAN APLIKASI: "Cuaca Kita" (Flutter)

> Instruksi untuk AI coding (Claude Code, Cursor, dll). Baca juga `01_PROMPT_UIUX.md` (desain, 7 layar) dan `02_PRD.md` (kebutuhan).
> Jika terjadi konflik: UI mengikuti 01, fungsi dan API mengikuti 02, aturan kode mengikuti file ini.

## 0. Peran dan tujuan

Kamu adalah developer Flutter senior yang menulis kode untuk **mahasiswa** yang harus menjelaskan kodenya sendiri di video.
Buat aplikasi Flutter lengkap bernama **Cuaca Kita** dengan **7 layar**: Splash, Home, Search, Favorit, Forecast 7 Hari, Detail Cuaca, Pengaturan. Prioritas:

1. Semua syarat wajib terpenuhi (Home dan Search dengan API, local storage, MVVM, state loading/kosong/error).
2. Kode **sederhana, pendek, mudah dijelaskan**. Walau layarnya banyak, tiap layar harus ringkas dan memakai widget serta ViewModel yang sama. Pilih cara yang paling mudah dibaca, bukan yang paling canggih.
3. UI bagus sesuai `01_PROMPT_UIUX.md`.

Jangan menanyakan hal yang sudah ada di dokumen. Langsung kerjakan. Jika ada yang ambigu, pilih opsi paling sederhana dan catat di README.

## 1. Aturan kode (WAJIB)

1. Arsitektur **MVVM**: `models`, `services`, `viewmodels`, `views`, `widgets`, `theme`, `utils`.
2. State management: **Provider** (`ChangeNotifier`). Dilarang Riverpod, BLoC, GetX.
3. Package yang boleh: `http`, `provider`, `shared_preferences`, `google_fonts`, `intl`. **Dilarang** package lain, termasuk `open_meteo`, `dio`, `freezed`, `json_serializable`, `get_it`, `equatable`.
4. JSON parsing **manual** dengan `factory Xxx.fromJson(Map<String, dynamic> json)`. Tanpa code generation.
5. Satu file = satu tanggung jawab. Satu method maksimal sekitar 30 baris. Satu file maksimal sekitar 200 baris (view boleh sampai 250). Jika sebuah `build()` terlalu panjang, pecah menjadi widget kecil di `widgets/`.
6. Tanpa `abstract class`, `interface`, `mixin`, `extension`, generics rumit, atau design pattern tambahan (repository, use case, dependency injection).
7. Null safety. Gunakan `const` bila bisa. Nama variabel bahasa Inggris, komentar bahasa **Indonesia** singkat.
8. Beri komentar di bagian penting: setiap method service, setiap method ViewModel, setiap `fromJson`, `weather_code.dart`, dan `weather_tips.dart`.
9. `StatefulWidget` hanya untuk: `SplashScreen`, `MainShell` (tab terpilih), `SearchScreen` (controller dan debounce), `ForecastScreen` (hari terpilih). Sisanya `StatelessWidget`. Wajib `dispose()` controller dan timer.
10. View hanya boleh: membaca state dari ViewModel (`context.watch` / `Consumer`) dan memanggil method ViewModel (`context.read`). View dilarang memanggil `http` atau `SharedPreferences`.
11. ViewModel dilarang mengimpor `package:flutter/material.dart`. Boleh `package:flutter/foundation.dart` (untuk `ChangeNotifier`).
12. Tidak ada data cuaca hardcoded. Satu-satunya nilai default adalah kota awal **Jakarta** (lat -6.2, lon 106.8) bila storage kosong.
13. Semua angka suhu dan angin yang tampil di layar WAJIB lewat `formatTemp` dan `formatWind` (`utils/units.dart`) dengan satuan dari `SettingsViewModel`. Data di model selalu metrik (°C dan km/h).
14. Warna latar, teks, dan bayangan di view diambil dari Theme (`Theme.of(context)`), bukan konstanta terang. Hanya warna gradien kartu cuaca dan warna putih di atas gradien yang boleh langsung dari `AppColors`.
15. Hasil akhir harus lolos `flutter analyze` tanpa error dan warning.

## 2. Setup proyek

- Nama paket: `cuaca_kita`. Jika proyek belum ada: `flutter create cuaca_kita`.
- `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.1.0
  shared_preferences: ^2.2.0
  google_fonts: ^6.2.0
  intl: ^0.19.0
```

  (Boleh memakai versi stabil terbaru yang kompatibel dengan Flutter yang terpasang.)

- Tambahkan izin internet di `android/app/src/main/AndroidManifest.xml`, di dalam `<manifest>` sebelum `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

- Tanggal berbahasa Indonesia: panggil `initializeDateFormatting('id_ID')` dari `package:intl/date_symbol_data_local.dart` di `main()` sebelum `runApp`, setelah `WidgetsFlutterBinding.ensureInitialized()`.

## 3. Struktur file (buat persis ini)

```
lib/
  main.dart
  theme/
    app_theme.dart
  models/
    location.dart
    weather.dart             # Weather, DailyForecast, HourlyForecast
  services/
    weather_service.dart
    storage_service.dart
  viewmodels/
    weather_viewmodel.dart
    search_viewmodel.dart
    favorites_viewmodel.dart
    settings_viewmodel.dart
  views/
    splash_screen.dart       # layar 0
    main_shell.dart          # NavigationBar 3 tab
    home_screen.dart         # layar 1
    search_screen.dart       # layar 2
    favorites_screen.dart    # layar 3
    forecast_screen.dart     # layar 4
    detail_screen.dart       # layar 5
    settings_screen.dart     # layar 6
  widgets/
    weather_card.dart
    info_chip.dart
    hourly_item.dart
    daily_tile.dart
    city_tile.dart
    detail_tile.dart
    tip_card.dart
    state_message.dart       # pesan error/kosong + tombol Coba Lagi
  utils/
    weather_code.dart        # kode cuaca -> teks, emoji, gradien
    weather_tips.dart        # aturan saran
    units.dart               # enum satuan + formatTemp + formatWind
    day_name.dart            # nama hari Indonesia
    error_message.dart       # friendlyError(Object e)
```

## 4. Spesifikasi per file

### 4.1 `theme/app_theme.dart`
- Kelas `AppColors`: konstanta `primary`, `primaryDark`, `accent`, `error`, `onGradient` (putih), `lightBackground`, `lightSurface`, `lightText`, `lightTextSecondary` (nilai dari `01_PROMPT_UIUX.md` bagian 1.1).
- `ThemeData buildLightTheme()`: `useMaterial3: true`, `ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light)` lalu `copyWith(primary, surface, onSurface, onSurfaceVariant, error)`, `scaffoldBackgroundColor: AppColors.lightBackground`, `textTheme: GoogleFonts.poppinsTextTheme(...).apply(bodyColor: text, displayColor: text)`.
- Konstanta radius: `kCardRadius = 28.0`, `kTileRadius = 20.0`.
- Fungsi `List<BoxShadow> cardShadow(BuildContext context)`: `AppColors.primary` opacity 0.15, blur 20, offset (0, 8).
- Pemakaian di view: latar kartu `Theme.of(context).colorScheme.surface`, teks sekunder `colorScheme.onSurfaceVariant`.

### 4.2 `models/location.dart`
- Field `final String name, admin1, country; final double latitude, longitude;`
- `factory Location.fromJson(Map<String, dynamic> json)`: `admin1` dan `country` default `''` bila null. Latitude dan longitude lewat `(json['latitude'] as num).toDouble()`.
- `Map<String, dynamic> toJson()` dengan key yang sama dengan `fromJson` (satu format untuk API dan storage).
- `operator ==` dan `hashCode` berdasarkan `latitude` dan `longitude`.
- Getter `subtitle` → `"admin1, country"` tanpa bagian kosong.

### 4.3 `models/weather.dart`
- `Weather`: `temperature`, `feelsLike`, `humidity` (int), `windSpeed`, `precipitation`, `pressure`, `visibility`, `weatherCode` (int), `isDay` (bool), `rainChance` (int), `uvIndex`, `sunrise` (DateTime), `sunset` (DateTime), `List<DailyForecast> daily`, `List<HourlyForecast> hourly`.
- `factory Weather.fromJson(Map<String, dynamic> json)` memetakan:
  - `current.temperature_2m`, `apparent_temperature`, `relative_humidity_2m`, `wind_speed_10m`, `precipitation`, `weather_code`, `surface_pressure`, `visibility`, `is_day == 1`.
  - `daily`: loop sepanjang `daily.time`, gabungkan `weather_code`, `temperature_2m_max`, `temperature_2m_min`, `precipitation_probability_max` (null → 0), `uv_index_max` (null → 0), `sunrise`, `sunset`. `date = DateTime.parse(time)`.
  - `rainChance`, `uvIndex`, `sunrise`, `sunset` pada `Weather` diambil dari `daily[0]`.
  - `hourly`: dari `hourly.time`, `temperature_2m`, `weather_code`. Cari indeks pertama yang waktunya >= `current.time` dibulatkan ke jam (`DateTime.parse(current.time)` lalu menit 0). Ambil 24 data dari indeks itu (`take(24)`). Bila indeks tidak ditemukan, mulai dari 0.
  - Angka JSON bisa `int` atau `double`: selalu `(x as num).toDouble()` atau `.toInt()`.
- `DailyForecast`: `date`, `weatherCode`, `maxTemp`, `minTemp`, `rainChance`, `uvIndex`, `sunrise`, `sunset`.
- `HourlyForecast`: `time` (DateTime), `temperature`, `weatherCode`.

### 4.4 `services/weather_service.dart`
- Kelas `WeatherService` dengan dua method `async`:
  - `Future<List<Location>> searchCity(String query)`: `Uri.https('geocoding-api.open-meteo.com', '/v1/search', {'name': query, 'count': '10', 'language': 'id', 'format': 'json'})`, `http.get(uri).timeout(const Duration(seconds: 10))`. Status bukan 200 → `throw Exception('Gagal memuat data (kode ${res.statusCode}).')`. Ambil `(json['results'] as List? ?? [])` lalu map ke `Location.fromJson`.
  - `Future<Weather> getWeather(Location loc)`: `Uri.https('api.open-meteo.com', '/v1/forecast', {...})` dengan parameter persis seperti `02_PRD.md` bagian 6.2 (`latitude`, `longitude`, `current` termasuk `is_day,surface_pressure,visibility`, `daily` termasuk `uv_index_max,sunrise,sunset`, `hourly`, `forecast_days: '7'`, `timezone: 'auto'`). Timeout 10 detik. Status bukan 200 → throw. Return `Weather.fromJson(jsonDecode(res.body))`.
- Service tidak menangkap error (ViewModel yang menangkap). Tidak mengirim parameter satuan (selalu °C dan km/h).

### 4.5 `services/storage_service.dart`
- Kelas `StorageService` memakai `SharedPreferences.getInstance()` di tiap method (sederhana).
- Key konstanta: `'favorites'`, `'history'`, `'last_location'`, `'temp_unit'`, `'wind_unit'`.
- Method lokasi: `getFavorites()`, `saveFavorites(List<Location>)`, `getHistory()`, `saveHistory(List<Location>)`, `getLastLocation()` (`Location?`), `saveLastLocation(Location)`. Format `List<String>` berisi `jsonEncode(location.toJson())`, dibaca dengan `Location.fromJson(jsonDecode(s))`.
- Method pengaturan: `Future<String?> getString(String key)` dan `Future<void> setString(String key, String value)`.

### 4.6 `utils/weather_code.dart`
- `enum GradientType { clear, cloudy, rain, storm, snow, night }` dan `class WeatherInfo { final String text; final String emoji; final GradientType type; }`.
- `WeatherInfo weatherInfo(int code, bool isDay)` dengan `switch` sesuai tabel `01_PROMPT_UIUX.md` bagian 2. Bila `isDay == false` dan kode 0, 1, atau 2 → emoji malam dan `GradientType.night`.
- `List<Color> gradientColors(GradientType type)` sesuai tabel `01_PROMPT_UIUX.md` bagian 1.2 (dua warna: awal dan akhir).
- File ini boleh mengimpor `material.dart` (untuk `Color`).

### 4.7 `utils/units.dart`
- `enum TempUnit { celsius, fahrenheit }`, `enum WindUnit { kmh, ms }`.
- `String formatTemp(double celsius, TempUnit unit)` → `"27°"`: bila Fahrenheit hitung `c * 9 / 5 + 32`; selalu `round()`.
- `String formatWind(double kmh, WindUnit unit)` → `"8 km/h"` (round) atau `"2.3 m/s"` (`kmh / 3.6`, satu desimal).
- Tanpa `material.dart`.

### 4.8 `utils/weather_tips.dart`
- `class WeatherTip { final String emoji; final String text; }`.
- `List<WeatherTip> getTips(Weather w)` mengikuti tabel aturan di `01_PROMPT_UIUX.md` bagian 4D, urut prioritas, maksimal 3. Bila tidak ada yang cocok, kembalikan satu saran "Cuaca nyaman, selamat beraktivitas!" (😊). Semua dalam satuan metrik. Daftar `if` sederhana, tanpa rumus rumit.

### 4.9 `utils/day_name.dart` dan `utils/error_message.dart`
- `String dayName(DateTime date, {bool isToday = false})` → `'Hari Ini'` bila `isToday`, selain itu `Senin`…`Minggu` dari list konstan dan `date.weekday`.
- `String dayShort(DateTime date)` → `Sen, Sel, Rab, Kam, Jum, Sab, Min`.
- `String friendlyError(Object e)`: `SocketException` / `TimeoutException` / `http.ClientException` → `'Tidak ada koneksi internet. Coba lagi.'`; `FormatException` / `TypeError` → `'Data tidak valid.'`; lainnya → `e.toString().replaceFirst('Exception: ', '')`. Dipakai semua ViewModel.

### 4.10 `viewmodels/settings_viewmodel.dart`
- `class SettingsViewModel extends ChangeNotifier`: field `tempUnit` (default celsius), `windUnit` (default kmh).
- `Future<void> load()`: baca dua string dari `StorageService`, ubah ke enum dengan `values.firstWhere((e) => e.name == s, orElse: () => default)`.
- `setTempUnit`, `setWindUnit`: ubah field, simpan `.name` lewat `setString`, `notifyListeners()`. Tidak ada request ulang.

### 4.11 `viewmodels/weather_viewmodel.dart`
- `enum ViewState { loading, success, empty, error }` (di file ini, diimpor view lain).
- `class WeatherViewModel extends ChangeNotifier` dengan `WeatherService` dan `StorageService` dibuat di dalam kelas (tanpa DI).
- Getter: `Location? location`, `Weather? weather`, `ViewState state`, `String errorMessage`.
- Method:
  - `Future<void> init()`: baca lokasi terakhir (null → Jakarta), lalu panggil `unawaited(loadWeather(lokasi))` (import `dart:async`) agar Splash tidak menunggu jaringan.
  - `Future<void> loadWeather(Location loc)`: `location = loc`, `state = loading`, `notifyListeners()`; simpan sebagai lokasi terakhir; `try { weather = await service.getWeather(loc); state = success; } catch (e) { errorMessage = friendlyError(e); state = error; }`; `notifyListeners()`.
  - `Future<void> refresh()` → `loadWeather(location!)` bila lokasi ada.

### 4.12 `viewmodels/favorites_viewmodel.dart`
- `class FavoritesViewModel extends ChangeNotifier`: **sumber tunggal** daftar favorit untuk Home, Search, dan tab Favorit.
- State: `List<Location> favorites`, `Map<Location, Weather> weathers`, `Set<Location> failed`.
- Method:
  - `Future<void> load()`: baca favorit dari storage.
  - `bool isFavorite(Location loc)`.
  - `Future<void> toggle(Location loc)`: tambah/hapus berdasarkan `==`, simpan, `notifyListeners()`.
  - `Future<void> remove(Location loc)` (untuk geser hapus), `Future<void> clearAll()`.
  - `Future<void> loadAllWeather()`: kosongkan `failed`, lalu `await Future.wait(favorites.map(_loadOne))`, `notifyListeners()`. `_loadOne` membungkus `service.getWeather` dengan `try/catch`: sukses → simpan ke `weathers`, gagal → masuk `failed`. Satu kota gagal tidak boleh membatalkan yang lain.

### 4.13 `viewmodels/search_viewmodel.dart`
- State: `List<Location> results`, `List<Location> history`, `ViewState? state` (null = belum mencari), `String errorMessage`.
- Method:
  - `Future<void> loadHistory()`.
  - `Future<void> search(String query)`: `query.trim().length < 2` → kosongkan hasil, `state = null`, notify, return. Selain itu `state = loading`, notify; `try { results = await service.searchCity(q); state = results.isEmpty ? empty : success; } catch (e) { errorMessage = friendlyError(e); state = error; }`; notify.
  - `Future<void> addToHistory(Location loc)`: hapus item yang sama, sisipkan di indeks 0, `take(5)`, simpan, notify.
  - `Future<void> clearHistory()`, `void clear()` (kosongkan hasil dan state).

### 4.14 `main.dart`
- `main()` async: `WidgetsFlutterBinding.ensureInitialized()`, `await initializeDateFormatting('id_ID')`, buat `final settings = SettingsViewModel(); await settings.load();`, lalu `runApp(MyApp(settings: settings))`.
- `MyApp`: `MultiProvider` berisi `ChangeNotifierProvider.value(value: settings)`, `ChangeNotifierProvider(create: (_) => FavoritesViewModel())`, `ChangeNotifierProvider(create: (_) => WeatherViewModel())`, `ChangeNotifierProvider(create: (_) => SearchViewModel())`. Memuat data awal dilakukan di Splash.
- `MaterialApp(debugShowCheckedModeBanner: false, title: 'Cuaca Kita', theme: buildLightTheme(), home: const SplashScreen())`.

### 4.15 Views

Ikuti layout dan angka di `01_PROMPT_UIUX.md`. Pada setiap view, state diambil dari ViewModel; tidak ada logika bisnis.

- **`splash_screen.dart` (Stateful, layar 0)** — `initState` memanggil `_start()`: `await Future.wait([weatherVm.init(), favoritesVm.load(), searchVm.loadHistory(), Future.delayed(const Duration(milliseconds: 1500))])`; `if (!mounted) return;` lalu `Navigator.pushReplacement` ke `MainShell`. Ambil ViewModel dengan `context.read` di `initState`.
- **`main_shell.dart` (Stateful)** — `int _index = 0`; `Scaffold(body: IndexedStack(index: _index, children: [HomeScreen(), FavoritesScreen(onCitySelected: () => setState(() => _index = 0)), SettingsScreen()]), bottomNavigationBar: NavigationBar(...))`. Saat tab Favorit dipilih (`_index == 1`), panggil `context.read<FavoritesViewModel>().loadAllWeather()`.
- **`home_screen.dart` (Stateless, layar 1)** — `Consumer` atas `WeatherViewModel`, `SettingsViewModel`, `FavoritesViewModel`. `switch` pada `state`: `loading` → `CircularProgressIndicator`; `error` → `StateMessage(emoji: '☁️', message: vm.errorMessage, onRetry: vm.refresh)`; `success` → header, info kota, `WeatherCard` (ketuk → `DetailScreen`), tiga `InfoChip`, banner saran (`getTips(w).first`, ketuk → `DetailScreen`), "Hari Ini" (`HourlyItem`, item pertama `isNow`), "3 Hari ke Depan" (tiga `DailyTile`) dengan tautan "Lihat 7 Hari >" → `ForecastScreen`. Header (cari dan bintang) tampil di semua state. Bintang: `favoritesVm.toggle(weatherVm.location!)`. Tanggal: `DateFormat('EEEE, d MMM yyyy', 'id_ID').format(DateTime.now())`. `RefreshIndicator(onRefresh: vm.refresh)` hanya membungkus state `success`.
- **`search_screen.dart` (Stateful, layar 2)** — `TextEditingController` dan `Timer? _debounce`. `onChanged`: batalkan timer lama, buat `Timer(Duration(milliseconds: 500), () => context.read<SearchViewModel>().search(text))`. `onSubmitted`: langsung `search`. `dispose()`: batalkan timer dan dispose controller. Isi memakai `Consumer2<SearchViewModel, FavoritesViewModel>`: `state == null` → bagian Favorit (dengan `Dismissible`) dan Riwayat, atau pesan 🔍 bila keduanya kosong; `loading`, `empty`, `error`, `success` sesuai tabel `01` bagian 4. Ketuk kartu kota: `await searchVm.addToHistory(loc); weatherVm.loadWeather(loc); if (!mounted) return; Navigator.pop(context, true);` (mengembalikan `true` = kota dipilih). Ketuk bintang: `favoritesVm.toggle(loc)`.
- **`favorites_screen.dart` (Stateless, layar 3)** — parameter `VoidCallback onCitySelected`. `Consumer2<FavoritesViewModel, SettingsViewModel>`. Kartu memakai `CityTile` bergaya favorit atau widget kartu sendiri berisi emoji, nama, suhu, kondisi (dari `weathers[loc]`; `failed.contains(loc)` → "Gagal memuat"; belum ada → "Memuat..."). `RefreshIndicator(onRefresh: favoritesVm.loadAllWeather)`. Ketuk kartu: `weatherVm.loadWeather(loc); onCitySelected();`. Ikon cari: `final picked = await Navigator.push<bool>(...SearchScreen); if (picked == true) onCitySelected();`. Kondisi kosong sesuai `01` bagian 4C.
- **`forecast_screen.dart` (Stateful, layar 4)** — `int _selected = 0` (diubah dengan `setState`). Data dari `WeatherViewModel.weather!.daily`. Kapsul hari, kartu hari terpilih (gradien dari `weatherInfo(code, true)`), empat chip (hujan, UV, terbit, terbenam), lalu tujuh `DailyTile` (terpilih berlatar accent opacity 0.12, ketuk memilih hari).
- **`detail_screen.dart` (Stateless, layar 5)** — ringkasan gradien, grid 6 `DetailTile`, kartu matahari (terbit, terbenam, UV), dan hingga 3 `TipCard` dari `getTips(w)`. Grid memakai `GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: NeverScrollableScrollPhysics(), childAspectRatio: 1.4)`.
- **`settings_screen.dart` (Stateless, layar 6)** — `Consumer<SettingsViewModel>` dengan dua `SegmentedButton` (suhu dan angin) yang memanggil `setTempUnit` dan `setWindUnit`. Dua `ListTile` hapus (riwayat → `SearchViewModel.clearHistory()`, favorit → `FavoritesViewModel.clearAll()`), masing-masing lewat `showDialog` `AlertDialog` konfirmasi lalu `SnackBar`. Kartu Tentang statis.

### 4.16 Widget (semua `StatelessWidget`, constructor `const` bila bisa)
- `WeatherCard({Weather weather, TempUnit unit, VoidCallback? onTap})`: kartu gradien (01 bagian 3 butir 3), memakai `weatherInfo` dan `gradientColors`, `AnimatedContainer` 300 ms.
- `InfoChip({String emoji, String value, String label})`.
- `HourlyItem({HourlyForecast item, TempUnit unit, bool isNow})`: `isNow` → latar accent, teks putih. Jam `HH:mm`.
- `DailyTile({DailyForecast item, TempUnit unit, bool isToday, bool selected = false, VoidCallback? onTap})`.
- `CityTile({Location location, bool isFavorite, VoidCallback onTap, VoidCallback onFavorite})`.
- `DetailTile({String emoji, String value, String label})`.
- `TipCard({WeatherTip tip})`.
- `StateMessage({String emoji, String message, VoidCallback? onRetry})`: tombol "Coba Lagi" tampil bila `onRetry != null`.

## 5. Perilaku yang sering terlewat (cek satu per satu)

- [ ] `json['results']` bisa tidak ada → jangan crash.
- [ ] `precipitation_probability_max` dan `uv_index_max` bisa `null` → `?? 0`.
- [ ] Angka JSON bisa `int` atau `double` → selalu lewat `num`.
- [ ] Setelah `await`, cek `mounted` sebelum memakai `BuildContext` (Splash, Search).
- [ ] Timer debounce dibatalkan di `dispose()`.
- [ ] Search tidak mengirim request untuk input kurang dari 2 karakter.
- [ ] Bintang di Home, Search, dan tab Favorit sinkron (semua membaca `FavoritesViewModel`).
- [ ] Favorit, kota terakhir, dan satuan dibaca saat aplikasi mulai.
- [ ] Splash tidak menunggu jaringan cuaca (hanya storage dan jeda 1,5 detik).
- [ ] Riwayat maksimal 5 dan tanpa duplikat.
- [ ] Prakiraan per jam dimulai dari jam `current.time`, bukan jam perangkat.
- [ ] Tombol "Coba Lagi" benar-benar memanggil ulang request.
- [ ] Tab Favorit: satu kota gagal tidak membatalkan kota lain (`try/catch` per kota).
- [ ] Mengganti satuan langsung mengubah tampilan tanpa request ulang.
- [ ] Semua angka suhu/angin tampil lewat `formatTemp`/`formatWind`.
- [ ] Tidak ada overflow di lebar 320 dp (`FittedBox` pada suhu, `ellipsis` pada nama kota, `GridView` tile tidak terpotong).
- [ ] Izin INTERNET ada di manifest utama.

## 6. Hal yang DILARANG

- Menambah layar di luar 7 layar, atau menambah drawer.
- Menambah package di luar daftar.
- Data cuaca hardcoded atau mock.
- Logika HTTP/storage di view.
- `BuildContext` atau widget di ViewModel.
- Menyimpan favorit di lebih dari satu ViewModel.
- Kode "pintar" yang sulit dijelaskan (rekursi rumit, operator berantai panjang, one-liner padat).

## 7. Dokumentasi (`README.md`)

Buat `README.md` berisi:
1. Judul, deskripsi singkat, dan daftar fitur (wajib dan tambahan).
2. Teknologi: Flutter, Dart, Provider, SharedPreferences, Open-Meteo.
3. Daftar 7 layar dan fungsinya.
4. Struktur folder (salin dari bagian 3).
5. Penjelasan MVVM dengan diagram alur `View → ViewModel → Service → API → Model → View` dan peran empat ViewModel.
6. Implementasi API: dua endpoint, parameter, dan cara respons diubah menjadi model.
7. Penyimpanan lokal: key dan formatnya.
8. Cara menjalankan: `flutter pub get`, `flutter run`.
9. Bagian **Screenshot** dengan placeholder untuk tiap layar: `![Splash](screenshots/splash.png)`, `![Home](screenshots/home.png)`, `![Search](screenshots/search.png)`, `![Favorit](screenshots/favorites.png)`, `![Forecast](screenshots/forecast.png)`, `![Detail](screenshots/detail.png)`, `![Pengaturan](screenshots/settings.png)`, `![Error](screenshots/error.png)` (mahasiswa mengisi gambarnya).
10. Catatan asumsi (jika ada).

## 8. Urutan pengerjaan

1. Setup proyek, dependency, izin internet.
2. `theme`, `utils`, `models`.
3. `services`.
4. `viewmodels` (settings, weather, favorites, search).
5. `widgets`.
6. `views` inti: Home dan Search, lalu `main.dart` sementara tanpa Splash. Uji jalan.
7. Tambahkan `main_shell`, Favorit, Pengaturan, Forecast, Detail, dan Splash satu per satu. Jalankan setelah tiap layar.
8. `flutter analyze` dan perbaiki sampai bersih.
9. Tulis `README.md`.

## 9. Keluaran akhir

1. Seluruh kode lengkap, per file, siap dijalankan (bukan potongan, bukan "sisanya sama").
2. `pubspec.yaml` dan perubahan `AndroidManifest.xml`.
3. `README.md`.
4. Ringkasan singkat (maksimal 10 baris): cara menjalankan dan alur data.
5. Daftar centang bagian 5 dengan status tiap butir.
