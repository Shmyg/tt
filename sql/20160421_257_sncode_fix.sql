/*
|| Script to fix sncode = 257 (missing tax categories)
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160421_257_sncode_fix.sql,v $
|| Revision 1.1  2016/04/21 19:28:35  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160421_257_sncode_fix.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Fixes sncode 257';
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

sysadm.migration.startscript
	(
	piosScriptName    => c_filename,
	piosTrack         => c_track,
	piosScriptVersion => c_version,
	piosScriptWhat    => v_mig_script_id,
	piobReentrantInd  => TRUE,
	piosDescription   => c_description
	);

-- Real job here
UPDATE	mpulktmb
SET	ACCSERV_CATCODE = 15,
	ACCSERV_CODE = 15,
	ACCSERV_TYPE = 'ALL',
	USGSERV_CATCODE = 15,
	USGSERV_CODE = 15,
	USGSERV_TYPE = 'ALL',
	SUBSERV_CATCODE = 15,
	SUBSERV_CODE = 15,
	SUBSERV_TYPE = 'ALL'
WHERE	sncode = 257;

UPDATE	mpulktm1
SET	ACCSERV_CATCODE = 15,
	ACCSERV_CODE = 15,
	ACCSERV_TYPE = 'ALL',
	USGSERV_CATCODE = 15,
	USGSERV_CODE = 15,
	USGSERV_TYPE = 'ALL',
	SUBSERV_CATCODE = 15,
	SUBSERV_CODE = 15,
	SUBSERV_TYPE = 'ALL'
WHERE	sncode = 257;

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
