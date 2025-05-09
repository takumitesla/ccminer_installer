#!/bin/bash
clear
pkg install figlet -y
clear
# Fungsi untuk meminta input dengan default
function input_with_default() {
    local prompt="$1"
    local default="$2"
    read -p "$prompt" input
    if [ -z "$input" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

figlet CCMINER INSTALLER
echo "by Takumi Tesla"
echo "github : https://github.com/takumitesla/"
echo ""
echo ""
# Meminta input untuk wallet dan worker
wallet=$(input_with_default "Masukkan Wallet (default: RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a): " "RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a")
worker=$(input_with_default "Masukkan Nama Worker (contoh: Redmi4x1): " "worker")
threads=$(input_with_default "Masukkan Jumlah Threads (contoh: 8): " "8")
pool_url=$(input_with_default "Masukkan URL Pool (contoh: stratum+tcp://sg.vipor.net:5040): " "stratum+tcp://sg.vipor.net:5040")
pool_name=$(input_with_default "Masukkan Nama Pool (contoh: SG-VIPOR): " "SG-VIPOR")

clear
# Menginstal paket yang diperlukan
pkg install libjansson nano -y

# Membuat direktori dan berpindah ke dalamnya
mkdir -p ~/ccminer && cd ~/ccminer

# Mengunduh file ccminer dan start.sh
wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer

# Membuat file config.json dengan isi sesuai permintaan
cat <<EOF > config.json
{
    "pools": [{
        "name": "$pool_name",
        "url": "$pool_url",
        "timeout": 180,
        "disabled": 0
    }],
    "user": "$wallet.$worker",
    "pass": "",
    "algo": "verus",
    "threads": $threads,
    "cpu-priority": 1,
    "cpu-affinity": -1,
    "retry-pause": 10,
    "api-allow": "192.168.0.0/16",
    "api-bind": "0.0.0.0:4068"
}
EOF

# Memberikan izin eksekusi pada file ccminer dan start.sh
chmod +x ~/ccminer/ccminer

# Menambahkan perintah untuk menjalankan start.sh saat membuka Termux
echo "~/ccminer/ccminer -c ~/ccminer/config.json" >> ~/.bashrc
# Memberikan informasi selesai
clear
echo "Instalasi selesai!"

sleep 1
echo ""
echo "memulai mining...."

sleep 3
clear
~/ccminer/ccminer -c ~/ccminer/config.json
