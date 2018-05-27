#!/bin/bash

function wait_bar () {
  for i in {1..10}
  do
    printf '=%.0s' {1..$i}
    sleep $1s
  done
}