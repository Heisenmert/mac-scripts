#!/bin/bash

#List all users which had UID greater than 500
for username in $(dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }');do

#we are excluding _jssadmin and the local admin user "macadmin"
if [[ $(dsmemberutil checkmembership -U "${username}" -G admin) == "user is a member of the group" ]] && [ "${username}" != "local_admin_user_here" ]; then 

echo $username is an unwanted admin, its privileges will be downgrade

#downgrading the privileges of unwanted admin
sudo dseditgroup -o edit -d $username -t user admin 
echo $username is now a standard user

else 

echo Right privileges for $username user!

fi

done
