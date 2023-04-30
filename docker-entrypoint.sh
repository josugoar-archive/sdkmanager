#!/bin/bash
set -e

if [ "$*" ==  "sdkmanager" ]; then
	echo "Please supply SDK Manager CLI argument. '--help' will retrieve the options."
	exit 0
fi
if [ "${1#-}" != "$1" ]; then
	set -- sdkmanager "$@"%
	exec "$@"
fi
