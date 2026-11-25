# 02 — PRD: Aplikasi Cuaca "Cuaca Kita"

| Item | Isi |
| --- | --- |
| Versi | 1.0 |
| Tanggal | 25 November 2026 |
| Konteks | Tugas Responsi Flutter |
| Tenggat | 26 November 2026, pukul 10.00 WIB |
| Platform | Android (Flutter, Dart), Material Design 3 |

## 1. Ringkasan

"Cuaca Kita" adalah aplikasi cuaca sederhana. Pengguna mencari kota dari namanya, melihat cuaca terkini dan perkiraan 7 hari, menyimpan kota favorit, melihat detail cuaca beserta saran aktivitas, dan mengatur satuan tampilan. Data diambil dari Open-Meteo (gratis, tanpa API key). Aplikasi memiliki 7 layar, tetapi tiap layar sederhana dan memakai data serta pola MVVM yang sama. Lingkup sengaja dijaga agar seluruh kode mudah dipahami dan dijelaskan oleh mahasiswa.

## 2. Tujuan

1. Memenuhi semua syarat wajib Responsi Flutter (bagian 3).
2. Kode sederhana, rapi, dan bisa dijelaskan baris per baris di video.
3. Tampilan menarik mengikuti referensi desain (lihat `01_PROMPT_UIUX.md`).
4. Menambahkan beberapa fitur kecil yang bernilai tanpa menambah kerumitan.

### Bukan tujuan (out of scope)

Login, notifikasi, widget homescreen, peta, GPS/lokasi otomatis, grafik, multi-bahasa, satuan di luar °C/°F dan km/h/m/s, dan cache data cuaca offline.

## 3. Pemetaan syarat responsi

| # | Syarat dari dokumen responsi | Cara dipenuhi |
| --- | --- | --- |
| 1 | Flutter dan Dart | Proyek Flutter, null safety |
| 2 | StatefulWidget dan StatelessWidget sesuai kebutuhan | `SplashScreen`, `MainShell`, `SearchScreen` (controller dan debounce), dan `ForecastScreen` (hari terpilih) memakai StatefulWidget. Widget lain StatelessWidget |
| 3 | Flutter Widgets dan Material Design | Material 3 (`useMaterial3: true`) |
| 4 | Theme konsisten | `ThemeData` di `theme/app_theme.dart`, dipakai di `MaterialApp` |
| 5 | Typography mudah dibaca | `TextTheme` Poppins lewat `google_fonts` |
| 6 | Responsif | `SafeArea`, scroll, `Expanded`, tanpa ukuran tetap berbahaya |
| 7 | Local storage untuk favorit dan/atau riwayat | `shared_preferences`: favorit, riwayat, kota terakhir |
| 8 | Data tersimpan tampil lagi saat aplikasi dibuka | Dibaca saat `main()` dan saat ViewModel dibuat |
| 9 | State management dari data API | Provider + `ChangeNotifier` |
| 10 | Pencarian lokasi berdasarkan nama kota | Geocoding API, request tiap pencarian |
| 11 | Hasil pencarian dipakai untuk cuaca kota terpilih | Ketuk hasil → `loadWeather(location)` |
| 12 | REST API Open-Meteo, HTTP GET, JSON ke model Dart | `http.get`, `jsonDecode`, `fromJson` manual |
| 13 | Tampilkan data sesuai lokasi terpilih | Koordinat lokasi dikirim ke Forecast API |
| 14 | Tangani loading, kosong, error | Status enum di ViewModel, UI per status |
| 15 | Arsitektur MVVM | models, services, viewmodels, views |
| 16 | Minimal 2 screen (Home dan Search) | `HomeScreen` dan `SearchScreen` (ditambah 5 layar lain, lihat bagian 4.3) |
| 17 | Data dari API, bukan hardcoded | Tidak ada data cuaca statis di kode |
| 18 | Pencarian benar-benar request ke API | Tiap pencarian memanggil Geocoding API |
| 19 | README + screenshot + dokumentasi + video | Lihat bagian 12 |

## 4. Fitur

### 4.1 Wajib

