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

echo -e "CCMINER_INSTALLER\n"
echo -e "version : 1.0.0\n"
echo "by Takumi Tesla"
echo -e "github : https://github.com/takumitesla/\n"

# Meminta input untuk wallet dan worker
wallet=$(input_with_default "Masukkan Wallet (default: RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a): " "RUjugNHKHCxKxFZinvhRuurLjK8iBkTL6a")
worker=$(input_with_default "Masukkan Nama Worker (contoh: Redmi4x1): " "worker")
threads=$(input_with_default "Masukkan Jumlah Threads (contoh: 8): " "8")
pool_url=$(input_with_default "Masukkan URL Pool (contoh: stratum+tcp://sg.vipor.net:5040): " "stratum+tcp://sg.vipor.net:5040")
pool_name=$(input_with_default "Masukkan Nama Pool (contoh: SG-VIPOR): " "SG-VIPOR")

clear
# Menginstal paket yang diperlukan
echo -e "Installing dependencies...\n"
pkg update && pkg upgrade -y
pkg install wget libjansson nano -y
clear

# Membuat direktori dan berpindah ke dalamnya
echo "Creating folder ccminer..."
mkdir -p "$HOME/ccminer" && cd "$HOME/ccminer"

# Mengunduh file ccminer
echo "Installing ccminer..."
wget -O ccminer https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer

# Cek apakah file berhasil diunduh
if [ ! -f "$HOME/ccminer/ccminer" ]; then
    echo "Error: Gagal mengunduh ccminer. Periksa koneksi internet atau URL."
    exit 1
fi

# Memberikan izin eksekusi pada file ccminer
chmod +x "$HOME/ccminer/ccminer"

# Membuat file config.json dengan isi sesuai permintaan
echo "Creating configuration..."
cat <<EOF > "$HOME/ccminer/config.json"
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

# Menambahkan perintah untuk menjalankan ccminer saat membuka Termux
echo "Configuring auto run ccminer..."
if ! grep -q "$HOME/ccminer/ccminer -c $HOME/ccminer/config.json" ~/.bashrc; then
    echo "# Auto run ccminer" >> ~/.bashrc
    echo "$HOME/ccminer/ccminer -c $HOME/ccminer/config.json" >> ~/.bashrc
fi

# Memberikan informasi selesai
clear
echo -e "Installation success!\n"
sleep 1
echo "Start mining...."
sleep 1
clear
"$HOME/ccminer/ccminer" -c "$HOME/ccminer/config.json"
