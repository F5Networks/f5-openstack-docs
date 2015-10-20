#!/bin/sh
set -e #halt script on error

#  ci_deploy.sh
#  
#
#  Created by Jodie Putrino on 10/19/15.
#

#Tell Travis what repo to use
[ "$TRAVIS_REPO_SLUG" == "jputrino/f5-openstack-docs" ]

#Tell Travis not to create a pull request
[ "TRAVIS_PULL_REQUEST" == "false" ]

# commit
cd $HOME
  git config --global user.email "travis@travis-ci.com"
  git config --global user.name "travis-ci"
git clone --quiet --branch=site https://${GH_TOKEN}@github.com/jputrino/f5-openstack-docs.git
  git commit -a
  git push origin site
