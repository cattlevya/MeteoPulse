# 01 — PROMPT UI/UX: Aplikasi Cuaca "Cuaca Kita"

> Gunakan file ini sebagai satu-satunya sumber desain. Semua nilai di bawah WAJIB dipakai persis.
> Jika ada hal yang tidak tertulis, pilih yang paling sederhana dan konsisten dengan gaya di bawah. Jangan menambah elemen baru.

## 0. Konteks

- Aplikasi mobile cuaca, bahasa antarmuka: **Bahasa Indonesia**.
- Aplikasi terdiri dari **7 layar**: Splash, Home, Search, Favorit, Forecast 7 Hari, Detail Cuaca, dan Pengaturan. Navigasi utama memakai bar bawah 3 tab (Beranda, Favorit, Pengaturan).
- Platform: Flutter, Material Design 3, orientasi portrait.
- Referensi visual (gambar terlampir oleh pengguna): dua layar ponsel bergaya soft 3D modern. Ciri-cirinya:
  - Latar putih dan biru muda, kartu sangat membulat, bayangan lembut.
  - Kartu cuaca utama berupa gradien biru dengan ikon cuaca besar di kiri dan suhu besar putih di kanan.
  - Tiga chip kecil berisi ikon dan nilai (hujan, angin, kelembapan).
  - Daftar jam horizontal, item aktif berwarna ungu.
  - Daftar hari berupa kartu putih dengan suhu min/maks.
  - Satu warna aksen: ungu.
- Ikon cuaca di referensi berupa 3D render. Di aplikasi, **gunakan emoji** sebagai ikon cuaca (tanpa aset gambar) agar tetap berwarna dan sederhana.

## 1. Design tokens (wajib dipakai persis)

### 1.1 Warna

| Nama | Hex | Pemakaian |
| --- | --- | --- |
| primary | `#6C9CFF` | Gradien kartu utama (awal), tombol, indikator |
| primaryDark | `#4A7BEA` | Gradien kartu utama (akhir), teks tautan |
| accent | `#7B6CF6` | Item terpilih (jam aktif), bintang favorit aktif |
| background | `#F2F6FF` | Latar semua layar |
| surface | `#FFFFFF` | Kartu, chip, kolom pencarian |
| textPrimary | `#1F2A44` | Judul, nama kota, angka |
| textSecondary | `#8A94A8` | Keterangan, tanggal, label |
| onGradient | `#FFFFFF` | Teks di atas kartu gradien |
| error | `#E5566D` | Pesan error |
| shadow | `#6C9CFF` dengan opacity 0.15 | Bayangan kartu |

Aturan: view mengambil warna latar, teks, dan bayangan dari Theme (`Theme.of(context)`).

### 1.2 Gradien kartu utama (berubah mengikuti kondisi cuaca)

| Kondisi | Warna awal | Warna akhir |
| --- | --- | --- |
| Cerah / cerah berawan | `#6FB1FF` | `#4A7BEA` |
| Berawan / berkabut | `#8FA6C8` | `#6B84AD` |
| Hujan / gerimis | `#6C8CDB` | `#4A5FB8` |
| Badai petir | `#7B6CF6` | `#4B3FB5` |
| Salju | `#A8C8F0` | `#7FA3D8` |
| Malam (is_day = 0, kondisi cerah/berawan) | `#5B5FC7` | `#2E3A87` |

Arah gradien: `topLeft` ke `bottomRight`.

### 1.3 Tipografi (font Poppins via package `google_fonts`)

| Gaya | Ukuran | Berat | Warna |
| --- | --- | --- | --- |
| Suhu besar | 72 | w600 | onGradient |
| Judul layar / nama kota | 22 | w700 | textPrimary |
| Judul bagian (mis. "Hari Ini") | 18 | w700 | textPrimary |
| Nama kondisi di kartu | 22 | w600 | onGradient |
| Isi / nilai | 14 | w500 | textPrimary |
| Keterangan | 12 | w400 | textSecondary |
| "Terasa seperti" | 14 | w400 | onGradient opacity 0.9 |

### 1.4 Bentuk, spasi, bayangan

