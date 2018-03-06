/*
|| Report providing payments linked to invoice lines
|| Requested by TSTT as a part of their financial reporting
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: payment_by_gl.sql,v $
|| Revision 1.1  2016/09/07 12:56:46  shmyg
|| *** empty log message ***
||
|| Revision 1.1.1.1  2005-06-07 11:16:08  serge
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
SET DEFINE &

BREAK ON caxact SKIP 1
COMP SUM of otmerch_gl ON caxact
COMP SUM of otmerch_gross_gl ON caxact

COLUMN begin_date new_val start_date
SELECT  TO_CHAR( SYSDATE, 'YYYYMMDDHH24MI' ) begin_date
FROM    DUAL; 


SPOOL payment_gl_&&start_date..txt

SELECT	ca.caxact,
	ca.cachkamt_gl,
	oh.ohinvamt_gl,
	oh.ohentdate,
	ot.otmerch_gl,
	ot.otmerch_gross_gl,
	ot.otglsale
FROM	cashreceipts_all	ca,
	cashdetail		cd,
	orderhdr_all		oh,
	ordertrailer		ot
WHERE	ca.caxact = cd.cadxact
AND	cd.cadoxact = oh.ohxact
AND	oh.ohxact = ot.otxact
AND	oh.ohstatus = 'IN'
AND	ca.cachkamt_gl = oh.ohinvamt_gl
ORDER	BY 1, 3;
--AND	ca.caentdate >= TRUNC( SYSDATE )
--AND	ca.caentdate < TRUNC( SYSDATE ) + 1;

SPOOL OFF

SET PAGESIZE 50
SET TERMOUT ON
