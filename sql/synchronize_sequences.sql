/*
|| Synchronization of sequences for BSCS DB
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: synchronize_sequences.sql,v $
|| Revision 1.4  2016/09/19 09:55:01  shmyg
|| Added sequence configuration script
||
|| Revision 1.3  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.2  2016/05/02 01:01:08  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/04/26 14:30:18  shmyg
|| *** empty log message ***
||
||
*/
SPOOL reset_seq.txt
DECLARE
	c_user	CONSTANT VARCHAR2(100) := 'shmyg';

BEGIN
	FOR	rec IN (select distinct app_sequence_schema from app_sequence)
	LOOP
		EXECUTE IMMEDIATE 'alter session set current_schema=' || rec.app_sequence_schema;
		seqpack.seq_create_all_app( i_resetsequence => TRUE );
	END	LOOP;

	EXECUTE IMMEDIATE 'alter session set current_schema=' || c_user;
END;
/

SPOOL OFF;
