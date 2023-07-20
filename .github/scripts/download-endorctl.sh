#!/bin/bash

# This script downloads the latest version of the endorctl CLI utility
# If ENDORCTL_VERSION is set in the environment, the specified version will
# be downloaded instead (ENDORCTL_SHA also needs to be set for verification)

if [ "${ENDORCTL_VERSION:-latest}" == "latest" ]; then
   echo "Downloading latest version of endorctl";
   ENDORCTL_SHA=$(curl --silent https://api.endorlabs.com/meta/version | jq -r '.ClientChecksums.ARCH_TYPE_LINUX_AMD64');
   VERSION=$(curl --silent https://api.endorlabs.com/meta/version | jq -r '.Service.Version');
   curl --silent https://storage.googleapis.com/endorlabs/"$VERSION"/binaries/endorctl_"$VERSION"_linux_amd64 -o endorctl;
   echo "$ENDORCTL_SHA  endorctl" | sha256sum -c;
   if [ $? -ne 0 ]; then 
      echo "Integrity check failed"; 
      exit 1;
   fi
else
   echo Downloading version "$ENDORCTL_VERSION" of endorctl;
   if [ "$ENDORCTL_SHA" = "" ]; then echo "WARNING: ENDORCTL_SHA not set"; fi
   curl --silent https://storage.googleapis.com/endorlabs/"$ENDORCTL_VERSION"/binaries/endorctl_"$ENDORCTL_VERSION"_linux_amd64 -o endorctl;
   echo "$ENDORCTL_SHA  endorctl" | sha256sum -c;
   if [ $? -ne 0 ]; then 
      echo "Integrity check failed for the pinned version of endorctl. Please ensure the environment variable is set and re-run the job"; 
      exit 1;
   fi
fi
chmod +x ./endorctl