- Radius kartu utama: **28**. Kartu daftar: **20**. Chip: **20**. Kolom pencarian: **16**. Tombol ikon: **14**.
- Padding layar horizontal: **20**. Jarak antar bagian: **24**. Jarak antar item daftar: **12**. Semua spasi kelipatan 8 (atau 4 untuk jarak kecil).
- Bayangan kartu: warna shadow di atas, blurRadius 20, offset (0, 8).
- Tidak memakai border, hanya bayangan lembut.
- Material 3: `useMaterial3: true`, `ColorScheme.fromSeed(seedColor: #6C9CFF)` lalu timpa `surface`/`background` sesuai tabel.

## 2. Ikon cuaca (emoji) dan teks kondisi

Satu fungsi `utils/weather_code.dart` memetakan `weather_code` WMO ke teks Indonesia, emoji, dan jenis gradien.

| weather_code | Teks | Emoji (siang) | Emoji (malam) | Jenis gradien |
| --- | --- | --- | --- | --- |
| 0 | Cerah | ☀️ | 🌙 | cerah / malam |
| 1 | Cerah Berawan | 🌤️ | 🌙 | cerah / malam |
| 2 | Berawan Sebagian | ⛅ | ☁️ | cerah / malam |
| 3 | Berawan | ☁️ | ☁️ | berawan |
| 45, 48 | Berkabut | 🌫️ | 🌫️ | berawan |
| 51, 53, 55 | Gerimis | 🌦️ | 🌧️ | hujan |
| 56, 57 | Gerimis Beku | 🌧️ | 🌧️ | hujan |
| 61 | Hujan Ringan | 🌦️ | 🌧️ | hujan |
| 63 | Hujan Sedang | 🌧️ | 🌧️ | hujan |
| 65 | Hujan Lebat | 🌧️ | 🌧️ | hujan |
| 66, 67 | Hujan Beku | 🌧️ | 🌧️ | hujan |
| 71, 73, 75, 77 | Salju | ❄️ | ❄️ | salju |
| 80, 81 | Hujan Lokal | 🌦️ | 🌧️ | hujan |
| 82 | Hujan Lokal Lebat | 🌧️ | 🌧️ | hujan |
| 85, 86 | Hujan Salju | 🌨️ | 🌨️ | salju |
| 95 | Badai Petir | ⛈️ | ⛈️ | badai |
| 96, 99 | Badai Petir dan Es | ⛈️ | ⛈️ | badai |
| kode lain | Tidak diketahui | 🌡️ | 🌡️ | berawan |

Ikon info:
- Peluang hujan: 💧 (label "Hujan", nilai `xx%`)
- Angin: 💨 (label "Angin", nilai `xx km/h`)
- Kelembapan: 💦 (label "Lembap", nilai `xx%`)

## 3. Layar 1 — Home / Weather Screen

Latar `background`. Seluruh isi dalam `SafeArea` dan `RefreshIndicator` yang membungkus `SingleChildScrollView` (physics: `AlwaysScrollableScrollPhysics`). Padding horizontal 20.

### Urutan elemen dari atas ke bawah

1. **Header** (tinggi 48, `Row` spaceBetween)
   - Kiri: tombol ikon 48×48, latar putih, radius 14, ikon `Icons.search_rounded` (24, textPrimary). Ketuk membuka Search Screen.
   - Kanan: tombol ikon 48×48 serupa dengan ikon bintang. Isi (`Icons.star_rounded`, accent) jika kota saat ini ada di favorit, kosong (`Icons.star_border_rounded`, textSecondary) jika tidak. Ketuk menyimpan/menghapus favorit kota saat ini.
2. **Info kota** (jarak 16 dari header)
   - Nama kota: gaya "Judul layar", satu baris, ellipsis.
   - Baris kedua: `"{admin1}, {negara}"` gaya "Keterangan" (admin1 dilewati jika kosong).
   - Baris ketiga: tanggal hari ini format Indonesia, contoh `Rabu, 25 Nov 2026`, gaya "Keterangan".
3. **Kartu cuaca utama** (jarak 20)
   - Lebar penuh, tinggi menyesuaikan isi (sekitar 210), padding 20, radius 28, gradien sesuai kondisi, bayangan kartu.
   - Kiri atas: emoji kondisi ukuran 88.
   - Kanan: suhu `{angka}°` gaya "Suhu besar" rata kanan. Di bawahnya `Terasa {angka}°` gaya "Terasa seperti".
   - Kiri bawah: nama kondisi gaya "Nama kondisi di kartu", di bawahnya teks kecil `Saat ini` (12, onGradient opacity 0.8).
   - Suhu dibulatkan ke bilangan bulat (`round()`), tanpa desimal.
   - Semua angka suhu mengikuti satuan di Pengaturan (°C atau °F).
   - Seluruh kartu bisa diketuk untuk membuka layar **Detail Cuaca**. Beri ikon `Icons.chevron_right_rounded` (putih opacity 0.8) di kanan bawah kartu sebagai petunjuk.
