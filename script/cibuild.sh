#!/usr/bin/env bash
set -e # halt script on error

echo "building site with jekyll"
bundle exec jekyll build -d ./site_build

# Check the html and validate links
#echo "proofing site with htmlproofer"
#bundle exec htmlproof ./site_build

cp -R ./site_build $HOME/site_build

# If this is a development build, rename index.html to os_landingpage.html
if [ "$TRAVIS_BRANCH" == "develop" ]; then
mv index.html os_landingpage.html
fi