# f5-openstack-docs
Documentation for all f5 openstack projects
[![Build Status](https://magnum.travis-ci.com/F5Networks/f5-openstack-docs.svg?branch=master)https://magnum.travis-ci.com/F5Networks/f5-openstack-docs/]

# What It Does

This repo houses the configuration materials for the [openstack.f5.com] website. We use [Jekyll] and [Travis CI] to build and to deploy the site, respectively.

# How It Works
When a change is committed to the GitHub repo, a Travis CI build kicks off automatically. The build script uses the `jekyll build` command to build the site, then runs [`HTML::Proofer`] to check the code. After a successful build, the site is automatically deployed.

## How It *Really* Works
In the `.travis.yml` file, we tell Travis to do the following:
    1. Run a build script (cibuild.sh)
        `bundle exec jekyll build -d {dir_name}` | tell jekyll to build the site into the \{dir_name\} folder
        `bundle exec htmlproof ./{dir_name}`  | tell the HTML::Proofer to check the content of the \{dir_name\} folder
        `cp -R ./{dir_name} $HOME/{dir_name-latest}` | tell jekyll to copy all of the content of the \{dir_name\} folder to a new folder in its local home directory
        `cd $HOME`
       `git config --global user.email "travis@travis-ci.org"`  | give travis some git credentials
        `git config --global user.name "travis-ci"`  | 
        `git clone --quiet --branch=site https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG site` | clone the repo into travis' local home directory

        cd site
        `git rm -rf ./{dir_name}`  |
        cp -Rf $HOME/{dir_name}-latest ./{dir_name}
        git add -f .
        git commit -m "Latest successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to {branch_name} branch [ci skip]"
        git push -fq origin site






[openstack.f5.com]:http://openstack.f5.com/
[Jekyll]:https://jekyllrb.com/
[Travis CI]:https://travis-ci.com/
[`HTML::Proofer`]:https://github.com/gjtorikian/html-proofer