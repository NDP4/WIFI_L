# Changelog

## [2.0.0] - 2025-08-02

### 🚀 Major Improvements

#### putuswifi - Deteksi WiFi Aktif yang Akurat

- **✨ BARU**: Metode deteksi koneksi WiFi menggunakan 3 cara sekaligus
  - `nmcli connection show --active | grep ":wifi:"`
  - `nmcli device status | grep "wifi:connected"`
  - `nmcli device wifi | grep "^yes:"`
- **✨ BARU**: Informasi detail koneksi aktif (SSID, IP, signal strength)
- **✨ BARU**: Error handling yang lebih baik dengan fallback detection
- **🔧 FIX**: Masalah WiFi aktif tidak terdeteksi

#### konekwifi - Sistem Pemilihan Nomor

- **✨ BARU**: Sistem pemilihan WiFi dengan nomor (tidak perlu ketik SSID)
- **✨ BARU**: Loop validasi input untuk mencegah error input
- **✨ BARU**: WiFi diurutkan berdasarkan kekuatan sinyal (terkuat di atas)
- **✨ BARU**: Pencegahan duplikasi SSID dalam daftar
- **✨ BARU**: Tampilan dengan emoji dan icon untuk UX yang lebih baik
- **🔧 FIX**: Validasi password yang lebih robust

#### User Experience Improvements

- **✨ BARU**: Output dengan emoji (📶, 🔍, ✅, ❌, 💡, 🔒, 🔄)
- **✨ BARU**: Error messages yang informatif dengan saran solusi
- **✨ BARU**: Progress indicator untuk proses scanning
- **✨ BARU**: Signal strength indicator dengan icon
- **✨ BARU**: Limit maksimum 20 WiFi untuk menghindari list panjang

### Technical Changes

- Improved WiFi detection algorithms
- Better error handling with fallback methods
- Enhanced input validation with retry loops
- Optimized nmcli command usage
- Better memory management for large WiFi lists

### Bug Fixes

- ✅ putuswifi sekarang bisa mendeteksi WiFi aktif dengan akurat
- ✅ konekwifi menggunakan sistem pilihan nomor, tidak perlu ketik SSID
- ✅ Password input validation dengan retry mechanism
- ✅ Signal strength sorting dan display yang lebih baik
- ✅ Duplicate SSID prevention

## [1.0.0] - 2024-01-01

### Added

- Script utama `konekwifi` untuk koneksi WiFi interaktif
- Script `putuswifi` untuk memutuskan koneksi dan mengelola profil
- Installer otomatis (`install.sh`)
- Uninstaller otomatis (`uninstall.sh`)
- Cek status NetworkManager otomatis
- Aktivasi NetworkManager otomatis jika diperlukan
- Scan dan tampilan daftar WiFi tersedia
- Koneksi WiFi dengan password dan tanpa password
- Manajemen profil WiFi tersimpan
- Interface interaktif dengan konfirmasi
- Output berwarna untuk kemudahan reading
- Validasi input dan error handling
- Help/bantuan terintegrasi
- README.md lengkap dengan dokumentasi
- MIT License

### Features

- ✅ Cek dan aktifkan NetworkManager
- ✅ Scan WiFi tersedia
- ✅ Koneksi WiFi aman (WPA/WPA2) dan terbuka
- ✅ Putus koneksi WiFi
- ✅ Kelola profil WiFi tersimpan
- ✅ Hapus profil WiFi tertentu
- ✅ Interface user-friendly
- ✅ Instalasi dan uninstalasi otomatis
- ✅ Error handling dan validasi
- ✅ Dokumentasi lengkap

### Technical Details

- Bahasa: Bash Script
- Dependensi: nmcli, NetworkManager, sudo
- Kompatibilitas: Linux (Ubuntu, Debian, Fedora, Arch, dll)
- Instalasi: `/usr/local/bin/`
- Symlink: `putuswifi` -> `konekwifi`
