#!/bin/bash
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

echo "CCMINER_INSTALLER"
echo "version : 1.0.0\n"
echo "by Takumi Tesla"
echo "github : https://github.com/takumitesla/\n"

# Meminta input untuk wallet dan worker
wallet=$(input_with_default "Masukkan Wallet (default: RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a): " "RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a")
worker=$(input_with_default "Masukkan Nama Worker (contoh: Redmi4x1): " "worker")
threads=$(input_with_default "Masukkan Jumlah Threads (contoh: 8): " "8")
pool_url=$(input_with_default "Masukkan URL Pool (contoh: stratum+tcp://sg.vipor.net:5040): " "stratum+tcp://sg.vipor.net:5040")
pool_name=$(input_with_default "Masukkan Nama Pool (contoh: SG-VIPOR): " "SG-VIPOR")

clear
# Menginstal paket yang diperlukan
echo "installing dependency..\n"
pkg install libjansson nano -y
clear

# Membuat direktori dan berpindah ke dalamnya
echo "creating folder ccminer..."
mkdir -p ~/ccminer && cd ~/ccminer

# Mengunduh file ccminer dan start.sh
echo "installing ccminer"
wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer

# Membuat file config.json dengan isi sesuai permintaan
echo "creating configuration..."
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
echo "set mode.."
chmod +x ~/ccminer/ccminer

# Menambahkan perintah untuk menjalankan start.sh saat membuka Termux
echo "configurating auto run ccminer..."

if ! grep -q "ccminer -c ~/ccminer/config.json" ~/.bashrc; then
    echo "~/ccminer/ccminer -c ~/ccminer/config.json" >> ~/.bashrc
fi

# Memberikan informasi selesai
clear
echo "installation success!\n"
sleep 1
echo "start mining...."

sleep 1
clear
~/ccminer/ccminer -c ~/ccminer/config.json
