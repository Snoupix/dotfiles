#!/bin/bash

set -e

if [[ -z $HOME ]]; then
    echo "Error: \$HOME is not set"
    exit 1
fi

if [[ ! -d $HOME/.config ]]; then
    mkdir $HOME/.config
    echo "Created $HOME/.config"
fi

DIRS=$(ls -d *)

for DIR in $DIRS
do
    if [[ -d $DIR && $DIR != _* ]]; then
        ln -s $DIR $HOME/.config/$DIR
        echo "Soft linked $DIR to $HOME/.config"
    fi
done

ln -s .zshrc $HOME/.zshrc
echo "Soft linked .zshrc to $HOME/.zshrc"
ln -s .p10k.zsh $HOME/.p10k.zsh
echo "Soft linked .p10k.zsh to $HOME/.p10k.zsh"

echo "Done!"
