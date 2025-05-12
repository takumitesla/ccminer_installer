#!/bin/bash

uninstall_program() {
  echo "Menghapus program..."
  if [ -d "$HOME/ccminer" ]; then
    rm -r "$HOME/ccminer"
    echo -e "Program berhasil dihapus.\n"
  else
    echo -e "Program tidak ditemukan.\n"
  fi

  echo "Menghapus autorun dari .bashrc..."
  if grep -q '\$HOME/ccminer/ccminer -c \$HOME/ccminer/config.json' "$HOME/.bashrc"; then
    sed -i '/\$HOME\/ccminer\/ccminer -c \$HOME\/ccminer\/config.json/d' "$HOME/.bashrc"
    echo "Autorun berhasil dihapus."
  else
    echo "Autorun tidak ditemukan di .bashrc."
  fi
}

clear
echo "Menghapus ccminer..."
uninstall_program
