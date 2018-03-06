/*
|| Creation of a new promotion mechanism
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: promotion2.sql,v $
|| Revision 1.1  2016/04/15 22:14:45  shmyg
|| Added promotions
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'promotion2.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_script_des	CONSTANT VARCHAR2(100) := 'Creation of a new promotion mechanism';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.13';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id  sysadm.rm_mig_script.mig_script_id%TYPE;
   
	c_shdes			CONSTANT VARCHAR2(10) := 'FBROF2';
	c_description_mech	CONSTANT VARCHAR2(30) := '50% monthly fee off, 1 month';
	c_description		CONSTANT VARCHAR2(30) := '50% monthly fee off, 2 months';
	c_currency_id		CONSTANT PLS_INTEGER := 47;
	c_rule_value		CONSTANT PLS_INTEGER := 50; -- Discount percentage
	c_assign_period		CONSTANT PLS_INTEGER := 2; -- Assignemnt duration

	c_rule_template_id	PLS_INTEGER;
	v_max_item_qual		PLS_INTEGER;
	v_set_id		PLS_INTEGER;
	v_rule_mech_id		PLS_INTEGER;
	v_model_id		PLS_INTEGER;
	v_pack_id		PLS_INTEGER;
	v_element_id		PLS_INTEGER;

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
SELECT	item_qual_id
INTO	v_max_item_qual
FROM	promo_item_qual
WHERE	description = c_description_mech;
  
SELECT	NVL(MAX(rule_mech_id),0) + 1
INTO	v_rule_mech_id
FROM	rule_mech;

-- Application mechanism
INSERT INTO rule_mech
	(
	rule_mech_id,
	short_description,
	description,
	work_state,
	state_date,
	logic_subtype_id,
	rule_purpose_code,
	rec_version
	)
VALUES	(
	v_rule_mech_id, 
	c_shdes,
	c_description,
	'P',
	SYSDATE,
	23,	-- LOGIC_SUBTYPE.DESCRIPTION = 'Apply relative discount'
       	1,
	1
	);

INSERT INTO promo_mech 
	(
	mech_id,
	intval_config,
	start_date,
	end_date,
	period_base_id,
	wait_period,
	activ_period,
	truncated_active_time,
	rec_version
	)
VALUES	(
	v_rule_mech_id,
	'B',
	NULL,
	NULL,
	1,	-- PROMO_PERIOD_BASE.DESCRIPTION = 'Months'
	NULL,
	NULL,
	'Y',
       	1
	);

INSERT	INTO promo_item_qual_to_mech
	(
	mech_id,
	item_qual_id,
	rec_version
	)
VALUES	(
	v_rule_mech_id,
	v_max_item_qual,
	1
	); 

INSERT	INTO rule_mech_config_switch
	(
	rule_mech_id,
	config_type_id,
	config_value_char,
	rec_version
	)
VALUES	(
	v_rule_mech_id,
	1,
	'N',
	1
	);

SELECT	NVL(MAX(rule_element_id),0) + 1
INTO	v_element_id
FROM	rule_element;

INSERT	INTO rule_element
	(
	rule_element_id,
	rule_template_id,
	rule_purpose_code,
	short_description,
	description,
	rec_version
	)
VALUES	(
	v_element_id,
       	21,	-- RULE_TEMPLATE.DESCRIPTION =  1,
	1,
	c_shdes,
	c_description,
	1
	);

INSERT	INTO rule_element_version
	(
	rule_element_id,
	version,
	version_date,
	work_state,
	rec_version
	)
VALUES	(
	v_element_id,
	0,
	TRUNC( SYSDATE ) - 1,
	'W',
	1
	);

INSERT	INTO rule_element_version
	(
	rule_element_id,
	version,
	version_date,
	work_state,
	rec_version
	)
VALUES	(
	v_element_id,
	1,
	TRUNC( SYSDATE ) - 1,
	'P',
	1
	);

INSERT	INTO rule_mech_element
	(
	rule_element_id,
	template_position,
	eval_or_appl,
	rule_mech_id,
	currency,
	rec_version,
	umcode,
	umcode_display,
	version
	)
VALUES	(
	v_element_id,
	1,
	'A',
	v_rule_mech_id,
	c_currency_id,
	1,
	NULL,
	NULL,
	1
	);

INSERT	INTO rule_mech_element
	(
	rule_element_id,
	template_position,
	eval_or_appl,
	rule_mech_id,
	currency,
	rec_version,
	umcode,
	umcode_display,
	version
	)
VALUES	(
	v_element_id,
	0,
	'A',
	v_rule_mech_id,
	c_currency_id,
	1,
	NULL,
	NULL,
	0
	);

INSERT	INTO rule_element_value_work
	(
	rule_element_id,
	version,
	line_num,
	eval_or_appl,
	template_position,
	rule_value,
	rule_value_date,
	rule_value_float,
	rec_version
	)
VALUES	(
	v_element_id,
	1,
	1,
	'A',
	1,
	c_rule_value,
	NULL,
	NULL,
	1
	);

INSERT	INTO rule_element_value
	(
	rule_element_id,
	version,
	line_num,
	eval_or_appl,
	template_position,
	rule_value,
	rule_value_date,
	rule_value_float,
	rec_version
	)
VALUES	(
	v_element_id,
	0,
	1,
	'A',
	1,
	c_rule_value,
	NULL,
	NULL,
	1
	);

SELECT	NVL(MAX(rule_model_id) ,0) + 1
INTO	v_model_id
FROM	rule_model;

INSERT	INTO rule_model
	(
	rule_model_id,
	rule_purpose_code,
	short_description,
	description,
	work_state,
	state_date,
	rec_version
	)
VALUES	(
	v_model_id,
	1,
	c_shdes,
	c_description,
	'P',
	TRUNC( SYSDATE ) - 1,
	1
	);

INSERT	INTO rule_entry
	(
	rule_model_id,
	priority_num,
	rule_element_id,
	rec_version
	)
VALUES	(
	v_model_id,
	1,
	v_element_id,
	1
	);
  
SELECT	NVL(MAX(rule_pack_id),0) + 1
INTO	v_pack_id
FROM	rule_pack;

INSERT	INTO rule_pack
	(
	rule_pack_id,
	rule_purpose_code,
	short_description,
	description,
	work_state,
	state_date,
	rec_version
	)
VALUES	(
	v_pack_id,
	1,		-- RULE_PURPOSE.DESCRIPTION = ' Promotions_Conditional'
       	c_shdes,
	c_description,
	'P',
	TRUNC( SYSDATE ) - 1,
	1
	);

INSERT	INTO promo_pack
	(
	pack_id,
	assign_method_id,
	avail_from,
	avail_to,
	period_base_id,
	assign_period,
	rec_version,
	level_parameter,
	scope
	)
VALUES	(
	v_pack_id,
	2,	-- PROMO_ASSIGN_METHOD (Explicit interactive assignm.)
	NULL,
	NULL,
	1,	-- PROMO_PERIOD_BASE.PERIOD_BASE_ID = 'Months'
	999,
	c_assign_period,	-- assignment period = 1 month
       	'CU',	-- assigned at customer level
	'PR'
	); 

INSERT	INTO rule_model_pack
	(
	rule_model_id,
	rule_pack_id
	)
VALUES	(
	v_model_id,
	v_pack_id
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
