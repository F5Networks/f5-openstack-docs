#!/usr/bin/env bash
set -e # halt script on error

bundle install https://rubygems.org/ 

echo "building site with jekyll"
bundle exec jekyll build -d ./site_build

#echo "proofing site with htmlproofer"
#bundle exec htmlproof ./site_build

cp -R ./site_build $HOME/site_build