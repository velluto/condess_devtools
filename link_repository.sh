#!/bin/bash

# Usage:  link_repository.sh <hostname> <template_repo_path>

if [ $# -ne 2 ];then
  echo "Usage:  link_repository.sh <hostname> <template_repo_path>"
  exit 1
fi

DEV_HOST=$1
REPOSITORY_PATH="templates/$2"

if [ ! -d "$REPOSITORY_PATH" ]; then
  echo "Error:  Repository Path $2 does not exist.  Please make sure it's in the 'templates' subdirectory."
  exit 1
fi

if [ -d "htdocs/$DEV_HOST" ]; then
  echo "Development host $DEV_HOST already exists, doing nothing."
  exit 1
fi

echo "Linking dev host"

(cd htdocs && ln -s ../$REPOSITORY_PATH $DEV_HOST)


echo "Done"