#!/bin/sh
#########################################
#Logging Func. for Reporting Actions
LogLocation="/Users/$1/Captive_Portal/CaptivePortal.log"
ScriptLogging(){

DATE=`date +%Y-%m-%d\ %H:%M:%S`
LOG="$LogLocation"

echo "$DATE" " $1" >> $LOG
}
#Force Proxy Script
nohup sh /Users/$USER/Captive_Portal/forceproxy.sh & > /dev/null 2>&1
#Removing Proxy
ScriptLogging "======== Starting Captive Portal Script ========"
ScriptLogging "Removing Proxy"
echo "\033[1;103m You have 1 minutes to perform this act \033[0m"
returnValue="" 

networksetup -setwebproxy "Wi-Fi" "" ""
sleep 1s
networksetup -setsecurewebproxy "Wi-Fi" "" ""
sleep 1s
#########################################
#Function that Pings google.com

ping_address () {
ping -c 4 google.com > /dev/null 2>&1

if [ $? -eq 0 ]

	then
		echo "\033[1;32m You're currently connected to the internet, setting up proxy \033[0m"
		ScriptLogging "You're currently connected to the internet, setting up proxy"
		networksetup -setwebproxy "Wi-Fi" "your proxy address here" 80
		sleep 1s
		networksetup -setsecurewebproxy "Wi-Fi" "your proxy address here" 80
		sleep 1s
		returnValue="1"
		#echo "Return value is $returnValue"
		ScriptLogging "Return value is $returnValue"
else
		echo "\033[1;31m You're NOT connected to the Internet, looking for network... \033[0m"
		returnValue="0"
		#echo "Return value is $returnValue"
		ScriptLogging "Return value is $returnValue"
fi
}
#########################################
#Internet Connection Control Loop (12 times approx. 60 secs)

for ((i=0; i<=12; i++))do
	ping_vpn
		if [ "$returnValue" == "0" ]; then
			sleep 5s 
			ScriptLogging "Still looking for network..."	 
	else
			#echo "Breaking the Loop"
			break
		fi 	
done
#########################################
#Re-Setting Proxy for due to timeout or connection
echo "\033[1;103m Re-Setting Proxy \033[0m"
ScriptLogging "Re-Setting Proxy"

	networksetup -setwebproxy "Wi-Fi" "your proxy address here" 80
	sleep 1s
	networksetup -setsecurewebproxy "Wi-Fi" "your proxy address here" 80
	sleep 1s

ScriptLogging "======== Ending the Script  ========"
exit 0
#########################################
