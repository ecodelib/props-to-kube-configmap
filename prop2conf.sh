#!/bin/bash

FILE="app.properties"
# This line sets a variable FILE (to the first argument passed to the script - $1). This argument should be the name of the properties file that will be used to generate the ConfigMap.

OUTPUT_FILE="configmap.yaml"
# This line sets a variable OUTPUT_FILE to the name of the YAML file that will be generated with the ConfigMap.


echo "apiVersion: v1" > $OUTPUT_FILE
# This line prints a message to the console indicating that the ConfigMap is being generated from the specified properties file.

echo "kind: ConfigMap" >> $OUTPUT_FILE
# Writes the first line of the YAML file, which specifies the API version for Kubernetes objects.

echo "metadata:" >> $OUTPUT_FILE
# Appends a line to the YAML file specifying that this object is a ConfigMap.

echo "  name: my-configmap" >> $OUTPUT_FILE
# Appends a line to the YAML file indicating that metadata for the ConfigMap will follow.

echo "data:" >> $OUTPUT_FILE
# This line appends a line to the YAML file specifying the name of the ConfigMap. The name is derived from the properties file name by removing the ".properties" extension.

: <<'THE_FIRST_VERSION'
while read line; do
  if [[ $line == \#* ]]; then
    echo "$line" >> $OUTPUT_FILE
    continue
  fi
  key=$(echo "$line" | cut -d= -f1)
  value=$(echo "$line" | cut -d= -f2-)
  key=$(echo "$key" | tr '.' '_')
  key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  value=$(echo "$value" | sed 's/\\/\//g')
  value=$(echo "$value" | sed 's/"/\\\\\\"/g')
  echo "  $key: \"$value\"" >> $OUTPUT_FILE
done < <(awk '{gsub(/\./,"_"); print toupper($0)}' $FILE)
THE_FIRST_VERSION


sed 's/^\s*//;s/\s*$//;s/\s*=\s*/=/g;/^\s*$/d' $FILE | awk -F= '{gsub(/\./,"_");
  key=toupper($1);
  value=$2;
  gsub(/\\/,"/",value);
  gsub(/"/,"\\\\\"",value);
  if(substr($0,1,1)=="#") {print "  "$0} else
    if (value ~ /^[\t\s]*$/) {next} else {print "  "key": \""value"\""}}' >> $OUTPUT_FILE
# Reading the contents of a file: The command starts by reading the contents of a file specified in the $FILE variable. The sed command is used to remove leading and trailing whitespace, replace whitespace around the equal sign with a single equal sign, and delete empty lines. The awk command is used to parse the cleaned up file contents. It converts the keys to uppercase and replaces dots with underscores. It also escapes any backslashes and double quotes in the values. Also the awk command filters out any lines that start with a hash symbol (#) or have empty values.The filtered data is then written to a file specified in the $OUTPUT_FILE variable.

echo "ConfigMap created in $OUTPUT_FILE."
# Printing a message: Finally, the command prints a message indicating that the ConfigMap has been created in the specified file.