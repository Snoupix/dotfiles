#!/usr/bin/env sh

# Define the list of commands to check in order of preference
commands_to_check=("btop" "htop" "top")

# Determine the terminal emulator to use
term=$(cat $HOME/.config/hypr/keybindings.lua | grep 'term' | head -1 | cut -d '=' -f2 | sed "s/[\s']*//g")

# Try to execute the first available command in the specified terminal emulator
for command in "${commands_to_check[@]}"; do
    if command -v "$command" &> /dev/null; then
        $term -e "$command"
        break  # Exit the loop if the command executed successfully
    fi
done
