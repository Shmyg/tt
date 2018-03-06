/*
|| Cleans up a BSCS DB and provides clean Business Configuration
||
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: clean_db.sql,v $
|| Revision 1.2  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/04/27 14:26:46  shmyg
|| Added cleanup procedure
||
*/
@delete_contracts
@delete_customers
TRUNCATE TABLE sysadm.udr_st;
TRUNCATE TABLE sysadm.udr_lt;
UPDATE	directory_number
SET	dn_status = 'r';
@synchronize_sequences
