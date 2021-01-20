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

#copy imlibcore
IMLIBCORE_PATH="../imlibcore"
if [ -d ${IMLIBCORE_PATH}/ ]; then
   echo "ifly build: copy imlibcore"
   cp -af ${IMLIBCORE_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy chatroom
CHATROOM_PATH="../chatroom"
if [ -d ${CHATROOM_PATH}/bin ]; then
   echo "ifly build: copy chatroom"
   cp -af ${CHATROOM_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy discussion
DISCUSSION_PATH="../discussion"
if [ -d ${DISCUSSION_PATH}/bin ]; then
   echo "ifly build: copy discussion"
   cp -af ${DISCUSSION_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy publicservice
PUBLICSERVICE_PATH="../publicservice"
if [ -d ${PUBLICSERVICE_PATH}/bin ]; then
   echo "ifly build: copy publicservice"
   cp -af ${PUBLICSERVICE_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy customerservice
CUSTOMERSERVICE_PATH="../customerservice"
if [ -d ${CUSTOMERSERVICE_PATH}/bin ]; then
   echo "ifly build: copy customerservice"
   cp -af ${CUSTOMERSERVICE_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi

#copy location
REALTIMELOCATION_PATH="../location"
if [ -d ${REALTIMELOCATION_PATH}/bin ]; then
   echo "ifly build: copy location"
   cp -af ${REALTIMELOCATION_PATH}/bin/* ${IFLY_FRAMEWORKER_PATH}/
fi
