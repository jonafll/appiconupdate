#!/usr/bin/env bash

VERSION="v0.3.0"
RED=$'\e[1;31m'
YELLOW=$'\e[1;33m'
NC=$'\e[0m'

if [[ "$1" == "-v" || "$1" == "--version" ]]; then
  echo "appiconupdate $VERSION"
  exit 0
fi

if [[ ! -x "$(command -v fileicon)" ]]; then
  echo "${RED}Error:${NC} fileicon not found"
  exit 1
fi

if [[ -n "$1" ]]; then
  ICN_PATH="$1"
fi

if [[ -z "${ICN_PATH}" ]]; then
  echo "${RED}Error:${NC} ICN_PATH is not set"
  exit 1
fi

echo "Updating icons..."

for icn in "$ICN_PATH"/*; do

  app_name=$(basename "$icn" | cut -f 1 -d ".")
  app=$(find /Applications -maxdepth 3 -type d -name "$app_name".app)

  if [[ -z "$app" ]]; then
    echo "${YELLOW}Skipping...${NC} $app_name not found"
    continue
  fi

  ret_code=$(fileicon test "$app" &> /dev/null; echo $?)
  if [[ "$ret_code" == 1 ]]; then
    fileicon set "$app" "$icn"
  fi
done