4. **Tiga chip info** (jarak 20, `Row` dengan `Expanded` ×3, jarak antar chip 12)
   - Tiap chip: latar putih, radius 20, padding vertikal 16, bayangan kartu.
   - Isi `Column` tengah: emoji ikon (24), nilai (gaya "Isi", w600), label (gaya "Keterangan").
   - Urutan: Hujan (peluang hujan hari ini), Angin, Lembap.
5. **Banner saran** (jarak 20)
   - Kartu radius 20, latar primary opacity 0.1, padding 14, `Row`: emoji saran pertama (24), jarak 12, teks saran (14, w500, maksimal 2 baris).
   - Saran dihitung oleh `utils/weather_tips.dart` (aturan di bagian 4D). Ketuk membuka Detail Cuaca.
6. **Bagian "Hari Ini"** (jarak 24)
   - Judul "Hari Ini" gaya "Judul bagian".
   - Daftar horizontal 24 jam ke depan mulai dari jam saat ini, tinggi 120, `ListView.separated` horizontal, jarak 12.
   - Tiap item lebar 64, radius 32 (kapsul), padding vertikal 12, isi `Column` tengah: jam (`HH:mm`, keterangan), emoji (28), suhu (`xx°`, gaya "Isi" w600).
   - Item pertama (jam saat ini): latar accent, semua teks putih. Item lain: latar putih, bayangan kartu.
7. **Bagian "3 Hari ke Depan"** (jarak 24)
   - `Row` spaceBetween: judul "3 Hari ke Depan" gaya "Judul bagian" dan tautan `Lihat 7 Hari >` (14, w600, primaryDark) yang membuka layar Forecast 7 Hari.
   - Tiga kartu pertama (hari ini, besok, lusa) dalam `Column` (bukan `ListView` bersarang), jarak antar kartu 12.
   - Tiap kartu: latar putih, radius 20, padding 16, bayangan kartu, `Row`:
     - Kiri (Expanded): nama hari Indonesia (`Hari Ini` untuk indeks 0, selain itu `Senin`, `Selasa`, dst.) gaya "Isi" w600, di bawahnya `💧 {xx}%` gaya "Keterangan".
     - Tengah: emoji 32.
     - Kanan: `{maks}°` gaya "Isi" w600 dan `/{min}°` gaya "Keterangan", dalam satu baris.
8. Jarak bawah 32.

### State Home

| State | Tampilan |
| --- | --- |
| loading | `CircularProgressIndicator` warna primary di tengah layar. Header tetap tampil. |
| error | Emoji ☁️ (64), teks pesan error (gaya "Isi", warna error), tombol `FilledButton` "Coba Lagi" (radius 14, latar primaryDark) |
| data | Seluruh elemen di atas |

## 4. Layar 2 — Search / Location Screen

Latar `background`, `SafeArea`, padding horizontal 20.

1. **Header**: tombol kembali 48×48 (gaya sama dengan tombol ikon Home, ikon `Icons.arrow_back_ios_new_rounded`) dan judul "Cari Kota" gaya "Judul layar" di sebelahnya.
2. **Kolom pencarian** (jarak 16): `TextField`, latar putih, radius 16, tanpa border, bayangan lembut, hint `Cari nama kota...`, ikon awal `Icons.search_rounded`, ikon akhir `Icons.close_rounded` (muncul hanya jika ada teks, menghapus teks). `textInputAction: search`. Pencarian berjalan setelah jeda 500 ms setelah pengguna berhenti mengetik, dan juga saat tombol cari di keyboard ditekan. Minimal 2 karakter.
3. **Isi di bawah** (jarak 20), tergantung kondisi:

| Kondisi | Tampilan |
| --- | --- |
| Kolom kosong | Bagian "Favorit" (jika ada) lalu bagian "Riwayat Pencarian" (jika ada). Jika keduanya kosong: emoji 🔍 dan teks "Cari kota untuk melihat cuacanya" |
| Sedang mencari | `CircularProgressIndicator` di tengah |
| Ada hasil | Daftar hasil |
| Hasil kosong | Emoji 🔍 (64) dan teks "Kota tidak ditemukan" |
| Error | Emoji ☁️ (64), pesan error, tombol "Coba Lagi" |

