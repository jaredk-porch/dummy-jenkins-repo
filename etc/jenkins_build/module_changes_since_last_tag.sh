#!/bin/bash

# this is the last known tag, assuming semver tags.
LAST_TAG=$(git tag -l | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+$' | sort -t. -k1,1n -k2,2n -k3,3n | head -n 1)

# TODO: check - perhaps we never actually had a tag
echo "last deployed tag was <$LAST_TAG>"
echo $(git --version)
