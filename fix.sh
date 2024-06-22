#!/bin/bash

for line in $(git diff | rg 100644 -C 1); do
    if [[ $line == a/* ]]; then
        path=$(echo $line | sed s/a\/./);
        # chmod 644 $path;
    fi
done
