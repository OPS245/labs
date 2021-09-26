#!/bin/bash

# ./lab5-check.bash

# Author:  Murray Saul
# Date:    June 7, 2016
# Edited by: Peter Callaghan
# Date: Sept 26, 2021
#
# Purpose: Check that students have correctly managed file system sizes with LVM
#          and other disk management utlities. Also check that crontab was correctly
#          set-up by the student

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab5_output.txt

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

 - IPADDRESSES for only your centos2 VM.

 - Your regular username password for centos2 VM.
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

# System information gathering
echo "OPS245 Lab 5 Check Script" > $logfile
echo | tee -a $logfile
echo "SYSTEM INFORMATION:" | tee -a $logfile
#echo "------------------------------------" | tee -a $logfile
hostnamectl | tee -a $logfile
echo -n "              Date: "  | tee -a $logfile
date | tee -a $logfile
echo | tee -a $logfile

# Start checking lab5
echo "CHECKING YOUR LAB 5 WORK:" | tee -a $logfile
echo | tee -a $logfile

# Check for file pathname /home/$USER/bin/monitor-disk-space.py (c7host)
echo -n "Checking that \"/home/$USER/bin/monitor-disk-space.py\" file exists (c7host): " | tee -a $logfile
check "test -f \"/home/$USER/bin/monitor-disk-space.py\"" "This program found there is no file called: \"//home/$USER/bin/monitor-disk-space.py\" on your \"c7host\" VM. Please create this archive again (for the correct VM), and re-run this checking shell script." | tee -a $logfile

# Check crontab file (c7host)
echo -n "Checking for crontab file (c7host): " | tee -a $logfile
check "crontab -l -u $USER | grep -iqs \"/home/$USER/bin/monitor-disk-space.py\"" "This program found there was no crontab entry to run the monitor-disk-space.py shell script. Please properly create this crontab entry as ${USER}, and re-run this checking shell script." | tee -a $logfile

# Check /dev/vda3 or /dev/sda3 partition created (centos2)
echo "Checking that /dev/vda3 or /dev/sda3 partition created (centos2): " | tee -a $logfile
read -p "Enter your centos2 username: " centos2UserName
read -p "Enter IP Address for your centos2 VMs eth0 device: " centos2_IPADDR
check "ssh ${centos2UserName}@$centos2_IPADDR ls /dev/vda3 > /dev/null || ls /dev/sda3 > /dev/null" "This program did NOT detect the partition called: \"/dev/vda3\" or \"/dev/sda3\" was created. Please create this partition, and re-run this checking script." | tee -a $logfile

# Check /dev/vda3 partition was mounted under /archive directory (centos2)
echo "Checking that \"/dev/vda3\" or \"/dev/sda3\" partition was mounted under \"/archive\" directory (centos2): " | tee -a $logfile
check "ssh ${centos2UserName}@$centos2_IPADDR mount | grep -isq \"/archive\"" "This program did NOT detect that the \"/dev/vda3\" or \"/dev/sda3\" partition was mounted under the \"/archive\" directory. Please make appropriate corrections, and re-run this checking script." | tee -a $logfile

# Check /dev/vda3 partition was formatted for ext4 file-system (centos2)
echo "Checking that \"/dev/vda3\" (or \"/dev/sda3\") partition was formatted for ext4 file-system: " | tee -a $logfile
check "ssh ${centos2UserName}@$centos2_IPADDR mount | grep /archive | grep -isq ext4" "This program did NOT detect that the \"/dev/vda3\" partition was formatted for the ext4 file-system. Please format this partition, and re-run this checking script." | tee -a $logfile

# Check /archive logical volume is 2.5G (centos2)
echo "Checking that \"/archive\" logical volume has size: 2.5G (centos2): " | tee -a $logfile
check "ssh ${centos2UserName}@$centos2_IPADDR lsblk | grep archive | grep -isq 2.5G" "This program did NOT detect that the size of the \"archive\" logical volume is set to: \"2.5G\". Please set the correct size for this partition, and re-run this checking script." | tee -a $logfile

# Check new virtual hard disk /dev/sdb created (centos2)
echo "Checking that new virtual hard disk \"/dev/vdb\" (or \"/dev/sdb\") was created (centos2): " | tee -a $logfile
check "ssh $centos2UserName@$centos2_IPADDR  ls /dev/[sv]db* >/dev/null" "This program did NOT detect the partition called: \"/dev/vdb\" or \"/dev/sdb\". Create this partition, and re-run this checking script." | tee -a $logfile

# Check /dev/sdb1 partition created (centos2)
echo "Checking that \"/dev/vdb1\" (or \"dev/sdb1\")partition was created (centos2): " | tee -a $logfile
 check "ssh $centos2UserName@$centos2_IPADDR lsblk | grep -isq sdb1 || ssh $centos2UserName@$centos2_IPADDR lsblk | grep -isq vdb1 " "This program did NOT detect the partition called: \"vdb1\" or \"sdb1\" when issuing the \"lsblk\" command. Please make appropriate fixes, and re-run this checking script." | tee -a $logfile

# Check \"home\" file-system size increased
echo -n "Checking that that the \"home\" file system increased to 4G (centos2): " | tee -a $logfile
check "ssh $centos2UserName@$centos2_IPADDR lsblk | grep home | grep -isq 4G" "This program did NOT detect that the \"home\" file-system was increased to 4G. Please change the size of your home partition to 3G, and re-run this checking script." | tee -a $logfile

# Check automatic boot of partition in /etc/fstab (centos2)
echo -n "Checking that entry of \"/archive\" mount in /etc/fstab(centos2): " | tee -a $logfile
check "ssh $centos2UserName@$centos2_IPADDR grep -sq /archive /etc/fstab" "This program did NOT detect  that the \"/etc/fstab\" file contains the entry to mount the \"/dev/vda3\" partition under the \"/archive\" directory. Please make corrections to this file, and re-run this checking script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 5." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo "3. Also submit a copy of your disk-monitor.py script." | tee -a $logfile
  echo
else
  echo "Your Lab 5 is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
