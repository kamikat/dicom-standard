#!/bin/bash

set -e

if [ ! -f .attributes.json ]; then
  wget -O .attributes.json "https://github.com/innolitics/dicom-standard/raw/master/standard/module_to_attributes.json"
fi

if [ -d modules ]; then
  rm -rf .modules-bak
  mv -f modules .modules-bak
fi

mkdir modules

MODULE_LIST=$(jq -r '.[].module' < .attributes.json | uniq)

export PYTHONUNBUFFERED=1

show_progress() {
  if python3 -c "import tqdm" 2>/dev/null; then
    python3 -m tqdm -ncols 80 --total $(wc -l <<< "$MODULE_LIST") --unit p > /dev/null
  else
    cat
  fi
}

for MODULE in $MODULE_LIST; do
  echo "Building '$MODULE'..."
  jq -c "[ .[] | select(.module == \"$MODULE\") ]" < .attributes.json > modules/${MODULE}.json
done | show_progress


rm -rf .attributes.json .modules-bak
