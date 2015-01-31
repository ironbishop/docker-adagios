#!/usr/bin/env bash

if [[ "$1" = "status" ]]
then
    # We need to return 1 if nagios is not running
    status=$(supervisorctl status nagios)
    echo $status
    grep RUNNING > /dev/null <<< "$status"
else
    supervisorctl "$1" nagios
fi
