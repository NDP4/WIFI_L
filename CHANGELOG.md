# Changelog

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
