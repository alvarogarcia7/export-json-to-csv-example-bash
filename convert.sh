function select_fields {
  cat $1 | jq '[.hits.hits[]._source | {"f1": .f1, "f2": .f2, f3}]'
}

function clean_up_fields {
  cat $1 | sed 's/\s*\("f3"\).*<name>\([^<]\+\)<\/name>.*/\1: "\2"/'
}

function export_to_csv {
  echo '"F1","F2","F3"'
  cat $1 |jq -r '.[]|[.f1, .f2, .f3]|@csv'
}

function extract_status {
  selected_fields=$(mktemp)
  selected_fields $1 > "${selected_fields}"
  clean_up_fields "${selected_fields}" > result.json
  export_to_csv result.json > result.csv
}
