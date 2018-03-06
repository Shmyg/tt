/*
|| Posting periods configuration, simply inserts posting periods for 10 years
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160601_posting_period.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160601_posting_period.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Posting periods configuration';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_author	CONSTANT VARCHAR2(30) := 'SHMYG';
   
BEGIN

INSERT	INTO sysadm.rm_mig_script
	(
	mig_script_id,
	mig_script_name,
	des,
	author,
	bug_id
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename,
	c_description,
	c_author,
	c_bug_id
FROM	sysadm.rm_mig_script
);

-- Real job here
UPDATE	postperiod_all
SET	ppenddate = LAST_DAY ( SYSDATE ),
	PPARCURMTH = 'X';

INSERT	INTO postperiod_all
	(
	ppperiod,
	pparmonth,
	pparyear,
	pparcurmth,
	ppglmonth,
	ppglyear,
	ppglcurmth,
	ppsrtdate,
	ppenddate,
	ppdesc,
	ppentdate,
	ppmoddate,
	ppmod,
	rec_version
	)
(
SELECT	TO_CHAR(mn, 'YYYYMM'),
	TO_CHAR(mn, 'MM'),
	TO_CHAR(mn, 'YYYY'),
	'C',
	TO_CHAR(mn, 'MM'),
	TO_CHAR(mn, 'YYYY'),
	'C',
	mn,
	LAST_DAY( mn ),
	TO_CHAR( mn, 'Mon YYYY'),
	TRUNC( SYSDATE ),
	TRUNC( SYSDATE ),
	NULL,
	0
FROM	(
	SELECT	ADD_MONTHS(TRUNC(SYSDATE, 'MM'), LEVEL) AS mn
	FROM	DUAL
	CONNECT	BY LEVEL < 121
	)
);

COMMIT;
                
END;
/
