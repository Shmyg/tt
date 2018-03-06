/*
|| Script to fix reference numbering for everything
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: refnum_fix.sql,v $
|| Revision 1.1  2016/04/08 21:16:53  shmyg
|| Script for reference numbers added
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'refnum_fix.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Fixes reference numbers for invoices';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '529526';
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
DELETE	FROM refnum_value
WHERE	(refnum_id, period_cnt) IN
	(
	SELECT	refnum_id,
		period_cnt 
	FROM	refnum_period	rp
	WHERE	refnum_id in (15, 16, 22)
	AND	period_start_date !=
		(
		SELECT	max(period_start_date)
	       	FROM	refnum_period
	       	WHERE	refnum_id = rp.refnum_id
		)
	);
	
DELETE	FROM refnum_period rp
WHERE 	refnum_id in (15, 16, 22)
AND	period_start_date !=
	(
	SELECT	max(period_start_date)
	FROM	refnum_period
	WHERE	refnum_id = rp.refnum_id
	);

UPDATE	refnum_version
SET	refnum_prefix =
	(
	SELECT	SUBSTR(reference_char_condition ||
		SUBSTR(UPPER(refnum_access_des), 1, 3), 1, 5)
	FROM	refnum_access
	WHERE	refnum_id = refnum_version.refnum_id
	);

DELETE	FROM dr_documents;
DELETE	FROM bgh_bill_image_ref;

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
