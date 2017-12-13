#!/usr/bin/env bats

setup() {
  NAME_REGEXP='[A-Z][A-Z][0-9][0-9][0-9]'
}

@test "it generates a valid robot name" {
  run bash robot_name.sh new

  [[ "$status" -eq "0" ]]
  [[ "$output" =~ $NAME_REGEXP ]]
}
