#!/bin/bash

set -e

echo "Building signed and notarized OpenInFinder PKG installer..."

# Check for required environment variables
if [ -z "$DEVELOPER_ID_INSTALLER" ]; then
    echo "Error: DEVELOPER_ID_INSTALLER environment variable not set"
    echo "Set it to your Developer ID Installer certificate name:"
    echo "export DEVELOPER_ID_INSTALLER=\"Developer ID Installer: Your Name (TEAMID)\""
    exit 1
fi

if [ -z "$DEVELOPER_ID_APPLICATION" ]; then
    echo "Error: DEVELOPER_ID_APPLICATION environment variable not set"
    echo "Set it to your Developer ID Application certificate name:"
    echo "export DEVELOPER_ID_APPLICATION=\"Developer ID Application: Your Name (TEAMID)\""
    exit 1
fi

if [ -z "$APPLE_ID" ] || [ -z "$APPLE_ID_PASSWORD" ] || [ -z "$TEAM_ID" ]; then
    echo "Error: Apple ID credentials not set"
    echo "Required environment variables:"
    echo "export APPLE_ID=\"your-apple-id@example.com\""
    echo "export APPLE_ID_PASSWORD=\"app-specific-password\""
    echo "export TEAM_ID=\"YOUR_TEAM_ID\""
    exit 1
fi

# Clean up previous builds
rm -rf installer/payload/Applications/OpenInFinder.app
rm -f OpenInFinder.pkg OpenInFinder-signed.pkg

# Build the app first
echo "Building app..."
./build.sh

# Sign the app
echo "Signing app..."
codesign --force --options runtime --deep --sign "$DEVELOPER_ID_APPLICATION" OpenInFinder.app

# Verify app signature
echo "Verifying app signature..."
codesign --verify --verbose OpenInFinder.app

# Copy signed app to installer payload
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
    --sign "$DEVELOPER_ID_INSTALLER" \
    OpenInFinder-signed.pkg

if [ $? -ne 0 ]; then
    echo "✗ Failed to create signed PKG installer"
    exit 1
fi

echo "✓ Signed PKG installer created: OpenInFinder-signed.pkg"

# Notarize the PKG
echo "Submitting for notarization..."
xcrun notarytool submit OpenInFinder-signed.pkg \
    --apple-id "$APPLE_ID" \
    --password "$APPLE_ID_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

if [ $? -ne 0 ]; then
    echo "✗ Notarization failed"
    exit 1
fi

# Staple the notarization
echo "Stapling notarization..."
xcrun stapler staple OpenInFinder-signed.pkg

if [ $? -eq 0 ]; then
    echo "✓ Signed and notarized PKG installer created successfully: OpenInFinder-signed.pkg"
    echo ""
    echo "The installer is now ready for distribution!"
    echo ""
    echo "To install:"
    echo "  sudo installer -pkg OpenInFinder-signed.pkg -target /"
    echo ""
    echo "Or double-click OpenInFinder-signed.pkg to install via GUI"
else
    echo "✗ Failed to staple notarization"
    exit 1
fi