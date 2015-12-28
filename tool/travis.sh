#!/bin/bash

# Modified version of
# https://github.com/duse-io/dart-coveralls/blob/master/tool/travis.sh
# By Kevin Moore <kevmoo>

# Fast fail the script on failures.
set -e

pub run test test/

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then

    pub run dart_coveralls report \
      --token $COVERALLS_TOKEN \
      --exclude-test-files \
      .pub/bin/test/test.dart.snapshot

else
  if [ -z ${COVERALLS_TOKEN+x} ]; then echo "COVERALLS_TOKEN is unset"; fi
  if [ -z ${TRAVIS_DART_VERSION+x} ]; then
    echo "TRAVIS_DART_VERSION is unset";
  else
    echo "TRAVIS_DART_VERSION is $TRAVIS_DART_VERSION";
  fi

  echo "Skipping coverage for this configuration."
fi
