#!/bin/bash

set -e

if [ ! -f .modules.json ]; then
  wget -O .modules.json "https://github.com/innolitics/dicom-standard/raw/master/standard/modules.json"
fi

if [ ! -f .attributes.json ]; then
  wget -O .attributes.json "https://github.com/innolitics/dicom-standard/raw/master/standard/attributes.json"
fi

if [ ! -f .module_to_attributes.json ]; then
  wget -O .module_to_attributes.json "https://github.com/innolitics/dicom-standard/raw/master/standard/module_to_attributes.json"
fi

if [ -d modules ]; then
  rm -rf .modules-bak
  mv -f modules .modules-bak
fi

mkdir modules

jq -s '([ .[0] | to_entries | .[].value   ] | map({ (.tag): .   }) | add) as $attrs | .[1] | map($attrs[.tag] + .)' \
  .attributes.json .module_to_attributes.json > .compound.json

MODULE_LIST=$(jq -r '.[] | select(.module != null) | .module' < .compound.json | sort | uniq)

show_progress() {
  if python3 -c "import tqdm" 2>/dev/null; then
    python3 -m tqdm -ncols 80 --total $(wc -l <<< "$MODULE_LIST") --unit p > /dev/null
  else
    cat
  fi
}

for MODULE in $MODULE_LIST; do
  echo "Building '$MODULE'..."
  jq -s -c ".[0][\"$MODULE\"] + { attributes: .[1] | [ .[] | select(.module == \"$MODULE\") ] }" .modules.json .compound.json > modules/${MODULE}.json
done | show_progress

rm -rf .modules-bak
