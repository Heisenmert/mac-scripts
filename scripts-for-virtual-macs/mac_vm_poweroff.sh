#!/bin/sh

###################################
#Virtual Mac Poweroff Script      #
#This script shuts down idle Macs #
#Made by Heisenmert		   - 2022 #
#All rights reserved ®            #
#Just kiddin' have fun!			  #
###################################
#CREATION OF INITIAL PARAMETERS#
#################################

#Finds the Local User (Standard)#
#################################
#We are excluding the local admins, also we are accepting that there are only 2 users
#(macadmin + local user) on the VM. 
local_user=$(dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }' | grep -vwE "(local_admin_user_name_here|Shared)")

#Log Location
LogLocation="/Users/$local_user/vm_poweroff.log"

#Logging Function#
##################
ScriptLogging(){

DATE=`date +%Y-%m-%d\ %H:%M:%S`
LOG="$LogLocation"

echo "$DATE" " $1" >> $LOG
}

#Take Last 1000 Lines of Log File#
##################################
echo "$(tail -1000 $LogLocation)" > $LogLocation


#Create an Array for Month Acronyms#
##################################
#Such as Jan=1, Feb=2 etc.

monthnumber(){
    month=$1
    months="JanFebMarAprMayJunJulAugSepOctNovDec"
    tmp=${months%%$month*}
    month=${#tmp}
    monthnumber=$((month/3+1))
    printf "%02d\n" $monthnumber
}

####################################
#The main scripts starts from here #
####################################

ScriptLogging "======== Starting VM Poweroff Check Script ========"
ScriptLogging "$local_user is the local user of this VM."

#Check the Uptime#
##################
#There is a Jamf policy that restarts the VM every week. But sometimes Jamf binary fails 
#which can affect the restart process. In this case we will check if the VM is up more then 
#7 days (604800 seconds). If so this script reboots the VM and exits.

kern_boottime=`sysctl kern.boottime 2> /dev/null | sed "s/.* sec\ =\ //" | sed "s/,.*//"`
time_now=`date +%s`
uptime_in_seconds=$(($time_now - $kern_boottime))
ScriptLogging "System is up for $uptime_in_seconds seconds."

if [ $uptime_in_seconds -gt "604800" ];
	
	then
		ScriptLogging "This VM is up for more than 7 days. Will be rebooted."
		sudo shutdown -r now

	else
		ScriptLogging "This VM is up for less than 7 days."
fi

#Check if Someone is Currently Logged in or Not#
################################################
#In our logic since the VMs are been rebooting each week, we are expecting fresh logins.
#If the last login is more than 30 days we are shutting down VM.


if [ -z "$(last -3 -h $local_user -t console | grep "still logged in")" ];
	then
		ScriptLogging "It seems no-one is logged in right now. Let's check the latest login on this VM."
	      
	      #This is a format like Oct 23 or Apr 22#
	      user_last_login_month_abr=$(last -1 -h $local_user -t console | awk '{ print $4 }')
	      month_as_integer=$(monthnumber $user_last_login_month_abr)

		  user_last_login_day=$(last -1 -h $local_user -t console | awk '{ print $5 }')

	      #Gives the current year
	      curr_year=$(date +'%Y')

	      #It gives us the day number of the year (like 294th day of 365)
	      day_number_of_year=$(date +%j)

	      #It gives us the day number of last login 
	      last_login_day_num_of_year=$(date -j -f "%Y-%m-%d" $curr_year-$month_as_integer-$user_last_login_day +%j)

	      ScriptLogging "Last Login Date (YY-MM-DD) is: $curr_year/$month_as_integer/$user_last_login_day"

	      if ((day_number_of_year - last_login_day_num_of_year > 30)); 

	  		then
	    		ScriptLogging "This VM is idle for $((day_number_of_year - last_login_day_num_of_year)) day(s). Will be shut down."
	    		sudo shutdown -h now

	  		else
	    		ScriptLogging "This VM is idle for $((day_number_of_year - last_login_day_num_of_year)) day(s). Not enough to shut it down."
	    		exit 0
	      fi

	else
		ScriptLogging "$local_user is logged in, so this VM is actively utilizing."
		exit 0      	
fi
######################################

