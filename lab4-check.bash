#!/bin/bash

# ./lab4-check.bash

# Author:  Murray Saul
# Date:    June 7, 2016
# Edited by: Peter Callaghan
# Date: Sept 26, 2021
#
# Purpose: Check that students correctly managed user and group accounts
#          when performing this lab, check that students have properly
#          managed services, and created a shell script to work like
#          a Linux command to automate creation of multiple user
#          accounts (user data stored in a text-file).

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab4_output.txt

function check(){

  if eval $1
  then
     echo -e "\e[0;32mOK\e[m"
  else
     echo
     echo
     echo -e "\e[0;31mWARNING\e[m"
     echo
     echo
     echo $2
     echo
     exit 1
  fi

} # end of check() function

clear  # Clear the screen

# Make certain user is logged in as root
if [ $(whoami) != "root" ]
then
  echo "Note: You are required to run this program as root."
  exit 1
fi

cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - IPADDRESSES for only your centos1 VM.

 - Your regular username password for centos1 VM.
   You were instructed to have the IDENTICAL usernames
   and passwords for ALL of these Linux servers. If not
   login into each VM, switch to root, and use the commands:

   useradd -m [regular username]
   passwd [regular username]

   Before proceeding.

After reading the above steps, press ENTER to continue
+
read null
clear


# Start checking lab4
echo "OPS245 Lab 4 Check Script" > $logfile
echo | tee -a $logfile
echo "CHECKING YOUR LAB 4 WORK:" | tee -a $logfile
echo | tee -a $logfile

# Check ops245_2 user created (centos1)
echo "Checking that ops245_2 user created (centos1): " | tee -a $logfile
read -p "Enter your centos1 username: " centos1UserName
read -p "Enter IP Address for your centos1 VMs eth0 device: " centos1_IPADDR
check "ssh $centos1UserName@$centos1_IPADDR \"grep -isq \"ops245_2\" /etc/passwd\"" "This program did NOT detect the user \"ops245_2\" in the \"/etc/passwd\" file. Please create this user, complete this lab, and re-run this checking script." | tee -a $logfile

# Check ops245_1 user removed (centos1)
#echo -n "Checking that ops245_1 user removed: "
#check "! ssh $centos1UserName@$centos1_IPADDR grep -isq \"ops245_2\" /etc/passwd" "This program detected the user \"ops245_1\" in the \"/etc/passwd\" file, when that user should have been removed. Please remove this user, complete this lab, and re-run this checking script."

# Check foo created in /etc/skel directory (centos1)
echo "Checking that \"/etc/skel\" directory contains the file called \"foo\" (centos1):" | tee -a $logfile
check "ssh $centos1UserName@$centos1_IPADDR ls /etc/skel | grep -isq \"foo\"" "This program did NOT detect the file called \"foo\" in the \"/etc/skel\" directory. Please create this file, remove the user ops245_2, and then create that user to see the \"foo\" file automatically created in that user's home directory upon the creation of this user. Complete this lab, and re-run this checking script." | tee -a $logfile

# Check group name ops245 created with name "welcome" (centos1)
echo "Checking that a group name \"welcome\" is contained in the file \"/etc/group\": " | tee -a $logfile
check "ssh $centos1UserName@$centos1_IPADDR grep -isq \"welcome\" /etc/group" "This program did NOT detect the group name \"welcome\" in the \"/etc/group\" file. Please remove the group, and correctly add the group with the correct GID, complete the lab (with secondary users added), and re-run this checking script." | tee -a $logfile

# Check user noobie removed
echo "Checking that \"noobie\" user was removed: " | tee -a $logfile
check "ssh $centos1UserName@$centos1_IPADDR ! grep -isq \"noobie\" /etc/passwd" "This program did NOT detect the user name \"noobie\" was removed. Remove this user account, and re-run this checking script." | tee -a $logfile

# Check iptables service started and enabled (centos1)
echo "Checking that iptables service started and enabled (centos1): " | tee -a $logfile
check "ssh $centos1UserName@$centos1_IPADDR systemctl status iptables | grep -iqs \"active\" && ssh $centos1UserName@$centos1_IPADDR systemctl status iptables | grep -iqs \"enabled\"" "This program did NOT detect that the iptables service has \"started\" and/or is \"enabled\". Use the systemctl to stopa and disable the iptables service, and re-run this checking script." | tee -a $logfile

# Check  runlevel 5 for centos1 VM
echo "Checking that that \"centos1\" VM is in run-level 5: " | tee -a $logfile
check "ssh $centos1UserName@$centos1_IPADDR /sbin/runlevel | grep -isq \"5$\"" "This program did NOT detect that your \"centos1\" VM is in runlevel 5. Please make certain you set the runlevel to 5 (Graphical mode with networking), and re-run this checking script." | tee -a $logfile

# Check for file: /user/bin/tarchiver2.py (c7host)
echo  "Checking that the script \"/home/$USER/bin/tarchiver2.py\" exists: " | tee -a $logfile
check "test -f /home/$USER/bin/tarchiver2.py" "This program did NOT detect the file \"/home/$USER/bin/tarchiver2.py\" on your \"c7host\" machine. Complete the lab, and re-run this checking script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 4." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo
else
  echo "Your Lab is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
