#!/usr/bin/env bats

setup() {
  # Regular expression to test valid robot names
  NAME_REGEXP='[A-Z][A-Z][0-9][0-9][0-9]'
}

teardown() {
  # Removes robot metadata file after each test
  rm -f .meta.robot_name
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

@test "new robot data is saved to .meta.robot_name" {
  run bash robot_name.sh new

  [[ "$status" -eq "0" ]]
  [[ -e ".meta.robot_name" ]]
}

@test "all robot information is displayed" {
  # Example Output: ROBOT: AB123, CREATED YYYY-MM-DD, UPDATED: YYYY-MM-DD
  CURRENT_TIME=$(date "+%Y-%m-%d.%H:%M:%S")
  run bash -c "bash $PWD/robot_name.sh new;bash $PWD/robot_name.sh display_all"

  [[ "$status" -eq "0" ]]
  [[ "${lines[1]}" = "ROBOT: ${lines[0]}, CREATED: $CURRENT_TIME, UPDATED: $CURRENT_TIME" ]]
}
