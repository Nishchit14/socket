#!/usr/bin/env bash
set -e;

function build {
  `echo $CXX` src/build.cc -o bin/build -std=c++2a -stdlib=libc++
  if [ ! $? = 0 ]; then
    echo '• Unable to build'
    exit 1
  fi
  echo '• OK'
}

#
# Install - when this script is called with a parameter
#
if [ "$1" ]; then
  TMPD=$(mktemp -d)

  echo '• Cloning from Github'
  git clone https://github.com/optoolco/opkit $TMPD > /dev/null 2>&1

  if [ ! $? = 0 ]; then
    echo "• Unable to clone"
    exit 1
  fi

  # enter the temp dir and run the build of the build tool
  cd $TMPD
  echo '• Building'
  build

  # create a symlink to the binary so it can be run anywhere
  echo '• Attempting to create a symlink in /usr/local/bin'
  ln -s `pwd`/bin/build /usr/local/bin/opkit

  if [ ! $? = 0 ]; then
    echo '• Unable to create symlink'
    exit 1
  fi

  echo '• Finished. Type \'opkit' for help'
  exit 0
fi

#
# Build - when being run from the source tree (developer mode)
#
echo '• Compiling build program'
build