| ID | Fitur | Detail |
| --- | --- | --- |
| F1 | Kota terpilih | Nama kota, provinsi/negara, tanggal hari ini |
| F2 | Cuaca terkini | Kondisi (teks + emoji), suhu, terasa seperti |
| F3 | Info tambahan | Kelembapan (%), kecepatan angin (km/h), peluang hujan hari ini (%) |
| F4 | Perkiraan hari ke depan | Home menampilkan 3 hari, layar Forecast menampilkan 7 hari: hari, kondisi, suhu maks/min, peluang hujan |
| F5 | Cari kota | Input teks, request Geocoding API, daftar hasil |
| F6 | Pilih hasil | Ketuk hasil → kembali ke Home dan memuat cuaca |
| F7 | Favorit | Tambah/hapus lewat bintang, tersimpan lokal |
| F8 | Penanganan state | Loading, kosong (kota tidak ditemukan), error + tombol Coba Lagi |

### 4.2 Tambahan (sederhana)

| ID | Fitur | Detail |
| --- | --- | --- |
| T1 | Riwayat pencarian | 5 kota terakhir yang dipilih, tersimpan lokal |
| T2 | Ingat kota terakhir | Aplikasi membuka kota terakhir. Default Jakarta |
| T3 | Prakiraan per jam | 24 jam ke depan dari jam saat ini, daftar horizontal |
| T4 | Warna kartu mengikuti cuaca | Gradien berdasarkan `weather_code` dan `is_day` |
| T5 | Tarik untuk refresh | `RefreshIndicator` di Home |
| T6 | Geser untuk hapus favorit | `Dismissible` di daftar favorit |
| T7 | Splash screen | Minimal 1,5 detik sambil memuat pengaturan, favorit, dan cuaca awal |
| T8 | Navigasi bawah 3 tab | Beranda, Favorit, Pengaturan (`NavigationBar` Material 3) |
| T9 | Favorit dengan suhu langsung | Tiap kartu favorit menampilkan suhu dan kondisi terkini dari API (request paralel `Future.wait`) |
| T10 | Forecast 7 Hari | Pilih hari lewat kapsul, kartu hari terpilih menampilkan suhu, hujan, UV, terbit, terbenam |
| T11 | Detail Cuaca dan saran | Terasa, kelembapan, angin, tekanan, jarak pandang, curah hujan, matahari, UV, dan saran berbasis aturan sederhana |
| T12 | Pengaturan | Satuan suhu (°C/°F), satuan angin (km/h, m/s), hapus riwayat, hapus favorit |

### 4.3 Daftar layar

| # | Layar | Jenis widget | Dibuka dari | Status |
| --- | --- | --- | --- | --- |
| 0 | Splash | StatefulWidget | Otomatis saat aplikasi mulai | Tambahan |
| 1 | Home / Weather | StatelessWidget | Tab Beranda | Wajib |
| 2 | Search / Location | StatefulWidget | Ikon cari di Home dan Favorit | Wajib |
| 3 | Favorit | StatelessWidget | Tab Favorit | Tambahan |
| 4 | Forecast 7 Hari | StatefulWidget | Tautan "Lihat 7 Hari" di Home | Tambahan |
| 5 | Detail Cuaca | StatelessWidget | Kartu utama atau banner saran di Home | Tambahan |
| 6 | Pengaturan | StatelessWidget | Tab Pengaturan | Tambahan |

`MainShell` (StatefulWidget) adalah wadah tiga tab dan bukan layar tersendiri.

## 5. Alur pengguna

1. Aplikasi dibuka: Splash tampil minimal 1,5 detik sambil membaca pengaturan, favorit, dan kota terakhir (default Jakarta), lalu memuat cuaca. Setelah itu masuk ke tab Beranda.
2. Data berhasil: Home tampil lengkap. Gagal: tampil error dan tombol Coba Lagi.
3. Pengguna mengetuk ikon cari → Search Screen. Favorit dan riwayat tampil.
4. Pengguna mengetik nama kota (minimal 2 huruf, jeda 500 ms) → hasil muncul dari Geocoding API.
5. Pengguna mengetuk hasil → kota disimpan sebagai kota terakhir dan masuk riwayat → kembali ke Home → cuaca dimuat.
6. Pengguna mengetuk bintang (di Home atau Search) → kota masuk/keluar favorit.
7. Aplikasi ditutup lalu dibuka lagi → kota terakhir, favorit, dan satuan tetap ada.
8. Di Home, pengguna mengetuk kartu utama atau banner saran → Detail Cuaca (6 tile, matahari, saran).
9. Pengguna mengetuk "Lihat 7 Hari" → Forecast 7 Hari. Memilih hari mengubah kartu hari terpilih.
10. Tab Favorit menampilkan suhu terkini tiap favorit. Mengetuk kartu membuka kota itu di Beranda.
11. Tab Pengaturan: mengubah satuan langsung berlaku di semua layar dan tersimpan.

