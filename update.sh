#!/bin/bash

for dir in */; do
   if [ -d "$dir" ]; then
      echo "Entering $dir"
      cd "$dir" || continue

      if [ -f "package.json" ]; then
         git stash
         # COMMAND: Set the fetch config to the wildcard pattern
         git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
         git fetch origin
         git checkout -b jh/plugins origin/jh/plugins
         git pull
         git submodule update --init --recursive
         # echo "Running npm install in $dir"
         npm install
         echo "Starting npm run build in $dir"
         npm run watch &
         git pop
      else
         echo "No package.json found in $dir, skipping..."
      fi

      cd ..
   fi
done
