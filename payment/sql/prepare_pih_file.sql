/*
||
|| $Log: prepare_pih_file.sql,v $
|| Revision 1.2  2018/02/15 07:52:08  shmyg
|| Restoring files which have misteriously disappeared from the project
||
*/

SET PAGESIZE 0
SET TRIMSPOOL ON
SET LINESIZE 32767
SET TAB OFF
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TERMOUT OFF
SET RECSEP OFF

COLUMN begin_date new_val start_date
SELECT  TO_CHAR( SYSDATE, 'YYYYMMDDHH24MI' ) begin_date
FROM    DUAL; 


SPOOL PIH&&start_date..txt

SELECT	tt.rectype || ';' || 
	tt.reversal_flag || ';' || 
	tt.payment_ref || ';' || 
	TO_CHAR( tt.payment_date, 'DD.MM.YYYY') || ';' || 
	ca.custcode || ';' || 
	tt.amount || ';' || 
	tt.currency || ';' || 
	tt.document_ref || ';' || 
	tt.comments || ';' || 
	tt.handling_reason_code
FROM	sysadm.tstt_payment_file	tt,
	customer_all		ca
WHERE	ca.custnum = tt.customer_ref
AND	tt.file_name = '&1';


SPOOL OFF

SET PAGESIZE 50
SET TERMOUT ON
