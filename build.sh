#!/bin/bash

# Create app bundle directory structure
mkdir -p "OpenInFinder.app/Contents/MacOS"
mkdir -p "OpenInFinder.app/Contents/Resources"

# Try to compile Objective-C version, fall back to shell script
if clang -framework Foundation -framework AppKit -o "OpenInFinder.app/Contents/MacOS/OpenInFinder" main.m 2>/dev/null; then
    echo "✓ Built Objective-C version"
else
    echo "! Objective-C compilation failed, using shell script version"
    # Copy shell script as the executable
    cp open-in-finder.sh "OpenInFinder.app/Contents/MacOS/OpenInFinder"
fi

# Copy Info.plist
cp Info.plist "OpenInFinder.app/Contents/Info.plist"

# Copy app icon
cp AppIcon.icns "OpenInFinder.app/Contents/Resources/AppIcon.icns"

# Make executable
chmod +x "OpenInFinder.app/Contents/MacOS/OpenInFinder"

echo "Build complete! You can now install OpenInFinder.app to /Applications"
echo "After installation, you can right-click any file -> Open With -> OpenInFinder"