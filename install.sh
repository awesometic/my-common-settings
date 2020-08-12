#!/usr/bin/env bash

msg() {
    echo -e "${TEXT_BOLD}"
    echo -e "/**"
    echo -e "/* $1"
    echo -e " */"
    echo -e "${TEXT_RESET}"
}

if [ "$EUID" -eq 0 ]; then
    msg "Please do not run as root"
    exit 0
fi

TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)
export RUNZSH=no
export EDITOR=nvim

export HOMEDIR="/home/$USER"
export PACKAGES="zsh neovim tmux git htop iotop iftop hardinfo inxi neofetch shellcheck curl wget minicom build-essential software-properties-common apt-transport-https ca-certificates gnupg-agent gem bundler python3 python3-dev python3-pip python3-setuptools gnome-keyring ibus-hangul"

msg "Install useful packages..."
echo "$PACKAGES" | xargs sudo apt install -y

if [[ "$PACKAGES" == *"zsh"* ]]; then
    msg "Install shell preference using 'Oh My Zsh'..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOMEDIR"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOMEDIR"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions "$HOMEDIR"/.oh-my-zsh/custom/plugins/zsh-completions
    cp -f zsh/.zshrc ~/
fi

if [[ "$PACKAGES" == *"neovim"* ]]; then
    msg "Install neovim preference..."
    cp -rf nvim ~/.config

    msg "Install vim-plug..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    msg "Execute PlugInstall command to install plugins..."
    nvim +PlugInstall +qall
fi

if [[ "$PACKAGES" == *"tmux"* ]]; then
    msg "Install tmux preference using 'Oh My Tmux'..."
    git clone https://github.com/gpakosz/.tmux.git "$HOMEDIR"/.oh-my-tmux/
    ln -s -f "$HOMEDIR"/.oh-my-tmux/.tmux.conf "$HOMEDIR"/
    cp "$HOMEDIR"/.oh-my-tmux/.tmux.conf.local "$HOMEDIR"/

    patch -p0 "$HOMEDIR"/.tmux.conf.local < tmux/tmux.conf.local.patch
fi

if [[ "$PACKAGES" == *"git"* ]]; then
    msg "Configure global git configuration..."
    git config --global user.name "Deokgyu Yang"
    git config --global user.email "secugyu@gmail.com"
    git config --global user.username "awesometic"
    git config --global core.editor "nvim"
    git config --global color.ui "auto"
    git config --global http.postBuffer 524288000
fi

sudo tee -a /etc/ssh/ssh_config > /dev/null <<EOT

Host 192.168.*.*
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
EOT

msg "You should set your system up to your liking for finishing."
msg "Done! Reboot your system to apply changes."
