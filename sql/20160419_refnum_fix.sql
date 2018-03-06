/*
|| Script to fix reference numbering for everything
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160419_refnum_fix.sql,v $
|| Revision 1.1  2016/04/21 19:28:35  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20140419_refnum_fix.sql';
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
UPDATE  refnum_version
SET     refnum_suffix = refnum_prefix,
	refnum_prefix = 'TT';

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