### Item kota (dipakai untuk hasil, favorit, dan riwayat)

- Kartu putih, radius 20, padding 16, bayangan kartu, jarak antar kartu 12.
- Kiri (Expanded): nama kota (gaya "Isi" w600) dan `"{admin1}, {negara}"` (gaya "Keterangan").
- Kanan: `IconButton` bintang (`Icons.star_rounded` accent jika favorit, `Icons.star_border_rounded` textSecondary jika bukan). Ketuk bintang hanya mengubah favorit.
- Ketuk kartu: memilih kota, menyimpan ke riwayat, kembali ke Home, dan cuaca kota itu dimuat.
- Item di bagian Favorit juga bisa digeser ke kiri untuk menghapus (`Dismissible`, latar `error` opacity 0.15, ikon hapus).
- Judul bagian ("Favorit", "Riwayat Pencarian") gaya "Judul bagian". Riwayat maksimal 5 item.

## 4A. Navigasi utama (MainShell)

- `Scaffold` dengan `NavigationBar` (Material 3) di bawah dan `IndexedStack` sebagai body agar state tiap tab terjaga.
- Tiga tujuan: **Beranda** (`Icons.home_rounded`), **Favorit** (`Icons.star_rounded`), **Pengaturan** (`Icons.settings_rounded`).
- Latar bar = surface, `indicatorColor` = primary opacity 0.2, label selalu tampil, ikon terpilih warna primaryDark, ikon lain textSecondary.
- Layar yang dibuka dengan `Navigator.push` (menutupi bar bawah): Search, Forecast 7 Hari, Detail Cuaca.

## 4B. Layar 0 — Splash

- Latar gradien `primary` ke `primaryDark` (topLeft ke bottomRight), konten di tengah (`Column`, mainAxisSize min).
- Emoji ⛅ ukuran 96, jarak 16, teks "Cuaca Kita" (32, w700, putih), jarak 8, tagline "Cek cuaca kotamu dengan cepat" (14, putih opacity 0.85).
- Jarak 32, `CircularProgressIndicator` putih ukuran 28, strokeWidth 3.
- Tampil minimal 1,5 detik sambil aplikasi memuat pengaturan, favorit, dan cuaca. Setelah itu pindah ke MainShell (tanpa tombol kembali).

## 4C. Layar 3 — Favorit (tab)

1. **Header**: judul "Favorit" (gaya "Judul layar") dan tombol cari 48×48 di kanan (gaya sama dengan Home).
2. **Daftar kartu favorit** (jarak 20, jarak antar kartu 12), `RefreshIndicator` untuk tarik-refresh.
   - Kartu putih, radius 20, padding 16, bayangan kartu, `Row`:
     - Emoji cuaca saat ini (36).
     - `Expanded` berisi nama kota (gaya "Isi" w600) dan `subtitle` (gaya "Keterangan").
     - Kanan: suhu `xx°` (gaya "Judul bagian") dan nama kondisi (gaya "Keterangan") rata kanan.
   - Selama data sebuah kota belum datang: emoji 🌡️, suhu `--°`, kondisi `Memuat...`. Jika gagal: suhu `--°`, kondisi `Gagal memuat`.
   - Geser ke kiri untuk menghapus (`Dismissible`, latar `error` opacity 0.15, ikon hapus).
   - Ketuk kartu: jadikan kota aktif, lalu pindah ke tab Beranda.
3. **Kondisi kosong**: emoji ⭐ (64), teks "Belum ada favorit" (gaya "Judul bagian"), teks "Cari kota lalu ketuk bintang untuk menyimpan" (gaya "Keterangan"), tombol `FilledButton` "Cari Kota" (membuka Search).

## 4D. Layar 5 — Detail Cuaca (dibuka dari kartu utama atau banner saran di Home)

1. **Header**: tombol kembali 48×48, judul "Detail Cuaca", dan nama kota (keterangan) di bawah judul.
2. **Ringkasan** (jarak 16): kartu gradien (sama seperti kartu utama), tinggi sekitar 120, emoji 64 di kiri, di kanan suhu (48, w600, putih) dan nama kondisi (16, putih).
3. **Grid 2 kolom** (jarak 20, jarak antar tile 12), enam tile. Tile putih, radius 20, padding 16, bayangan kartu: emoji (24), nilai (18, w700), label (12, textSecondary).

