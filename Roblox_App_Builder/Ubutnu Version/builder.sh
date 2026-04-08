#!/bin/bash

# 1. Ask for the App Name
APP_NAME=$(zenity --entry --title="RbxAppBuilder" --text="Enter the name of your App (e.g., RetroStudio):")
[ -z "$APP_NAME" ] && exit

# 2. Image Detection (icon.png)
# Checks if icon.png exists in the current folder
SCRIPT_DIR=$(pwd)
ICON_PATH="$SCRIPT_DIR/icon.png"

if [ ! -f "$ICON_PATH" ]; then
    zenity --warning --title="Missing Icon" --text="WARNING: 'icon.png' not found in the folder.\nPlease add a PNG image named icon.png to use a custom icon."
    ICON_VALUE="roblox" # Fallback to default
else
    ICON_VALUE="$ICON_PATH"
fi

# 3. Ask for Game ID or URL
INPUT_ID=$(zenity --entry --title="RbxAppBuilder" --text="Enter the Roblox Game ID or URL:")
[ -z "$INPUT_ID" ] && exit

# Extract only digits using regex (handles URLs and raw IDs)
GAME_ID=$(echo "$INPUT_ID" | grep -oP '\d+' | head -n 1)

if [ -z "$GAME_ID" ]; then
    zenity --error --title="Error" --text="Could not find a valid Game ID. Please try again."
    exit
fi

# 4. Create the .desktop file
FILENAME="${APP_NAME// /_}.desktop" # Replace spaces with underscores for the filename

cat <<EOF > "$FILENAME"
[Desktop Entry]
Type=Application
Name=$APP_NAME
Comment=Standalone Roblox App created with RbxAppBuilder
Exec=flatpak run org.vinegarhq.Sober "roblox://placeId=$GAME_ID"
Icon=$ICON_VALUE
Terminal=false
Categories=Game;
EOF

# 5. Finalize
chmod +x "$FILENAME"
zenity --info --title="Success" --text="App Creation Finished!\n\nYou can now move '$FILENAME' to your desktop or applications folder."
