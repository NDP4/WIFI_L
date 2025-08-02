#!/bin/bash

# Uninstaller untuk WiFi Connection Manager

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
echo -e "${BLUE}     WiFi Connection Manager Uninstaller      ${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Cek apakah running sebagai root
if [[ $EUID -eq 0 ]]; then
    print_message $RED "Jangan jalankan uninstaller ini sebagai root!"
    print_message $YELLOW "Gunakan: ./uninstall.sh"
    exit 1
fi

INSTALL_DIR="/usr/local/bin"

print_message $BLUE "Mencari WiFi Connection Manager yang terinstall..."

# Cek apakah terinstall
if [ -f "$INSTALL_DIR/konekwifi" ]; then
    print_message $GREEN "✓ konekwifi ditemukan di $INSTALL_DIR"
else
    print_message $YELLOW "konekwifi tidak ditemukan di $INSTALL_DIR"
fi

if [ -f "$INSTALL_DIR/putuswifi" ]; then
    print_message $GREEN "✓ putuswifi ditemukan di $INSTALL_DIR"
else
    print_message $YELLOW "putuswifi tidak ditemukan di $INSTALL_DIR"
fi

echo ""

# Konfirmasi uninstall
if confirm_action "Apakah yakin ingin menghapus WiFi Connection Manager?"; then
    print_message $BLUE "Memulai penghapusan..."
    
    # Hapus konekwifi
    if [ -f "$INSTALL_DIR/konekwifi" ]; then
        print_message $YELLOW "Menghapus konekwifi..."
        if sudo rm -f "$INSTALL_DIR/konekwifi"; then
            print_message $GREEN "✓ konekwifi berhasil dihapus"
        else
            print_message $RED "✗ Gagal menghapus konekwifi"
        fi
    fi
    
    # Hapus putuswifi
    if [ -f "$INSTALL_DIR/putuswifi" ]; then
        print_message $YELLOW "Menghapus putuswifi..."
        if sudo rm -f "$INSTALL_DIR/putuswifi"; then
            print_message $GREEN "✓ putuswifi berhasil dihapus"
        else
            print_message $RED "✗ Gagal menghapus putuswifi"
        fi
    fi
    
    echo ""
    print_message $GREEN "🗑️  Uninstall selesai!"
    print_message $BLUE "WiFi Connection Manager telah dihapus dari sistem."
    
else
    print_message $YELLOW "Uninstall dibatalkan."
fi
