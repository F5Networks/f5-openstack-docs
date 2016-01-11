#!/bin/bash
#  deploy_script.sh
#  
#
#  Originally based on a script created by blimmer for ReadyTalk -- http://github.com/ReadyTalk/swt-bling
#
#  Modified by Jodie Putrino on 12/11/15.
#  Rewritten by Matt Greene on 01/11/16.
#

set -e # exit with nonzero exit code if anything fails

if [[ "$TRAVIS_REPO_SLUG" == "F5Networks/f5-openstack-docs" ]]; then

  # go to the out directory and create a *new* Git repo
  cd "$HOME"/site_build
  git init

  # inside this git repo we'll pretend to be a new user
  git config user.name "f5-travisci"
  git config user.email "OpenStack_TravisCI@f5.com"

  # The first and only commit to this new Git repo contains all the
  # files present with the commit message "Deploy to GitHub Pages".
  git add .
  git commit -m "Deploy to GitHub Pages"

  git remote rm origin
  git remote add origin https://f5-travisci:$TRAVIS_PATOKEN@github.com/F5Networks/f5-openstack-docs.git
  
  # Force push from the current repo's master branch to the remote
  # repo's gh-pages branch. (All previous history on the gh-pages branch
  # will be lost, since we are overwriting it.) We redirect any output to
  # /dev/null to hide any sensitive credential data that might otherwise be exposed.
  git push --force --quiet "https://f5-travisci:$TRAVIS_PATOKEN@github.com/F5Networks/f5-openstack-docs.git" origin master:gh-pages-test > /dev/null 2>&1

  echo "Published docs to F5 Networks GH Pages."

else

  echo "Docs not published to GitHub Pages"

fi
