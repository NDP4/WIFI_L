#!/bin/bash

# Installer untuk WiFi Connection Manager
# Script ini akan menginstall konekwifi dan putuswifi ke sistem

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fungsi untuk menampilkan pesan dengan warna
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Fungsi untuk konfirmasi ya/tidak
confirm_action() {
    local prompt=$1
    while true; do
        echo -e "${YELLOW}${prompt} (y/n): ${NC}"
        read -r response
        case $response in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) print_message $RED "Silakan jawab dengan y atau n.";;
        esac
    done
}

# Header
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}      WiFi Connection Manager Installer        ${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Cek apakah running sebagai root
if [[ $EUID -eq 0 ]]; then
    print_message $RED "Jangan jalankan installer ini sebagai root!"
    print_message $YELLOW "Gunakan: ./install.sh"
    exit 1
fi

# Cek apakah nmcli tersedia
if ! command -v nmcli &> /dev/null; then
    print_message $RED "nmcli tidak ditemukan!"
    print_message $YELLOW "Install NetworkManager terlebih dahulu:"
    print_message $YELLOW "  Ubuntu/Debian: sudo apt install network-manager"
    print_message $YELLOW "  Fedora/RHEL:   sudo dnf install NetworkManager"
    print_message $YELLOW "  Arch Linux:    sudo pacman -S networkmanager"
    exit 1
fi

print_message $GREEN "✓ nmcli ditemukan"

# Tentukan direktori instalasi
INSTALL_DIR="/usr/local/bin"
CURRENT_DIR=$(pwd)

print_message $BLUE "Direktori instalasi: $INSTALL_DIR"
print_message $BLUE "Direktori saat ini: $CURRENT_DIR"
echo ""

# Konfirmasi instalasi
if confirm_action "Apakah ingin menginstall WiFi Connection Manager?"; then
    print_message $BLUE "Memulai instalasi..."
    
    # Buat file executable
    chmod +x "$CURRENT_DIR/konekwifi"
    
    # Copy ke sistem
    print_message $YELLOW "Mengcopy konekwifi ke $INSTALL_DIR..."
    if sudo cp "$CURRENT_DIR/konekwifi" "$INSTALL_DIR/"; then
        print_message $GREEN "✓ konekwifi berhasil diinstall"
    else
        print_message $RED "✗ Gagal menginstall konekwifi"
        exit 1
    fi
    
    # Buat symlink untuk putuswifi
    print_message $YELLOW "Membuat symlink putuswifi..."
    if sudo ln -sf "$INSTALL_DIR/konekwifi" "$INSTALL_DIR/putuswifi"; then
        print_message $GREEN "✓ putuswifi berhasil diinstall"
    else
        print_message $RED "✗ Gagal membuat symlink putuswifi"
        exit 1
    fi
    
    echo ""
    print_message $GREEN "🎉 Instalasi berhasil!"
    print_message $BLUE "Sekarang Anda dapat menggunakan:"
    print_message $YELLOW "  konekwifi        - Untuk koneksi WiFi"
    print_message $YELLOW "  putuswifi        - Untuk memutus koneksi WiFi"
    print_message $YELLOW "  konekwifi --help - Untuk bantuan"
    
else
    print_message $YELLOW "Instalasi dibatalkan."
    exit 0
fi

# Test instalasi
echo ""
if confirm_action "Apakah ingin test instalasi sekarang?"; then
    print_message $BLUE "Testing instalasi..."
    konekwifi --help
fi

echo ""
print_message $GREEN "Instalasi selesai! Terima kasih telah menggunakan WiFi Connection Manager."
