#!/bin/bash

# ./lab8-check.bash

# Author:  Murray Saul
# Date:    November 18, 2016
# Edited by: Peter Callaghan
# Date: Sept 26, 2021
#
# Purpose: 

# Function to indicate OK (in green) if check is true; otherwise, indicate
# WARNING (in red) if check is false and end with false exit status

logfile=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)/Desktop/lab8_output.txt

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
cat <<+
ATTENTION:

In order to run this shell script, please
have the following information ready:

 - Your c7host and your centos1 and centos3 VMs are running.
   
 - Your centos1 username.
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

# Make certain user is logged in as root
if [ $(whoami) != "root" ]
then
  echo "Note: You are required to run this program as root."
  exit 1
fi

# System information gathering
echo "OPS245 Lab 8 Check Script" > $logfile
echo | tee -a $logfile
echo "SYSTEM INFORMATION:" | tee -a $logfile
#echo "------------------------------------" | tee -a $logfile
hostnamectl | tee -a $logfile
echo -n "              Date: "  | tee -a $logfile
date | tee -a $logfile
echo | tee -a $logfile

# Start checking lab8
echo "CHECKING YOUR LAB 8 WORK:" | tee -a $logfile
echo | tee -a $logfile


# Check option BOOTPROTO set to "dhcp" in "ifcfg" file
echo "Checking BOOTPROTO set to \"dhcp\" for centos1 VM: " | tee -a $logfile
read -p "Enter your centos1 username: " centos1UserName
check "ssh $centos1UserName@192.168.245.42 grep -sqi BOOTPROTO.*dhcp '/etc/sysconfig/network-scripts/ifcfg-e*'" "This program did not detect the value \"dhcp\" for the BOOTPROTO option in the network interface file on your centos1 VM. Another reason why this error occurred is that you didn't complete the last section to add a host for centos1 using the IPADDR \"192.168.245.42\". Please make corrections, reboot your centos3 VM, and re-run this checking shell script." | tee -a $logfile

# Check that dhcp server is running on centos3 VM
echo "Checking that dhcp service is currently running on your centos3 VM: " | tee -a $logfile
check "ssh root@centos3 systemctl status dhcpd | grep -iqs active" "This program did not detect that the \"dhcp\" service is running (active). Please make corrections, and re-run this checking shell script." | tee -a $logfile

# Check DHCPDISCOVER, DHCPOFFER, DHCPREQUEST & DHCPACK for centos3 on /var/log/messages
echo "Checking \" DHCPDISCOVER, DHCPOFFER, DHCPREQUEST & DHCPACK\" on" | tee -a $logfile
echo " \"/var/log/messages\" on centos3 VM: " | tee -a $logfile
check "ssh root@centos3 \"(grep -iqs DHCPDISCOVER /var/log/messages &&  grep -iqs DHCPOFFER /var/log/messages && grep -iqs DHCPREQUEST /var/log/messages && grep -iqs DHCPACK /var/log/messages)\"" "This program did not detect the messages containing \" DHCPDISCOVER or DHCPOFFER or DHCPREQUEST or DHCPACK\" relating to \"centos3\" for your centos3 VM. Please make corrections, and re-run this checking shell script." | tee -a $logfile

# Check for non-empty "/var/lib/dhcpd/dhcpd.leases" file on centos3 VM
echo "Checking for non-empty \"/var/lib/dhcpd/dhcpd.leases\" file on centos3 VM: " | tee -a $logfile
check "ssh ops245@centos3 test -s /var/lib/dhcpd/dhcpd.leases " "This program did not detect the NON-EMPTY file called \"/var/lib/dhcpd/dhcpd.leases\" file in your centos3 VM. Please make corrections, and re-run this checking shell script." | tee -a $logfile

# Check that centos3 can ping centos host (IPADDR: 192.168.245.42)
echo "Checking that centos3 VM can ping centos1 host (IPADDR: \"192.168.245.42\"): " | tee -a $logfile
check "ssh ops245@centos3 ping -c1 192.168.245.42 > /dev/null 2> /dev/null" "This program did not detect that there was an ip address set for any network interface card (i.e. eth0) for the value: \"192.168.245.42\". Please make corrections, and re-run this checking shell script." | tee -a $logfile

# Check that "/var/lib/dhclient" directory is non-empty on centos1 VM
echo  "Checking that \"/var/lib/dhclient\" directory is non-empty on centos1 VM: " | tee -a $logfile
check "ssh $centos1UserName@192.168.245.42 ls /var/lib/dhclient | grep -sq ." "This program did not detect regular files contained in the \"/var/lib/dhclient\" directory - this indicates that the dhcp process did not correctly for your centos1 VM when you issued the command \"dhclient\". Please make corrections, and re-run this checking shell script." | tee -a $logfile

warningcount=`grep -c "WARNING" $logfile`

echo | tee -a $logfile
echo | tee -a $logfile
if [ $warningcount == 0 ]
then
  echo "Congratulations!" | tee -a $logfile
  echo | tee -a $logfile
  echo "You have successfully completed Lab 8." | tee -a $logfile
  echo "1. Submit a screenshot of your entire desktop (including this window) to your course professor." | tee -a $logfile
  echo "2. A copy of this script output has been created at $logfile. Submit this file along with your screenshot." | tee -a $logfile
  echo
else
  echo "Your Lab is not complete." | tee -a $logfile
  echo "Correct the warnings listed above, then run this script again." | tee -a $logfile
fi
