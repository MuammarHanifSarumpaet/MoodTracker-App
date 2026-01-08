# mood_tracker
1. Mood Tracker App adalah aplikasi berbasis Flutter yang digunakan untuk mencatat dan memantau suasana hati (mood) pengguna secara harian. 
Aplikasi ini membantu pengguna memahami pola emosi melalui pencatatan jurnal dan visualisasi statistik.

2. Fitur Utama :
- Pencatatan mood harian menggunakan emoji
- Catatan jurnal harian
- Upload foto
- Riwayat mood & kalender
- Insight & statistik mood = Mood streak (konsistensi pencatatan)
- Basic error handling

3. Cara Menjalankan Aplikasi Prasyarat
- Flutter SDK (stable)
- Android Studio / VS Code
- Emulator Android atau device fisik
- flutter pub get
- flutter run

4. Database Schema,Aplikasi ini menggunakan SQLite sebagai database lokal dengan satu tabel utama, yaitu moods.
 Field Name  Type     Keterangan                      
 id          INTEGER  Primary key, auto increment     
 mood        TEXT     Emoji atau label mood           
 mood_level  INTEGER  Tingkat mood (skala numerik)    
 category    TEXT     Kategori mood                   
 date        TEXT     Tanggal pencatatan (ISO format) 
 image_path  TEXT     Path gambar (opsional)          

5. Image Handling
- Gambar diambil menggunakan image_picker
- Disimpan di local storage
- Path gambar dicatat di database

6. Teknologi yang Digunakan
- Flutter & Dart
- SQLite (sqflite)
- Provider (State Management)
- Image Picker
- Local Storage

7. Link APK/AAB untuk testing dan Video Presentasi

Nama: Muammar Hanif Sarumpaet 
NIM : A11.2022.14598

