#!/usr/bin/env bash
set -e # halt script on error

echo "building site with jekyll"
bundle exec jekyll build -d ./site_build

# Check the html and validate links
echo "proofing site with htmlproofer"
bundle exec htmlproof ./site_build --empty-alt-ignore true --disable-external true 

cp -R ./site_build $HOME/site_build

