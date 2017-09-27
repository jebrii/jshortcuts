#! /bin/bash

# TODO: Check for proper parameter inputs

if ! [ -d "$1" ]; then # check if file exists and is a regular file
  egrep '^#|^[^ ]*=[^;&]*' "$1"
else
  echo -ne $RED
  echo "ERROR: Please supply regular file"
  echo -ne $NC
  exit 1
fi
