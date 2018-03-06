/*
|| Adds service #137 to the right offer
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 137_sncode_config.sql,v $
|| Revision 1.1  2016/04/21 19:28:35  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '137_sncode_config.sql';
	c_version	CONSTANT VARCHAR2(3) := '1';
	c_description	CONSTANT VARCHAR2(100) := 'Insertion of Internet FTTH 5MB service into Fiber $399 offer';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
	c_sncode	CONSTANT PLS_INTEGER := 137;
	c_spcode	CONSTANT PLS_INTEGER := 47;
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

INSERT	INTO mpulktm1
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
	ECHIND,
	AMTIND,
	FRQIND,
	SRVIND,
	PROIND,
	ADVIND,
	SUSIND,
	LTCODE,
	PLCODE,
	BILLFREQ,
	FREEDAYS,
	CSIND,
	CLCODE,
	ACCSERV_CATCODE,
	ACCSERV_CODE,
	ACCSERV_TYPE,
	USGSERV_CATCODE,
	USGSERV_CODE,
	USGSERV_TYPE,
	SUBSERV_CATCODE,
	SUBSERV_CODE,
	SUBSERV_TYPE,
	DEPOSIT,
	INTERVAL_TYPE,
	INTERVAL,
	PV_COMBI_ID,
	PRM_PRINT_IND,
	PRINTSUBSCRIND,
	PRINTACCESSIND,
	REC_VERSION,
	NON_EXPL_SERV_PREPAID_IND,
	DEF_PAYMENT_COND_USG,
	DEF_TIME_PACKAGE_USG,
	INITIAL_CREDIT,
	PAYMENT_COND_CHANGEABLE_USG,
	BOP_MODE_ID,
	DEF_PAYMENT_COND_ONETIME_REC,
	OVW_RECUR_AMOUNT,
	OVW_PERIOD_TYPE,
	OVW_PERIOD_LENGTH,
	SERVICE_PRIORITY,
	CHARGING_SCHEDULE,
	ACCOUNT_ID,
	DEF_TYPE_OF_CONTROL,
	SUB_GL_ACC_PACK_ID,
	ACC_GL_ACC_PACK_ID,
	USG_GL_ACC_PACK_ID,
	GL_PACK_SYSTEM_SCENARIO_FLAG,
	OFFER_ID,
	PAM_CONFIG_ID_MAIN,
	PAM_CONFIG_ID_REC_CHARGE,
	INDIVIDUAL_CHARGING,
	CHARGE_PERIOD_LENGTH,
	WAIT_PERIOD_LENGTH,
	CUSTOM_INDIVIDUAL_CHRG
	)
VALUES	(
	c_tmcode,
	0,
	'01.01.1998',
	'W',
	c_spcode,
	c_sncode,
	0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	'P',
	'Y',
	'P',
	'N',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	15,
	15,
	'ALL',
	NULL,
	NULL,
	NULL,
	15,
	15,
	'ALL',
	NULL,
	'M',
	1,
	NULL,
	'N',
	'N',
	'N',
	1,
	NULL,
	1,
	NULL,
	NULL,
	NULL,
	NULL,
	1,
	NULL,
	NULL,
	NULL,
	1,
	'B',
	NULL,
	NULL,
	1,
	1,
	1,
	'X',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
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
	ECHIND,
	AMTIND,
	FRQIND,
	SRVIND,
	PROIND,
	ADVIND,
	SUSIND,
	LTCODE,
	PLCODE,
	BILLFREQ,
	FREEDAYS,
	CSIND,
	CLCODE,
	BILL_FMT,
	ACCSERV_CATCODE,
	ACCSERV_CODE,
	ACCSERV_TYPE,
	USGSERV_CATCODE,
	USGSERV_CODE,
	USGSERV_TYPE,
	SUBSERV_CATCODE,
	SUBSERV_CODE,
	SUBSERV_TYPE,
	DEPOSIT,
	INTERVAL_TYPE,
	INTERVAL,
	PV_COMBI_ID,
	PRM_PRINT_IND,
	PRINTSUBSCRIND,
	PRINTACCESSIND,
	REC_VERSION,
	NON_EXPL_SERV_PREPAID_IND,
	DEF_PAYMENT_COND_USG,
	DEF_TIME_PACKAGE_USG,
	INITIAL_CREDIT,
	PAYMENT_COND_CHANGEABLE_USG,
	BOP_MODE_ID,
	DEF_PAYMENT_COND_ONETIME_REC,
	OVW_RECUR_AMOUNT,
	OVW_PERIOD_TYPE,
	OVW_PERIOD_LENGTH,
	SERVICE_PRIORITY,
	CHARGING_SCHEDULE,
	ACCOUNT_ID,
	DEF_TYPE_OF_CONTROL,
	SUB_GL_ACC_PACK_ID,
	ACC_GL_ACC_PACK_ID,
	USG_GL_ACC_PACK_ID,
	GL_PACK_SYSTEM_SCENARIO_FLAG,
	OFFER_ID,
	PAM_CONFIG_ID_MAIN,
	PAM_CONFIG_ID_REC_CHARGE,
	INDIVIDUAL_CHARGING,
	CHARGE_PERIOD_LENGTH,
	WAIT_PERIOD_LENGTH,
	CUSTOM_INDIVIDUAL_CHRG
	)
VALUES	(
	c_tmcode,
	1,
	'01.01.1998',
	'P',
	c_spcode,
	c_sncode,
	0,
	0,
	0,
	NULL,
	NULL,
	NULL,
	'P',
	'Y',
	'P',
	'N',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	15,
	15,
	'ALL',
	NULL,
	NULL,
	NULL,
	15,
	15,
	'ALL',
	NULL,
	'M',
	1,
	NULL,
	'N',
	'N',
	'N',
	1,
	NULL,
	1,
	NULL,
	NULL,
	NULL,
	NULL,
	1,
	NULL,
	NULL,
	NULL,
	1,
	'B',
	NULL,
	NULL,
	1,
	1,
	1,
	'X',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
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
