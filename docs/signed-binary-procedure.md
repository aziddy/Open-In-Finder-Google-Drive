# Signed Binary Release Procedure

## One-Time Setup

### 1) Create Developer ID Certificates
1. Log into [Apple Developer Portal - Certificates](https://developer.apple.com/account/resources/certificates/list)
2. Click the **+** button to create a new certificate
3. Scroll to the bottom of the **Software** section and create these two certificates (one at a time):
   - **Developer ID Application** — signs the app binary for distribution outside the Mac App Store
   - **Developer ID Installer** — signs the PKG installer for distribution outside the Mac App Store
4. On the next screen, select **G2 Sub-CA** and upload a CSR file:
   - Open **Keychain Access** app on your Mac
   - Menu bar: **Keychain Access** > **Certificate Assistant** > **Request a Certificate from a Certificate Authority**
   - Fill in your **email address**, leave **CA Email Address** blank, select **Saved to disk**, click **Continue**
   - Save the `.certSigningRequest` file to your Desktop
5. Back in the browser, click **Choose File**, select your `.certSigningRequest` file, then click **Continue**
6. Click **Download** to save the `.cer` file, then double-click it to install in Keychain
7. Repeat steps 2–6 for the second certificate type
    - Will need to request new cert from cert authority again (can't use the same one)

### 2) Create App-Specific Password
1. Go to [Apple ID Account](https://appleid.apple.com/account/manage)
2. Under **Sign-In and Security** > **App-Specific Passwords**, generate a new password
3. Save it somewhere secure

### 3) Find Your Team ID
- Go to [Apple Developer - Membership Details](https://developer.apple.com/account#MembershipDetailsCard)
- Your **Team ID** is listed there

### 4) Set Certificate Environment Variables
Add to your `~/.zshrc`:
```bash
export DEVELOPER_ID_APPLICATION="Developer ID Application: Your Name (TEAMID)"
export DEVELOPER_ID_INSTALLER="Developer ID Installer: Your Name (TEAMID)"
```
Then run `source ~/.zshrc`.

### 5) Store Notarization Credentials in Keychain
This saves your Apple ID credentials securely in the macOS Keychain (only needs to be done once):
```bash
xcrun notarytool store-credentials "OpenInFinder" \
    --apple-id "your-apple-id@example.com" \
    --team-id "YOUR_TEAM_ID" \
    --password "xxxx-xxxx-xxxx-xxxx"
```
Use the app-specific password from step 2.

### 6) Verify Certificates
```bash
security find-identity -v -p codesigning
```
You should see both your `Developer ID Application` and `Developer ID Installer` certificates listed.

---

## Signed Release Procedure

### 1) Update Version in Code
- Update `build-pkg-signed.sh` (line 57)
- Update `build-pkg.sh` (line 25)
```bash
--version 1.0.x \
```
- Update `Info.plist`
```xml
<key>CFBundleVersion</key>
<string>1.0.x</string>
<key>CFBundleShortVersionString</key>
<string>1.0.x</string>
```

### 2) Build and Test (Unsigned)
```bash
./build-pkg.sh
```
- Install the unsigned PKG
- Go to `/Applications/`, right-click **OpenInFinder** > **Get Info**
- Confirm the version number is correct

![Confirm Version](../media/app-get_info-confirm_version.png)

### 3) Build Signed & Notarized PKG
```bash
./build-pkg-signed.sh
```
This script will:
1. Build the app
2. Sign it with your Developer ID Application certificate
3. Create a signed PKG with your Developer ID Installer certificate
4. Submit to Apple for notarization (takes 1-5 minutes)
5. Staple the notarization ticket to the PKG

### 4) Verify the Signed PKG
```bash
# Check PKG signature
pkgutil --check-signature OpenInFinder-signed.pkg

# Check notarization
spctl --assess --verbose --type install OpenInFinder-signed.pkg
```
Both should report accepted/valid with your Developer ID.

### 5) GitHub Release
1. On the GitHub repo page, click **Releases** > **Draft a new release**
2. Create a new tag: `V1.0.x`
3. Release title: `OpenInFinder V1.0.x Signed - Universal Binary (x86/Arm64)`
4. Copy description from previous release
5. Drag and drop `OpenInFinder-signed.pkg` into the release assets
6. Publish the release

### 6) Update README.md Download Link
- Copy the link address for `OpenInFinder-signed.pkg` from the release
- Update `README.md`:
```html
<a href="https://github.com/aziddy/Open-In-Finder-Google-Drive/releases/download/V1.0.x/OpenInFinder-signed.pkg">
  <img src="media/download-icon.png" alt="Download Latest Version" style="width: 400px; height: auto; display: block; margin: 0 auto;" />
</a><br>
```

### 7) Commit and Push Changes
