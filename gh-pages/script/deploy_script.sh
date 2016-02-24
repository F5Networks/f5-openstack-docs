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
set -x # enable verbose output for debugging

#  Specify the git branch receiving a pull request that will replace the published docs on github pages.
#  master is correct for final released 'images', feature.autodocgen (or something else) for testing changes
F5_ORIGIN_BRANCH="master"

#  Set the git branch destination to which docs will be pushed.
#  gh-pages is the live site for github pages, gh-pages-test is a branch for testing plumbing changes
F5_GHPAGES_BRANCH="gh-pages"

F5_SITE_FILES="$HOME/site_build"

S3_KEY="$AWS_KEY"
S3_SECRET="$AWS_ACCESSKEY"
S3_BUCKET='f5-openstack-dev'
S3_URL="http://$S3_BUCKET.s3-website-us-west-2.amazonaws.com"

if [[ "$TRAVIS_REPO_SLUG" != "F5Networks/f5-openstack-docs" ]]; then
  echo "Docs not published"
  exit
fi

function putS3 {
  path=$1
  file=$2
  aws_path=$3
  bucket=$S3_BUCKET
  url=$S3_URL
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='application/x-compressed-tar'
  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3_SECRET}" -binary | base64)
  curl -X PUT -T "$path$file" \
    -H "Host: $S3_URL" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3_KEY}:$signature" \
    "$url$aws_path$file"
}

if [[ "$TRAVIS_BRANCH" == "$F5_ORIGIN_BRANCH" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  # This is a commit to master branch, which means we update official website.

  # go to the out directory and create a *new* Git repo
  cd "$F5_SITE_FILES"
  git init

  # inside this git repo we'll pretend to be a new user
  git config user.name "f5-travisci"
  git config user.email "OpenStack_TravisCI@f5.com"

  # The first and only commit to this new Git repo contains all the
  # files present with the commit message "Deploy to GitHub Pages".
  git add .
  git commit -m "Deploy to GitHub Pages"

  git remote add origin https://f5-travisci:$TRAVIS_PATOKEN@github.com/F5Networks/f5-openstack-docs.git

  # Force push from the current repo's master branch to the remote
  # repo's gh-pages branch. (All previous history on the gh-pages branch
  # will be lost, since we are overwriting it.) We redirect any output to
  # /dev/null to hide any sensitive credential data that might otherwise be exposed.
  git push --force --quiet  origin master:$F5_GHPAGES_BRANCH > /dev/null 2>&1

  echo "Published docs to F5 Networks GH Pages."

elif [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then

  # This is a pull request, push to S3 for code review.

  cd "$F5_SITE_FILES"
  for file in `find . -type f`; do
    putS3 . "/${file#*/}" "/$TRAVIS_PULL_REQUEST"
  done

  echo "Published docs to F5 S3 Dev Bucket.  Browse to ${S3_URL}/$TRAVIS_PULL_REQUEST for review."

else

  echo "Docs not published to GitHub Pages"

fi
