#!/bin/sh

ChromeVersion=$(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version | awk '{print $3}')

echo "Chrome version is $ChromeVersion"

if [ -d "/Applications/Google Chrome.app/Contents/Frameworks/Google Chrome Framework.framework/Versions/$ChromeVersion/Frameworks/KeystoneRegistration.framework" ]; 
	then
		echo "Problematic path exist"
	else
		echo "There is no such path!, quitting"
		exit 0
fi


sudo rm -rf /Applications/Google\ Chrome.app/Contents/Frameworks/Google\ Chrome\ Framework.framework/Versions/"$ChromeVersion"/Frameworks/KeystoneRegistration.framework

if [ $? -eq 0 ]

	then
		echo "Auto-update for Google Chrome has disabled"
		exit 0
	else
		echo "There was a problem with disabling the Chrome Update"
		exit 1
fi






