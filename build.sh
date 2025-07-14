#!/bin/bash

# Create app bundle directory structure
mkdir -p "OpenInFinder.app/Contents/MacOS"
mkdir -p "OpenInFinder.app/Contents/Resources"

# Try to compile native versions first, fall back to shell script
# Try Objective-C first (more reliable)
if clang -framework Foundation -framework AppKit -o "OpenInFinder.app/Contents/MacOS/OpenInFinder" main.m 2>/dev/null; then
    echo "✓ Built Objective-C version"
else
    echo "! Objective-C compilation failed, trying Swift"
    # Try Swift compilation
    if [ -d "/Applications/Xcode.app" ]; then
        XCODE_PATH="/Applications/Xcode.app/Contents/Developer"
        if /usr/bin/xcode-select -s "$XCODE_PATH" 2>/dev/null && xcrun swiftc -target arm64-apple-macos12.0 -o "OpenInFinder.app/Contents/MacOS/OpenInFinder" main.swift 2>/dev/null; then
            echo "✓ Built Swift version using Xcode"
        else
            echo "! Swift compilation with Xcode failed, trying command line tools"
            # Reset to command line tools
            /usr/bin/xcode-select -s /Library/Developer/CommandLineTools 2>/dev/null || true
            if xcrun swiftc -target arm64-apple-macos12.0 -o "OpenInFinder.app/Contents/MacOS/OpenInFinder" main.swift 2>/dev/null; then
                echo "✓ Built Swift version using command line tools"
            else
                echo "! Swift compilation failed, using shell script version"
                # Copy shell script as the executable
                cp open-in-finder.sh "OpenInFinder.app/Contents/MacOS/OpenInFinder"
            fi
        fi
    else
        # No Xcode, try with command line tools
        if xcrun swiftc -target arm64-apple-macos12.0 -o "OpenInFinder.app/Contents/MacOS/OpenInFinder" main.swift 2>/dev/null; then
            echo "✓ Built Swift version using command line tools"
        else
            echo "! Swift compilation failed, using shell script version"
            # Copy shell script as the executable
            cp open-in-finder.sh "OpenInFinder.app/Contents/MacOS/OpenInFinder"
        fi
    fi
fi

# Copy Info.plist
cp Info.plist "OpenInFinder.app/Contents/Info.plist"

# Copy app icon
cp AppIcon.icns "OpenInFinder.app/Contents/Resources/AppIcon.icns"

# Make executable
chmod +x "OpenInFinder.app/Contents/MacOS/OpenInFinder"

echo "Build complete! You can now install OpenInFinder.app to /Applications"
echo "After installation, you can right-click any file -> Open With -> OpenInFinder"