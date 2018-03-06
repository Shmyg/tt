/*
|| Adds service #136 to the right offer
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 136_sncode_config.sql,v $
|| Revision 1.1  2016/04/06 17:59:06  shmyg
|| One more fix
||
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '136_service_config.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Insertion of Fiber $229 service into Fiber $299 offer';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '529462';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
	c_sncode	CONSTANT PLS_INTEGER := 136;
	c_spcode	CONSTANT PLS_INTEGER := 46;
	c_tmcode	CONSTANT PLS_INTEGER := 3;

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
INSERT	INTO mpulkpxn
	(
	spcode,
	sncode,
	rec_version
	)
VALUES	(
	c_spcode,
	c_sncode,
	1
	);

INSERT	INTO mpulktmb
	(
	TMCODE,
	VSCODE,
	VSDATE,
	STATUS,
	SPCODE,
	SNCODE,
	SUBSCRIPT,
	ACCESSFEE,
	EVENT,
	SRVIND,
	PROIND,
	ADVIND,
	SUSIND,
	ACCSERV_CATCODE,
	ACCSERV_CODE,
	ACCSERV_TYPE,
	SUBSERV_CATCODE,
	SUBSERV_CODE,
	SUBSERV_TYPE,
	INTERVAL_TYPE,
	INTERVAL,
	PRM_PRINT_IND,
	PRINTSUBSCRIND,
	PRINTACCESSIND,
	REC_VERSION,
	DEF_PAYMENT_COND_USG,
	DEF_PAYMENT_COND_ONETIME_REC,
	SERVICE_PRIORITY,
	CHARGING_SCHEDULE,
	SUB_GL_ACC_PACK_ID,
	ACC_GL_ACC_PACK_ID,
	USG_GL_ACC_PACK_ID,
	GL_PACK_SYSTEM_SCENARIO_FLAG
	)
VALUES	(
	c_tmcode,
	1,
	TO_DATE('01.01.1998','dd.mm.yyyy'),
	'P',
	c_spcode,
	c_sncode,
	0,
	0,
	0,
	'P',
	'Y',
	'P',
	'N',
	15,
	15,
	'ALL',
	15,
	15,
	'ALL',
	'M',
	1,
	'N',
	'N',
	'N',
	1,
	1,
	1,
	1,
	'B',
	1,
	1,
	1,
	'X'
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
