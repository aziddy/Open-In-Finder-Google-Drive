#!/bin/bash
# Simple shell script to open a file in Finder

# Debug: Log all arguments and environment to a file
echo "$(date): OpenInFinder called with args: $@" >> /tmp/openinfinder.log
echo "$(date): PWD: $(pwd)" >> /tmp/openinfinder.log
echo "$(date): Environment:" >> /tmp/openinfinder.log
env >> /tmp/openinfinder.log
echo "---" >> /tmp/openinfinder.log

if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>" >> /tmp/openinfinder.log
    exit 1
fi

FILE_PATH="$1"
echo "$(date): Original file path: $FILE_PATH" >> /tmp/openinfinder.log

# Convert to absolute path if relative
if [[ "$FILE_PATH" != /* ]]; then
    FILE_PATH="$(pwd)/$FILE_PATH"
fi

echo "$(date): Absolute file path: $FILE_PATH" >> /tmp/openinfinder.log

# Check if file exists
if [ ! -e "$FILE_PATH" ]; then
    echo "$(date): Error: File does not exist: $FILE_PATH" >> /tmp/openinfinder.log
    exit 1
fi

echo "$(date): File exists, running open -R" >> /tmp/openinfinder.log

# Use the open command to reveal the file in Finder
open -R "$FILE_PATH"

echo "$(date): open -R completed" >> /tmp/openinfinder.log