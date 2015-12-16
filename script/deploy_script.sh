#!/bin/sh

#  deploy_script.sh
#  
#
#  Based on a script created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#
#  Modified by Jodie Putrino on 12/11/15.
#

# turn tracing on so we can see the script run in travis
set -x

#  Set travis' username and email for GitHub
git config --global user.email "OpenStack_TravisCI@f5.com"
git config --global user.name "f5-travisci"

# Log in to GitHub using travis' gh token
travis login --pro -u $TRAVIS_USER --github-token $TRAVIS_GHTOKEN

if [[ "$TRAVIS_REPO_SLUG" =~ "F5Networks/" ]] && [[ "$TRAVIS_PULL_REQUEST" == "TRUE" ]]; then

  echo -e "Publishing docs to GitHub Pages"
  cd $HOME
  git clone --verbose --branch=gh-pages git@github.com:F5Networks/f5-openstack-docs.git gh-pages
  cd gh-pages
  cp -Rf $HOME/site_build ./
  git add -f .
  git commit -m "Lastest doc set on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
  git push --verbose origin gh-pages
  echo "Published docs to F5 Networks GH Pages."; else

  echo "skipping deploy script and not publishing to GitHub Pages"

fi

