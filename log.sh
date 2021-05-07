#!/bin/bash

dir="content/"
section="log/"

cd $(cd $(dirname $0); pwd)
now=$(date '+%Y-%m-%dT%H%M%S')
suffix="_${1:-log}"
file="${section}${now}${suffix}.md"
path="$dir$file"

hugo new $file

before=`wc -c < $path`
code $path --wait
after=`wc -c < $path`

if [ $before = $after ]; then
  rm -f $path
else
    read -n1 -p "Git Commit?: " yn
    if [[ $yn = [yY] ]]; then
        git add $path
        git status
        git commit -m "💬add: ${file}"
        read -n1 -p "Git Push?: " yn
        if [[ $yn = [yY] ]]; then
            git push
        fi
    fi
fi