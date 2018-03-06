/*
|| Bugfix for 549260 
||
|| $Log: 20160630_Phani_Rating_PPB_Mapping.sql,v $
|| Revision 1.1  2016/07/05 16:50:55  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160630_Phani_Rating_PPB_Mapping.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Mapping PPB service to Fiber $699';
	c_bug_id	CONSTANT PLS_INTEGER := '549260';
	c_user		CONSTANT VARCHAR2(30) := 'PHANI';
	v_mig_script_id PLS_INTEGER;
	
	v_spcode PLS_INTEGER;
	v_sncode PLS_INTEGER;
	v_svlcode varchar2(16) := 'GSMTP1B*****S***';
	v_vdate date := TO_DATE('01/01/1998 00:00:00', 'MM/DD/YYYY HH24:MI:SS');
   
BEGIN

INSERT	INTO sysadm.rm_mig_script
	(
	mig_script_id,
	mig_script_name,
	des,
	author,
	bug_id
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename,
	c_description,
	c_user,
	c_bug_id
FROM	sysadm.rm_mig_script
);

-- Real job here

SELECT SNCODE INTO V_SNCODE FROM MPUSNTAB WHERE SHDES = 'PPB01';

SELECT SPCODE INTO V_SPCODE FROM MPUSPTAB WHERE SHDES = 'IPTB5';

Insert into MPULKPXN
   (SPCODE, SNCODE, REC_VERSION)
 Values
   (v_spcode, v_sncode, 0);


Insert into MPULKTM2
   (TMCODE, VSCODE, VSDATE, STATUS, SPCODE, SNCODE, SVLCODE, RATEIND, UPCODE, RICODE, REC_VERSION, USAGE_TYPE_ID)
 Values
   (3, 0,v_vdate, 'W', v_spcode, v_sncode, v_svlcode, 'N', 3, 10, 1, 4);

Insert into MPULKTMM
   (TMCODE, VSCODE, VSDATE, STATUS, SPCODE, SNCODE, SVLCODE, RATEIND, UPCODE, RICODE, REC_VERSION, USAGE_TYPE_ID)
 Values
   (3, 1, v_vdate, 'P', v_spcode, v_sncode, v_svlcode, 'N', 3, 10, 1, 4);



Insert into MPULKTM1
   (TMCODE, VSCODE, VSDATE, STATUS, SPCODE, SNCODE, SUBSCRIPT, ACCESSFEE, EVENT, SRVIND, PROIND, ADVIND, SUSIND, ACCSERV_CATCODE, ACCSERV_CODE, ACCSERV_TYPE, SUBSERV_CATCODE, SUBSERV_CODE, SUBSERV_TYPE, INTERVAL_TYPE, INTERVAL, PRM_PRINT_IND, PRINTSUBSCRIND, PRINTACCESSIND, REC_VERSION, DEF_PAYMENT_COND_USG, DEF_PAYMENT_COND_ONETIME_REC, SERVICE_PRIORITY, CHARGING_SCHEDULE, SUB_GL_ACC_PACK_ID, ACC_GL_ACC_PACK_ID, USG_GL_ACC_PACK_ID, GL_PACK_SYSTEM_SCENARIO_FLAG)
 Values
   (3, 0, v_vdate, 'W', v_spcode, v_sncode, 0, 0, 0, 'P', 'Y', 'P', 'N', '15', '15', 'ALL', '15', '15', 'ALL', 'M', 1, 'N', 'N', 'N', 1, 1, 1, 1, 'B', 1, 1, 1, 'X');

Insert into MPULKTMB
   (TMCODE, VSCODE, VSDATE, STATUS, SPCODE, SNCODE, SUBSCRIPT, ACCESSFEE, EVENT, SRVIND, PROIND, ADVIND, SUSIND, ACCSERV_CATCODE, ACCSERV_CODE, ACCSERV_TYPE, SUBSERV_CATCODE, SUBSERV_CODE, SUBSERV_TYPE, INTERVAL_TYPE, INTERVAL, PRM_PRINT_IND, PRINTSUBSCRIND, PRINTACCESSIND, REC_VERSION, DEF_PAYMENT_COND_USG, DEF_PAYMENT_COND_ONETIME_REC, SERVICE_PRIORITY, CHARGING_SCHEDULE, SUB_GL_ACC_PACK_ID, ACC_GL_ACC_PACK_ID, USG_GL_ACC_PACK_ID, GL_PACK_SYSTEM_SCENARIO_FLAG)
 Values
   (3, 1, v_vdate, 'P', v_spcode, v_sncode, 0, 0, 0, 'P', 'Y', 'P', 'N', '15', '15', 'ALL', '15', '15', 'ALL', 'M', 1, 'N', 'N', 'N', 1, 1, 1, 1, 'B', 1, 1, 1, 'X');




COMMIT;

END;
/
