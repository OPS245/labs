#!/bin/bash

# report3.bash
#
# Author: Murray Saul
# Date: January 21, 2015
#
# Purpose: To present sysadmin to create an software inventory
#          report containing selected elements contained in a
#          web-broswer (HTML and JavaScript)

# Check to see if logged in as root to be able to create file
# in /root/ directory...

if [ $USER != "root" ]
then
   echo "You must be logged in as root to run the command."
   echo "Either login as root or issue command \"sudo ./report1.bash\""
   exit 1
fi


# Generate first part of HTML5 document

cat > installation_report.html <<+
<!DOCTYPE HTML>
<html>

 <!-- Heading Section -->

 <head>
   <title>Installation Report</title>
   <meta charset="UTF-8">


   <script type="text/javascript">

   function toggle_visibility(tbid,lnkid) {
   if (document.getElementsByTagName) {
     var tables = document.getElementsByTagName('table');
     for (var i = 0; i < tables.length; i++) {
      if (tables[i].id == tbid){
        var trs = tables[i].getElementsByTagName('tr');
        for (var j = 2; j < trs.length; j+=1) {
        trs[j].bgcolor = '#CCCCCC';
          if(trs[j].style.display == 'none') 
             trs[j].style.display = '';
          else 
             trs[j].style.display = 'none';
       }
      }
     }
    }
      var x = document.getElementById(lnkid);
      if (x.innerHTML == '[+] Expand ')
         x.innerHTML = '[-] Collapse ';
      else 
         x.innerHTML = '[+] Expand ';
   }
   </script>

   <style type="text/css">
   td {FONT-SIZE: 90%; MARGIN: 0px; COLOR: #000000;}
   td {FONT-FAMILY: verdana,helvetica,arial,sans-serif}
   a {TEXT-DECORATION: none;}
   </style>

 </head>

 <!-- body section with table for Installation Report information -->

 <body>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" > <strong>Linux Server Installation Report</strong></td><td colspan="2" style="text-align:right"><strong>Date: $(date +'%A %B %d, %Y @ %H%M%S %p')</strong></td>
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
            <tr><td height="25" bgcolor="#FFFFFF" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2"> Hostname</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(hostname)</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Linux Distribution</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(cat /etc/*-release)</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Uptime</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(uptime | sed 's/  */,/g'| awk -F"," '{print $2 " (" $3,$4,$5 ")"}')</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Kernel Version</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(uname -rn)</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Name Server(s)</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(cat /etc/resolv.conf | sed -e 's/[^0-9.]//g' -e 's/$/,/g')</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Number of packages installed</td>
            <td bgcolor="#EEEEEE" style="text-align:right">$(grep -i installing /var/log/anaconda/packaging.log | wc -l)</td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
    </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0" id="tbl0" name="tbl0">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">List of Installed Packages</td>
            <td bgcolor="#EEEEEE"><a href="javascript:toggle_visibility('tbl0','lnk0');">
            <div align="right" id="lnk0" name="lnk0">[+] Expand </div></a></td></tr>
        <tr style="display:none;"><td colspan="3"><div align="left">
           <pre>

+


cat /var/log/anaconda/packaging.log >> installation_report.html


cat >> installation_report.html <<+
        </pre>
        </div></td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>

            <tr style="display:none;"><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
            <tr style="display:none;"><td height="1" bgcolor="#727272" colspan="3"></td></tr>

            <tr style="display:none;"><td height="8" colspan="3"></td></tr>
     </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0" id="tbl2" name="tbl2">




    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0" id="tbl1" name="tbl1">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Process Status</td>
            <td bgcolor="#EEEEEE"><a href="javascript:toggle_visibility('tbl1','lnk1');">
            <div align="right" id="lnk1" name="lnk1">[+] Expand </div></a></td></tr>
        <tr style="display:none;"><td colspan="3"><div align="left">
           <pre>

+

ps aux | cut -c-80 | sed -e 's/[<]/\&lt;/g' -e 's/[>]/\&gt;/g' >> installation_report.html


cat >> installation_report.html <<+
        </pre>
        </div></td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>

            <tr style="display:none;"><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
            <tr style="display:none;"><td height="1" bgcolor="#727272" colspan="3"></td></tr>

            <tr style="display:none;"><td height="8" colspan="3"></td></tr>
     </table>
    <table width="800" border="0" align="center" cellpadding="4" cellspacing="0" id="tbl2" name="tbl2">
        <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
        <tr bgcolor="#EEEEEE"><td height="15" colspan="2">Network Interface Information</td>
            <td bgcolor="#EEEEEE"><a href="javascript:toggle_visibility('tbl2','lnk2');">
            <div align="right" id="lnk2" name="lnk2">[+] Expand </div></a></td></tr>
        <tr style="display:none;"><td colspan="3"><div align="left">
           <pre>

+

/sbin/ifconfig | cut -c-80 | sed -e 's/[<]/\&lt;/g' -e 's/[>]/\&gt;/g' >> installation_report.html


cat >> installation_report.html <<+
        </pre>
        </div></td></tr>

            <tr style="display:none;"><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
            <tr style="display:none;"><td height="1" bgcolor="#727272" colspan="3"></td></tr>

            <tr style="display:none;"><td height="8" colspan="3"></td></tr>
            <tr><td height="1" bgcolor="#CCCCCC" colspan="3"></td></tr>
            <tr><td height="1" bgcolor="#727272" colspan="3"></td></tr>
     </table>



  </body>
</html>
+

firefox installation_report.html
