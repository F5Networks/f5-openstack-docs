#!/usr/bin/env bash
set -e # halt script on error

#use the comand below if you don't already have jekyll on your machine
#requires ruby and rubygems
# gem install bundle
# gem install jekyll

# remove docs-build-temp folder if it exists
#rm -rf ./docs-serve-temp

#make temp folder
#mkdir ./docs-serve-temp

#copy site config content from root folder into temp folder
#cp ./Gemfile ./docs-serve-temp
#cp ./Rakefile ./docs-serve-temp
#cp ./_config.yml ./docs-serve-temp
#cp ./feed.xml ./docs-serve-temp
#cp ./index.html ./docs-serve-temp
#cp -rf ./_layouts ./docs-serve-temp
#cp -rf ./_includes ./docs-serve-temp
#cp -rf ./_sass ./docs-serve-temp
#cp -rf ./css ./docs-serve-temp


#copy content from submodules' doc folders into temp folder
#cp -R ./openstack-f5-agent/doc ./docs-serve-temp/agent
#cp -R ./openstack-f5-lbaasv1/doc ./docs-serve-temp/lbaasv1

#tell jekyll to serve the site from the temp folder and to ignore the baseurl set in the _config.yml file
bundle exec jekyll serve 

#use the following commands when you're done if you want to uninstall jekyll | bundle
# gem uninstall jekyll | bundle
