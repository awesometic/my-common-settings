#!/bin/bash

if [[ ! "$OSTYPE" == *"darwin"* ]]; then
    echo 'You cannot install to non-macOS operating system.'
    exit
fi

TEXT_BOLD=`tput bold`
TEXT_RESET=`tput sgr0`

echo_msg() {
    echo -e "${TEXT_BOLD}"
    echo -e "/**"
    echo -e "/* $1"
    echo -e " */"
    echo -e "${TEXT_RESET}"
}

echo_msg "Install vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo_msg "Execute PlugInstall command to install plugins..."
nvim +PlugInstall +qall

echo_msg "Configure global git configuration..."
git config --global user.name "Yang Deokgyu"
git config --global user.email "secugyu@gmail.com"
git config --global user.username "awesometic"
git config --global core.editor "nvim"
git config --global color.ui "auto"

echo_msg "You should set your system up using gnome-tweaks to your liking."
echo_msg "Done! Reboot your system to apply changes."

