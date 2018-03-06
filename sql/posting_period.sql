/*
|| Posting periods configuration, simply inserts posting periods for 10 years
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: posting_period.sql,v $
|| Revision 1.1  2016/04/13 16:19:57  shmyg
|| Added posting period script
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'posting_period.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_description	CONSTANT VARCHAR2(100) := 'Posting periods configuration';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id  sysadm.rm_mig_script.mig_script_id%TYPE;
   
BEGIN

INSERT	INTO sysadm.rm_mig_script
	(
	mig_script_id,
	mig_script_name
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename 
FROM	sysadm.rm_mig_script
);

SELECT	MAX( mig_script_id )
INTO	v_mig_script_id
FROM	sysadm.rm_mig_script;

SYSADM.Migration.StartScript
	(
	piosScriptName    => c_filename,
	piosTrack         => c_track,
	piosScriptVersion => c_version,
	piosScriptWhat    => v_mig_script_id,
	piobReentrantInd  => TRUE,
	piosDescription   => c_description
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

-- Finish
sysadm.migration.finishscript ( c_filename );

UPDATE	sysadm.rm_mig_process
SET	release_name = 'PCP-1503',
	level_name = 'CBIO_PCP1503_150728',
	mig_user = c_user
WHERE	script_name = c_filename;

COMMIT;
                
END;
/
