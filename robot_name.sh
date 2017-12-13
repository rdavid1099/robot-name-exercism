#!/bin/bash

declare -a ALPHABET=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

generate_new_name() {
  NEW_ROBOT_NAME=""
  for (( i = 0; i < 5; i++ )); do
    if [[ "$i" -gt "1" ]]; then
      NEW_ROBOT_NAME+=$(( RANDOM % 10 ))
    else
      NEW_ROBOT_NAME+=${ALPHABET[$(( RANDOM % 26 ))]}
    fi
  done
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
