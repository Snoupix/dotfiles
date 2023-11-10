#!/bin/bash

set -e

FILES=(
    .zshrc
    .p10k.zsh
)

if [[ -z $HOME || -z $PWD ]]; then
    echo "Error: \$HOME or \$PWD is not set"
    exit 1
fi

if [[ ! -d $HOME/.config ]]; then
    mkdir $HOME/.config
    echo "Created $HOME/.config"
fi

DIRS=$(ls -d *)

for DIR in $DIRS; do
    rm -rf $HOME/.config/$DIR

    if [[ $1 == "-r" ]]; then
        echo "Removed $HOME/.config/$DIR symlink"
        continue
    fi

    if [[ -d $DIR && $DIR != _* ]]; then
        ln -s $PWD/$DIR $HOME/.config/$DIR
        echo "Symlinked $DIR to $HOME/.config"
    fi
done

for FILE in $FILES; do
    rm -rf $HOME/$FILE

    if [[ $1 == "-r" ]]; then
        echo "Removed $HOME/$FILE symlink"
        continue
    fi

    if [[ -f $FILE ]]; then
        ln -s $PWD/$FILE $HOME/$FILE
        echo "Symlinked $FILE to $HOME"
    fi
done

echo "Done!"
exit 0
