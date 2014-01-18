#!/bin/bash

[ -n "$PORT" ] || PORT=6379
declare -a FILES
declare -a KEYS

while getopts "i:k:" opt
do
    case "$opt" in
        i)
            FILES=("${FILES[@]}" "$OPTARG");;
        k)
            KEYS=("${KEYS[@]}" "$OPTARG");;
    esac
done

shift $(($OPTIND-1))

exit_no_file() {
    echo "No files given" 1>&2
    exit 1
}

exit_file_does_not_exist() {
    echo "File $1 does exist" 1>&2
    exit 1
}


include_file() {
    file="$1"
    [ -f "$file" ] || exit_file_does_not_exist $file
    cat $file
}

[ ${#FILES[@]} -gt 0 ] || exit_no_file

(
echo "eval '"
for file in ${FILES[@]}; do
    include_file $file
done
echo "'"
echo "${#KEYS[@]}"
for key in ${KEYS[@]}; do
    echo $key
done
echo $@
) | sed 's/--.*//g' | tr '\n' ' ' | sed 's/[[:space:]][[:space:]]*/ /g' | redis-cli -p $PORT --raw
