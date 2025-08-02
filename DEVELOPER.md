# Developer Guide - WiFi Connection Manager

## 📋 Struktur Project

```
konekwifi/
├── konekwifi           # Script utama (bash)
├── putuswifi          # Symlink ke konekwifi
├── install.sh         # Script installer
├── uninstall.sh       # Script uninstaller
├── test.sh            # Test suite
├── README.md          # Dokumentasi utama
├── CHANGELOG.md       # Log perubahan
├── LICENSE           # MIT License
└── DEVELOPER.md      # Guide untuk developer (file ini)
```

## 🔧 Cara Kerja Script

### konekwifi (Script Utama)

Script ini menggunakan bash dengan fitur:

1. **Deteksi Mode**: Script mendeteksi nama pemanggilan (`konekwifi` atau `putuswifi`)
2. **Interface Interaktif**: Menggunakan fungsi `confirm_action()` untuk konfirmasi user
3. **Warna Output**: Menggunakan ANSI color codes untuk output yang menarik
4. **Error Handling**: Validasi input dan penanganan error yang baik

### Fungsi-fungsi Utama

```bash
# Fungsi utama
show_header()                 # Tampilkan header aplikasi
print_message()              # Print dengan warna
confirm_action()             # Konfirmasi ya/tidak dari user

# NetworkManager
check_networkmanager_status() # Cek status NetworkManager
enable_networkmanager()      # Aktifkan NetworkManager

# WiFi Management
show_wifi_list()            # Scan dan tampilkan WiFi
connect_wifi()              # Koneksi ke WiFi
disconnect_wifi()           # Putus koneksi WiFi
show_connection_info()      # Tampilkan info koneksi

# Profile Management
show_saved_connections()    # Tampilkan profil tersimpan
delete_wifi_profile()       # Hapus profil WiFi

# Utility
show_help()                # Tampilkan bantuan
```

## 🎨 Kustomisasi Warna

```bash
# Definisi warna yang digunakan
RED='\033[0;31m'      # Error, gagal
GREEN='\033[0;32m'    # Success, berhasil
YELLOW='\033[1;33m'   # Warning, input
BLUE='\033[0;34m'     # Info, header
NC='\033[0m'          # No Color (reset)
```

## 🔄 Flow Diagram

### konekwifi Flow

```
Start
  ↓
Cek NetworkManager Status? → Yes → Show Status → Active? → No → Enable NM
  ↓                                     ↓                    ↓
  No                                   Yes                   Yes
  ↓                                     ↓                    ↓
Direct Check NM → Not Active? → Enable NM                   ↓
  ↓                    ↓                                     ↓
  ↓                   Yes                                    ↓
  ↓                    ↓                                     ↓
Show WiFi List? → Yes → Scan & Show                         ↓
  ↓                                                          ↓
  No                                                         ↓
  ↓                                                          ↓
Connect WiFi? → Yes → Input SSID → Need Password? → Yes → Input Password
  ↓                                        ↓                      ↓
  No                                      No                      ↓
  ↓                                        ↓                      ↓
Exit                                 Connect Open           Connect Secure
                                          ↓                      ↓
                                    Show Result ← ← ← ← ← ← ← ← ← ←
                                          ↓
                                        End
```

### putuswifi Flow

```
Start
  ↓
Show Active Connections
  ↓
Any Active? → No → Show "No connections"
  ↓                        ↓
 Yes                      End
  ↓
Disconnect All? → No → End
  ↓
 Yes
  ↓
Disconnect WiFi
  ↓
Manage Profiles? → No → End
  ↓
 Yes
  ↓
Show Saved Profiles
  ↓
Delete Profile? → Yes → Input Profile Name → Delete
  ↓                                            ↓
  No                                          End
  ↓
 End
```

## 🛠️ Pengembangan Lanjutan

### Fitur yang Bisa Ditambahkan

1. **GUI Interface**

   - Zenity untuk dialog box
   - GTK+ interface
   - Qt interface

2. **Advanced Features**

   - WiFi enterprise support (WPA-Enterprise)
   - VPN integration
   - Hotspot creation
   - WiFi priority management
   - Auto-connect features

3. **Monitoring & Logging**

   - Connection logs
   - Speed monitoring
   - Signal strength monitoring
   - Auto-reconnect on disconnect

