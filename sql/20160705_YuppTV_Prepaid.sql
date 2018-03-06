DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160705_YuppTV_Prepaid.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Configuration of the PrePaid YuppTV';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
	v_sncode		PLS_INTEGER;
	c_des			CONSTANT VARCHAR2(100) := 'PrePaid YuppTV Bollywood Basic';
	c_sccode		CONSTANT PLS_INTEGER := 2; -- Event VAS
	c_app_sequence_key	CONSTANT VARCHAR2(30) := 'MAX_SNCODE';
	v_evcode		PLS_INTEGER;
	c_spcode		CONSTANT PLS_INTEGER := 2; -- OCC
	c_tmcode		CONSTANT PLS_INTEGER := 1; -- OCC
   
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

UPDATE  app_sequence_value
SET     next_free_value = next_free_value + 1 
WHERE   app_sequence_id = 
        (
	SELECT  app_sequence_id
	FROM    app_sequence
	WHERE   app_sequence_key = c_app_sequence_key
	)
RETURNING       next_free_value - 1
INTO    v_sncode;

INSERT	INTO mpusntab
	(
	sncode,
	des,
	snind,
	rec_version,
	sntype,
	pde_implicit_ind,
	print_balance_ind,
	billing_ind,
	priority,
	service_offering_id,
	charging_engine_code,
	shdes
	)
VALUES	(
       	v_sncode,
	c_des,
	'N',
	1,
	NULL,
	'N',
	'N',
	'X',
	0,
	1,
	NULL,
	'YUPRE'	
	);

INSERT INTO mpulknxc
	(
	sncode,
	sccode,
	snind,
	rec_version,
	lcm_service_type
	)
VALUES	(
	v_sncode,
	c_sccode,
	'A', 
	1,
	NULL
	);

SELECT	MAX( evcode ) + 1
INTO	v_evcode
FROM	mpdevtab;

INSERT	INTO mpdevtab
	(
	evcode,
	des,
	evcharge,
	scope,
	rf,
	rec_version,
	purpose	
	)
VALUES	(
	v_evcode,
	c_des,
	'A',
	'B',
	'O',
	0,
	NULL
	);

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

INSERT	INTO mpulkpxn
	(
	spcode,
	sncode,
	rec_version
	)
VALUES	(
	c_spcode,
	v_sncode,
	0
	);

INSERT	INTO mpulktm1
	(
	tmcode,
	vscode,
	vsdate,
	status,
	spcode,
	sncode,
	subscript,
	accessfee,
	event,
	echind,
	amtind,
	frqind,
	srvind,
	proind,
	advind,
	susind,
	ltcode,
	plcode,
	billfreq,
	freedays,
	csind,
	clcode,
	accserv_catcode,
	accserv_code,
	accserv_type,
	usgserv_catcode,
	usgserv_code,
	usgserv_type,
	subserv_catcode,
	subserv_code,
	subserv_type,
	deposit,
	interval_type,
	interval,
	pv_combi_id,
	prm_print_ind,
	printsubscrind,
	printaccessind,
	rec_version,
	non_expl_serv_prepaid_ind,
	def_payment_cond_usg,
	def_time_package_usg,
	initial_credit,
	payment_cond_changeable_usg,
	bop_mode_id,
	def_payment_cond_onetime_rec,
	ovw_recur_amount,
	ovw_period_type,
	ovw_period_length,
	service_priority,
	charging_schedule,
	account_id,
	def_type_of_control,
	sub_gl_acc_pack_id,
	acc_gl_acc_pack_id,
	usg_gl_acc_pack_id,
	gl_pack_system_scenario_flag,
	offer_id,
	pam_config_id_main,
	pam_config_id_rec_charge,
	individual_charging,
	charge_period_length,
	wait_period_length,
	custom_individual_chrg
	)
VALUES	(
	c_tmcode,
	0,
	TO_DATE( '01.01.1998', 'DD.MM.YYYY'),
	'W',
	c_spcode,
	v_sncode,
	NULL,
	NULL,
	207,
	'A',
	'C',
	'O',
	'E',
	NULL,
	NULL,
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
	3,
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
	tmcode,
	vscode,
	vsdate,
	status,
	spcode,
	sncode,
	subscript,
	accessfee,
	event,
	echind,
	amtind,
	frqind,
	srvind,
	proind,
	advind,
	susind,
	ltcode,
	plcode,
	billfreq,
	freedays,
	csind,
	clcode,
	accserv_catcode,
	accserv_code,
	accserv_type,
	usgserv_catcode,
	usgserv_code,
	usgserv_type,
	subserv_catcode,
	subserv_code,
	subserv_type,
	deposit,
	interval_type,
	interval,
	pv_combi_id,
	prm_print_ind,
	printsubscrind,
	printaccessind,
	rec_version,
	non_expl_serv_prepaid_ind,
	def_payment_cond_usg,
	def_time_package_usg,
	initial_credit,
	payment_cond_changeable_usg,
	bop_mode_id,
	def_payment_cond_onetime_rec,
	ovw_recur_amount,
	ovw_period_type,
	ovw_period_length,
	service_priority,
	charging_schedule,
	account_id,
	def_type_of_control,
	sub_gl_acc_pack_id,
	acc_gl_acc_pack_id,
	usg_gl_acc_pack_id,
	gl_pack_system_scenario_flag,
	offer_id,
	pam_config_id_main,
	pam_config_id_rec_charge,
	individual_charging,
	charge_period_length,
	wait_period_length,
	custom_individual_chrg
	)
VALUES	(
	c_tmcode,
	1,
	TO_DATE( '01.01.1998', 'DD.MM.YYYY'),
	'P',
	c_spcode,
	v_sncode,
	0,
	207,
	0,
	NULL,
	NULL,
	NULL,
	'P',
	'Y',
	'A',
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
	3,
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
COMMIT;
END;
/
