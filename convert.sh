function extract_status {
  cat $1 | jq '[.hits.hits[]._source | {"f1": .f1, "f2": .f2, f3}]' > selected_fields.jq

  cat selected_fields.jq | sed 's/\s*\("f3"\).*<name>\([^<]\+\)<\/name>.*/\1: "\2"/' > result.json

  echo '"F1","F2","F3"' > result.csv
  cat result.json|jq -r '.[]|[.f1, .f2, .f3]|@csv' >> result.csv
}
