#!/bin/bash

echo "Testing OpenInFinder app..."
echo "=========================="

# Clear previous log
rm -f /tmp/openinfinder.log

# Test 1: Direct execution with file path
echo "Test 1: Direct execution with file path"
/Applications/OpenInFinder.app/Contents/MacOS/OpenInFinder "$(pwd)/test.txt"
echo "✓ Direct execution completed"

# Test 2: Using open -a command
echo ""
echo "Test 2: Using 'open -a' command"
open -a OpenInFinder test.txt
echo "✓ Open -a command completed"

# Test 3: Check log file
echo ""
echo "Test 3: Checking log file"
if [ -f /tmp/openinfinder.log ]; then
    echo "Log file contents:"
    cat /tmp/openinfinder.log
else
    echo "No log file found"
fi

echo ""
echo "=========================="
echo "Manual tests to try:"
echo "1. Right-click on 'test.txt' file"
echo "2. Look for 'Open With' submenu"
echo "3. Check if 'OpenInFinder' appears in the list"
echo "4. If it appears, click on it"
echo "5. Finder should open and highlight the file"
echo ""
echo "If the app doesn't appear in the context menu:"
echo "- Try logging out and back in"
echo "- Try restarting your Mac"
echo "- The app might need to be signed by Apple"