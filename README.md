# Open in Finder - Google Drive
A simple macOS app that opens Finder and navigates to the folder containing any file you select. Perfect for use with Google Drive files where you want to see the file in its folder context.

## Installation

### Easy installation:
```bash
./install.sh
```
Both builds and installs App in your `/Applications` folder

### Manual installation:
1. Run the build script:
   ```bash
   ./build.sh
   ```

2. Copy the generated app to your Applications folder:
   ```bash
   cp -r OpenInFinder.app /Applications/
   ```

3. Register the app with the system:
   ```bash
   /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -f /Applications/OpenInFinder.app
   ```

The app is now installed and ready to use!

## Usage

### Method 1: Right-click context menu
1. Right-click any file in Finder
2. Select "Open With" → "OpenInFinder"
3. Finder will open and navigate to the folder containing that file

### Method 2: Default app for file type
1. Right-click a file
2. Select "Get Info"
3. In the "Open with" section, choose "OpenInFinder"
4. Click "Change All..." to make it the default for all files of that type

### Method 3: Google Drive integration
1. In Google Drive (web), right-click a file
2. Select "Open with" → "OpenInFinder" (if configured)
3. The file will be downloaded/synced and Finder will open to its location

## How it works

The app uses **AppleScript** to:
1. Receive the file path as a command-line argument
2. Tell Finder to reveal the file at that path
3. Activate Finder to bring it to the front

## Files

- `open-in-finder.sh` - The main shell script that handles the file revealing
- `Info.plist` - App configuration that makes it accept all file types
- `build.sh` - Build script to create the app bundle
- `OpenInFinder.app` - The final application bundle

## Requirements

- macOS 10.15 or later
- AppleScript support (built into macOS)

## Troubleshooting

If the app doesn't appear in "Open With" menus:
1. Make sure it's in the `/Applications` folder
2. Try running: `lsregister -f /Applications/OpenInFinder.app`
3. Restart Finder: `killall Finder`