| Emoji | Label | Nilai |
| --- | --- | --- |
| 🌡️ | Terasa Seperti | `xx°` |
| 💦 | Kelembapan | `xx%` |
| 💨 | Angin | `xx km/h` atau `x.x m/s` (sesuai Pengaturan) |
| 🧭 | Tekanan | `xxxx hPa` |
| 👁️ | Jarak Pandang | `x.x km` (meter dibagi 1000, satu desimal) |
| 🌧️ | Curah Hujan | `x.x mm` |

4. **Kartu Matahari** (jarak 20): kartu putih radius 20, `Row` tiga kolom sama lebar, masing-masing emoji, nilai, label: 🌅 `HH:mm` "Terbit", 🌇 `HH:mm` "Terbenam", ☀️ UV `x` "Indeks UV" (UV dibulatkan satu desimal).
5. **Bagian "Saran Hari Ini"** (jarak 24): judul gaya "Judul bagian", lalu maksimal 3 kartu saran (radius 20, latar primary opacity 0.1, padding 14, emoji 28, teks 14).

Aturan saran (`utils/weather_tips.dart`, semua nilai dalam satuan metrik dari API, urutan prioritas dari atas, ambil maksimal 3):

| Syarat | Emoji | Teks |
| --- | --- | --- |
| `weatherCode` 95, 96, atau 99 | ⚠️ | Ada petir, hindari area terbuka. |
| `rainChance` >= 60 atau `weatherCode` 51–67 atau 80–82 | ☂️ | Bawa payung, kemungkinan hujan tinggi. |
| `uvIndex` >= 6 | 🧴 | Indeks UV tinggi, pakai tabir surya dan topi. |
| `temperature` >= 33 | 🥤 | Cuaca panas, perbanyak minum air. |
| `temperature` <= 20 | 🧥 | Cuaca sejuk, bawa jaket. |
| `windSpeed` >= 30 | 💨 | Angin kencang, hati-hati di luar ruangan. |
| `visibility` < 2000 (meter) | 🌫️ | Jarak pandang rendah, hati-hati berkendara. |
| Tidak ada yang cocok | 😊 | Cuaca nyaman, selamat beraktivitas! |

## 4E. Layar 4 — Forecast 7 Hari (dibuka dari tautan "Lihat 7 Hari" di Home)

Mengikuti layar kedua pada gambar referensi.

1. **Header**: tombol kembali 48×48, judul "7 Hari ke Depan", nama kota (keterangan) di bawah judul.
2. **Pilihan hari** (jarak 16): daftar horizontal 7 kapsul, tinggi 104, jarak 12.
   - Kapsul lebar 64, radius 32, padding vertikal 12, `Column` tengah: emoji (24), tanggal angka (18, w700), nama hari singkat (12): `Sen`, `Sel`, `Rab`, `Kam`, `Jum`, `Sab`, `Min`.
   - Terpilih: latar accent, teks putih. Tidak terpilih: latar surface dengan bayangan kartu.
   - Default terpilih: hari pertama (hari ini).
3. **Kartu hari terpilih** (jarak 20): gradien sesuai kondisi hari itu (siang), radius 28, padding 20.
   - Kiri: emoji (80), di bawahnya nama kondisi (20, w600, putih).
   - Kanan: nama hari lengkap + tanggal (`Senin, 30 Nov`, 14, putih opacity 0.9), suhu maksimum (56, w600, putih), dan `Min xx°` (14, putih opacity 0.9).
4. **Empat chip info** (jarak 12), dua baris × dua kolom (`Row` + `Expanded`): 💧 `xx%` "Hujan", ☀️ `x` "Indeks UV", 🌅 `HH:mm` "Terbit", 🌇 `HH:mm` "Terbenam". Gaya sama dengan chip di Home.
5. **Bagian "Semua Hari"** (jarak 24): tujuh kartu `DailyTile` (jarak 12). Kartu hari terpilih berlatar accent opacity 0.12. Ketuk kartu juga memilih hari tersebut.

## 4F. Layar 6 — Pengaturan (tab)

