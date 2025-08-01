# Building Signed and Notarized PKG Installer

This guide explains how to create a signed and notarized PKG installer for distribution.

## Prerequisites

1. **Apple Developer Program membership** ($99/year)
2. **Developer ID certificates** installed in Keychain
3. **App-specific password** for your Apple ID

## Setup

### 1. Install Developer ID Certificates

1. Log into [Apple Developer Portal](https://developer.apple.com/account/resources/certificates/list)
2. Create/download these certificates:
   - **Developer ID Application** (for signing the app)
   - **Developer ID Installer** (for signing the PKG)
3. Double-click to install them in your Keychain

### 2. Create App-Specific Password

1. Go to [Apple ID account page](https://appleid.apple.com/account/manage)
2. Sign in with your Apple ID
3. In **Security** section, generate an app-specific password
4. Save this password securely

### 3. Set Environment Variables

```bash
# Your certificate names (check Keychain Access for exact names)
export DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAMID)"
export DEVELOPER_ID_INSTALLER="Developer ID Installer: Your Name (TEAMID)"

# Your Apple ID credentials
export APPLE_ID="your-apple-id@example.com"
export APPLE_ID_PASSWORD="app-specific-password"
export TEAM_ID="YOUR_TEAM_ID"
```

**To find your Team ID:**
- Check Apple Developer Portal ’ Membership
- Or run: `xcrun altool --list-providers -u "$APPLE_ID" -p "$APPLE_ID_PASSWORD"`

## Building

Run the signed build script:

```bash
./build-pkg-signed.sh
```

## What Happens

1. **App Signing**: Signs `OpenInFinder.app` with Developer ID Application certificate
2. **PKG Creation**: Creates signed PKG with Developer ID Installer certificate  
3. **Notarization**: Submits to Apple for security scanning (takes 1-5 minutes)
4. **Stapling**: Attaches notarization ticket to the PKG

## Output

- **OpenInFinder-signed.pkg** - Ready for public distribution
- No Gatekeeper warnings when users install
- Can be distributed via web download, email, etc.

## Troubleshooting

### Certificate Issues
```bash
# List available certificates
security find-identity -v -p codesigning

# Check certificate names in Keychain Access app
```

### Notarization Failures
```bash
# Check notarization history
xcrun notarytool history --apple-id "$APPLE_ID" --password "$APPLE_ID_PASSWORD" --team-id "$TEAM_ID"

# Get detailed logs for a submission
xcrun notarytool log <submission-id> --apple-id "$APPLE_ID" --password "$APPLE_ID_PASSWORD" --team-id "$TEAM_ID"
```

### Environment Variables
Add to your `~/.zshrc` or `~/.bash_profile`:
```bash
# Apple Developer credentials
export DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAMID)"
export DEVELOPER_ID_INSTALLER="Developer ID Installer: Your Name (TEAMID)"
export APPLE_ID="your-apple-id@example.com"
export APPLE_ID_PASSWORD="xxxx-xxxx-xxxx-xxxx"
export TEAM_ID="TEAMID123"
```