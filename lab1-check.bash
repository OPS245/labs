#!/bin/bash

# ./lab1-check.bash

# Author:  Murray Saul
# Date:    May 22, 2016
# Edited by: Peter Callaghan
# Date: Sept 26, 2021
#
# Purpose: Check that students correctly installed the centos1 VM
#          and properly performed common Linux commands. Script will
#          exit if errors, but provide feedback to correct the problem.

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab1_output.txt

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

# System information gathering
echo "OPS245 Lab 1 Check Script" > $logfile
echo | tee -a $logfile
echo "SYSTEM INFORMATION:" | tee -a $logfile
#echo "------------------------------------" | tee -a $logfile
hostnamectl | tee -a $logfile
echo -n "              Date: "  | tee -a $logfile
date | tee -a $logfile

# Start checking lab1
echo | tee -a $logfile
echo "CHECKING YOUR LAB 1 WORK:" | tee -a $logfile
#echo | tee -a $logfile

# Check version of Linux distribution
echo -n "Checking Correct Linux Distribution: " | tee -a $logfile
check "grep -iqs \"VERSION=.*7\" /etc/os-release && grep -iqs \"centos\" /etc/os-release" " Your version of Centos is not 7. You are required to use Centos 7 in order to perform these labs. Install the correct version of Centos7 Full DVD (links on the main OPS245 WIKI) and re-run this shell script." | tee -a $logfile

# Checking for correct partitions created
echo -n "Checking that root partition was created: " | tee -a $logfile
check "lsblk -f | grep  /$ | grep -isq ext4" "You needed to create a root partition (file system type: ext4). Please reinstall the c7host and re-run this shell script." | tee -a $logfile

echo -n "Checking that \"/home\" partition was created: " | tee -a $logfile
check "lsblk -f | grep  /home$ | grep -isq ext4" "You needed to create a \"/home\" partition (file system type: ext4). Please reinstall the c7host and re-run this shell script." | tee -a $logfile

echo -n "Checking that \"/var/lib/libvirt/images\" partition was created: " | tee -a $logfile
check "lsblk -f | grep  /var/lib/libvirt/images$ | grep -isq ext4" "You needed to create a \"/var/lib/libvirt/images\" partition (file system type: ext4 with correct absolute images pathname correctly spelled). Please reinstall the c7host and re-run this shell script." | tee -a $logfile

# Checking for correct sizes for the partitions created
echo -n "Checking that the root partition is at least 30GB: " | tee -a $logfile
check "test `df | grep /$ | awk '{print $2;}'` -ge 30000000" "The size of the root partition must be at least 30GB. Please reinstall the c7host and re-run this shell script." | tee -a $logfile

echo -n "Checking that the /home partition is at least 40GB: " | tee -a $logfile
check "test `df | grep /home$ | awk '{print $2;}'` -ge 40000000" "The /home partition must be at least 40GB. Please reinstall the c7host and run-run this shell script." | tee -a $logfile

echo -n "Checking that the \"/var/lib/libvirt/images\" partition is at least 100GB: " | tee -a $logfile
check  "test `df | grep /var/lib/libvirt/images$ | awk '{print $2;}'` -ge 100000000" "The \"/var/lib/libvirt/images\" partition must be at least 100GB. Please reinstall the c7host and run-run this shell script." | tee -a $logfile

# Checking for network connectivity
echo -n "Checking for network connectivity: " | tee -a $logfile
check "wget -qO- http://google.ca &> /dev/null" "Your internet connection doesn't seem to work. Check /etc/sysconfig/network-scripts/ifcfg-ens33 to make sure ONBOOT is set to YES and being up the network interface using ifup." | tee -a $logfile

# Check if SELinux is disabled
echo -n "Checking that SELinux is disabled: " | tee -a $logfile
check "grep -isq SELINUX=permissive /etc/selinux/config" "According to your \"/etc/selinux/config\" file, the variable SELINUX is not set to \"permissive\". Please make corrections and re-run this shell script." | tee -a $logfile

# Check if /home/user/bin directory was created
echo -n "Checking that \"/home/$USER/bin\" directory was created:" | tee -a $logfile
check "test -d \"/home/$USER/bin\"" "This program did NOT detect that the \"/$USER/bin\" directory was created. Please create this directory, and re-run this shell script." | tee -a $logfile

# Check for existence of /home/user/bin/report.txt
echo -n "Checking that \"/home/$USER/bin/report.txt\"  exists:" | tee -a $logfile
check "test -f \"/home/$USER/bin/myreport.py\"" "This program did NOT detect the output from the manual system report \"/home/$USER/bin/report.txt\". Please create your manual system report and re-run this shell script." | tee -a $logfile

# Check for existence of /home/user/bin/myreport.py script
echo -n "Checking that \"/home/$USER/bin/myreport.py\" script exists:" | tee -a $logfile
check "test -f \"/home/$USER/bin/myreport.py\"" "This program did NOT detect the existence of the file pathname \"/home/$USER/bin/myreport.py\". Please create this script at that pathname and re-run this shell script." | tee -a $logfile

# Check that myreport.py script was run
echo -n "Checking that \"/home/$USER/bin/myreport.py\" script was run:" | tee -a $logfile
check "test -f \"/home/$USER/bin/pythonreport.txt\"" "This program did NOT detect the existence of the file \"/home/$USER/bin/pythonreport.txt\" and may indicate that the shell script was NOT run. Please run the shell script correctly and re-run this shell script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 1." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo "3. Also submit a copy of your myreport.py script." | tee -a $logfile
  echo
else
  echo "Your Lab is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
