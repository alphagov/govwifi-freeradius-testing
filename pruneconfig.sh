#!/bin/bash

usage() {
    echo "$0: script to remove comments from a file"
    echo ""
    echo "Usage: $0 config1 [..config2]"
    echo "       $0 configdir/*"
}

if [ "$#" -eq 0 ] ||
   [ "$1" == "-h" ] || 
   [ "$1" == "--help" ]; then
    usage
    exit
fi

for file in "$@"
do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "***This script needs updating to work on MacOS****"
    else
        sed -i 's:^\s*#.*$::g' "$file"
        sed -i '$!N;/^\n$/{$q;D;};P;D;' "$file"
    fi
done

