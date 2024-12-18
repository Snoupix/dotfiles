cwd := `dirname $0`

alias help := _default

_default:
    @just -l --justfile {{ justfile() }} --unsorted

update:
    #!/usr/bin/env bash
    sudo apt update
    sudo apt upgrade
    flatpak update
    rustup update

    skip=("cargo" "cargo-clippy" "cargo-fmt" "clippy-driver" "rls" "rustc" "rustdoc" "rustfmt" "rustup")
    for bin in $(ls /home/snoupix/.cargo/bin); do
        if [[ ${skip[@]} =~ $bin ]]; then
            continue
        fi

        echo "Updating $bin..."
        out=$(cargo install $bin 2>&1)
        if [ $? -eq 101 ]; then
            pkg=$(echo $out | rg -o '`([^`]+)`' --replace '$1' | tail -n 1 | sed "s/[\sv(0-9)\.]*//g")
            if [ "$pkg" = "*" ]; then
                continue
            fi

            echo "$out => trying to update/install $pkg instead..."
            cargo install $pkg
            continue
        fi
        echo $out
    done

    cd /home/snoupix/packages/neovim
    git fetch -ft --all
    current_commit=$(git rev-parse HEAD)
    current_stable=$(git rev-parse stable 2>/dev/null)

    if [ "$current_commit" != "$current_stable" ]; then
        git reset --hard
        git clean -fd
        git checkout stable

        sudo cmake --build build/ --target uninstall
        sudo rm /usr/local/bin/nvim
        sudo rm -r /usr/local/share/nvim build/
        make CMAKE_BUILD_TYPE=Release
        sudo make install
    fi

start_pingview:
    cd {{ cwd / "work/pingadmin-devtools" }} && \
    make dev && \
    make vault-unseal

    cd {{ cwd / "work/pingview-devtools" }} && \
    make dev

    docker stop pingview_fry_1
    docker stop pingview_mom_1

    @echo "npm run start > pingview-api"
    @echo "pnpm run dev > pingview"
