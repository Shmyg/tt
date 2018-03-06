#!/bin/sh
# **********************************************************************************************************
# * Script for baseline data information: BSCS groups and ADMX user.
# * This script will execute "ssoadm" command-line utility from OpenAM, which must be previouly installed.
# * Change the first lines below to suite to your needs.
# *
# * SSOADM_DIR represents bin folder of OpenaAM Tools installation where ssoadm.sh is located.
# * OPENAM_ADMIN_FILE represents the complete path and name of the file with admin user's password
# *
# * Obs.: The use of "ssoadm" command-line utility implies its installation, and use of a valid OpenAM
# * server instance running on Tomcat.
# **********************************************************************************************************

if [ -z "$SSOADM_DIR" ]
then
    echo "SSOADM_DIR isn't set!"
    exit 1
fi

if [ -z "$OPENAM_ADMIN_FILE" ]
then
    echo "OPENAM_ADMIN_FILE isn't set!"
    exit 1
fi

LINE=---------------------------------------------------

echo $LINE
echo Location of ssoadm command-line utility: $SSOADM_DIR
echo $LINE
echo File containing OpenAM\'s admin user password: $OPENAM_ADMIN_FILE
echo $LINE


# **********************************************************************************************************
# * Defining the temporary batch file that will contain the statements to create users and roles on OpenAM.
# **********************************************************************************************************

OPENAM_BATCH_FILE=/tmp/openam_baseline_setup.ssoadm.$$

cat >${OPENAM_BATCH_FILE} <<-EOF

# **********************************************************************************************************
# * Creation of baseline BSCS groups
# **********************************************************************************************************

# **********************************************************************************************************
# * Creation of BSCS group for Online Users
# **********************************************************************************************************

create-identity -i "BSCS_OnlineUsers" -t Group -e /

add-privileges -i "BSCS_OnlineUsers" -t Group -g LogAdmin -e /
add-privileges -i "BSCS_OnlineUsers" -t Group -g PrivilegeRestAccess -e /
add-privileges -i "BSCS_OnlineUsers" -t Group -g PrivilegeRestReadAccess -e /

# **********************************************************************************************************
# * Creation of BSCS group for Application Users
# **********************************************************************************************************

create-identity -i "BSCS_ApplicationUsers" -t Group -e /

add-privileges -i "BSCS_ApplicationUsers" -t Group -g LogAdmin -e /
add-privileges -i "BSCS_ApplicationUsers" -t Group -g PrivilegeRestAccess -e /
add-privileges -i "BSCS_ApplicationUsers" -t Group -g PrivilegeRestReadAccess -e /

# **********************************************************************************************************
# * Creation of baseline BSCS Application Users
# **********************************************************************************************************
create-identity -i SOIUSER -t User -a "cn=Federated Factory" sn=Factory givenname=Federated inetuserstatus=Active userpassword=SOI -e /
create-identity -i "ROLE_SOIUSER" -t Group -e /
add-member -m SOIUSER -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m SOIUSER -y User -i "ROLE_SOIUSER" -t Group -e /

create-identity -i SOICS -t User -a "cn=SOI Command Scheduler" sn=Scheduler givenname=Command inetuserstatus=Active userpassword=SOICS -e /
create-identity -i "ROLE_SOICS" -t Group -e /
add-member -m SOICS -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m SOICS -y User -i "ROLE_SOICS" -t Group -e /

create-identity -i SXREG -t User -a "cn=SX user to perform customer identification and notification" sn=SX givenname=Customer inetuserstatus=Active userpassword=SXREG -e /
create-identity -i "ROLE_SXREG" -t Group -e /
add-member -m SXREG -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m SXREG -y User -i "ROLE_SXREG" -t Group -e /

create-identity -i SXUSR -t User -a "cn=SX user" sn=user givenname=SX inetuserstatus=Active userpassword=SXUSR -e /
create-identity -i "ROLE_SXUSR" -t Group -e /
add-member -m SXUSR -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m SXUSR -y User -i "ROLE_SXUSR" -t Group -e /

