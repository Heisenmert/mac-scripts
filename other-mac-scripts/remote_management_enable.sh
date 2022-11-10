#!/bin/bash

#Configuring Remote Management
ARD="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
$ARD -configure -activate
$ARD -configure -access -on
$ARD -configure -allowAccessFor -specifiedUsers
$ARD -configure -access -on -users local_admin_user_here -privs -all

exit 0 