#!/bin/bash

declare -a ALPHABET=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
current_time=$(date "+%Y-%m-%d.%H:%M:%S")

generate_new_name() {
  NEW_ROBOT_NAME=""
  for (( i = 0; i < 5; i++ )); do
    if [[ "$i" -gt "1" ]]; then
      NEW_ROBOT_NAME+=$(( RANDOM % 10 ))
    else
      NEW_ROBOT_NAME+=${ALPHABET[$(( RANDOM % 26 ))]}
    fi
  done
  save_names_metadata
}

save_names_metadata() {
  if [[ ! -e ".meta.robot_name" ]]; then
    echo "$NEW_ROBOT_NAME;$current_time;$current_time" > .meta.robot_name
  fi
}

case $1 in
  new)
    generate_new_name
    echo $NEW_ROBOT_NAME
  ;;
  *)
    echo "ERROR: Invalid command"
  ;;
esac
