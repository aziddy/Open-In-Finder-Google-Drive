# Testing Right-Click Menu

## Steps to test:

1. Right-click on `test.txt` file
2. Look for "Open With" submenu
3. Check if "OpenInFinder" or "Open in Finder" appears in the list
4. If it appears, click on it
5. Check `/tmp/openinfinder.log` to see if the app was called

## If the app doesn't appear in the menu:

The issue might be that the app needs to be signed or that the file associations aren't properly registered.

## Try this manual test:

Open Terminal and run:
```bash
open -a OpenInFinder test.txt
```

This should trigger the app. Then check the log:
```bash
cat /tmp/openinfinder.log
```

## Alternative approach:

Try setting the app as the default handler for a specific file type:
1. Right-click on `test.txt`
2. Select "Get Info"
3. In the "Open with" section, choose "OpenInFinder"
4. Click "Change All..."