DECLARE
	v_sncode	PLS_INTEGER;
	v_service_des	VARCHAR2(100) := 'Extension - Residential';
	v_service_shdes	VARCHAR2(6) := 'EXTRE';
	c_spcode	CONSTANT PLS_INTEGER := 85;
	c_tmcode	CONSTANT PLS_INTEGER := 3;
	v_parameter_id	PLS_INTEGER := 68;

BEGIN

UPDATE  app_sequence_value
SET     next_free_value = next_free_value + 1 
WHERE   app_sequence_id = 
        (
	SELECT  app_sequence_id
	FROM    app_sequence
	WHERE   app_sequence_key = 'MAX_SNCODE'
	)
RETURNING       next_free_value - 1
INTO    v_sncode;

INSERT 	INTO mpusntab 
	(
	sncode,
	des,
	shdes,
	snind,
	rec_version,
	sntype,
	pde_implicit_ind,
	print_balance_ind,
	billing_ind,
	priority,
	service_offering_id,
	charging_engine_code
	)
VALUES	(
	v_sncode,
	v_service_des,
	v_service_shdes,
	'Y',
	0,
	NULL,
	'N',
	'N',
	'X',
	0,
	NULL,
	NULL
	);

INSERT	INTO mpulknxc
	(
	sncode,
	sccode,
	snind,
	rec_version,
	lcm_service_type
	)
VALUES	(
	v_sncode,
	1,
	'V',
	1,
	''
	);


INSERT	INTO mpulknxv
	(
	sncode,
	s1code,
	s2code,
	sscode,
	svlcode,
	snmml,
	associate_ports,
	port_npcode,
	dirnum_npcode,
	associate_dn,
	quantity_ind,
	associate_cug,
	rating_ind,
	vas_mapping_flag,
	srv_type,
	srv_subtype,
	switch_auditing_flag,
	prepaid_supported,
	rscode,
	provisioning_int_flag,
	rec_version
	)
VALUES	(
	v_sncode,
	1,
	1,
	'459',
	'GSMT**B*****SEE*',
	'N',
	'N',
	'',
	'',
	'N',
	'N',
	'N',
	'N',
	'',
	'V',
	'A',
	'',
	'',
	'',
	'',
	1
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
	1
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
	bill_fmt,
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
	TO_DATE( '01.01.1998', 'DD.MM.YYYY' ),
	'P',
	c_spcode,
	v_sncode,
	0,
	6,
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
	103,
	104,
	58,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
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
	TO_DATE( '01.01.1998', 'DD.MM.YYYY' ),
	'W',
	c_spcode,
	v_sncode,
	0,
	6,
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
	103,
	104,
	58,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
	);

UPDATE	mpulktm1
SET	prm_print_ind = 'Y',
	pv_combi_id = '1'
WHERE	tmcode = c_tmcode
AND	spcode = c_spcode
AND	sncode = v_sncode;

UPDATE	mpulktmb
SET	prm_print_ind = 'Y',
	pv_combi_id = '1'
WHERE	tmcode = c_tmcode
AND	spcode = c_spcode
AND	sncode = v_sncode;

INSERT	INTO mpulkpv1
	(
	pv_combi_id,
	vscode,
	set_id,
	des,
	subscript,
	accessfee,
       	rec_version
	)
VALUES	(
	1,
	0,
	1,
	'Number of lines',
	0,
	6,
	1
	);

INSERT	INTO mpulkpv2
	( 
	pv_combi_id,
	vscode,
	set_id,
	sccode, 
	parameter_id,
	prm_value_des,
	prm_value_number, 
	prm_value_date,
	prm_value_string,
	lower_threshold, 
	rec_version
	)
VALUES	(
	1,
	0,
	1,
	1, 
	68,
	'',
	1,
	'',
	'',
	1, 
	1
	);

END;
/
