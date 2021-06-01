#!/bin/bash

# ./packageInfo.bash
#
# Purpose: To generate a report for an application
#          using sed command and redirection to a
#          text file.
#
# Author: Murray Saul
# Date:   April, 2015


if [ $PWD != "/root/bin" ] # only runs if in appropriate
 then
   echo "You must be in \"/root/bin\" directory to run command." >&2 
   exit 1 
fi

if [ $# -ne 1 ]
 then
   echo "Your command must have a application-name as argument" >&2
   echo "USAGE: $0 [application-name]" >&2
   exit 1
fi



processedChoice=$(zenity --height 320 --width 290 --text "<b>Select elements that you want\nto display in report:</b>\n" --list --checklist --column "Session Type" --column "Name" TRUE "Summary" TRUE "Version" TRUE "License" FALSE "Source" TRUE "URL")



rpm -qi $1 | sed -r -n "/($processedChoice)/ p" | zenity --height 400 --width 400 --text-info --title "Software Information Report"





