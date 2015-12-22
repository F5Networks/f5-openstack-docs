#!/bin/bash
#  deploy_script.sh
#  
#
#  Based on a script created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#
#  Modified by Jodie Putrino on 12/11/15.
#

set -ev

#  Set travis' username and email for GitHub
git config --global user.email "OpenStack_TravisCI@f5.com"
git config --global user.name "f5-travisci"

if [[ "$TRAVIS_REPO_SLUG" == "F5Networks/f5-openstack-docs" ]]; then

  echo "Publishing docs to GitHub Pages"
  cd "$HOME"
  git clone --verbose --branch=gh-pages https://f5-travisci:$TRAVIS_PATOKEN@github.com/F5Networks/f5-openstack-docs.git gh-pages
  cd gh-pages
  git remote rm origin
  git remote add origin https://f5-travisci:$TRAVIS_PASS@github.com/F5Networks/f5-openstack-docs.git
  cp -Rf "$HOME"/site_build ./
  git add -f .
  git commit -m "Latest doc set auto-pushed to gh-pages on successful travis build $TRAVIS_BUILD_NUMBER"
  git push --verbose origin gh-pages
  echo "Published docs to F5 Networks GH Pages." else

 echo "Docs not published to GitHub Pages"

fi
