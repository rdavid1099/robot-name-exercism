# Robot Name

Create a script that generates names for robots.

When robots come off the factory floor, they have no name.

The first time you boot them up, this script generates a random name is
in the format of two uppercase letters followed by three digits, such as RX837
or BC811.

The names are saved by the script along with the number of times the robot has
been reset. If a robot's name is passed in as an argument, the script prints
out the given robot's data. If the name passed to the script is not found, the
script prints out an error message.

Every once in a while we need to reset a robot to its factory settings,
which means that their name gets wiped. The next time you pass in the robot's
new name to the script it pulls up the robot's data which will now have at least
one number of resets.

The names must be random: they should not follow a predictable sequence.
Random names means a risk of collisions. Your solution must ensure that
every existing robot has a unique name.

Be sure to check the saved log of robot names to ensure the name generated is in
fact unique.

## Source

Modified from [Ruby Exercism](http://exercism.io/exercises/ruby/robot-name/readme)
which was created following a debugging session with Paul Blackwell at gSchool.

## Submitting Incomplete Solutions

It's possible to submit an incomplete solution so you can see how others have
completed the exercise.
