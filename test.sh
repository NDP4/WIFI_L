#!/bin/bash

# Test script untuk WiFi Connection Manager
# Script ini untuk testing fungsi-fungsi dasar

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}      WiFi Connection Manager - Test Suite    ${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Test 1: Cek dependencies
print_message $BLUE "Test 1: Mengecek dependencies..."

# Cek nmcli
if command -v nmcli &> /dev/null; then
    print_message $GREEN "✓ nmcli tersedia"
    nmcli --version
else
    print_message $RED "✗ nmcli tidak ditemukan"
    exit 1
fi

echo ""

# Cek NetworkManager
if systemctl is-active --quiet NetworkManager; then
    print_message $GREEN "✓ NetworkManager aktif"
else
    print_message $YELLOW "⚠ NetworkManager tidak aktif"
fi

echo ""

# Test 2: Cek instalasi
print_message $BLUE "Test 2: Mengecek instalasi..."

if [ -f "/usr/local/bin/konekwifi" ]; then
    print_message $GREEN "✓ konekwifi terinstall"
else
    print_message $YELLOW "⚠ konekwifi belum terinstall"
fi

if [ -f "/usr/local/bin/putuswifi" ]; then
    print_message $GREEN "✓ putuswifi terinstall"
else
    print_message $YELLOW "⚠ putuswifi belum terinstall"
fi

echo ""

# Test 3: Cek permission
print_message $BLUE "Test 3: Mengecek permission..."

if [ -x "/usr/local/bin/konekwifi" ]; then
    print_message $GREEN "✓ konekwifi executable"
else
    print_message $YELLOW "⚠ konekwifi tidak executable"
fi

echo ""

# Test 4: Test help
print_message $BLUE "Test 4: Testing help function..."

if command -v konekwifi &> /dev/null; then
    print_message $GREEN "✓ konekwifi command tersedia"
    echo ""
    print_message $YELLOW "Output konekwifi --help:"
    echo "---"
    konekwifi --help
    echo "---"
else
    print_message $RED "✗ konekwifi command tidak tersedia"
fi

echo ""

# Test 5: Test info sistem
print_message $BLUE "Test 5: Informasi sistem WiFi..."

print_message $YELLOW "Device WiFi yang tersedia:"
nmcli device status | grep wifi || print_message $RED "Tidak ada device WiFi"

echo ""

print_message $YELLOW "Koneksi yang tersimpan:"
nmcli connection show | grep wifi || print_message $YELLOW "Tidak ada koneksi WiFi tersimpan"

echo ""

# Test 6: Rangkuman
print_message $BLUE "================================================"
print_message $BLUE "                 Test Summary                   "
print_message $BLUE "================================================"

if command -v nmcli &> /dev/null && systemctl is-active --quiet NetworkManager; then
    print_message $GREEN "🎉 Sistem siap untuk WiFi Connection Manager!"
    print_message $BLUE "Langkah selanjutnya:"
    print_message $YELLOW "  1. Jalankan: ./install.sh (jika belum install)"
    print_message $YELLOW "  2. Test dengan: konekwifi --help"
    print_message $YELLOW "  3. Gunakan: konekwifi untuk koneksi"
    print_message $YELLOW "  4. Gunakan: putuswifi untuk putus koneksi"
else
    print_message $RED "⚠ Sistem belum siap!"
    print_message $YELLOW "Perbaiki masalah di atas terlebih dahulu."
fi

echo ""
