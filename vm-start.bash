#!/bin/bash

# ATTENTION: This script is still a demo creating a file with
#            imaginary settings for VMs!

# vm-start.bash
#
# Author: Murray Saul
# Date: January 17, 2015
#
# Purpose: To allow a Linux sysadmin to identify status of
#          VMs on system and start them...

# Check to see if logged in as root to be able to create file
# in /root/ directory...

if [ $USER != "root" ]
then
   echo "You must be logged in as root to run the command."
   echo "Either login as root or issue command \"sudo ./report1.bash\""
   exit 1
fi

# Create dummy virsh list file (virsh list --all) for testing purposes
# to incoporate the zenity command to list status of VMs and
# use checkbox to check or uncheck based on their status in order
# to launch VM that are only "shut-off"

virsh list --all > vm-status.txt
 
awk 'NR > 2 {print}' vm-status.txt | sed '/^$/ d' > vm-status2.txt

# Using zenity (dialog box constructor) 
# Prompts user for elements to be included in the report...
# Activated check box returns values (multiple values | symbol )...

items=$(zenity --height 320 --width 290 --text "<b>Current status of VMs:\n(VMs running are not selected to start):</b>\n" --list --checklist --column "Session Type" --column "Description" $(awk -F" " '{if ($3 == "running") {print "FALSE " $2 "-running"} else {print "TRUE " "\"" $2 "-shutdown\""}}' vm-status2.txt | sed 's/["]//g'))
  
# Replace pipe "|" with space, and store as positional parameters
set $(echo $items | sed "s/|/ /g") > /dev/null 2> /dev/null

for x          # Run loop for each positional parameter to launch application
do
 
  virsh start $(echo $x | awk -F"-" '{print $1}')

done

rm vm-status*.txt

# End of Bash Shell Script
