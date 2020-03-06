#!/bin/sh

set -e

# Enable Dark mode
adb shell settings put secure ui_night_mode 2
adb shell reboot

screenshots

# Disable Dark mode
adb shell settings put secure ui_night_mode 1
adb shell reboot

screenshots