#!/usr/bin/env bats

setup() {
  NAME_REGEXP='[A-Z][A-Z][0-9][0-9][0-9]'
}

@test "it generates a valid robot name" {
  run bash robot_name.sh new

  [[ "$status" -eq "0" ]]
  [[ "$output" =~ $NAME_REGEXP ]]
}

@test "each new robot name is unique" {
  run bash -c "bash $PWD/robot_name.sh new; bash $PWD/robot_name.sh new"

  [[ "$status" -eq "0" ]]
  [[ "${lines[0]}" != "${lines[1]}" ]]
}
