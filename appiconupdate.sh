#!/usr/bin/env bash

VERSION="v0.1.0"
RED=$'\e[1;31m'
NC=$'\e[0m'

if [[ "$1" == "-v" || "$1" == "--version" ]]; then
  echo "appiconupdate $VERSION"
  exit 0
fi

if [[ -n "$1" ]]; then
  ICN_PATH="$1"
fi

if [[ -z "${ICN_PATH}" ]]; then
  echo "${RED}Error:${NC} ICN_PATH is not set"
  exit 1
fi

for icn in "$ICN_PATH"/*; do
  app_name=$(basename "$icn" | cut -f 1 -d ".")
  app=/Applications/$app_name.app

  if [[ ! -d "$app" ]]; then
    echo "${RED}Error:${NC} $app not found"
    continue
  fi

  ret_code=$(fileicon test "$app" &> /dev/null; echo $?)
  if [[ "$ret_code" == 1 ]]; then
    fileicon set "$app" "$icn"
  fi
done