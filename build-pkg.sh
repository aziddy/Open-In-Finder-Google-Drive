#!/bin/bash

set -e

echo "Building OpenInFinder PKG installer..."

# Clean up previous builds
rm -rf installer/payload/Applications/OpenInFinder.app
rm -f OpenInFinder.pkg

# Build the app first
echo "Building app..."
./build.sh

# Copy app to installer payload
echo "Preparing installer payload..."
cp -r OpenInFinder.app installer/payload/Applications/

# Build the PKG
echo "Creating PKG installer..."
pkgbuild \
    --root installer/payload \
    --scripts installer/scripts \
    --identifier com.alexzidros.openinfinder \
    --version 1.0 \
    --install-location / \
    OpenInFinder.pkg

if [ $? -eq 0 ]; then
    echo "✓ PKG installer created successfully: OpenInFinder.pkg"
    echo ""
    echo "To install:"
    echo "  sudo installer -pkg OpenInFinder.pkg -target /"
    echo ""
    echo "Or double-click OpenInFinder.pkg to install via GUI"
else
    echo "✗ Failed to create PKG installer"
    exit 1
fi