#!/bin/bash

# Usage:  init_template.sh <hostname> <template_repo_path>

if [ $# -ne 2 ];then
  echo "Usage:  init_template.sh <hostname> <template_repo_path>"
  exit 1
fi

REPOSITORY_PATH="$2"

if [ ! -d "$REPOSITORY_PATH" ]; then
  echo "Error:  Repository Path $2 does not exist.  "
  exit 1
fi

./link_repository.sh $1 $2

echo "Copying default configuration files."

if [ ! -f "$REPOSITORY_PATH/dev_config.json" ]; then
  cp defaults/dev_config.json $REPOSITORY_PATH
fi

if [ ! -f "$REPOSITORY_PATH/template_config.json" ]; then
  cp defaults/template_config.json $REPOSITORY_PATH
fi

cp defaults/htaccess $REPOSITORY_PATH/.htaccess

twig_folders=( handlers components layouts sections )
for i in "${twig_folders[@]}"
do
  current_path="$REPOSITORY_PATH/__twig/$i"
  echo "Adding template standard path: ${current_path}"
  mkdir -p ${current_path}
  touch ${current_path}/.keep
done

echo "Done"