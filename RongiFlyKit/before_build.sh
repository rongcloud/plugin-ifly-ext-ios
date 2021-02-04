#!/bin/sh

echo "------ifly build start ----------------"

IFLY_FRAMEWORKER_PATH="./framework"
if [ ! -d "$IFLY_FRAMEWORKER_PATH" ]; then
    mkdir -p "$IFLY_FRAMEWORKER_PATH"
fi

#copy imlib
IMLIB_PATH="../imlib/bin"
if [ -d "$IMLIB_PATH" ]; then
    echo "ifly build: copy imlib"
    cp -af ${IMLIB_PATH}/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy imkit

IMKIT_PATH="../imkit/bin"
if [ -d "$IMKIT_PATH" ]; then
    echo "ifly build: copy imkit"
    cp -af ${IMKIT_PATH}/* ${IFLY_FRAMEWORKER_PATH}/
fi
