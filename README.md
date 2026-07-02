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

### Screenshots

<img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/39be691b-a1da-4165-b677-cc86774bdb8c" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/7c6103e2-43a2-4950-b837-18697f322d0c" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/4e0523c4-d436-4d8f-a9cf-6498dc78b06b" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/73863b90-557f-40e2-b988-c49616d7e88c" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/a307ef53-c48b-452e-96dd-2e40cb9d29ab" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/4575bf62-e836-4361-a576-063106c0ff33" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/a89ef82c-0757-4197-978a-639540a73449" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/c00b0a2e-3ab8-4cfb-adef-1e132fac093a" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/04e17f3c-abb6-473a-9f90-d6dde260b7df" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/46e10dca-0a09-418a-bfc5-9add93cd713b" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/99695b9e-df5a-4a62-8026-8799b566bca8" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/b7ed98c3-2b85-4b07-aa0d-f786ea7fc8da" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/5058fcf0-1850-4b00-8489-849c696fd356" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/a680c13e-d728-4350-a48c-728f096322f8" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/a832814e-f920-4191-a80c-21a5e8bc2776" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/30452eac-5cde-408f-a62f-61fb62b91ce7" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/0a9f5fd8-73e3-49c8-89e7-43f02ac1c2fd" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/b9642eaa-ba16-489c-ae6a-b01216667276" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/005cb960-ab64-4d57-8f76-3494f5c190e9" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/73f4077b-aa82-4151-aeb7-502c63947d71" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/78ed0d75-8375-48aa-9702-05ae48b2777f" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/fe85ce5a-21e1-4fee-be82-204e2b5e7b1a" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/d85fdd5a-4b29-4f62-b100-86ca288b5fc0" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/9ee6acf9-b900-4e5c-8ae7-aa102b626bf7" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/2b2aa482-a77d-46a6-a884-443c2abe97ed" /> <img width="50" height="112" alt="Screenshot" src="https://github.com/user-attachments/assets/afb6c744-a83b-4749-8323-b5aff85340e2" />
