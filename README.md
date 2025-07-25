
# Open in Finder - Google Drive
A simple macOS app that opens Finder and navigates to the folder containing any file you select. **Perfect for Google Drive integration** - when you want to quickly locate and view Google Drive files in their native folder context within Finder.

<table width="100%">
  <tr>
    <td width="25%" align="center" valign="middle">
      <img src="media/OpenInFinder-Logo-FullSize.png" alt="OpenInFinder Logo" style="max-width: 100%; height: auto; display: block; margin: 0 auto;" />
    </td>
    <td align="center" valign="middle">
      <img src="media/demo1.gif" alt="Demo: Open in Finder with Google Drive" style="max-width: 100%; height: auto; display: block; margin: 0 auto;" />
    </td>
  </tr>
</table>


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

1. In Google Drive (web), right-click a file
2. Select "Open with" → "OpenInFinder" (if configured)
3. The file will be downloaded/synced and Finder will open to its location

## How it works

The app uses **AppleScript** to:
1. Receive the file path as a command-line argument
2. Tell Finder to reveal the file at that path
3. Activate Finder to bring it to the front

## Files

- `install.sh` - Installs the app in your `/Applications` folder and registers it with the system
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