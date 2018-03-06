/*
|| Fixes BLIN2 service
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160501_BLIN2_fix.sql,v $
|| Revision 1.1  2016/05/02 01:11:58  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160501_BLIN2_fix.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Fix of BLIN2 service';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.13';
	c_bug_id	CONSTANT PLS_INTEGER := '533121';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
	c_shdes		CONSTANT VARCHAR2(10) := 'BLIN2';
	c_des		CONSTANT VARCHAR2(100) := 'Blink Ent. Installation Add. Outlet (Res)';
	v_sncode	PLS_INTEGER;
	v_evcode	PLS_INTEGER;
	c_price		CONSTANT NUMBER := 86.96;

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
UPDATE	mpulktm1
SET	subscript = NULL,
	accessfee = NULL,
	event = c_price,
	echind = 'A',
	amtind = 'C',
	frqind = 'O',
	srvind = 'E',
	proind = NULL,
	advind = NULL,
	susind = NULL
WHERE	sncode =
	(
	SELECT	sncode
	FROM	mpusntab
	WHERE	shdes = c_shdes
	);

UPDATE	mpulktmb
SET	subscript = NULL,
	accessfee = NULL,
	event = c_price,
	echind = 'A',
	amtind = 'C',
	frqind = 'O',
	srvind = 'E',
	proind = NULL,
	advind = NULL,
	susind = NULL
WHERE	sncode =
	(
	SELECT	sncode
	FROM	mpusntab
	WHERE	shdes = c_shdes
	);

SELECT	sncode
INTO	v_sncode
FROM	mpusntab
WHERE	shdes = c_shdes;
	
SELECT	evcode
INTO	v_evcode
FROM	mpdevtab
WHERE	des = c_des;

INSERT	INTO mpulkexn
	(
	evcode,
	sncode,
	rec_version
	)
VALUES	(
	v_evcode,
	v_sncode,
	0
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