create-identity -i EVHSOICL -t User -a "cn=Event Handler SOI client" sn=client givenname=EVH inetuserstatus=Active userpassword=EVHSOICL -e /
create-identity -i "ROLE_EVHSOICL" -t Group -e /
add-member -m EVHSOICL -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m EVHSOICL -y User -i "ROLE_EVHSOICL" -t Group -e /

create-identity -i BEE -t User -a "cn=BEE User" sn=User givenname=BEE inetuserstatus=Active userpassword=BEE -e /
create-identity -i "ROLE_BEE" -t Group -e /
add-member -m BEE -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m BEE -y User -i "ROLE_BEE" -t Group -e /

create-identity -i OAB -t User -a "cn=OAB User" sn=User givenname=OAB inetuserstatus=Active userpassword=OABKIEV00 -e /
create-identity -i "ROLE_OAB" -t Group -e /
add-member -m OAB -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m OAB -y User -i "ROLE_OAB" -t Group -e /

create-identity -i CAB -t User -a "cn=CAB User" sn=User givenname=CAB inetuserstatus=Active userpassword=CABKIEV00 -e /
create-identity -i "ROLE_CAB" -t Group -e /
add-member -m CAB -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m CAB -y User -i "ROLE_CAB" -t Group -e /

create-identity -i CIL -t User -a "cn=CIL User" sn=User givenname=CIL inetuserstatus=Active userpassword=CIL -e /
create-identity -i "ROLE_CIL" -t Group -e /
add-member -m CIL -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m CIL -y User -i "ROLE_CIL" -t Group -e /

create-identity -i MSC -t User -a "cn=Mobile Switch Center" sn=Mobile givenname=Mobile inetuserstatus=Active userpassword=MSC -e /
create-identity -i "ROLE_MSC" -t Group -e /
add-member -m MSC -y User -i "BSCS_ApplicationUsers" -t Group -e /
add-member -m MSC -y User -i "ROLE_MSC" -t Group -e /

create-identity -i INTSOIUSR -t User -a "cn=Internal SOI application user" sn=User givenname=Internal inetuserstatus=Active userpassword=INTUSR -e /
create-identity -i "ROLE_INTSOIUSR" -t Group -e /
add-member -m INTSOIUSR -y User -i "ROLE_INTSOIUSR" -t Group -e /
add-member -m INTSOIUSR -y User -i "BSCS_ApplicationUsers" -t Group -e /

# **********************************************************************************************************
# * Creation of the baseline Supervisor role
# **********************************************************************************************************

create-identity -i "ROLE_SUPERVISOR" -t Group -e /

# **********************************************************************************************************
# * Creation of ADMX user
# **********************************************************************************************************

create-identity -i ADMX -t User -a "cn=Administrator User" sn=User givenname=Administrator inetuserstatus=Active userpassword=ADMX -e /
add-member -m ADMX -y User -i "ROLE_SUPERVISOR" -t Group -e /
add-member -m ADMX -y User -i "BSCS_OnlineUsers" -t Group -e /

# **********************************************************************************************************
# * Creation of MX roles
# **********************************************************************************************************

create-identity -i "MXUSER" -t Group -e /
create-identity -i "MXGUEST" -t Group -e /

# **********************************************************************************************************
# * Creation of Prurge & Archive role
# **********************************************************************************************************

create-identity -i "ROLE_ARCHIVE" -t Group -e /

# **********************************************************************************************************
# * Creation of VIP & EMPLOYEE CSR roles
# **********************************************************************************************************

create-identity -i "ROLE_VIPCSR" -t Group -e /
create-identity -i "ROLE_EMPLOYEECSR" -t Group -e /

EOF
# End of temporary file.

# **********************************************************************************************************
# * Processing temporary batch file in order to create stated users and roles on OpenAM.
# **********************************************************************************************************

$SSOADM_DIR/ssoadm do-batch --batchfile ${OPENAM_BATCH_FILE} --adminid amadmin --password-file ${OPENAM_ADMIN_FILE}

echo $LINE
echo Baseline data created succesfully
echo $LINE