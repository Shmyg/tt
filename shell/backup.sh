#!/bin/bash
. /home/oracle/.bash_profile
DATA_PUMP_DIR=/u01/app/oracle/oradata/BSCSTEST/diag/rdbms/bscstest/BSCSTEST/udump
ORACLE_SID=BSCSTEST
USER=tstt
IP=94.45.132.38

dt=`date +%d%m%Y`
expdp userid=SYSADM/SYSADM@"$ORACLE_SID" dumpfile="$ORACLE_SID""$dt".dmp logfile="$ORACLE_SID""$dt".log
gzip "$DATA_PUMP_DIR"/"$ORACLE_SID""$dt".dmp
scp "$DATA_PUMP_DIR"/"$ORACLE_SID""$dt".dmp.gz "$USER"@"$IP":~/backup
