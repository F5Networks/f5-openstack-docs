#!/bin/sh

#  deploy_script.sh
#  
#
#  Created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#  Modified by Jodie Putrino on 12/11/15.
#

#  Push content up to gh-pages branch in the f5-openstack-docs repo in GitHub
git config --global user.email "OpenStack_TravisCI@f5.com"
git config --global user.name "f5-travisci"

travis login --pro -u f5-travisci --github-token add82b53db8ca8cf46f708cb22e2724e124978cc

#if [ "$TRAVIS_REPO_SLUG" == "F5Networks/*" ] ; then
#
#  echo -e "Publishing docs to GitHub Pages"
#
#    cd $HOME
#  git clone --quiet --branch=gh-pages git@github.com:F5Networks/f5-openstack-docs.git gh-pages > /dev/null
#
#  cd gh-pages
#  git rm -rf ./site_build
#  cp -Rf $HOME/site_build ./site_build
#  git add -f .
#  git commit -m "Lastest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
#  git push -fq origin gh-pages > /dev/null
#
#  echo -e "Published docs to F5 Networks GH Pages.";

#if [ "$TRAVIS_REPO_SLUG" == "jputrino/*" ] ; then

  echo -e "Publishing docs to GitHub Pages"

  cd $HOME
  git clone --verbose --branch=gh-pages git@github.com:jputrino/f5-openstack-docs.git gh-pages

  cd gh-pages
  #git rm -rf # needs to remove all content except git config dirs/files
  cp -Rf $HOME/site_build .
  git add . -f
  git commit -m "Latest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push -f origin gh-pages

  echo -e "Published docs to jputrino GH Pages.";



# fi