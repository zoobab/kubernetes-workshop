#!/bin/sh

# some random crap here 2

while true; do
  sleep 1
  if [ -z "$FOO" ]; then
	echo "FOO is empty"
  else
	echo "FOO is $FOO"
  fi
done
