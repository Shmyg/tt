/*
|| Inserts missing data for PPV service into MPULKTMM table
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: ppv_service_add.sql,v $
|| Revision 1.1  2016/04/05 20:02:54  shmyg
|| Added template for SQL fixes and a script to fix 528519
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'ppv_service_add.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Insertion of PPV service into MPULKTMM';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '528519';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
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

-- Main part
INSERT	INTO	mpulktmm
	(
	tmcode,
	vscode,
	vsdate,
	status,
	spcode,
	sncode,
	svlcode,
	rateind,
	upcode,
	ricode,
	rec_version,
	usage_type_id
	)
(
SELECT	tmcode,
	vscode,
	vsdate,
	status,
	spcode,
	sncode,
	'GSMT40B*****S***',
	'N',
	3,
	2,
	1,
	4
FROM	mpulktmb
WHERE	sncode = 382
AND	status = 'P'
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
