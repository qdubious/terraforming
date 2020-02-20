#! /bin/bash

while IFS= read -r line; do
    if [ -z "$line" ]; then
        continue;
    fi
    if [[ $line == \#* ]]; then
        continue;
    fi
    [ -d terraform ] || mkdir terraform
    #echo "$line"
    command=$(echo "${line}" | awk '{print $2}')
    output=$(terraforming "$command")
    if [[ -z $output ]]; then
        continue;
    fi
    echo "$output" > terraform/"$command".tf
done < terraforming_commands.txt
