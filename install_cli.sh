#!/bin/bash

if [[ ! "$OSTYPE" == *"linux-gnu"* ]]; then
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
sudo apt install neovim tmux git htop iotop iftop shellcheck \
    curl wget zsh build-essential python3 python3-dev python3-pip python3-setuptools

echo_msg "Install shell preference using 'Oh My Zsh'..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp -f zsh/.zshrc ~/

echo_msg "Install neovim preference..."
if [ ! -d ~/.config/nvim ]; then
    mkdir ~/.config/nvim
fi
cp -rL --remove-destination nvim/* ~/.config/nvim/

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

echo_msg "Done! Reboot your system to apply changes."

