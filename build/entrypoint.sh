#!/bin/sh
set -e

# Set the working directory for the template
cd "${INPUT_WORKINGDIR:-.}"

set +e
# Run packer build
BUILD_OUTPUT=$(sh -c "packer build -debug ." 2>&1)
BUILD_SUCCESS=$?
echo "$BUILD_OUTPUT"
set -e

exit $BUILD_SUCCESS