#!/bin/bash

PACKAGES=(
    cmake
    curl
    dart
    docker
    docker-buildx
    docker-compose
    fzf
    gcc
    git
    go
    grep
    gzip
    htop
    jq
    less
    lsof
    make
    man-db
    neofetch
    neovim
    nodejs
    npm
    pass
    python3
    python3-pip
    rsync
    rustup
    sed
    tar
    tcpdump
    tr
    unzip
    websocat
    wget
    which
    zsh
)

PM_FLAGS=(
    "yay:-S --noconfirm --needed"
    "pacman:-S --noconfirm --needed"
    "brew:install"
    "dnf:install -y"
    "yum:install -y"
    "apt:install"
)

for V in "${PM_FLAGS[@]}"; do
    PM=${V%%:*}
    ARGS=${V#*:}
    if [ -x "$(command -v $PM)" ]; then
        for PKG in "${PACKAGES[@]}"; do
            if [ $PM = "apt" ]; then
                sudo $PM $ARGS $PKG
                continue
            fi

            $PM $ARGS $PKG
        done
        break
    fi
done

# Post commands

read -rep '[GIT config] Would you like to (re)configure git? (y/N) ' git
if [[ $git =~ ^[Yy]$ ]]; then
    read -rep '[GIT config] Enter your name: ' name
    git config --global user.name $name
    read -rep '[GIT config] Enter your email: ' email
    git config --global user.email $email
    git config --global credential.helper store
    read -rep '[GIT config] Enter your default git branch: ' branch
    git config --global init.defaultBranch $branch
fi

rustup default stable
rustup component add cargo rustfmt clippy rust-src rust-analyzer rustc rust-docs
rustup update

read -rep '[Cargo binaries] Would you like to install cargo binaries? (y/N) ' cb
if [[ $cb =~ ^[Yy]$ ]]; then
    cargo install --locked zellij
    cargo install ripgrep
    cargo install eza
    cargo install cargo-watch
    cargo install cargo-cache
    cargo install just
fi

read -rep '[Neovim config] Would you like to restore nvim packages? (y/N) ' nv
if [[ $nv =~ ^[Yy]$ ]]; then
    nvim --headless '+Lazy! restore' +qa
fi

git clone https://github.com/githubnext/monaspace
cd monaspace
./util/install_linux.sh
cd ..
rm -rf ./monaspace
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "Done!"
exit 0
