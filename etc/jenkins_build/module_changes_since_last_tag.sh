#!/bin/bash

# this is the last known tag, assuming semver tags.
LAST_TAG=$(git tag -l | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+$' | sort -t. -k1,1n -k2,2n -k3,3n | head -n 1)

# TODO: check - perhaps we never actually had a tag
echo "last deployed tag was <${LAST_TAG}>"

# now look for changes
CHANGES=$(git diff --name-only HEAD ${LAST_TAG} | grep -E 'core|services')

if [ -z "$CHANGES" ]; then
  echo "no changes to core/ or services/ detected since <${LAST_TAG}> on ${GIT_BRANCH}.  nothing to see here."
else
  echo "changes found:"
  CHANGED_MODULES=$(echo "$CHANGES" | tr '/' ' ' | awk '{print $1 "/" $2}' | uniq)

  for mod in $CHANGED_MODULES; do
    echo -e "\t $mod"

    # if there's a build.sbt file, use its version string as the version of that module
    if [ -a "${mod}/build.sbt" ]; then
      SBT_FNAME="${mod}/build.sbt"
      VERSION=$(cat ${SBT_FNAME} | grep "version" | grep -o -E "\d+\.\d+\.\d+")

      echo -e "\t->scala SBT file found (${SBT_FNAME}): version is ${VERSION}"
    else
      # TODO: how to establish version numbers otherwise?
      echo "no version number found, reverting to git tag version"
      VERSION=${LAST_TAG}
    fi

    # now set the environment variable ${mod} to be the version
    echo "export "$(echo $mod | sed -e 's/[-/]/\_/g')"="$VERSION""
  done
fi
