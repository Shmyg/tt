#!/bin/bash
DATA_PUMP_DIR=/home/oracle/oracode/11.2/db/rdbms/log/
ORACLE_SIDS=(BSCSDEV BSCSTSTT)
USER=tstt
IP=94.45.132.38

dt=`date +%d%m%Y`
for ORACLE_SID in ${ORACLE_SIDS[@]}; do
 scp oracle2@10.110.8.187:"$DATA_PUMP_DIR"/"$ORACLE_SID""$dt".dmp.gz /home/shmyg/backup
# scp /home/shmyg/tmp/"$ORACLE_SID""$dt".dmp.gz "$user"@"$ip":~/backup
 rm /home/shmyg/tmp/"$ORACLE_SID""$dt".dmp.gz
done
