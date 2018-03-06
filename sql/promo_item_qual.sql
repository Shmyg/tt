/*
|| Creation of promotion qualifer
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: promo_item_qual.sql,v $
|| Revision 1.1  2016/04/15 22:14:45  shmyg
|| Added promotions
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'promo_item_qual.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_script_des	CONSTANT VARCHAR2(100) := 'Creation of promotion qualifier';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.9';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id  sysadm.rm_mig_script.mig_script_id%TYPE;
   
	c_tmcode		CONSTANT PLS_INTEGER := 3;
	c_description		CONSTANT VARCHAR2(30) := '50% monthly fee off, 1 month';
	c_shdes			CONSTANT VARCHAR2(10) := 'FBROF';
	c_rule_template_id	PLS_INTEGER;
	v_max_item_qual		PLS_INTEGER;
	v_set_id		PLS_INTEGER;

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
	piosDescription   => c_script_des
	);

-- Real job here
SELECT	NVL( MAX( item_qual_id ), 0 ) + 1
INTO	v_max_item_qual
FROM	promo_item_qual;
  
INSERT	INTO promo_item_qual
	(
	item_qual_id,
	short_description,
	description,
	state_dependent,
	rec_version,
	rule_purpose_code
	)
VALUES	(
	v_max_item_qual,
	c_shdes,
	c_description,
	'Y',
	1,
	1
	);
				  
INSERT	INTO promo_item_qual_version 
	(
	item_qual_id,
	version,
	version_date,
	work_state,
	state_date,
	check_code,
	rec_version
	)
VALUES	(
	v_max_item_qual,
	0,
	TRUNC( SYSDATE ) - 1,
	'W',
	TRUNC( SYSDATE ) - 1,
	NULL,
	1
	);

INSERT	INTO promo_item_qual_version 
	(
	item_qual_id,
	version,
	version_date,
	work_state,
	state_date,
	check_code,
	rec_version
	)
VALUES	(
	v_max_item_qual,
	1,
	TRUNC( SYSDATE ) - 1,
	'P',
	TRUNC( SYSDATE ) - 1,
	NULL,
	1
	);

SELECT	NVL(MAX(item_qual_set_id),0) + 1
INTO	v_set_id
FROM	promo_item_qual_set;

INSERT	INTO promo_item_qual_set_work
	(
	item_qual_set_id,
	item_qual_id,
	version,
	item_qual_set_type_id,
	short_description,
	description,
	rec_version
	)
VALUES	(
	v_set_id,
	v_max_item_qual,
	0,
	2, -- promo_item_qual_set_type (Qualifying all accessible data)
	c_shdes,
	c_description,
	1
	);

INSERT	INTO promo_item_qual_set
	(
	item_qual_set_id,
	item_qual_id,
	version,
	item_qual_set_type_id,
	short_description,
	description,
	rec_version
	)
VALUES	(
	v_set_id,
	v_max_item_qual,
	1,
	2, -- promo_item_qual_set_type (Qualifying all accessible data)
	c_shdes,
	c_description,
	1
	);

INSERT	INTO promo_item_qual_data_work
	(
	item_qual_set_id,
	item_qual_id,
	version,
	item_qual_detail_id,
	detail_value,
	rec_version,
	seqno,
	operator_id
	)
VALUES	(
	v_set_id,
	v_max_item_qual,
	0,
	7,	-- PROMO_PROP.DESCRIPTION = 'Charge type'
	2,	-- Don't know where it comes from
	1,
	1,
	1
	);

INSERT	INTO promo_item_qual_data
	(
	item_qual_set_id,
	item_qual_id,
	version,
	item_qual_detail_id,
	detail_value,
	rec_version,
	seqno,
	operator_id
	)
VALUES	(
	v_set_id,
	v_max_item_qual,
	1,
	7,
	2,
	1,
	1,
	1
	);

-- Finish
sysadm.migration.finishscript ( c_filename );

UPDATE	sysadm.rm_mig_process
SET	release_name = 'PCP-1503',
	level_name = 'CBIO_PCP1503_150728',
	mig_user = c_user
WHERE	script_name = c_filename;
                
END;
/
