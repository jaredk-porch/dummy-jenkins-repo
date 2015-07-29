#!/bin/bash

# this is the last known tag, assuming semver tags.
LAST_TAG=$(git tag -l --sort "-version:refname" | grep '^[0-9]\+\.[0-9]\+\.[0-9]\+$' | head -n 1)

# TODO: check - perhaps we never actually had a tag
echo "last deployed tag was <$LAST_TAG>"
