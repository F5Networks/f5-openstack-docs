#!/usr/bin/env bash
set -e # halt script on error

echo -e "building site with jekyll"
bundle exec jekyll build -s 

echo -e "proofing site with htmlproofer"
bundle exec htmlproof ./_site
