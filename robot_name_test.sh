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
  ROBOT_ONE=$(bash $PWD/robot_name.sh new)
  ROBOT_TWO=$(bash $PWD/robot_name.sh new)

  [[ "$status" -eq "0" ]]
  [[ "$ROBOT_ONE" != "$ROBOT_TWO" ]]
}

@test "new robot data is saved to .meta.robot_name" {
  run bash robot_name.sh new

  [[ "$status" -eq "0" ]]
  [[ -e ".meta.robot_name" ]]
}

@test "one robot's information is displayed" {
  ROBOT=$(bash $PWD/robot_name.sh new)
  run bash robot_name.sh display_all

  [[ "$status" -eq "0" ]]
  [[ "$output" = "ROBOT: $ROBOT, TIMES RESTARTED: 0" ]]
}

@test "all robot information is displayed" {
  ROBOT_ONE=$(bash $PWD/robot_name.sh new)
  ROBOT_TWO=$(bash $PWD/robot_name.sh new)
  run bash robot_name.sh display_all

  [[ "$status" -eq "0" ]]
  [[ "${lines[0]}" = "ROBOT: $ROBOT_ONE, TIMES RESTARTED: 0" ]]
  [[ "${lines[1]}" = "ROBOT: $ROBOT_TWO, TIMES RESTARTED: 0" ]]
}

@test "a specific robot's information is displayed" {
  ROBOT_ONE=$(bash $PWD/robot_name.sh new)
  ROBOT_TWO=$(bash $PWD/robot_name.sh new)
  ROBOT_THREE=$(bash $PWD/robot_name.sh new)
  ROBOT_FOUR=$(bash $PWD/robot_name.sh new)
  ROBOT_FIVE=$(bash $PWD/robot_name.sh new)
  run bash robot_name.sh display $ROBOT_THREE

  [[ "$status" -eq "0" ]]
  [[ "$output" = "ROBOT: $ROBOT_THREE, TIMES RESTARTED: 0" ]]
}

@test "error is printed if unknown name is passed to script" {
  ROBOT_ONE=$(bash $PWD/robot_name.sh new)
  run bash robot_name.sh display C3PO

  [[ "$status" -eq "0" ]]
  [[ "$output" = "ERROR: Invalid name given. Could not find data on C3PO." ]]
}

@test "robot is reset and generates a new name with updated data" {
  ROBOT=$(bash $PWD/robot_name.sh new)
  NEW_NAME=$(bash $PWD/robot_name.sh restart $ROBOT)
  run bash robot_name.sh display $NEW_NAME

  [[ "$status" -eq "0" ]]
  [[ "$output" = "ROBOT: $NEW_NAME, TIMES RESTARTED: 1" ]]
}
