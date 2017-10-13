#!/bin/bash
error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  local lc="$BASH_COMMAND"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; Command "[$lc]" exiting with status ${code}"
  else
    echo " Error on or near line ${parent_lineno}; Command -> "[$lc]" exiting with status ${code}"
  fi
}

trap 'error ${LINENO}' ERR 

ls -arlt


ls -3543


ls -arlt
