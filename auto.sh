#!/bin/bash

# Usage: ./rename_app.sh NewName OriginalAppName
# $1 = the new name (e.g., New_App_Name)
# $2 = the original app's name (e.g., DuckDuckGo, without .app extension)

# rename the .app bundle
mv "$2.app" "$1.app"

# rename the runnable inside Contents/MacOS
mv "$1.app/Contents/MacOS/$2" "$1.app/Contents/MacOS/$1"

# set the new "CFBundleName" and "CFBundleExecutable" values in "Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName $1" "$1.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleExecutable $1" "$1.app/Contents/Info.plist"

# re-sign the application
codesign --force --sign - "$1.app"

# Remove the quarentine attribute <3
xattr -d com.apple.quarantine "$1.app"
