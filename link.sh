#!/bin/bash

if [[ $1 == "--help" ]]; then
    echo "Usage: ./link.sh [rhd] [--help]"
    echo -e "Symlink dotfiles (config files/directories) to \$HOME/.config\n"
    echo "Options:"
    echo "  -r: Only remove symlinks that would be created by this script"
    echo "  -h: Also symlinks hyprland config files/directories"
    echo "  -d: Dry run, only show what would be symlinked"
    echo "  --help: Show this help message"
    exit 0
fi

while getopts ":rhd" opt; do
    case $opt in
        r) REMOVE_=true;;
        h) HYPRLAND_=true;;
        d) DRYRUN_=true;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            echo "Try './link.sh --help' for more information."
            exit 1
            ;;
    esac
done

set -e

FILES=(
    .zprofile
    .bashrc
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

if [[ -n $HYPRLAND_ ]]; then
    DIRS="$(\ls -d *) $(\ls -d _hypr/*)"
else
    DIRS=$(\ls -d *)
fi

for DIR in $DIRS; do
    if [[ -n $DRYRUN_ && -d $DIR && ($DIR != _* || $DIR == _hypr/* && $DIR != _hypr/_*) ]]; then
        echo "[ $DIR ] would be symlinked to $HOME/.config"
        continue
    fi

    if [[ -n $HYPRLAND_ ]]; then
        dir="$(echo $DIR | sed 's/_hypr\///')"
        rm -rf $HOME/.config/$dir
    else
        rm -rf $HOME/.config/$DIR
    fi

    if [[ -n $REMOVE_ ]]; then
        echo "Removed $HOME/.config/$DIR symlink"
        continue
    fi

    if [[ -d $DIR && ($DIR != _* || $DIR == _hypr/* && $DIR != _hypr/_*) ]]; then
        ln -s $PWD/$DIR $HOME/.config/
        echo "Symlinked $DIR to $HOME/.config"
    fi
done

for FILE in "${FILES[@]}"; do
    if [[ -n $DRYRUN_ && -f $FILE ]]; then
        echo "[ $FILE ] would be symlinked to $HOME"
        continue
    fi

    rm -rf $HOME/$FILE

    if [[ -n $REMOVE_ ]]; then
        echo "Removed $HOME/$FILE symlink"
        continue
    fi

    if [[ -f $FILE ]]; then
        ln -s $PWD/$FILE $HOME
        echo "Symlinked $FILE to $HOME"
    fi
done

# TODO: /etc/sddm.conf.d/10-theme.conf should have "
# [Theme]
# Current=sdt
# "
SDDM_THEME="_hypr/_sdt"
TARGET_DIR="/usr/share/sddm/themes/sdt"
if [[ -n $HYPRLAND_ ]]; then
    if [[ -n $DRYRUN_ ]]; then
        echo "[ $SDDM_THEME ] would be symlinked to $TARGET_DIR"
    else
        # /etc folder needs sudo perms
        sudo rm -r $TARGET_DIR
        sudo ln -sf $PWD/$SDDM_THEME $TARGET_DIR
        echo "Symlinked $SDDM_THEME to $TARGET_DIR"
    fi
fi

echo "Done!"
exit 0
