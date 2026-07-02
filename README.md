#  Catalog Helm
## Pengembang
 * Muhammad Turtusi Afrizal Perdana 
 * 1123150012
 * TI SE 23 P1
 * Teknik Informatika
 * Software Engineering   
 * [Link-Youtube-presentation](https://youtu.be/eaOdBzlhGT8?si=hcxhMzmdavuXZM4F)

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


# Tampilan Aplikasi The Helmets
## Halaman Login & Register
<img width="150" height="336" alt="Screenshot" src="https://github.com/user-attachments/assets/4e0523c4-d436-4d8f-a9cf-6498dc78b06b" /> 
<img width="150" height="336" alt="Screenshot" src="https://github.com/user-attachments/assets/7c6103e2-43a2-4950-b837-18697f322d0c" /> 

## Halaman Menu Utama
<img width="150" height="336" alt="Screenshot" src="https://github.com/user-attachments/assets/39be691b-a1da-4165-b677-cc86774bdb8c" /> 

## Halaman Riwayat Pesanan
<img width="150" height="336" alt="Screenshot_20260702-115436" src="https://github.com/user-attachments/assets/630627a4-4f88-4ec2-ae24-c1578f51509b" />

## Halaman Profile
<img width="150" height="336" alt="Screenshot_20260702-115440" src="https://github.com/user-attachments/assets/3caf286b-cf24-46ee-a296-545fce1be32b" />

## Halaman Keranjang
<img width="150" height="336" alt="Screenshot_20260702-115446" src="https://github.com/user-attachments/assets/7af8afa3-dda2-4e74-b606-7132b8a8beb3" />

## Proses Order & Payment 
<img width="150" height="336" alt="Screenshot_20260702-115451" src="https://github.com/user-attachments/assets/c4635316-17d0-45a0-889b-c023315ef9c1" />
<img width="150" height="336" alt="Screenshot_20260702-115537" src="https://github.com/user-attachments/assets/1894406b-3d47-4ff4-9c1a-bd4107e49ac5" />
<img width="150" height="336" alt="Screenshot_20260702-115542" src="https://github.com/user-attachments/assets/a8cc6cdf-8189-40fb-a98f-c0e11f4d8fa8" />
<img width="150" height="336" alt="Screenshot_20260702-115552" src="https://github.com/user-attachments/assets/02fbf40f-0009-4e0a-9c0c-b32beaa68100" />
<img width="150" height="336" alt="Screenshot_20260702-115557" src="https://github.com/user-attachments/assets/589f3ed2-18d1-4347-a8e5-6bcfd5978744" />
<img width="150" height="336" alt="Screenshot_20260702-115615" src="https://github.com/user-attachments/assets/544cd0d1-7734-4b5d-aa96-32adb7a6cd05" />


# Dark Mode Version
## Halaman Login & Register
<img width="150" height="336" alt="Screenshot_20260702-115732" src="https://github.com/user-attachments/assets/6bfe98d7-2f63-473e-8bf5-c2d58d5c386a" />
<img width="150" height="336" alt="Screenshot_20260702-115736" src="https://github.com/user-attachments/assets/1f10bad7-4054-4508-b4a2-1aaee8e93dd9" />
 
## Halaman Menu Utama
<img width="150" height="336" alt="Screenshot_20260702-115634" src="https://github.com/user-attachments/assets/b8b7e457-f750-47f3-a36f-bda570c792bb" />

## Halaman Riwayat Pesanan
<img width="150" height="336" alt="Screenshot_20260702-115643" src="https://github.com/user-attachments/assets/3a2f6a58-6c89-4404-9d14-1a5dc0d97a36" />

## Halaman Profile
<img width="150" height="336" alt="Screenshot_20260702-115645" src="https://github.com/user-attachments/assets/f85fde86-cf72-4742-b8d3-fe590d4f2203" />

## Halaman Keranjang
<img width="150" height="336" alt="Screenshot_20260702-115639" src="https://github.com/user-attachments/assets/ff7a44b4-5c35-4095-9e47-23dd66e7819b" />

## Halaman Checkout
<img width="150" height="336" alt="Screenshot_20260702-115700" src="https://github.com/user-attachments/assets/9d99328a-b673-4884-9d85-335349507930" />

## Halaman Status Pesanan
<img width="150" height="336" alt="Screenshot_20260702-115712" src="https://github.com/user-attachments/assets/f60b6a8d-dff6-4f58-8f37-b92b79d5169e" />

