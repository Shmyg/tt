#!/bin/bash

# Script for loading payment file recieved from TSTT into the DB
# The purpose is to replace CUSTNUM in the original file with CUSTCODE
# and prepare file for PIH. This file only loads the data, PIH file itself is
# prepared by an SQL script
#
# $Log#
#

#. ${HOME}/.bash_profile

# Startup checks
# Checking that DB access vars set
if [ -z "$DB_USER" -o -z "$DB_NAME" -o -z "$DB_PASS" ] ; then
 echo "Cannot access database - DB_USER/DB_NAME/DB_PASS not set"
 exit
fi

# Checking working environment
if [ -z "$LOG_DIR" -o -z "$PROJECT_DIR" -o -z "$DATA_DIR" ] ; then
 echo "LOG_DIR or PROJECT_DIR or DATA_DIR is not set"
 exit
fi

# Looking for files and try to load them into the database
# We need to filter out already processed files
cd $DATA_DIR
 for DATA_FILE in `ls *.txt`; do

  # Checking if control file exists
  # Directory structure for control files must be the same as for data files
  if [ ! -r "${CONTROL_FILE}" ]; then
   echo "Control file ${CONTROL_FILE} doesn't exist or is not readable"
  else
   # Adding filename to each row in datafile through fifo
   cat ${DATA_FILE} | sed -e "s/$/;$DATA_FILE/" > ${FIFO} &
   # Invoking SQL*Loader
   echo ${DB_PASS} | \
           sqlldr control=${CONTROL_FILE} \
	   data=${FIFO} \
	   log=${LOG_DIR}/${DATA_FILE}.log \
	   bad=${LOG_DIR}/${DATA_FILE}.bad \
	   discard=${LOG_DIR}/${DATA_FILE}.disc \
	   userid=${DB_USER}@${DB_NAME}

   RET_CODE=$?

   # Checking return code
   # 2 - it's warning - maybe some bad records found
   if [ "${RET_CODE}" -eq "0" -o "${RET_CODE}" -eq "2" ]; then
    # Checking if there is discards file
    test -f ${LOG_DIR}/${DATA_FILE}.disc && echo "There are discarded records, you'd better check"
    mv ${DATA_FILE} ${PROJECT_DIR}/processed/${DATA_FILE}.proc
    cd ${PROJECT_DIR}/PIH
    echo ${DB_PASS} | \
	    sqlplus ${DB_USER}@${DB_NAME} @${PROJECT_DIR}/sql/prepare_pih_file.sql ${DATA_FILE}
    cd -
   else
    echo "SQL*Loader returned with code $RET_CODE. Something might be wrong, you'd better check"
   fi  
  fi
 done
exit 0
