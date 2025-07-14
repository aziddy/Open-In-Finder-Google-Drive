#!/bin/bash

FILE_PATH="${1:-test.txt}"

echo "Checking registered handlers for: $FILE_PATH"
echo "============================================"

# Check what applications can handle this file
echo "Applications that can handle this file:"
/usr/bin/lsappinfo list -all | grep -i "openinfinder"

echo ""
echo "Launch Services database info:"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -dump | grep -i "openinfinder" | head -20

echo ""
echo "Default handler for .txt files:"
/usr/bin/duti -x txt

echo ""
echo "File type information:"
/usr/bin/file "$FILE_PATH"
/usr/bin/mdls "$FILE_PATH" | grep kMDItemContentType