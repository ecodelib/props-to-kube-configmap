# Script Description
*A quick and an easy way of creation ConfigMap.yaml file from app.properties file*

This script creates a Kubernetes ConfigMap from a properties file. It takes the name of the properties file as input and generates a YAML file with the ConfigMap. The script reads the properties file and converts each property into a key-value pair in the ConfigMap. It also handles special characters and comments in the properties file. The output is saved in a specified YAML file.

## The main sections
1. Variable declarations
2. Setting the output file name and printing a message to the console
3. Writing the initial YAML lines for the ConfigMap
4. Looping through each line of the properties file and processing it into a key-value pair in the ConfigMap
5. Printing a message to the console indicating that the ConfigMap has been generated and saved to the specified YAML file.


# Main Commands
The script uses the following main commands:
- `sed` command: Removes leading or trailing white spaces and replaces any white space around the equal sign with just one equal sign. It also removes any empty lines.
- `awk` command: Transforms each property into a key-value pair in the ConfigMap YAML format. It converts the property key to uppercase and replaces any dot (.) with an underscore (_) character. The property value is escaped by replacing any backslashes (\) with forward slashes (/) and any double quotes (") with escaped double quotes (\\"). If a line starts with a hash (#), it is treated as a comment and printed as-is in the YAML file. If the property value is empty or only contains white spaces or tabs, it is skipped.
- `echo` command: Prints the YAML headers and metadata sections to the output file.