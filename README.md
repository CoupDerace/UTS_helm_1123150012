# UTS Catalog Helm

## Deskripsi Aplikasi
Aplikasi E-commerce Toko Helm adalah aplikasi mobile berbasis Flutter yang menyediakan platform untuk membeli helm. Aplikasi ini dilengkapi dengan fitur autentikasi Firebase yang mencakup verifikasi email dan login dengan akun Google. Selain itu, aplikasi juga memiliki tampilan modern dengan dukungan *Dark Mode* dan *Light Mode*. Aplikasi ini terhubung ke backend API berbasis Golang yang menggunakan database MySQL.

## Arsitektur Aplikasi
Aplikasi ini dibangun menggunakan arsitektur fitur-based atau Clean Architecture yang terbagi dalam direktori `core` (untuk komponen utama) dan `features` (untuk modul-modul spesifik). 

**Tech Stack Utama:**
- **Front-End:** Flutter (Dart)
- **State Management:** Provider
- **Autentikasi:** Firebase Authentication (Email/Password & Google Sign-In)
- **API Client:** Dio
- **Back-End API:** Golang (dihosting secara terpisah)
- **Database:** MySQL

## Cara Menjalankan Proyek
Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi di lingkungan lokal Anda:

1. **Persyaratan Sistem:**
   - Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.9.2 atau lebih baru) sudah terinstal.
   - Emulator Android/iOS atau perangkat fisik yang terhubung.
2. **Clone Repositori:**
   ```bash
   git clone <https://github.com/CoupDerace/UTS_helm_1123150012.git>
   cd uts_catalog_helm
   ```
3. **Instal Dependensi:**
   Unduh semua dependensi yang dibutuhkan dengan perintah berikut:
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi:**
   Pastikan emulator atau perangkat Anda siap, lalu jalankan:
   ```bash
   flutter run
   ```

## Daftar Dependensi Utama
Berikut adalah dependensi utama yang digunakan dalam pengembangan aplikasi ini, seperti yang tercantum pada `pubspec.yaml`:
- **flutter:** Framework UI utama.
- **provider** (`^6.1.2`): Untuk manajemen state aplikasi.
- **firebase_core** (`^3.6.0`), **firebase_auth** (`^5.3.1`), **google_sign_in** (`^6.2.1`): Untuk layanan backend dan autentikasi.
- **dio** (`^5.7.0`): Untuk melakukan HTTP requests ke backend API.
- **flutter_secure_storage** (`^9.2.2`): Untuk penyimpanan data sensitif secara aman.
- **shared_preferences** (`^2.5.5`): Untuk penyimpanan data lokal yang ringan.
- **image_picker** (`^1.2.2`): Untuk memilih gambar dari galeri perangkat.
