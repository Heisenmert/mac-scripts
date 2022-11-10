#!/bin/bash

username=$3

DevToolsSecurity -enable
dscl . append /Groups/_developer GroupMembership $username

/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg -tgt /
/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg -tgt /
/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/XcodeExtensionSupport.pkg -tgt /
/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/XcodeSystemResources.pkg -tgt /
/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/CoreTypes.pkg -tgt /

/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept

exit 0