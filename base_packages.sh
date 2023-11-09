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

echo "Done!"
