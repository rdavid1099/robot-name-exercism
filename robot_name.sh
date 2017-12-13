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
  check_uniqueness $NEW_ROBOT_NAME
}

save_names_metadata() {
  if [[ ! -e ".meta.robot_name" ]]; then
    echo "$NEW_ROBOT_NAME;0" > .meta.robot_name
  else
    echo "$NEW_ROBOT_NAME;0" >> .meta.robot_name
  fi
}

update_meta_data() {
  while read bot; do
    [[ "$(echo $bot | cut -d ";" -f 1)" != "$1" ]] && echo $bot >> .meta.robot_name.1
  done <.meta.robot_name
  rm .meta.robot_name && mv .meta.robot_name.1 .meta.robot_name
  echo "$NEW_ROBOT_NAME;$restart_amt" >> .meta.robot_name
}

restart_bot() {
  get_bot_info $1
  generate_new_name
  restart_amt=$(( restart_amt + 1 ))
  update_meta_data $1
  echo $NEW_ROBOT_NAME
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
  [[ "$name_found" = 1 && "$1" != "all" ]] && robot_not_found_error $1
}

get_bot_info() {
  while read bot; do
    [[ "$(echo $bot | cut -d ";" -f 1)" = "$1" ]] && format_robot_info bot
  done <.meta.robot_name
  [[ "$ROBOT_INFO" = "" ]] && robot_not_found_error $1
}

format_robot_info() {
  robot_name=$(echo $bot | cut -d ";" -f 1)
  restart_amt=$(echo $bot | cut -d ";" -f 2)
  ROBOT_INFO="ROBOT: $robot_name, TIMES RESTARTED: $restart_amt"
}

check_uniqueness() {
  unique=0
  if [[ -e ".meta.robot_name" ]]; then
    while read bot; do
      [[ "$(echo $bot | cut -d ";" -f 1)" = "$1" ]] && unique=1
    done <.meta.robot_name
  fi
  [[ "$unique" = 1 ]] && generate_new_name
}

robot_not_found_error() {
  echo "ERROR: Invalid name given. Could not find data on $1."
  exit 1
}

case $1 in
  new)
    generate_new_name
    save_names_metadata
    echo $NEW_ROBOT_NAME
  ;;
  restart)
    restart_bot $2
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
