#!/bin/sh

######################
###Current User/Date##
######################

user=$(whoami) 
date=$(date +%Y-%m-%d)
hour=$(date +%H:%M)

######################
#Current Power Source#
######################

power_source=$(pmset -g batt | grep 'Now drawing from' | cut -d " " -f4 | cut -c 2-)

######################
###Disk Usage in GB###
######################

disk_remain=$(df -kh | head -2 | tr -s " " | cut -d " " -f4 | tail -1 | sed 's/[^0-9]*//g')

######################
#System Battery Cycle#
######################

battery_cycle=$(system_profiler SPPowerDataType | grep "Cycle Count" | tr -s " " | sed 's/[^0-9]*//g')

######################
###System CPU Usage###
######################

cpu_user=$(top -l 1 | grep -i "CPU Usage"| cut -d ' ' -f3|cut -d '%' -f1)
cpu_system=$(top -l 1 | grep -i "CPU Usage"| cut -d ' ' -f5|cut -d '%' -f1)
cpu_total=$(echo "$cpu_user" + "$cpu_system" | bc)
 
###################################
##Free Memory/Load Average Amount##
###################################

free_mem=$(top -l 1 | grep PhysMem | cut -d ',' -f2 | cut -d ' ' -f2)
load_avg=$(top -l 1 | grep Load\ Avg | cut -d ',' -f3 | cut -d " " -f2)

##############################
#Avg Disk Write Speed(in MBs)#
##############################

disk_avg_write=$(dd if=/dev/zero of=/tmp/output bs=8k count=10k 2>&1)
disk_avg_write_mb=$(echo $disk_avg_write | cut -d '(' -f2 | sed 's/[^0-9]*//g' | rev | cut -c 7- | rev) 

rm -f /tmp/output

echo "All data from $user received successfully" 

##############
#Logging Path#
##############

if [ -d "/Users/$user/PM_Logs" ]; 
	then
		echo "PM_Logs file exist"
	else
		echo "PM_Logs file doesn't exist, will be created"
		mkdir /Users/$user/PM_Logs 
fi

log_file="/Users/$user/PM_Logs/pm_$user.log"

##############
#Logging File#
##############

echo "File logging has started"
echo $date,$hour,$user,$power_source,$disk_remain,$battery_cycle,$cpu_user,$cpu_system,$cpu_total,$free_mem,$load_avg,$disk_avg_write_mb >> $log_file
echo "All process is done" 

##############



