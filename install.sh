#!/usr/bin/env bash

TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)

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

if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
    PACKAGES="zsh neovim tmux git htop iotop iftop inxi neofetch shellcheck curl wget build-essential software-properties-common apt-transport-https ca-certificates gnupg-agent python3 python3-dev python3-pip python3-setuptools"

    DESKTOP=$(env | grep XDG_CURRENT_DESKTOP)
    [[ "${DESKTOP,,}" == *"pantheon" ]] && PACKAGES="$PACKAGES gnome-tweaks uim"
elif [[ "$OSTYPE" == *"darwin"* ]]; then
        PACKAGES="coreutils zsh neovim tmux git htop shellcheck python3 reattach-to-user-namespace"
else
    msg "System is not recognized. The program will be closed."
    exit 0
fi

msg "Install useful packages..."

if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
    echo "$PACKAGES" | xargs sudo apt install -y
else
    echo "$PACKAGES" | xargs brew install -y
fi

if [[ "$PACKAGES" == *"zsh"* ]]; then
    msg "Install shell preference using 'Oh My Zsh'..."
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/"$USER"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions /home/"$USER"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    cp -f zsh/.zshrc ~/
fi

if [[ "$PACKAGES" == *"neovim"* ]]; then
    msg "Install neovim preference..."
    if [ ! -d ~/.config/nvim ]; then
        mkdir ~/.config/nvim
    fi
    cp -rL --remove-destination nvim/* ~/.config/nvim/

    msg "Install vim-plug..."
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    msg "Execute PlugInstall command to install plugins..."
    nvim +PlugInstall +qall
fi

if [[ "$PACKAGES" == *"tmux"* ]]; then
    [[ -n $(command -v nvim) ]] && export EDITOR=nvim

    msg "Install tmux preference using 'Oh My Tmux'..."
    git clone https://github.com/gpakosz/.tmux.git /home/"$USER"/.oh-my-tmux/
    ln -s -f /home/"$USER"/.oh-my-tmux/.tmux.conf /home/"$USER"/
    cp /home/"$USER"/.oh-my-tmux/.tmux.conf.local /home/"$USER"/

    patch -p0 /home/"$USER"/.tmux.conf.local < tmux/tmux.conf.local.patch 
fi

if [[ "$PACKAGES" == *"uim"* ]]; then
    msg "Configure input method to use 'uim'..."
    im-config -n uim
fi

msg "Configure global git configuration..."
git config --global user.name "Yang Deokgyu"
git config --global user.email "secugyu@gmail.com"
git config --global user.username "awesometic"
git config --global core.editor "nvim"
git config --global color.ui "auto"

msg "You should set your system up to your liking for finishing."
msg "Done! Reboot your system to apply changes."

