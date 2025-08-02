# WiFi Connection Manager

Aplikasi sederhana berbasis bash script untuk mempermudah koneksi WiFi di Linux menggunakan `nmcli` tanpa perlu mengingat perintah-perintah yang rumit.

## 📋 Daftar Isi

- [Fitur Utama](#fitur-utama)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi](#instalasi)
- [Cara Penggunaan](#cara-penggunaan)
- [Perintah yang Tersedia](#perintah-yang-tersedia)
- [Contoh Penggunaan](#contoh-penggunaan)
- [Troubleshooting](#troubleshooting)
- [Uninstall](#uninstall)

## 🚀 Fitur Utama

### ✅ konekwifi

- Cek status NetworkManager otomatis
- Aktifkan NetworkManager jika diperlukan
- Scan dan tampilkan daftar WiFi tersedia
- Koneksi ke WiFi dengan atau tanpa password
- Interface interaktif dengan konfirmasi untuk setiap langkah
- Tampilkan informasi koneksi setelah berhasil terhubung

### ✅ putuswifi

- Putuskan koneksi WiFi aktif
- Kelola profil WiFi yang tersimpan
- Hapus profil WiFi tertentu
- Interface yang user-friendly

### ✅ Fitur Tambahan

- Output berwarna untuk kemudahan reading
- Validasi input pengguna
- Error handling yang baik
- Help/bantuan terintegrasi

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
git clone <repository-url>
cd konekwifi

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
   - Pilih apakah ingin melihat daftar WiFi tersedia
   - Pilih untuk melakukan koneksi WiFi
   - Masukkan nama WiFi (SSID)
   - Masukkan password (jika diperlukan)

### Putus Koneksi WiFi (putuswifi)

1. **Jalankan perintah**:

   ```bash
   putuswifi
   ```

2. **Ikuti alur interaktif**:
   - Lihat koneksi WiFi yang aktif
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

### Skenario 1: Koneksi WiFi Pertama Kali

```bash
$ konekwifi

================================================
           WiFi Connection Manager
================================================

Apakah ingin melihat status NetworkManager? (y/n): y
Mengecek status NetworkManager...
● NetworkManager.service - Network Manager
   Loaded: loaded (/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2024-01-01 10:00:00 WIB; 1h 30min ago

✓ NetworkManager sudah aktif

Apakah ingin melihat daftar WiFi yang tersedia? (y/n): y
Memindai WiFi yang tersedia...
Menjalankan: nmcli device wifi rescan
Daftar WiFi yang tersedia:
================================================
*  SSID           MODE   CHAN  RATE        SIGNAL  BARS  SECURITY
   MyWiFi-5G      Infra  149   540 Mbit/s  85      ▂▄▆█  WPA2
   MyWiFi-2.4G    Infra  6     130 Mbit/s  82      ▂▄▆█  WPA2
   Guest-WiFi     Infra  1     54 Mbit/s   45      ▂▄__  --
================================================

Apakah ingin menghubungkan ke WiFi? (y/n): y

Masukkan nama WiFi (SSID) yang ingin dihubungkan:
MyWiFi-5G
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

### Skenario 2: Putus Koneksi WiFi

```bash
$ putuswifi

================================================
           WiFi Connection Manager
================================================

Koneksi WiFi saat ini:
================================================
- MyWiFi-5G
================================================
Apakah ingin memutuskan semua koneksi WiFi? (y/n): y
Memutuskan koneksi WiFi...
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
# Jalankan uninstaller
./uninstall.sh
```

### Manual

```bash
# Hapus file yang terinstall
sudo rm -f /usr/local/bin/konekwifi
sudo rm -f /usr/local/bin/putuswifi
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
