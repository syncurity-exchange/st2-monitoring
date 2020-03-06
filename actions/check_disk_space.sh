#!/usr/bin/env bash

# Grab $1 and $2

if [[ "$#" -ne 1 ]]; then
  echo "Usage: ${0} /path/to/directory"
  exit 1
else
  FOLDERPATH=$1
fi


# make sure we have a directory
if [[ ! -d "$FOLDERPATH" ]]; then
  echo "${1} is not a path that exists"
  exit 1
fi

if [[ ! -r "$FOLDERPATH" ]]; then
  echo "User does not have access to this folder"
  exit 1
fi

DISK_PERCENT_USED=$(df -k "$FOLDERPATH" | grep -v Use | awk '{ print $5 }' | sed 's/%//')

if [[ "$?" -ne 0 ]]; then
    echo "Failed to find disk usage"
    exit 1
else
    echo " { \"USED_DISK_SPACE\": ${DISK_PERCENT_USED} }"
fi
