#! /bin/bash

while IFS= read -r line; do
    if [ -z "$line" ]; then
        continue;
    fi
    if [[ $line == \#* ]]; then
        continue;
    fi
    [ -d output ] || mkdir output
    #echo "$line"
    command=$(echo "${line}" | awk '{print $2}')
    output=$(terraforming "$command" | sed -E "s/tags \{/tags = \{/g")
    sleep 1
    if [[ -z $output ]]; then
        continue;
    fi
    echo "$output" > output/"$command".tf
done < terraforming_commands.txt
