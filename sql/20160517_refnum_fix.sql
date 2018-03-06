/*
|| Script to fix reference numbering for everything
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160517_refnum_fix.sql,v $
|| Revision 1.1  2016/06/08 15:31:55  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160517_refnum_fix.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Fixes reference numbers for invoices';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.13';
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
execute immediate 'ALTER TABLE sysadm.refnum_value DISABLE CONSTRAINT fk_refval_refper';

UPDATE	refnum_base
SET	refnum_maintenance_type = 'A',
	range_autoextension_type = 'A',
	business_unit_ind = 'Y';

DELETE	FROM refnum_value
WHERE	(refnum_id, period_cnt) IN
	(
	SELECT	refnum_id,
		period_cnt 
	FROM	refnum_period	rp
	WHERE	period_start_date !=
		(
		SELECT	max(period_start_date)
	       	FROM	refnum_period
	       	WHERE	refnum_id = rp.refnum_id
		)
	);

DELETE	FROM refnum_period rp
WHERE 	period_start_date !=
	(
	SELECT	max(period_start_date)
	FROM	refnum_period
	WHERE	refnum_id = rp.refnum_id
	);

UPDATE	refnum_value
SET	refnum_version = 1,
	period_cnt = 1,
	range_cnt = 1,
	range_active_ind = 'Y',
	last_reference_date = TO_DATE('01.01.2016', 'DD.MM.YYYY'),
	next_ref_value =  1,
	rec_version = 0;

UPDATE	refnum_period
SET	refnum_version = 1,
	period_cnt = 1,
	period_start_date = TO_DATE('01.01.2016', 'DD.MM.YYYY'),
	period_active_ind = 'Y',
	rec_version = 0;

UPDATE	refnum_version
SET	period_type = 'N';

execute immediate 'ALTER TABLE sysadm.refnum_value ENABLE CONSTRAINT fk_refval_refper';

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
