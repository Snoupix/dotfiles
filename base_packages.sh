#!/bin/bash

PACKAGES=(
    unzip
    curl
    git
    go
    neofetch
    nodejs
    npm
    python3
    python3-pip
    which
    wget
    tar
    sed
    grep
    rsync
    pass
    make
    cmake
    jq
    tr
    less
    htop
    gzip
    fzf
    gcc
    zsh
    neovim
    rustup
    docker
    docker-compose
)

PM_FLAGS=(
    "yay:-S --noconfirm --needed"
    "pacman:-S --noconfirm --needed"
    "apt:install"
    "brew:install"
    "dnf:install -y"
    "yum:install -y"
)

for V in "${PM_FLAGS[@]}"; do
    PM=${V%%:*}
    ARGS=${V#*:}
    if [ -x "$(command -v $PM)" ]; then
        for PKG in "${PACKAGES[@]}"; do
            $PM $ARGS $PKG
        done
        break
    fi
done

# Post commands

rustup default stable
rustup component add cargo rustfmt clippy rust-src rust-analyzer rustc rust-docs
rustup update

cargo install --locked zellij
cargo install ripgrep

nvim --headless '+Lazy! restore' +qa

sh -c $(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

echo "Done!"
exit 0
