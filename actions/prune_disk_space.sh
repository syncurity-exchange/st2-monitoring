#!/usr/bin/env bash

# Grab $1 and $2

if [[ "$#" -lt 2 ]] || [["$#" -gt 3 ]]; then
  echo "Usage: ${0} '/path/to/directory' 'percent_used_integer (defaults to 80)' [test]"
  exit 1
elif [[ "$#" -eq 2 ]]; then
  FILESYSTEM=$1
  PERCENT_USED=${2}
  TESTRUN=""
else
  FILESYSTEM=$1
  PERCENT_USED=${2}
  TESTRUN=$3
fi

if ! [[ "$PERCENT_USED" =~ ^[1-9][0-9]?$|^100$ ]]; then
  echo "Your percent of disk space used is not an integer, or is not between 1-100"
  exit 1
fi



if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root"
  exit 1
fi

# make sure we have a directory
if [[ ! -d "$FILESYSTEM" ]]; then
  echo "${1} is not a path that exists"
  exit 1
fi

if [[ -z "$TESTRUN" ]]; then
  echo "Running in delete mode"
else
  echo "Test mode enabled, listing directory usage and files to be deleted"
fi

DISK_PERCENT_USED=$(df -k "$FILESYSTEM" | grep -v Use | awk '{ print $5 }' | sed 's/%//')

if [[ "$DISK_PERCENT_USED" -gt "$PERCENT_USED" ]]; then
  if [[ -z "$TESTRUN" ]]; then
    echo "Running in delete mode"
    echo "Deleting ${FILESYSTEM}/*.log"
    find "${FILESYSTEM}" -type f -name "*.log" -print -delete
  else
    echo "Running in test mode"
    find "${FILESYSTEM}" -type f -name "*.log" -print
  fi
fi

