#!/bin/bash

# Demo script untuk menguji WiFi Connection Manager
# Author: GitHub Copilot
# Version: 2.0

echo "=========================================="
echo "    WiFi Connection Manager - DEMO"
echo "=========================================="
echo ""

echo "🔍 Mengecek apakah script dapat dijalankan..."
if [ -x "./konekwifi" ] && [ -x "./putuswifi" ]; then
    echo "✅ Script konekwifi dan putuswifi siap digunakan"
else
    echo "❌ Script tidak memiliki permission execute"
    echo "Menjalankan: chmod +x konekwifi putuswifi"
    chmod +x konekwifi putuswifi
    echo "✅ Permission execute telah diberikan"
fi

echo ""
echo "🔍 Mengecek persyaratan sistem..."

# Cek nmcli
if command -v nmcli &> /dev/null; then
    echo "✅ nmcli tersedia"
    nmcli --version | head -1
else
    echo "❌ nmcli tidak ditemukan"
    echo "Silakan install NetworkManager terlebih dahulu"
    exit 1
fi

# Cek NetworkManager
if systemctl is-active --quiet NetworkManager; then
    echo "✅ NetworkManager sedang berjalan"
else
    echo "⚠️  NetworkManager tidak aktif"
    echo "Script akan membantu mengaktifkannya saat dijalankan"
fi

# Cek device WiFi
wifi_devices=$(nmcli device status | grep wifi)
if [ -n "$wifi_devices" ]; then
    echo "✅ Perangkat WiFi terdeteksi:"
    echo "$wifi_devices"
else
    echo "⚠️  Tidak ada perangkat WiFi yang terdeteksi"
fi

echo ""
echo "🆕 FITUR BARU YANG TELAH DIPERBAIKI:"
echo "=================================="
echo "1. ✨ Sistem pemilihan WiFi dengan nomor (tidak perlu mengetik SSID)"
echo "2. ✨ Tampilan informasi koneksi WiFi aktif yang detail"
echo "3. ✨ Deteksi koneksi WiFi yang lebih akurat"
echo "4. ✨ Daftar WiFi tersusun berdasarkan kekuatan signal"
echo "5. ✨ Validasi input yang lebih baik"
echo ""

echo "📝 CARA PENGGUNAAN:"
echo "=================="
echo "1. Untuk koneksi WiFi: ./konekwifi"
echo "2. Untuk putus WiFi:   ./putuswifi"
echo "3. Untuk bantuan:      ./konekwifi --help"
echo ""

echo "🚀 DEMO SELESAI!"
echo "Silakan jalankan script sesuai kebutuhan Anda."
echo ""
