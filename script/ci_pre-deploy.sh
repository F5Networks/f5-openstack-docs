#Hat-tip to Ben Limmer @http://benlimmer.com/2013/12/26/automatically-publish-javadoc-to-gh-pages-with-travis-ci/, without whose help (via the web) I never would have figured this out.


if [ "$TRAVIS_REPO_SLUG" == "jputrino/f5-openstack-docs" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then

  echo "Pushing site to GitHub...\n"

  cp -R f5-openstack-docs/_site $HOME/site_build-latest

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  git clone --quiet --branch=site https://${GH_TOKEN}@github.com/jputrino/f5-openstack-docs site

  cd site
  git rm -rf ./site_build
  cp -Rf $HOME/site_build-latest ./site_build
  git add -f .
  git commit -m "Latest site build on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to site branch"
  git push -fq origin site

  echo "Pushed site to GitHub.\n"
  
fi