4. **Configuration**
   - Config file support
   - User preferences
   - Custom themes/colors
   - Language localization

### Contoh Pengembangan GUI dengan Zenity

```bash
# Contoh dialog dengan zenity
wifi_list=$(nmcli -t -f SSID device wifi list | zenity --list \
    --title="Pilih WiFi" \
    --column="WiFi Networks" \
    --height=400 \
    --width=300)

password=$(zenity --password --title="Password WiFi")
```

### Contoh Konfigurasi File

```bash
# ~/.config/konekwifi/config
DEFAULT_INTERFACE="wlan0"
AUTO_CONNECT="true"
SHOW_COLORS="true"
LOG_CONNECTIONS="true"
PREFERRED_NETWORKS="Home-WiFi,Office-WiFi"
```

## 🧪 Testing & Debugging

### Manual Testing

```bash
# Test dependencies
./test.sh

# Test help
./konekwifi --help

# Test dengan dry-run (tambahkan ke script)
./konekwifi --dry-run

# Debug mode (tambahkan ke script)
DEBUG=1 ./konekwifi
```

### Unit Testing Framework

Bisa menggunakan framework seperti:

- **bats** (Bash Automated Testing System)
- **shunit2**
- **bashunit**

Contoh dengan bats:

```bash
#!/usr/bin/env bats

@test "nmcli is available" {
    command -v nmcli
}

@test "NetworkManager is active" {
    systemctl is-active NetworkManager
}

@test "help shows correct content" {
    run ./konekwifi --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "WiFi Connection Manager" ]]
}
```

## 📦 Packaging

### Debian Package (.deb)

```bash
# Struktur untuk debian package
debian-package/
├── DEBIAN/
│   ├── control
│   ├── postinst
│   └── prerm
└── usr/
    └── local/
        └── bin/
            ├── konekwifi
            └── putuswifi
```

### RPM Package (.rpm)

```spec
# konekwifi.spec
Name: konekwifi
Version: 1.0.0
Release: 1
Summary: WiFi Connection Manager
License: MIT
Requires: NetworkManager

%install
mkdir -p %{buildroot}/usr/local/bin
cp konekwifi %{buildroot}/usr/local/bin/
ln -s konekwifi %{buildroot}/usr/local/bin/putuswifi
```

### AUR Package (Arch Linux)

```bash
# PKGBUILD
pkgname=konekwifi
pkgver=1.0.0
pkgdesc="Simple WiFi connection manager using nmcli"
depends=('networkmanager')
source=("konekwifi")
```

## 🔒 Security Considerations

1. **Password Handling**

   - Password tidak disimpan di log
   - Menggunakan `read -s` untuk input tersembunyi
   - Clear password dari memory setelah digunakan

2. **Sudo Usage**

   - Minimal sudo usage
   - Specific commands only
   - Validation before execution

3. **Input Validation**
   - Sanitize SSID input
   - Validate password format
   - Prevent command injection

## 📊 Performance Optimization

1. **Caching**

   - Cache WiFi scan results
   - Store last successful connections
   - Optimize nmcli calls

2. **Background Operations**
   - Async WiFi scanning
   - Background connectivity checks
   - Non-blocking UI

## 🌐 Internationalization (i18n)

```bash
# Example localization
case $LANG in
    id_ID*)
        MSG_CONNECT="Menghubungkan ke WiFi"
        MSG_SUCCESS="Berhasil terhubung"
        ;;
    en_US*|*)
        MSG_CONNECT="Connecting to WiFi"
        MSG_SUCCESS="Successfully connected"
        ;;
esac
```

## 📝 Code Style Guide

1. **Function Naming**: snake_case
2. **Variables**: lowercase with underscore
3. **Constants**: UPPERCASE
4. **Indentation**: 4 spaces
5. **Comments**: Bahasa Indonesia untuk user-facing, English untuk technical

## 🤝 Contributing

1. Fork repository
2. Create feature branch
3. Add tests
4. Update documentation
5. Submit pull request

### Commit Message Format

```
type(scope): description

feat(wifi): add enterprise WiFi support
fix(connection): resolve timeout issue
docs(readme): update installation guide
```

---

Semoga panduan ini membantu dalam pengembangan WiFi Connection Manager lebih lanjut! 🚀
