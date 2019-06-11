#!/bin/bash

if [[ "$OSTYPE" != "linux-gnu" ]]; then
    echo 'You cannot install to non-Linux operating system.'
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

echo_msg "Install useful packages..."
sudo apt install neovim terminator tmux git htop iotop iftop shellcheck \
	build-essential python3 python3-dev python3-pip python3-setuptools

echo_msg "Install neovim preference..."
cp -rL --remove-destination nvim/* ~/.config/nvim/

echo_msg "Install vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo_msg "Execute PlugInstall command to install plugins..."
nvim +PlugInstall +qall

echo_msg "Install terminator preference..."
cp terminator/* ~/.config/terminator/config

