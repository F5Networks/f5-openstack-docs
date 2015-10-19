#!/usr/bin/env bash
set -e # halt script on error

# remove docs-build-temp folder if it exists
rm -rf ./docs-build

#make temp folder to build site in
mkdir ./docs-build

#copy site config content from root folder into temp folder
#cp ./Gemfile ./docs-build-temp/
#cp ./Rakefile ./docs-build-temp/
#cp ./_config.yml ./docs-build-temp/
#cp ./feed.xml ./docs-build-temp/
#cp ./index.html ./docs-build-temp/
#cp -rf ./_layouts ./docs-build-temp/
#cp -rf ./_includes ./docs-build-temp/
#cp -rf ./_sass ./docs-build-temp/
#cp -rf ./css ./docs-build-temp/

#copy content from doc folder in submodules into temp-content folder
#cp -R ./openstack-f5-agent/doc ./docs-build-temp/agent
#cp -R ./openstack-f5-lbaasv1/doc ./docs-build-temp/lbaasv1

bundle exec jekyll build 
bundle exec htmlproof ./_site

git config user.email "j.putrino@f5.com"
git config user.name "jputrino"
git commit -a -m "travis-ci build"
git push origin site