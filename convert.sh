function select_fields {
  cat $1 | jq '[.hits.hits[]._source | {"f1": .f1, "f2": .f2, f3}]'
}

function clean_up_fields {
  cat selected_fields.jq | sed 's/\s*\("f3"\).*<name>\([^<]\+\)<\/name>.*/\1: "\2"/' > result.json
}

function extract_status {
  selected_fields $1 > selected_fields.jq
  clean_up_fields selected_fields.jq
  echo '"F1","F2","F3"' > result.csv
  cat result.json|jq -r '.[]|[.f1, .f2, .f3]|@csv' >> result.csv
}
