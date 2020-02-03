#!/usr/bin/env bash

msg() {
    echo -e "${TEXT_BOLD}"
    echo -e "/**"
    echo -e "/* $1"
    echo -e " */"
    echo -e "${TEXT_RESET}"
}

is_ubuntu_gnome() {
    if [[ "$OS_NAME" == *"Ubuntu"* ]] && [[ "$GDE_NAME" == *"gnome"* ]]; then
        return 1
    fi

    return 0
}

is_macos() {
    if [[ "$OS_NAME" == *"macOS"* ]]; then
        return 1
    fi

    return 0
}

TEXT_BOLD=$(tput bold)
TEXT_RESET=$(tput sgr0)
export RUNZSH=no
export EDITOR=nvim

if [[ "$OSTYPE" == *"linux-gnu"* ]]; then
    source "/etc/os-release"
    export OS_NAME="$PRETTY_NAME"
elif [[ "$OSTYPE" == *"darwin"* ]]; then
    export OS_NAME="macOS ""$(sw_vers -productVersion)"
fi

if is_ubuntu_gnome; then
    export GDE_NAME=$(env | grep XDG_CURRENT_DESKTOP)
    export HOMEDIR="/home/$USER"
    export PACKAGES="zsh neovim tmux git htop iotop iftop hardinfo inxi neofetch shellcheck curl wget build-essential software-properties-common apt-transport-https ca-certificates gnupg-agent gem bundler python3 python3-dev python3-pip python3-setuptools gnome-tweaks imwheel"
    export PACKAGES_SNAP="chromium vlc discord ao"
    export PACKAGES_SNAP_CLASSIC=(android-studio code slack skype)
    gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'UHC', 'CURRENT', 'ISO-8859–15', 'EUC-KR', 'UTF-16']"
elif is_macos; then
    type brew &> /dev/null && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    export HOMEDIR="/Users/$USER"
    export PACKAGES="coreutils zsh neovim tmux git neofetch htop shellcheck ruby python3 reattach-to-user-namespace"
else
    msg "This system is not Ubuntu Gnome or macOS"
    exit 0
fi

if [ "$EUID" -eq 0 ]; then
    msg "Please do not run as root"
    exit 0
fi

msg "Install useful packages..."
if is_ubuntu_gnome; then
    echo "$PACKAGES" | xargs sudo apt install
    echo "$PACKAGES_SNAP" | xargs sudo snap install
    for package in "${PACKAGES_SNAP_CLASSIC[@]}"; do
        echo "$package" | xargs sudo snap install --classic
    done
elif is_macos; then
    echo "$PACKAGES" | xargs brew install
fi

if [[ "$PACKAGES" == *"zsh"* ]]; then
    msg "Install shell preference using 'Oh My Zsh'..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOMEDIR"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOMEDIR"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    cp -f zsh/.zshrc ~/

    is_macos && patch -p0 "$HOMEDIR"/.zshrc < zsh/zshrc_to_mac.patch
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

if [[ "$PACKAGES" == *"imwheel"* ]]; then
    msg "Configure imwheel to improve mouse scrolling speed..."
    cp -f imwheel/.imwheelrc ~/
    cp -f imwheel/imwheel.desktop ~/.config/autostart/
    imwheel --kill
    killall imwheel; imwheel -b "4 5"
fi

msg "Configure global git configuration..."
git config --global user.name "Yang Deokgyu"
git config --global user.email "secugyu@gmail.com"
git config --global user.username "awesometic"
git config --global core.editor "nvim"
git config --global color.ui "auto"
git config --global http.postBuffer 524288000

msg "You should set your system up to your liking for finishing."
msg "Done! Reboot your system to apply changes."
