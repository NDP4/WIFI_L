# Quick Start - WiFi Connection Manager

## 🚀 Instalasi Cepat

```bash
# 1. Clone atau download project
git clone <repo-url>
cd konekwifi

# 2. Install
./install.sh

# 3. Test
konekwifi --help
```

## ⚡ Penggunaan Cepat

### Koneksi WiFi

```bash
konekwifi
```

### Putus Koneksi

```bash
putuswifi
```

### Bantuan

```bash
konekwifi --help
```

## 🔧 Troubleshoot Cepat

### NetworkManager tidak aktif

```bash
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
```

### nmcli tidak ditemukan

```bash
# Ubuntu/Debian
sudo apt install network-manager

# Fedora
sudo dnf install NetworkManager

# Arch
sudo pacman -S networkmanager
```

### Permission denied

```bash
sudo usermod -a -G netdev $USER
# Logout dan login kembali
```

## 📱 Contoh Penggunaan

### Skenario 1: Koneksi WiFi rumah

```
$ konekwifi
> Cek NetworkManager? (y/n): y
> Lihat daftar WiFi? (y/n): y
> Koneksi WiFi? (y/n): y
> SSID: Home-WiFi
> Password: [masukkan password]
✓ Berhasil terhubung!
```

### Skenario 2: Putus dan hapus profil

```
$ putuswifi
> Putus koneksi? (y/n): y
✓ Koneksi diputus
> Hapus profil? (y/n): y
> Nama profil: Old-WiFi
✓ Profil dihapus
```

## 🗑️ Uninstall

```bash
./uninstall.sh
```

---

**Selamat menggunakan WiFi Connection Manager!** 🎉
