#!/bin/sh

#  deploy_script.sh
#  
#
#  Created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#  Modified by Jodie Putrino on 12/11/15.
#

#  Push content up to gh-pages branch in the f5-openstack-docs repo in GitHub

if [ "$TRAVIS_REPO_SLUG" == "F5Networks/*" ] ; then

  echo -e "Publishing docs to GitHub Pages"

    cd $HOME
  git clone --quiet --branch=gh-pages git@github.com:F5Networks/f5-openstack-docs.git gh-pages > /dev/null

  cd gh-pages
  git rm -rf ./site_build
  cp -Rf $HOME/site_build ./site_build
  git add -f .
  git commit -m "Lastest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Published docs to F5 Networks GH Pages.";

if [ "$TRAVIS_REPO_SLUG" == "jputrino/*" ] ; then

  echo -e "Publishing docs to GitHub Pages"

  cp -R build/docs/javadoc $HOME/javadoc-latest

  cd $HOME
  git clone --quiet --branch=gh-pages git@github.com:jputrino/f5-openstack-docs.git gh-pages > /dev/null

  cd gh-pages
  git rm -rf ./site_build
  cp -Rf $HOME/site_build ./site
  git add -f .
  git commit -m "Lastest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Published docs to jputrino GH Pages.";



fi