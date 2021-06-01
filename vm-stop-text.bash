#!/bin/bash

# vm-stop-text.bash
#
# Author: Murray Saul
# Date: January 26, 2015
#
# Purpose: To allow a Linux sysadmin to identify status of
#          VMs on system and stop running VMs (text-based, not graphical)...

# Check to see if logged in as root to be able to create file
# in /root/ directory...

if [ $USER != "root" ]
then
   echo "You must be logged in as root to run the command."
   echo "Either login as root or issue command \"sudo ./report1.bash\""
   exit 1
fi

# Create modified virsh list of active VMs with number to stop by number

virsh list > vm-status.txt
awk 'BEGIN {count=1}{if (NR > 2 && /^..*$/) {print count++,$0}}' vm-status.txt > vm-status2.txt
# ./script.bash | awk '{if (NR > 2 && /^..*$/) {print}}'

cat <<+
Virtual Machine Status:

Here is a list of running Virtual Machines.
Enter a number or numbers (separated by a dash) to shutdown the VM(s):

$(cat vm-status2.txt)

+
read -p "Please enter VM number(s) to launch: " selection

until echo $selection | egrep -qs "^[1-9 ]{1,}$" 
do
   read -p "You need to enter either number(s) or spaces: " selection >&2
done


set $(echo $selection) > /dev/null 2> /dev/null

for x          # Run loop for each positional parameter to launch application
do
 
#  virsh start $(echo $x | awk -F"-" '{print $1}')

   vmName=$(grep $x vm-status2.txt| awk '{print $3}')
   virsh shutdown $vmName

done

echo
echo "Selected VM(s) have been shutdown"
echo


rm vm-status*.txt  2> /dev/null

# End of Bash Shell Script

