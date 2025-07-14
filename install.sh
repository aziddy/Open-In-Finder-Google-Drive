#!/bin/bash

echo "Installing OpenInFinder app..."

# Build the app
./build.sh

# Copy to Applications folder
if [ -d "/Applications" ]; then
    rm -rf "/Applications/OpenInFinder.app"
    cp -r "OpenInFinder.app" "/Applications/"
    echo "✓ App installed to /Applications/OpenInFinder.app"
    
    # Register the app with the system
    /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f "/Applications/OpenInFinder.app"
    echo "✓ App registered with Launch Services"
    
    echo ""
    echo "Installation complete!"
    echo "You can now:"
    echo "1. Right-click any file → Open With → OpenInFinder"
    echo "2. Use it from Google Drive's 'Open with' menu"
    echo ""
    echo "Note: You may need to restart Finder or log out/in for the app to appear in all menus."
else
    echo "Error: /Applications directory not found"
    exit 1
fi