#!/bin/bash

FILE="app.properties"
OUTPUT_FILE="configmap.yaml"

echo "apiVersion: v1" > $OUTPUT_FILE
echo "kind: ConfigMap" >> $OUTPUT_FILE
echo "metadata:" >> $OUTPUT_FILE
echo "  name: my-configmap" >> $OUTPUT_FILE
echo "data:" >> $OUTPUT_FILE

#while read line; do
#  if [[ $line == \#* ]]; then
#    echo "$line" >> $OUTPUT_FILE
#    continue
#  fi
#  key=$(echo "$line" | cut -d= -f1)
#  value=$(echo "$line" | cut -d= -f2-)
#  key=$(echo "$key" | tr '.' '_')
#  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
#  value=$(echo "$value" | sed 's/\\/\//g')
#  value=$(echo "$value" | sed 's/"/\\\\\\"/g')
#  echo "  $key: \"$value\"" >> $OUTPUT_FILE
#done < <(awk '{gsub(/\./,"_"); print toupper($0)}' $FILE)


sed 's/^\s*//;s/\s*$//;s/\s*=\s*/=/g;/^\s*$/d' $FILE | awk -F= '{gsub(/\./,"_");
  key=toupper($1);
  value=$2;
  gsub(/\\/,"/",value);
  gsub(/"/,"\\\\\"",value);
  if(substr($0,1,1)=="#") {print "  "$0} else
    if (value ~ /^[\t\s]*$/) {next} else {print "  "key": \""value"\""}}' >> $OUTPUT_FILE

echo "ConfigMap created in $OUTPUT_FILE."