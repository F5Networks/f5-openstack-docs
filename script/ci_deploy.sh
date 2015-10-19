#!/bin/sh
set -e #halt script on error

#  ci_deploy.sh
#  
#
#  Created by Jodie Putrino on 10/19/15.
#

# commit
git config user.email "j.putrino@f5.com"
git config user.name "jputrino"
git commit _site/ -m "travis-ci build"
git push origin site