## 6. Spesifikasi API

### 6.1 Geocoding

```
GET https://geocoding-api.open-meteo.com/v1/search?name={query}&count=10&language=id&format=json
```

Respons (disederhanakan):

```json
{
  "results": [
    {
      "id": 1642911,
      "name": "Jakarta",
      "latitude": -6.17806,
      "longitude": 106.63,
      "country": "Indonesia",
      "admin1": "Jakarta",
      "timezone": "Asia/Jakarta"
    }
  ]
}
```

Catatan penting:
- Jika tidak ada hasil, kunci `results` **tidak ada** sama sekali (bukan array kosong). Anggap sebagai daftar kosong.
- `admin1` dan `country` bisa tidak ada. Beri nilai default string kosong.
- `query` harus di-encode: gunakan `Uri.https(host, path, queryParameters)`.

### 6.2 Forecast

```
GET https://api.open-meteo.com/v1/forecast
  ?latitude={lat}&longitude={lon}
  &current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,is_day,surface_pressure,visibility
  &daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,uv_index_max,sunrise,sunset
  &hourly=temperature_2m,weather_code
  &forecast_days=7
  &timezone=auto
```

Respons (disederhanakan):

```json
{
  "current": {
    "time": "2026-11-25T18:00",
    "temperature_2m": 27.4,
    "relative_humidity_2m": 78,
    "apparent_temperature": 31.9,
    "precipitation": 0.0,
    "weather_code": 63,
    "wind_speed_10m": 8.2,
    "is_day": 1,
    "surface_pressure": 1008.5,
    "visibility": 24140.0
  },
  "daily": {
    "time": ["2026-11-25", "2026-11-26"],
    "weather_code": [63, 3],
    "temperature_2m_max": [30.1, 31.0],
    "temperature_2m_min": [24.0, 24.5],
    "precipitation_probability_max": [80, 40],
    "uv_index_max": [9.4, 8.1],
    "sunrise": ["2026-11-25T05:42", "2026-11-26T05:42"],
    "sunset": ["2026-11-25T18:00", "2026-11-26T18:01"]
  },
  "hourly": {
    "time": ["2026-11-25T00:00", "2026-11-25T01:00"],
    "temperature_2m": [25.1, 24.8],
    "weather_code": [3, 3]
  }
}
```

Catatan penting:
- Semua array `daily` sama panjang (7) dan berurutan sesuai `daily.time`.
- `hourly` berisi 168 data (7 hari × 24). Ambil 24 data mulai dari jam yang sama dengan `current.time` (dibulatkan ke jam), bandingkan dengan string waktu `hourly.time`. Jangan memakai `DateTime.now()` perangkat, karena zona waktu kota bisa berbeda.
- Waktu tanpa zona (`"2026-11-25T18:00"`) di-parse dengan `DateTime.parse` sebagai waktu lokal kota. Itu sudah benar untuk tampilan.
- Nilai `precipitation_probability_max` bisa `null`. Perlakukan sebagai 0.
- Peluang hujan di Home = `daily.precipitation_probability_max[0]`.
- `sunrise` dan `sunset` berformat `"2026-11-25T05:42"`, di-parse dengan `DateTime.parse` dan ditampilkan `HH:mm`.
- `uv_index_max` bisa `null` → perlakukan sebagai 0. `visibility` dalam meter, `surface_pressure` dalam hPa.
- Satuan suhu dan angin TIDAK dikirim ke API (selalu °C dan km/h). Konversi dilakukan di aplikasi saat menampilkan: °F = °C × 9/5 + 32 dan m/s = km/h ÷ 3.6. Mengganti satuan tidak perlu request ulang.
- Untuk tab Favorit: satu request Forecast per kota favorit (`Future.wait`), dengan parameter yang sama.

## 7. Model data

