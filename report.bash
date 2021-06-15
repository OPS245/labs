#!/bin/bash

# report.bash
#
# Author: Murray Saul <murray.saul@senecacollege.ca)
# Date: January 16, 2015
# Modified by: Chris Johnson <chris.johnson@senecacollege.ca), June 1, 2021
#
# Purpose: To present sysadmin to create an software inventory
#          report containing selected elements

# Check to see if logged in as root to be able to create file
# in /root/ directory...

if [ $USER != "root" ]
then
   echo "You must be logged in as root to run the command."
   echo "Either login as root or issue command \"sudo ./report.bash\""
   exit 1
fi


# Create report title

echo "SOFTWARE ASSET REPORT FOR INSTALLED LINUX SYSTEM"  
echo "Date: $(date +'%A %B %d, %Y (%H:%M:%p)')" 
echo  

# Using zenity (dialog box constructor)
# Prompts user for elements to be included in the report...
# Activated check box returns values (multiple values | symbol )...

items=$(zenity --height 320 --width 290 --text "<b>Please select elements\nthat you want to display in report:</b>\n" --list --checklist --column "Session Type" --column "Description" TRUE "Kernel" TRUE "Processes" TRUE "Hostname" FALSE "Network" FALSE "Routing")
 

# Replace pipe "|" with space, and store as positional parameters
set $(echo $items | sed "s/|/ /g") > /dev/null 2> /dev/null

for x          # Run loop for each positional parameter to launch application
do

   if [ "$x" = "Kernel" ]    # Add Kernel Version to report
   then
      echo "Kernel Version: $(uname -rv)"  
      echo  
   fi

   if [ "$x" = "Processes" ]    # Add Kernel Version to report
   then
      echo "Process Information:"  
      echo  
      ps -ef  
      echo  
   fi

   if [ "$x" = "Hostname" ]    # Add Kernel Version to report
   then
      echo "Hostname: $(hostname)"  
      echo  
   fi

   if [ "$x" = "Network" ]    # Add Kernel Version to report
   then
      echo "Network Interface Information:"  
      echo  
      ifconfig  
      echo  
   fi

   if [ "$x" = "Routing" ]    # Add Kernel Version to report
   then
      echo "Routing information:"  
      echo  
      route -n  
      echo  
   fi

done

echo
zenity --info --text "To save a copy of this report, use: <b>sudo ./report.bash > report.txt</b>.\n\nHave a Nice Day..."

# End of Bash Shell Script
