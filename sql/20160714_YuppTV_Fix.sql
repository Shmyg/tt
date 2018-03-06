DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160714_YuppTV_Fix.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Fix of MPULKTMB for YuppTV';
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
	c_shdes			CONSTANT VARCHAR2(30) := 'YUPRE';
   
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

SELECT	sncode
INTO    v_sncode
FROM	mpusntab
WHERE	shdes = c_shdes;

DELETE	FROM mpulktmb
WHERE	sncode = v_sncode;

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
(
SELECT	tmcode,
	1,
	vsdate,
	'P',
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
	NULL,
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
	14,
	14,
	37,
	gl_pack_system_scenario_flag,
	offer_id,
	pam_config_id_main,
	pam_config_id_rec_charge,
	individual_charging,
	charge_period_length,
	wait_period_length,
	custom_individual_chrg
FROM	mpulktm1
WHERE	sncode = v_sncode
);

COMMIT;
END;
/
