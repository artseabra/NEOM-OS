#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title NEOM OS
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🟢
# @raycast.packageName NEOM OS

# Documentation:
# @raycast.description Launch NEOM OS in Warp Terminal
# @raycast.author Art Seabra
# @raycast.authorURL https://sn.ifth.is/art

# Open Warp and run the NEOM home script
open -a Warp
sleep 0.3  # Give Warp time to open

# Send command to Warp to run neom-home
osascript <<EOF
tell application "Warp"
    activate
end tell

tell application "System Events"
    keystroke "neom-home"
    keystroke return
end tell
EOF