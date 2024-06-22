#!/bin/zsh

for line in $(git diff | rg 100644 -C 1); do
    if [[ $line == a/* ]]; then
        echo $line | sed s/a\/./;
    fi
done
