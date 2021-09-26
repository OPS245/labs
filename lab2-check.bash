#!/bin/bash

# ./lab2-check.bash

# Author:    Murray Saul
# Date:      May 22, 2016
# Modified:  September 15, 2016
# Edited by: Peter Callaghan
# Date: 26 Sept, 2021
#
# Purpose: Check that students correctly installed centos1, centos2,
#          and centos3 VMs. Check that VMs installed correctly
#          (ext4 filesystem, sizes, SElinux disabled).
#          Check that VMs were backed-up, and backup script created

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab2_output.txt

function check(){

  if eval $1
  then
     echo -e "\e[0;32mOK\e[m"
  else
     echo
     echo
     echo -e "\e[0;31mWARNING\e[m"
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

# Banner

cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - IPADDRESSES for your centos1 and centos2 VMs
   For your centos2 VM, the ifconfig command does
   not work. Instead, use the command:
   ip address

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


# Start checking lab2
echo "OPS245 Lab 2 Check Script" > $logfile
echo | tee -a $logfile
echo "CHECKING YOUR LAB 2 WORK:" | tee -a $logfile
echo | tee -a $logfile

read -p "Enter the username that you created for your c7host and ALL VMs: " UserName
# Insert various checks here

# Check if ~user/bin directory exists in c7host VM
echo -n "Checking for existence of \"/home/$UserName/bin\" directory in c7host: " | tee -a $logfile
check "test -d /home/$UserName/bin" "There is no bin directory contained in your home directory in your c7host VM. You need to issue command: \"mkdir /home/$UserName/bin\" and re-run this shell script." | tee -a $logfile

# Check if ~user/bin/lab2-check.bash path exists
echo -n "Checking for pathname \"/home/$UserName/bin/lab2-check.bash\"" | tee -a $logfile
check "test -f /home/$UserName/bin/lab2-check.bash" "The \"lab2-check.bash\" file should be contained in the \"/home/$UserName/bin\" directory where all shell scripts should be for your Linux system administrator. Please location that file to the directory, and re-run this checking shell script." | tee -a $logfile

# Check that all 3 VMs have been created
echo -n "Checking that \"centos1\", \"centos2\", and \"centos3\" VMs have been created:" | tee -a $logfile
check "virsh list --all | grep -isq centos1 && virsh list --all | grep -isq centos2 && virsh list --all | grep -isq centos3" "This program detected that not ALL VMs have been created (i.e. centos1, centos2, centos3). Please create these VMs with the correct VM names, and re-run this checking shell script." | tee -a $logfile


# Check that all 3 VMs are running
echo -n "Checking that \"centos1\", \"centos2\", and \"centos3\" VMs are ALL running:" | tee -a $logfile
check "virsh list | grep -isq centos1 && virsh list | grep -isq centos2 && virsh list | grep -isq centos3" "This program detected that not ALL VMs (i.e. centos1, centos2, centos3) are running. Please make certain that ALL VMs are running, and re-run this checking shell script." | tee -a $logfile

# Check centos1 VM has \"ext4\" file-system types
echo "Checking that \"centos1\" has correct ext4 file-system type:" | tee -a $logfile
read -p "Enter IP Address for your centos1 VMs eth0 device: " centos1_IPADDR
check "ssh $UserName@$centos1_IPADDR \"lsblk -f | grep -i /$ | grep -iqs \"ext4\"\"" "This program detected that your centos1 VM does NOT have the correct filesystem type (ext4) for your / partition. Please remove and recreate the \"centos1\" VM, and re-run this checking shell script." | tee -a $logfile

# Check centos2 VM has \"ext4\" file-system types
echo "Checking that \"centos2\" has correct ext4 file-system types:" | tee -a $logfile
read -p "Enter IP Address for your centos2 VMs eth0 device: " centos2_IPADDR
check "ssh $UserName@$centos2_IPADDR \"lsblk -f | grep -iqs \"ext4\" && lsblk -f | grep -i /home$ | grep -iqs \"ext4\"\"" "This program detected that your centos2 VM does NOT have \"ext4\" file system types for / and/or /home partitions. Please remove and recreate the \"centos2\" VM, and re-run this checking shell script." | tee -a $logfile


# Check centos2 VM has correct partition sizes
echo "Checking that \"centos2\" has correct partition sizes:" | tee -a $logfile
check "ssh $UserName@$centos2_IPADDR \"lsblk | grep -isq \"2G.*/home\" && lsblk | grep -isq \"8G.*/\"\"" "This program detected that your centos2 VM does NOT have correct partition sizes for  / and/or /home partitions. Please remove and recreate the \"centos2\" VM, and re-run this checking shell script." | tee -a $logfile


# centos3 does not have to be checked since it was automatically setup...


# Check centos1 VM image file is in "images" directory
echo "Checking that \"/var/lib/libvirt/images/centos1.qcow2\" file exists:" | tee -a $logfile
check "test -f /var/lib/libvirt/images/centos1.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos1.qcow2\" does NOT exist. Please remove, and recreate the centos1 VM, and then re-run this checking shell script." | tee -a $logfile

# Check centos2 VM image file is in "images" directory
echo -n "Checking that \"/var/lib/libvirt/images/centos2.qcow2\" file exists:" | tee -a $logfile
check "test -f /var/lib/libvirt/images/centos2.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos2.qcow2\" does NOT exist. Please remove, and recreate the centos1 VM, and then re-run this checking shell script." | tee -a $logfile

# Check centos3 VM image file is in "images" directory
echo -n "Checking that \"/var/lib/libvirt/images/centos3.qcow2\" file exists:" | tee -a $logfile
check "test -f /var/lib/libvirt/images/centos3.qcow2" "This program detected that the file pathname \"/var/lib/libvirt/images/centos3.qcow2\" does NOT exist. Please remove, and recreate the centos3 VM, and then re-run this checking shell script." | tee -a $logfile

# Check that  backupVM.bash script was created in user's bin directory
echo -n "Checking that file pathname \"/home/$UserName/bin/backupVM.py\" exists:" | tee -a $logfile
check "test -f /home/$UserName/bin/backupVM.py" "This program detected that the file pathname \"/home/$UserName/bin/backupVM.py\" does NOT exist. please make fixes to this script, and re-run this checking shell script." | tee -a $logfile

# Check centos1 VM backed up (qcow2)
echo -n "Checking that centos1 backed up in user's home directory:" | tee -a $logfile
check "test -f /home/$UserName/backups/centos1.qcow2.gz" "This program detected that the file pathname \"/home/$UserName/backups/centos1.qcow2.gz\" does NOT exist. Please properly backup the centos1 VM (using gzip) to your home directory, and then re-run this checking shell script." | tee -a $logfile

# Check centos2 VM backed up (qcow2)
echo -n "Checking that centos2 backed up in user's home directory:" | tee -a $logfile
check "test -f /home/$UserName/backups/centos2.qcow2.gz" "This program detected that the file pathname \"/home/$UserName/backups/centos2.qcow2.gz\" does NOT exist. Please properly backup the centos2 VM (using gzip) to your home directory, and then re-run this checking shell script." | tee -a $logfile

# Check centos3 VM backed up (qcow2)
echo "Checking that centos3 backed up in user's home directory:" | tee -a $logfile
check "test -f /home/$UserName/backups/centos3.qcow2.gz" "This program detected that the file pathname \"/home/$UserName/backups/centos3.qcow2.gz\" does NOT exist. Please properly backup the centos3 VM (using gzip) to your home directory, and then re-run this checking shell script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 2." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo "3. Also submit a copy of your backupVM.py script." | tee -a $logfile
  echo
else
  echo "Your Lab is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