1. **Header**: judul "Pengaturan" (gaya "Judul layar").
2. **Kartu pengaturan** (jarak 20, jarak antar kartu 12): kartu surface, radius 20, padding 16, bayangan kartu. Tiap kartu: judul (14, w600) lalu `SegmentedButton` lebar penuh (jarak 12).

| Pengaturan | Pilihan | Default |
| --- | --- | --- |
| Satuan Suhu | `°C`, `°F` | °C |
| Satuan Angin | `km/h`, `m/s` | km/h |

3. **Kartu Data** (jarak 12): dua baris `ListTile`: "Hapus Riwayat Pencarian" (ikon `Icons.history_rounded`) dan "Hapus Semua Favorit" (ikon `Icons.star_border_rounded`). Ketuk menampilkan `AlertDialog` "Hapus?" dengan tombol Batal dan Hapus, lalu `SnackBar` konfirmasi ("Riwayat dihapus" / "Favorit dihapus").
4. **Kartu Tentang** (jarak 12): "Cuaca Kita v1.0.0" (14, w600) dan "Data cuaca oleh Open-Meteo.com" (12, textSecondary).
5. Perubahan satuan langsung berlaku di seluruh aplikasi dan tersimpan, tanpa tombol simpan.

## 5. Interaksi dan animasi (sederhana)

- Transisi antar layar: default `MaterialPageRoute`.
- Tidak ada animasi kompleks. Boleh memakai `AnimatedContainer` (durasi 300 ms) untuk perubahan warna gradien kartu.
- Tarik ke bawah di Home memuat ulang data.
- Semua area ketuk minimal 48×48.

## 6. Responsif dan aksesibilitas

- Tidak boleh ada overflow di lebar 320 hingga 430 dp. Pakai `Expanded`, `Flexible`, `FittedBox` untuk angka suhu, dan `maxLines` + `overflow: ellipsis` untuk nama kota.
- Layar tinggi kecil harus bisa di-scroll.
- Kontras teks pada gradien: putih di atas warna gradien di tabel 1.2 (semua cukup gelap).
- Tambahkan `Semantics`/`tooltip` pada tombol ikon ("Cari kota", "Tambah favorit").

## 7. Hal yang DILARANG

- Jangan memakai aset gambar, Lottie, atau SVG. Ikon cuaca hanya emoji.
- Jangan menambah layar di luar 7 layar pada dokumen ini, dan jangan memakai drawer.
- Jangan memakai warna di luar tabel.
- Jangan memakai ukuran tetap yang bisa menyebabkan overflow.

## 8. Prompt ringkas untuk tool desain (Figma AI / Stitch / Claude Design)

```text
Rancang UI aplikasi cuaca mobile bergaya soft 3D modern, rasio 9:19.5, bahasa Indonesia, Material 3.
Warna: primary #6C9CFF, primaryDark #4A7BEA, aksen ungu #7B6CF6, latar #F2F6FF, kartu putih, teks #1F2A44.
Font Poppins. Radius kartu 28, bayangan biru lembut blur 20. Ikon cuaca besar berwarna ala emoji 3D.

Layar 1 Home: tombol cari (kiri) dan bintang favorit (kanan) di kotak putih membulat; nama kota tebal,
negara dan tanggal abu; kartu gradien biru berisi ikon cuaca besar kiri, suhu 72px putih kanan, "Terasa 32°",
nama kondisi kiri bawah; tiga chip (Hujan, Angin, Lembap); "Hari Ini" daftar jam horizontal berbentuk
kapsul dengan jam aktif ungu; "7 Hari ke Depan" kartu putih berisi hari, ikon, peluang hujan, suhu maks/min.

Layar 2 Cari Kota: tombol kembali, judul, kolom pencarian membulat, daftar hasil kartu putih dengan
nama kota, provinsi/negara, bintang favorit; bagian Favorit dan Riwayat saat kolom kosong.

Layar lain (total 7): Splash bergradien dengan logo emoji; tab Favorit berisi kartu kota dengan suhu langsung;
Forecast 7 Hari dengan kapsul pilihan hari dan kartu hari terpilih; Detail Cuaca dengan grid 6 tile
(terasa, lembap, angin, tekanan, jarak pandang, hujan), kartu matahari terbit/terbenam/UV, dan kartu saran;
Pengaturan dengan segmented button satuan suhu dan satuan angin. Navigasi bawah 3 tab.
Sertakan varian loading, kosong, dan error.
Konsisten, bersih, mudah dibaca.
```
