/*
|| Script to collect 'expired' deposit and prepare PIH file to process them
|| TSTT project, Deposit Cancellation functionality
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: find_deposits.sql,v $
|| Revision 1.2  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/04/11 15:28:41  shmyg
|| Added first version of deposit return script
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


SPOOL PIHPI&&start_date..txt

SELECT	'CE2DP;Y;' || ca.cachknum || ';' || TO_CHAR(ca.cachkdate,'DD.MM.YYYY') || ';' || cu.custcode ||
	';;;;' || 'Deposit refund' || ';' || ca.cachkamt_gl
FROM	cashreceipts_all	ca,
	customer_all		cu
WHERE	ca.customer_id = cu.customer_id
AND	ca.catype = 10
AND	ca.careasoncode = 3
AND	ca.caentdate <= TRUNC(SYSDATE) - 180
/

SPOOL OFF
