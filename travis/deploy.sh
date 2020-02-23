#!/bin/sh

set -e

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    flutter build appbundle;
    cd android;
    bundle install;
    bundle exec fastlane android deploy;
    cd -;
fi