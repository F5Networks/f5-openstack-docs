#!/bin/sh

#  deploy_script.sh
#  
#
#  Created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#  Modified by Jodie Putrino on 12/11/15.
#

# turn tracing on so we can see the script run in travis
set -x

#  Set travis' username and email for GitHub
git config --global user.email "OpenStack_TravisCI@f5.com"
git config --global user.name "f5-travisci"

# Log in to GitHub using travis' gh token
travis login --pro -u $TRAVIS_USER --github-token $TRAVIS_GHTOKEN

# If working in 'jputrino' repo, don't publish to GH Pages (can view site in s3 dev bucket)

#if [ "$TRAVIS_REPO_SLUG" == "jputrino/*" ] ; then

  echo "skipping deploy script and not publishing to GitHub Pages"

  cd $HOME
  git clone --verbose --branch=gh-pages git@github.com:jputrino/f5-openstack-docs.git gh-pages

  cd gh-pages

  #git rm -rf # needs to remove all content except git config dirs/files

  cp -Rf $HOME/site_build .
  git add . -f
  git commit -m "Latest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push -f origin gh-pages

  echo -e "Published docs to GH Pages.";

#if [ "$TRAVIS_REPO_SLUG" == "F5Networks/*" ] && [ "$TRAVIS_PULL_REQUEST" == "TRUE" ]; then
#
#  echo -e "Publishing docs to GitHub Pages"
#
#  cd $HOME
#  git clone --verbose --branch=gh-pages git@github.com:F5Networks/f5-openstack-docs.git gh-pages
#
#  cd gh-pages
#  git rm -rf ./site_build
#  cp -Rf $HOME/site_build ./
#  git add -f .
#  git commit -m "Lastest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
#  git push origin gh-pages
#
#  echo -e "Published docs to F5 Networks GH Pages.";

# fi

