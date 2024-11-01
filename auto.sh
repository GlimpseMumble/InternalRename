#!/bin/bash

# Usage: ./rename_app.sh NewName OriginalAppName
# $1 = the new name (e.g., EvanTest)
# $2 = the original app's name (e.g., DuckDuckGo, without .app extension)

# Rename the .app bundle
mv "$2.app" "$1.app"

# Rename the executable inside Contents/MacOS
mv "$1.app/Contents/MacOS/$2" "$1.app/Contents/MacOS/$1"

# Set the new CFBundleName and CFBundleExecutable values in Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleName $1" "$1.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $1" "$1.app/Contents/Info.plist"

# Re-sign the application to ensure it's recognized as a valid app
codesign --force --sign - "$1.app"

# Remove the quarentine attribute
xattr -d com.apple.quarantine "$1.app"