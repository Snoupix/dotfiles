cwd := `dirname $0`

alias help := _default

_default:
    @just -l --justfile {{ justfile() }} --unsorted

update:
    #!/usr/bin/env bash
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove
    flatpak update
    deno upgrade
    rustup update

    skip=("cargo" "cargo-clippy" "cargo-fmt" "clippy-driver" "rls" "rustc" "rustdoc" "rustfmt" "rustup" "rust-analyzer" "zellij")
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

    # if [ "$current_commit" != "$current_stable" ]; then
        # git reset --hard
        # git clean -fd
        # git checkout stable

        # sudo cmake --build build/ --target uninstall
        # sudo rm /usr/local/bin/nvim
        # sudo rm -r /usr/local/share/nvim build/
        # make CMAKE_BUILD_TYPE=Release
        # sudo make install
    # fi

start_pingview:
    cd {{ cwd / "pingflow/pingadmin-devtools" }} && \
    make dev && \
    make vault-unseal

    cd {{ cwd / "pingflow/pingview-devtools" }} && \
    make dev

    docker stop pingview-fry-1
    docker stop pingview-mom-1

    cd {{ cwd / "pingflow/workers" }} && \
    for worker_dir in $(ls); do \
        cd $worker_dir && make start-dev; cd ..; \
    done

    @echo "nvm use 20 && npm run dev > pingview-api"
    @echo "pnpm run dev > pingview"

stop_pingview:
    cd {{ cwd / "pingflow/pingadmin-devtools" }} && \
    make down

    cd {{ cwd / "pingflow/pingview-devtools" }} && \
    make down

    cd {{ cwd / "pingflow/workers" }} && \
    for worker_dir in $(ls); do \
        cd $worker_dir && make stop; cd ..; \
    done

restart_pingview: stop_pingview start_pingview
