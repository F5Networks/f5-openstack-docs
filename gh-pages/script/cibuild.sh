#!/usr/bin/env bash
set -e # halt script on error
set -x # enable verbose output for debugging

#  Specify the git branch receiving a pull request that will replace the published docs on github pages.
#  master is correct for final released 'images', feature.autodocgen (or something else) for testing changes
F5_ORIGIN_BRANCH="master"



if [[ "$TRAVIS_REPO_SLUG" == "F5Networks/f5-openstack-docs" && "$TRAVIS_BRANCH" == "F5_ORIGIN_BRANCH" ]]; then
  JEKYLL_CONFIG="_config.yml"
  JEKYLL_BASEURL="f5-openstack-docs"
else
  JEKYLL_CONFIG="_config_dev.yml"
  JEKYLL_BASEURL="$TRAVIS_BUILD_NUMBER"
fi

sed -i "s/baseurl:.*$/baseurl: \"\/$JEKYLL_BASEURL\"/" $JEKYLL_CONFIG
grep baseurl $JEKYLL_CONFIG

echo "building site with jekyll"
bundle exec jekyll build -d ./site_build

# Check the html and validate links
echo "proofing site with htmlproofer"
bundle exec htmlproof ./site_build --empty-alt-ignore true --disable-external true 

rm -rf $HOME/site_build
cp -R ./site_build $HOME/site_build
