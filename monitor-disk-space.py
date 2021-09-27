#!/usr/bin/env python3

'''
This python script is based off of:
Linux shell script to watch disk space (should work on other UNIX oses )
SEE URL: http://www.cyberciti.biz/tips/shell-script-to-watch-the-disk-space.html

Re-written in python by: Peter Callaghan
Date: 24 Sept 2021
Note:  I am aware this is not the most efficient way of performing this task.
I have used an arbitrarily limited sub-set of python's capabilities.
'''

import os

#The local email account to send notifications to
admin="root"
#The percentage use at which notifications will be sent
alert=90
#Capture the machine's hostname
hostname = os.popen("hostname").read().strip()
#current timestamp
date = os.popen("date").read().strip()

#Gather %use and device/filesystem of each volume
diskusage = os.popen("df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 \" \" $1 }'")
#Loop through each volume entry
for disk in diskusage.readlines():
    #Extract percentage use
    usage = os.popen("echo " + disk.strip() + " | awk '{ print $1}' | cut -d'%' -f1").read().strip()
    #extract device/filesystem name
    partition = os.popen ("echo " + disk.strip() + " | awk '{ print $2 }'")
    #Convert usage into intege
    usageint = int(usage)
    partitionstring = partition.read().strip()
    #if %use of this volume is above the point at which we want to be notified...
    if usageint > alert:
        #...send that notification
        os.system("echo '" + hostname + " is running out of space on " + partitionstring + " partition.  As of " + date + " it is at " + usage + "%.' | mail -s 'Alert: " + hostname + " is almost out of disk space' " + admin)
