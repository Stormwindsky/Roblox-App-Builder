#!/bin/bash

echo "--------------------------------------"
echo "   RbxAppBuilder - Steam Deck Edition"
echo "--------------------------------------"

# 1. Ask for the App Name
echo "Enter the name of your App (e.g., RetroStudio):"
read APP_NAME
if [ -z "$APP_NAME" ]; then echo "Name cannot be empty."; exit; fi

# 2. Image Detection (icon.png)
SCRIPT_DIR=$(pwd)
ICON_PATH="$SCRIPT_DIR/icon.png"

if [ ! -f "$ICON_PATH" ]; then
    echo "WARNING: 'icon.png' not found in this folder."
    echo "Using default roblox icon instead."
    ICON_VALUE="roblox"
else
    echo "Success: Custom icon.png detected."
    ICON_VALUE="$ICON_PATH"
fi

# 3. Ask for Game ID or URL
echo "Enter the Roblox Game ID or URL:"
read INPUT_ID
if [ -z "$INPUT_ID" ]; then echo "Input cannot be empty."; exit; fi

# Extract digits (Game ID)
GAME_ID=$(echo "$INPUT_ID" | grep -oP '\d+' | head -n 1)

if [ -z "$GAME_ID" ]; then
    echo "Error: Could not find a valid Game ID."
    exit
fi

# 4. Create the .desktop file
FILENAME="${APP_NAME// /_}.desktop"

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
echo "--------------------------------------"
echo "DONE! '$FILENAME' has been created."
echo "You can now add it to Steam as a non-Steam game."
echo "--------------------------------------"
