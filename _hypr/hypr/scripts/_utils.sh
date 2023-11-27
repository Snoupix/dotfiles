#!/bin/bash

ensure_cargo_bins() {
    if [[ $(echo $PATH) != *"~/.cargo/bin"* ]]; then
        export PATH="$PATH:~/.cargo/bin"
    fi
}
