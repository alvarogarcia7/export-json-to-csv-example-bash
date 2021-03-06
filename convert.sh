#!/bin/bash

set -euf -o pipefail

function select_fields {
  cat $1 | jq '[. | {"f1": .f1, "f2": .f2, f3}]'
}

function clean_up_fields {
  cat $1 | sed 's/\s*\("f3"\).*<name>\([^<]\+\)<\/name>.*/\1: "\2"/'
}

function export_to_csv {
  echo '"F1","F2","F3"'
  cat $1 |jq -r '.[]|[.f1, .f2, .f3]|@csv'
}

function download_results {
  all=$(mktemp)
  wget $1 -o "${all}" #and other options
  cat "${all}" | jq -r '.hits.hits[]._source'
}

function select_fields_into_csv {
  selected_fields=$(mktemp)
  select_fields $1 > "${selected_fields}"

  result=$(mktemp)
  clean_up_fields "${selected_fields}" > "${result}"

  export_to_csv "${result}"
}

function main {
  download=$(mktemp)
  download_results $1 > "${download}"

  select_fields_into_csv "${download}"
}

## Usage
#./$0 $YOUR_ELASTICSEARCH_URL_WITH_QUERY > destination.csv


#Inspired by https://google.github.io/styleguide/shell.xml
main $1