| Kelas | Field | Keterangan |
| --- | --- | --- |
| `Location` | `name`, `admin1`, `country`, `latitude`, `longitude` | Punya `fromJson` (Geocoding), `toJson`/`fromStorageJson` (storage), `==` dan `hashCode` berdasarkan koordinat |
| `Weather` | `temperature`, `feelsLike`, `humidity`, `windSpeed`, `precipitation`, `weatherCode`, `isDay`, `pressure`, `visibility`, `rainChance`, `uvIndex`, `sunrise`, `sunset`, `daily`, `hourly` | `fromJson` memetakan seluruh respons Forecast |
| `DailyForecast` | `date`, `weatherCode`, `maxTemp`, `minTemp`, `rainChance`, `uvIndex`, `sunrise`, `sunset` | `Weather.uvIndex`, `sunrise`, `sunset` diambil dari `daily[0]` |
| `HourlyForecast` | `time`, `temperature`, `weatherCode` | |

## 8. Penyimpanan lokal (`shared_preferences`)

| Key | Tipe | Isi |
| --- | --- | --- |
| `favorites` | `List<String>` | Tiap item = `jsonEncode(location.toJson())` |
| `history` | `List<String>` | Sama seperti di atas, maksimal 5, terbaru di depan, tanpa duplikat |
| `last_location` | `String` | `jsonEncode(location.toJson())` |
| `temp_unit` | `String` | `celsius` atau `fahrenheit` |
| `wind_unit` | `String` | `kmh` atau `ms` |

Aturan:
- Duplikat ditentukan oleh koordinat (latitude dan longitude sama).
- Menambah ke riwayat: hapus dulu item yang sama, sisipkan di indeks 0, potong sampai 5.
- Semua operasi storage bersifat `async` dan hanya dipanggil dari ViewModel.

## 9. Arsitektur MVVM

```
View  ──(panggil method, baca state)──▶  ViewModel  ──▶  Service  ──▶  API / Storage
  ▲                                         │
  └────────── notifyListeners() ◀───────────┘
```

| Lapisan | Tanggung jawab | Tidak boleh |
| --- | --- | --- |
| Model | Data murni + `fromJson` | Memanggil HTTP atau UI |
| Service | `WeatherService` (HTTP GET), `StorageService` (SharedPreferences) | Menyimpan state UI |
| ViewModel | Menyimpan state (status, data, error), memanggil service, `notifyListeners()` | Mengimpor widget (`package:flutter/material.dart`) |
| View | Menggambar UI dari state, meneruskan aksi pengguna ke ViewModel | Memanggil service atau http langsung |

Empat ViewModel:
- `WeatherViewModel`: kota saat ini, cuaca, status, error, kota terakhir.
- `SearchViewModel`: hasil pencarian, status pencarian, riwayat.
- `FavoritesViewModel`: daftar favorit (sumber tunggal agar bintang di Home, Search, dan tab Favorit sinkron), suhu terkini tiap favorit.
- `SettingsViewModel`: satuan suhu, satuan angin. Dibaca semua view yang menampilkan angka.

Status memakai `enum ViewState { loading, success, empty, error }` (untuk pencarian, `idle` ditambahkan).

## 10. Penanganan error

| Situasi | Perilaku |
| --- | --- |
| Tidak ada internet / timeout | Status error, pesan "Tidak ada koneksi internet. Coba lagi." Timeout request 10 detik |
| HTTP status bukan 200 | Status error, pesan "Gagal memuat data (kode {status})." |
| JSON tidak sesuai | Status error, pesan "Data tidak valid." |
| Pencarian tanpa hasil | Status empty, "Kota tidak ditemukan" |
| Kolom pencarian kosong atau 1 karakter | Tidak ada request, tampilkan favorit dan riwayat |
| Satu kota favorit gagal dimuat | Kartu itu menampilkan `--°` dan `Gagal memuat`. Kota lain tetap tampil |

Semua request dibungkus `try/catch`. Aplikasi tidak boleh crash karena error jaringan.

## 11. Kebutuhan non-fungsional

- Waktu muat cuaca normal: kurang dari 3 detik pada koneksi biasa.
- `flutter analyze` tanpa error dan tanpa warning.
- Tidak ada overflow di lebar 320–430 dp.
- Izin internet: `<uses-permission android:name="android.permission.INTERNET"/>` ada di `android/app/src/main/AndroidManifest.xml` (agar jalan di build release).
- minSdk bawaan Flutter. Tidak ada izin lain.

