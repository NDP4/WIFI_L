# WiFi Connection Manager (konekwifi)

Comprehensive WiFi connection manager untuk Linux dengan multiple versions dan fitur advanced.

## 📋 Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Available Versions](#available-versions)
- [Quick Start](#quick-start)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi](#instalasi)
- [Cara Penggunaan](#cara-penggunaan)
- [Advanced Features](#advanced-features)
- [Troubleshooting](#troubleshooting)
- [Testing](#testing)
- [Uninstall](#uninstall)
- [Changelog](#changelog)

## 🚀 Fitur Utama

### Core Features

- ✅ Koneksi WiFi dengan mudah (tidak perlu mengingat command nmcli yang kompleks)
- ✅ Pemilihan WiFi berdasarkan nomor (tidak perlu mengetik nama SSID)
- ✅ Putus koneksi WiFi dengan mudah
- ✅ Deteksi WiFi yang sedang aktif dengan 3 metode deteksi
- ✅ Interface yang user-friendly dengan warna dan emoji
- ✅ Validasi input password dengan secure input
- ✅ Easy uninstall dengan command `uninstallwifi`

### Advanced Features (v3.0)

- 🔒 **Security**: Root user prevention, secure password handling
- 🌍 **Internationalization**: Support Bahasa Indonesia & English
- ⚡ **Performance**: WiFi list caching, optimized scanning
- 🖥️ **GUI Support**: Zenity-based graphical interface
- 📊 **Enhanced Logging**: Comprehensive error reporting
- 🔧 **Enhanced Error Handling**: Multiple fallback methods

## 📦 Available Versions

| Version         | Description         | Features                                |
| --------------- | ------------------- | --------------------------------------- |
| `konekwifi`     | Original CLI        | Basic WiFi management                   |
| `konekwifi-v3`  | Enhanced CLI        | Security, i18n, caching                 |
| `konekwifi-gui` | GUI Version         | Zenity integration, graphical interface |
| `putuswifi`     | Disconnect CLI      | Original disconnect functionality       |
| `putuswifi-v3`  | Enhanced Disconnect | Enhanced with i18n and security         |

## 🚀 Quick Start

### Instalasi

```bash
# Clone atau download project
git clone https://github.com/NDP4/WIFI_L.git
cd WIFI_L

# Install dengan enhanced installer
chmod +x install-v3.sh
./install-v3.sh

# Atau install dengan installer original
chmod +x install.sh
./install.sh
```

### Penggunaan

#### CLI Versions

```bash
# Original CLI version
konekwifi        # Connect to WiFi
putuswifi        # Disconnect WiFi

# Enhanced CLI version (v3)
konekwifi-v3     # Enhanced connect with security features
putuswifi-v3     # Enhanced disconnect with i18n

# Help
konekwifi --help
konekwifi-v3 --help
```

#### GUI Version

```bash
# Graphical interface (requires zenity)
konekwifi-gui
```

#### Maintenance

```bash
# Uninstall
uninstallwifi

# Test installation
./test-v3.sh
```

## 🔧 Persyaratan Sistem

- **OS**: Linux (Ubuntu, Debian, Fedora, Arch, dll)
- **NetworkManager**: Harus terinstall di sistem
- **nmcli**: Command line tool untuk NetworkManager
- **Bash**: Shell untuk menjalankan script
- **sudo**: Akses root untuk mengelola NetworkManager

### Cek Persyaratan

```bash
# Cek apakah nmcli tersedia
which nmcli

# Cek status NetworkManager
systemctl status NetworkManager
```

### Install NetworkManager (jika belum ada)

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install network-manager

# Fedora/RHEL/CentOS
sudo dnf install NetworkManager

# Arch Linux
sudo pacman -S networkmanager

# openSUSE
sudo zypper install NetworkManager
```

## 📦 Instalasi

### 1. Download atau Clone Repository

```bash
# Clone repository
git clone https://github.com/NDP4/WIFI_L.git
cd WIFI_L

# Atau download manual dan extract
```

### 2. Jalankan Installer

```bash
# Berikan permission execute
chmod +x install.sh

# Jalankan installer
./install.sh
```

### 3. Verifikasi Instalasi

```bash
# Test apakah berhasil terinstall
konekwifi --help
putuswifi --help
```

## 🎯 Cara Penggunaan

### Koneksi WiFi (konekwifi)

1. **Jalankan perintah**:

   ```bash
   konekwifi
   ```

2. **Ikuti alur interaktif**:
   - Pilih apakah ingin melihat status NetworkManager
   - Konfirmasi untuk mengaktifkan NetworkManager (jika diperlukan)
   - Pilih apakah ingin melihat daftar WiFi tersedia (opsional preview)
   - Pilih untuk melakukan koneksi WiFi
   - **Pilih nomor WiFi dari daftar yang tersedia** (sistem baru)
   - Masukkan password (jika WiFi memerlukan autentikasi)

### Putus Koneksi WiFi (putuswifi)

1. **Jalankan perintah**:

   ```bash
   putuswifi
   ```

2. **Ikuti alur interaktif**:
   - **Lihat informasi detail koneksi WiFi yang aktif** (fitur baru)
   - Konfirmasi untuk memutuskan koneksi
   - Pilih untuk mengelola profil WiFi tersimpan
   - Hapus profil WiFi tertentu (opsional)

## 📝 Perintah yang Tersedia

| Perintah           | Fungsi       | Deskripsi                            |
| ------------------ | ------------ | ------------------------------------ |
| `konekwifi`        | Koneksi WiFi | Proses lengkap untuk koneksi ke WiFi |
| `putuswifi`        | Putus WiFi   | Memutuskan koneksi dan kelola profil |
| `konekwifi --help` | Bantuan      | Menampilkan panduan penggunaan       |
| `konekwifi -h`     | Bantuan      | Alias untuk --help                   |

## 💡 Contoh Penggunaan

### Skenario 1: Koneksi WiFi dengan Sistem Pemilihan Nomor (Fitur Baru)

```bash
$ konekwifi

================================================
           WiFi Connection Manager
================================================

Apakah ingin melihat status NetworkManager? (y/n): y
Mengecek status NetworkManager...
● NetworkManager.service - Network Manager
   Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2025-01-01 10:00:00 WIB; 1h 30min ago

✓ NetworkManager sudah aktif

Apakah ingin melihat daftar WiFi yang tersedia terlebih dahulu? (y/n): n

Apakah ingin menghubungkan ke WiFi? (y/n): y

Memindai WiFi yang tersedia...
Menjalankan: nmcli device wifi rescan
Daftar WiFi yang tersedia:
================================================
No.  SSID                          Security     Signal
================================================
1    MyWiFi-5G                     WPA2         85%
2    MyWiFi-2.4G                   WPA2         82%
3    Office-WiFi                   WPA2         70%
4    Guest-Network                 --           45%
5    Neighbor-WiFi                 WPA2         38%
================================================

Pilih nomor WiFi yang ingin dihubungkan (1-5): 1
WiFi yang dipilih: MyWiFi-5G
WiFi ini memerlukan password.
Masukkan password WiFi:
[password tersembunyi]

Menghubungkan ke WiFi: MyWiFi-5G
Menjalankan: nmcli device wifi connect "MyWiFi-5G" password "***"
✓ Berhasil terhubung ke WiFi: MyWiFi-5G

Informasi koneksi saat ini:
================================================
NAME                UUID                                  TYPE  DEVICE
MyWiFi-5G          a1b2c3d4-e5f6-7890-abcd-ef1234567890  wifi  wlan0

DEVICE  TYPE      STATE         CONNECTION
wlan0   wifi      connected     MyWiFi-5G
================================================

Proses selesai!
```

### Skenario 2: Putus Koneksi WiFi dengan Informasi Detail (Fitur Baru)

```bash
$ putuswifi

================================================
           WiFi Connection Manager
================================================

Mengecek koneksi WiFi saat ini...
Koneksi WiFi aktif saat ini:
================================================
KONEKSI AKTIF:
- Nama Koneksi: MyWiFi-5G
- Perangkat: wlan0
- Tipe: wifi
  IP4.ADDRESS[1]:                         192.168.1.150/24
  802-11-wireless.ssid:                   MyWiFi-5G
  Signal: 85%

STATUS PERANGKAT:
- Perangkat: wlan0 (wifi)
- Status: connected
- Koneksi: MyWiFi-5G
================================================

Apakah ingin memutuskan semua koneksi WiFi? (y/n): y
Memutuskan koneksi WiFi...
Menjalankan: nmcli connection down "MyWiFi-5G"
Menjalankan: nmcli radio wifi off
Menjalankan: nmcli radio wifi on
✓ Koneksi WiFi telah diputuskan

Apakah ingin menghapus profil WiFi yang tersimpan? (y/n): y
Profil WiFi yang tersimpan:
================================================
- MyWiFi-5G
- Office-WiFi
- Home-Guest
================================================
Apakah ingin menghapus profil WiFi tertentu? (y/n): y

Masukkan nama profil WiFi yang ingin dihapus:
Office-WiFi
Menghapus profil WiFi: Office-WiFi
Menjalankan: nmcli connection delete "Office-WiFi"
✓ Profil WiFi 'Office-WiFi' berhasil dihapus
```

## 🔧 Troubleshooting

### Problem: NetworkManager tidak aktif

**Solusi**:

```bash
# Aktifkan dan start NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Atau gunakan aplikasi untuk mengaktifkan otomatis
konekwifi
```

### Problem: nmcli tidak ditemukan

**Solusi**:

```bash
# Install NetworkManager
sudo apt install network-manager  # Ubuntu/Debian
sudo dnf install NetworkManager   # Fedora/RHEL
sudo pacman -S networkmanager     # Arch Linux
```

### Problem: Gagal koneksi ke WiFi

**Penyebab umum**:

- Password salah
- Nama WiFi (SSID) salah
- Signal WiFi lemah
- WiFi menggunakan autentikasi enterprise

**Solusi**:

1. Pastikan nama WiFi benar (case-sensitive)
2. Pastikan password benar
3. Dekat ke router WiFi
4. Untuk WiFi enterprise, gunakan nmcli manual

### Problem: Permission denied

**Solusi**:

```bash
# Pastikan user dalam group yang tepat
sudo usermod -a -G netdev $USER
# Logout dan login kembali
```

### Problem: WiFi adapter tidak terdeteksi

**Solusi**:

```bash
# Cek adapter WiFi
nmcli device status
lspci | grep -i wireless
lsusb | grep -i wireless

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

## 🔍 Informasi Tambahan

### File yang Terinstall

```
/usr/local/bin/konekwifi    # Script utama
/usr/local/bin/putuswifi    # Symlink ke konekwifi
```

### Log NetworkManager

```bash
# Lihat log NetworkManager
journalctl -u NetworkManager -f
```

### Konfigurasi Manual nmcli

```bash
# Contoh perintah nmcli manual
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"
nmcli connection show
nmcli connection delete "SSID"
```

## 🗑️ Uninstall

### Otomatis menggunakan Uninstaller

```bash
# Jalankan uninstaller dari mana saja
uninstallwifi
```

### Manual (jika diperlukan)

```bash
# Hapus file yang terinstall
sudo rm -f /usr/local/bin/konekwifi
sudo rm -f /usr/local/bin/putuswifi
sudo rm -f /usr/local/bin/uninstallwifi
```

## 📄 Lisensi

Script ini bebas digunakan dan dimodifikasi sesuai kebutuhan.

## 🤝 Kontribusi

Silakan buat issue atau pull request untuk perbaikan dan fitur baru.

## 📞 Support

Jika mengalami masalah, silakan:

1. Cek bagian [Troubleshooting](#troubleshooting)
2. Buat issue di repository
3. Hubungi developer

---

**WiFi Connection Manager** - Mempermudah koneksi WiFi di Linux tanpa ribet! 🚀
