# RbxAppBuilder - Windows Version (CC0 1.0)
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

# 1. Ask for the App Name
$AppName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the name of your App (e.g., RetroStudio):", "RbxAppBuilder", "My Roblox App")
if ([string]::IsNullOrWhiteSpace($AppName)) { exit }

# 2. Image Detection (icon.ico)
# Note: Windows shortcuts (.url) use .ico files for icons, not .png
$ScriptDir = $PSScriptRoot
$IconPath = Join-Path $ScriptDir "icon.ico"
$HasIcon = Test-Path $IconPath

if (-not $HasIcon) {
    [System.Windows.Forms.MessageBox]::Show("WARNING: 'icon.ico' not found in the folder.`nPlease add an ICO file named icon.ico to use a custom icon.", "Missing Icon", "OK", "Warning")
}

# 3. Ask for Game ID or URL
$InputID = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the Roblox Game ID or URL:", "RbxAppBuilder", "")
if ([string]::IsNullOrWhiteSpace($InputID)) { exit }

# Extract digits (Game ID) using Regex
$GameID = [regex]::match($InputID, '\d+').Value

if (-not $GameID) {
    [System.Windows.Forms.MessageBox]::Show("Could not find a valid Game ID. Please try again.", "Error", "OK", "Error")
    exit
}

# 4. Create the Windows Shortcut (.url format for Roblox protocol)
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $ScriptDir "$AppName.url"

# Build the .url file content
$Content = @"
[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,0
[InternetShortcut]
IDList=
URL=roblox://placeId=$GameID
"@

if ($HasIcon) {
    $Content += "`nIconFile=$IconPath`nIconIndex=0"
}

$Content | Out-File -FilePath $ShortcutPath -Encoding ASCII

# 5. Finalize
[System.Windows.Forms.MessageBox]::Show("App Creation Finished!`n`nYou can now find '$AppName.url' in your folder.", "Success", "OK", "Information")