## 12. Kriteria penerimaan (centang saat selesai)

### Fungsi
- [ ] Home menampilkan kota, kondisi, suhu, terasa seperti, kelembapan, angin, peluang hujan, dan 3 hari ke depan (7 hari lengkap di layar Forecast).
- [ ] Mencari "Bandung", "Tokyo", dan "xyzxyz" menghasilkan daftar, daftar, dan "Kota tidak ditemukan".
- [ ] Memilih hasil mengubah Home ke kota itu dengan data berbeda.
- [ ] Favorit bertahan setelah aplikasi di-kill lalu dibuka lagi.
- [ ] Kota terakhir terbuka otomatis saat aplikasi dibuka lagi.
- [ ] Mode pesawat → tampil error + tombol Coba Lagi, lalu berhasil setelah internet menyala.
- [ ] Riwayat maksimal 5 dan tanpa duplikat.
- [ ] Prakiraan per jam dimulai dari jam saat ini kota tersebut.
- [ ] Splash tampil lalu masuk ke Beranda tanpa layar kosong.
- [ ] Tab Favorit menampilkan suhu tiap kota dari API. Mengetuk kartu membuka kota itu di Beranda.
- [ ] Forecast 7 Hari: memilih hari mengubah kartu hari terpilih (suhu, hujan, UV, terbit, terbenam).
- [ ] Detail Cuaca menampilkan 6 tile, kartu matahari, dan 1 sampai 3 saran yang sesuai aturan.
- [ ] Mengubah °C/°F dan km/h/m/s langsung mengubah semua angka di semua layar tanpa request ulang, dan tetap setelah restart.
- [ ] Hapus riwayat dan hapus favorit berfungsi setelah konfirmasi.

### Teknis
- [ ] Ada StatefulWidget dan StatelessWidget.
- [ ] Theme terpusat, tidak ada warna/font hardcoded di view selain lewat theme/konstanta.
- [ ] View tidak memanggil `http` atau `SharedPreferences`.
- [ ] ViewModel tidak mengimpor `material.dart`.
- [ ] Tidak ada data cuaca statis.

### Pengumpulan
- [ ] Source code di GitHub.
- [ ] `README.md`: deskripsi, fitur, struktur folder, penjelasan MVVM, implementasi API, screenshot Home dan Search (dan state error jika ada).
- [ ] Video penjelasan kode (urutan di bagian 13).
- [ ] Link dikirim ke https://forms.gle/vz5LUdPVZmJ2F5uKA sebelum 26 November 2026 pukul 10.00.

## 13. Urutan penjelasan kode di video

1. Demo aplikasi: cari kota, pilih, favorit, tutup dan buka lagi, lalu tunjukkan Forecast, Detail, dan Pengaturan.
2. Struktur folder dan peran MVVM.
3. `weather_service.dart`: GET dan JSON ke model.
4. `weather_viewmodel.dart`: status, `notifyListeners()`.
5. `home_screen.dart`: `Consumer` dan perubahan tampilan.
6. `storage_service.dart`: simpan dan baca favorit.
7. `app_theme.dart`, `weather_tips.dart`, dan fitur tambahan lain.

## 14. Risiko

| Risiko | Mitigasi |
| --- | --- |
| Kunci `results` tidak ada saat kota tidak ditemukan | Parsing memakai `json['results'] ?? []` |
| `precipitation_probability_max` bernilai null | Pakai `?? 0` |
| Zona waktu salah pada prakiraan per jam | Memakai `current.time` dari API, bukan jam perangkat |
| Aplikasi tidak bisa akses internet di release | Izin INTERNET di manifest utama |
| Terlalu banyak fitur | Hanya fitur di bagian 4, tidak menambah lagi |
| Tujuh layar membuat kode panjang | Layar memakai widget kecil yang sama (`InfoChip`, `DailyTile`, `CityTile`) dan ViewModel yang ringkas |
| Tab Favorit memicu banyak request | Request paralel dengan `Future.wait`, timeout 10 detik per request, kegagalan satu kota tidak membatalkan yang lain |
