#Hat-tip to Ben Limmer @http://benlimmer.com/2013/12/26/automatically-publish-javadoc-to-gh-pages-with-travis-ci/, without whose help (via the web) I never would have figured this out.


#if [ "$TRAVIS_REPO_SLUG" == "jputrino/f5-openstack-docs" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then

#  echo "Pushing site to GitHub...\n"

jekyll build -d ./site_build
  cp -R ./site_build $HOME/site_build-latest

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  git clone --quiet --branch=site https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG site

  cd site
  git rm -rf ./site_build
  cp -Rf $HOME/site_build-latest ./site_build
  git add -f .
  git commit -m "Latest successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to site branch"
  git push -fq origin site

#fi

