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
  save_names_metadata
}

save_names_metadata() {
  if [[ ! -e ".meta.robot_name" ]]; then
    echo "$NEW_ROBOT_NAME;0" > .meta.robot_name
  else
    echo "$NEW_ROBOT_NAME;0" >> .meta.robot_name
  fi
}

print_meta() {
  name_found=1
  while read bot; do
    ROBOT_INFO=""
    [[ "$(echo $bot | cut -d ";" -f 1)" = "$1" || "all" = "$1" ]] && format_robot_info bot
    if [[ "$ROBOT_INFO" != "" ]]; then
      echo $ROBOT_INFO
      name_found=0
    fi
  done <.meta.robot_name
  [[ "$name_found" = 1 && "$1" != "all" ]] && robot_not_found_error
}

format_robot_info() {
  robot_name=$(echo $bot | cut -d ";" -f 1)
  restart_amt=$(echo $bot | cut -d ";" -f 2)
  ROBOT_INFO="ROBOT: $robot_name, TIMES RESTARTED: $restart_amt"
}

robot_not_found_error() {
  echo "ERROR: Invalid name given. Could not find data on $1."
}

case $1 in
  new)
    generate_new_name
    echo $NEW_ROBOT_NAME
  ;;
  display)
    print_meta $2
  ;;
  display_all)
    print_meta all
  ;;
  *)
    echo "ERROR: Invalid command"
  ;;
esac
