#!/bin/sh

set -e

function setNightMode() {
  local isDarkMode=$1
  local darkModeValue=$([[ "$isDarkMode" = true ]] && echo 2 || echo 1)
  echo "darkModeValue: $darkModeValue"
  emulator @Nexus_6P_API_28 &
  adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'
  adb shell settings put secure ui_night_mode $darkModeValue
  adb reboot
  adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'
  adb emu kill
}

# Enable Dark mode
setNightMode true

screenshots
find android/fastlane/metadata/android -type f -name "Nexus 6P*.png" -print0 | xargs -0 -n1 bash -c 'mv -f "$0" "${0/Nexus 6P/N6P_Dark}"'

# Disable Dark mode
setNightMode false

screenshots
find android/fastlane/metadata/android -type f -name "Nexus 6P*.png" -print0 | xargs -0 -n1 bash -c 'mv -f "$0" "${0/Nexus 6P/N6P_Light}"'

declare -a arr=("en-AU" "en-CA" "en-GB" "en-IN" "en-SG" "en-ZA")

for i in "${arr[@]}"
do
   rsync -r 'android/fastlane/metadata/android/en-US/images/' "android/fastlane/metadata/android/$i/images"
done
