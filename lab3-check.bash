#!/bin/bash

# ./lab3-check.bash

# Author:  Murray Saul
# Date:    June 7, 2016
# Edited by: Peter Callaghan
# Date: Sept 19, 2021
#
# Purpose: Check that students correctly archived and installed and
#          removed software on their VMs

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab3_output.txt

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

 - IPADDRESSES for only your centos3 VM.
   Remember that your password for your ops245 account
   in centos3 is "ops245"!!!!

 - Your regular username password for c7host and ALL VMs.
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






# Start checking lab3
echo "OPS245 Lab 3 Check Script" > $logfile
echo | tee -a $logfile
echo "CHECKING YOUR LAB 3 WORK:" | tee -a $logfile
echo | tee -a $logfile

centos3UserName="ops245"



# Check creation of /tmp/archive1.tar archive file (centos3)
echo "Checking creation of \"/tmp/extract1/archive1.tar\" archive file (centos3): " | tee -a $logfile
read -p "Enter IP Address for your centos3 VMs eth0 device: " centos3_IPADDR
check "ssh $centos3UserName@$centos3_IPADDR test -f /tmp/extract1/archive1.tar" "This program found there is no file called: \"/tmp/extract1/archive1.tar\" on your \"centos3\" VM. Please create this archive again (for the correct VM), and re-run this checking shell script." | tee -a $logfile

# Check creation of /tmp/archive2.tar.gz zipped tarball (centos3)
echo "Checking creation of \"/tmp/extract2/archive2.tar.gz\" archive file (centos3): " | tee -a $logfile
check "ssh $centos3UserName@$centos3_IPADDR test -f /tmp/extract2/archive2.tar.gz" "This program found there is no file called: \"/tmp/extract2/archive2.tar.gz\" on your \"centos3\" VM. Please create this archive again (for the correct VM), and re-run this checking shell script." | tee -a $logfile

# Check for restored archive in /tmp/extract1 directory (centos3)
echo "Checking archive1.tar restored to \"/tmp/extract1\" directory (centos3): " | tee -a $logfile
check "ssh $centos3UserName@$centos3_IPADDR test -d /tmp/extract1" "This program found that the \"archive1.tar\" was not properly restored to directory \"/tmp/extract1\" directory in your \"centos3\" VM. Please restore this archive again (for the correct VM), and re-run this checking shell script." | tee -a $logfile

# Check for restored archive in /etc/extract2 directory (centos3)
echo "Checking archive2.tar.gz restored to \"/tmp/extract2\" directory (centos3): " | tee -a $logfile
check "ssh $centos3UserName@$centos3_IPADDR test -d /tmp/extract2" "This program found that the \"archive2.tar.gz\" was not properly restored to directory \"/tmp/extract2\" directory in your \"centos3\" VM. Please restore this archive again (for the correct VM), and re-run this checking shell script." | tee -a $logfile

# Check for removal of elinks application (centos1)
echo "Checking for removal of \"elinks\" application: " | tee -a $logfile
check "! which elinks > /dev/null 2> /dev/null" "This program found that the \"elinks\" application was NOT removed on your \"c7host\" VM. Please re-do this task, and then re-run this checking shell script." | tee -a $logfile

# Check for install of xchat application (centos1)
echo -n "Checking for install of \"xchat\" application: " | tee -a $logfile
check "which xchat" "This program found that the \"xchat\" application was NOT installed on your \"c7host\" VM. Please re-do this task, and then re-run this checking shell script." | tee -a $logfile


# Check for epel repository added to c7host (Note: this may take a few moments - be patient):
echo -n "Checking for \"epel\" repository added to repolist (c7host). Note: This may take a few moments (please be patient): " | tee -a $logfile
check "yum repolist | grep -isq \"epel\"" "This program did NOT detect that the \"epel\" repository was added to the repository list. Please re-do the task to add the \"epel\" repository to the repository list, issue the \"yum repolist\" command to verify it has been added, and then re-run this checking shell script." | tee -a $logfile

# Check for presence of lbreakout or lbreakout2  application (c7host)
echo -n "Checking for presence of \"lbreakout\" application (c7host): " | tee -a $logfile
check "which lbreakout > /dev/null 2> /dev/null || which lbreakout2 > /dev/null 2> /dev/null || test -f /usr/bin/lbreakout2 || test -f /usr/local/bin/lbreakout2" "This program did NOT detect that the game called \"lbreakout2\" was installed on your \"c7host\" VM. Please follow the instructions to properly compile your downloaded source code (perhaps ask your instructor or lab assistant for help), and then re-run this checking shell script." | tee -a $logfile

# Check for presence of tarchiver.py bash shell script
echo -n "Checking for presence of \"/home/$USER/bin/tarchiver.py\" script: " | tee -a $logfile
check "test -f /home/$USER/bin/tarchiver.py" "This program did NOT detect the presence of the file: \"/home/$USER/bin/tarchiver.py\". Please create this shell script in the correct location, assign execute permissions, and run this shell script, and then re-run this checking shell script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 3." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo "3. Also submit a copy of your tarchiver.py script." | tee -a $logfile
  echo
else
  echo "Your Lab is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
