#!/bin/bash


export SSOADM_DIR= /BSCS_BILLING/PCP1601/TPS/openam/admin/opensso/bin 
export OPENAM_ADMIN_FILE= /BSCS_BILLING/PCP1601/resource/openam/admin-pass-file
export OPENAM_SERVER= http://10.85.6.43:10180/opensso 
export JAVA_HOME= /software/jdk1.6.0_31 
export CATALINA_HOME = /BSCS_BILLING/PCP1601/TPS/tomcat
export BSCS_RESOURCE= /BSCS_BILLING/PCP1601/resource
export JAVA_HOME= /software/JDK_1.7/jdk1.7.0_25 
export CATALINA_HOME= /BSCS_BILLING/PCP1601/WEB

$SSOADM_DIR/ssoadm create-identity -i TSTT -t User -a "cn=TSTT" "givenname=TSTT" "preferredlanguage=English" "preferredlocale=USA" inetuserstatus=Active "userpassword=TSTT" -e /

$SSOADM_DIR/ssoadm add-member   -m TSTT -y User -i "BSCS_OnlineUsers" -t Group -e /
$SSOADM_DIR/ssoadm add-member   -m TSTT -y User -i "ROLE_EMPLOYEECSR" -t Group -e /
