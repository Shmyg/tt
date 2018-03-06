/*
|| Bank details update
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160426_bank_details.sql,v $
|| Revision 1.1  2016/04/26 14:30:18  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160426_bank_details.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_description	CONSTANT VARCHAR2(100) := 'Updates bank details';
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
UPDATE	bank_all
SET	bankcode = 'STT', 
	bankname = 'Scotiabank Trinidad and Tobago',
	bankloc = 'Trinidad and Tobago',
	bankstreet = 'Cor. park and Richmond Street',
	bankcountry = 215,
	swiftcode = 'NOSCTTPS',
	username = 'SYSADM',
	entdate = TRUNC( SYSDATE ),
	moddate = TRUNC( SYSDATE ),
	business_unit_id = 2
WHERE	bank_def = 'X';

-- Finish
sysadm.migration.finishscript ( c_filename );

UPDATE	sysadm.rm_mig_process
SET	release_name = 'PCP-1503',
	level_name = 'CBIO_PCP1503_150728',
	mig_user = c_user
WHERE	script_name = c_filename;
                
END;
/
