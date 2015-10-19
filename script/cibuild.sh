#!/usr/bin/env bash
set -e # halt script on error



bundle exec jekyll build 
bundle exec htmlproof ./_site

git commit -a -m "travis-ci site build"
git push origin site