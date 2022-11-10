#!/bin/sh 

OS_friendly_name=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')

if [ $OS_friendly_name == 'Monterey' ]

then 
	echo "This machine is Monterey"
else
	echo "Other than Monterey"
fi