/*
|| Script created as a part of clean-up procedure for Ericsson TSTT project
|| Deactivates active and suspended contracts associated to the list of
|| directory numbers from TEST_DN table
|| Workflow is identical to the SOI command CONTRACT.WRITE(CO_STATUS=4)
|| Status of all directory numbers is set to 'r' so they're available for reuse
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: deactivate_contracts.sql,v $
|| Revision 1.5  2016/05/02 22:35:03  shmyg
|| Added pending request verification for cleanup
||
|| Revision 1.4  2016/05/02 02:11:41  shmyg
|| Fixed bloody error causing PK violation in CMS
||
|| Revision 1.3  2016/04/01 19:06:31  shmyg
|| Truly the first production release
||
*/

DECLARE
	v_co_id			PLS_INTEGER;
	v_customer_id		PLS_INTEGER;
	v_co_code		VARCHAR2(100);
	c_app_sequence_key_tck 	CONSTANT VARCHAR2(100) := 'MAX_TICKLER_NUMBER';
	c_app_sequence_key_req	CONSTANT VARCHAR2(100) := 'MAX_REQUEST';
	c_app_sequence_key_prs	CONSTANT VARCHAR2(100) := 'PR_SERV_STATUS_HISTNO';
	c_app_sequence_key_trx	CONSTANT VARCHAR2(100) := 'PR_SERV_TRANS_NO';
	v_next_free_value_tck	PLS_INTEGER;
	v_next_free_value_req	PLS_INTEGER;
	v_next_free_value_prs	PLS_INTEGER;
	v_next_free_value_trx	PLS_INTEGER;
	c_username		CONSTANT VARCHAR2(100) := 'ADMX';
BEGIN

FOR	contracts IN
	(
	SELECT	DISTINCT cs.co_id
	FROM	contr_services_cap	cs,
		directory_number	dn,
		test_dn			td,
		contract_history	ch
	WHERE	cs.dn_id = dn.dn_id
	AND	dn.dn_num = td.dn_num
	AND	ch.co_id = cs.co_id
	AND	ch.ch_status IN ( 'a', 's' )
	AND	ch.ch_seqno =
		(
		SELECT	MAX( ch_seqno )
		FROM	contract_history
		WHERE	co_id = ch.co_id
		)
	AND	NOT EXISTS
		(
		SELECT	*
		FROM	mdsrrtab
		WHERE	co_id = cs.co_id
		)
	)
LOOP
	
v_co_id := contracts.co_id;

SELECT	customer_id,
	co_code
INTO	v_customer_id,
	v_co_code
FROM	contract_all
WHERE	co_id = v_co_id;

UPDATE	contract_all
SET	co_userlastmod = c_username,
	co_moddate = sysdate,
	rec_version = rec_version + 1
WHERE	co_id = v_co_id;

UPDATE	app_sequence_value
SET	next_free_value = next_free_value + 1 
WHERE	app_sequence_id = 
	(
	SELECT	app_sequence_id
	FROM	app_sequence
	WHERE	app_sequence_key = c_app_sequence_key_tck
	)
RETURNING	next_free_value - 1
INTO	v_next_free_value_tck;

UPDATE	app_sequence_value
SET	next_free_value = next_free_value + 1 
WHERE	app_sequence_id = 
	(
	SELECT	app_sequence_id
	FROM	app_sequence
	WHERE	app_sequence_key = c_app_sequence_key_req
	)
RETURNING	next_free_value - 1
INTO	v_next_free_value_req;

UPDATE	app_sequence_value
SET	next_free_value = next_free_value + 1 
WHERE	app_sequence_id = 
	(
	SELECT	app_sequence_id
	FROM	app_sequence
	WHERE	app_sequence_key = c_app_sequence_key_trx
	)
RETURNING	next_free_value - 1
INTO	v_next_free_value_trx;

INSERT	INTO TICKLER_RECORDS
	(
	tickler_number,
	tickler_code,
	tickler_status,
	priority,
	rec_version,
	short_description,
	long_description,
	created_date,
	customer_id,
	created_by,
	follow_up_status,
	co_id
	)
VALUES (
	v_next_free_value_tck,
	'SYSTEM',
	'NOTE',
	4,
	1,
	'CO STATUS CHANGED',
	'Contract No.:CONTR00000000' || v_co_id || '
	Status:Suspended -> Deactive
	Reason:deactivation
	Request:' || v_next_free_value_req,
	SYSDATE,
	v_customer_id,
	c_username,
	'N',
	v_co_id
	);

INSERT	INTO gmd_request_base
	(
	request_id,
	entry_date
	)
VALUES	(
	v_next_free_value_req,
	SYSDATE
	);

INSERT	INTO MDSRRTAB
	(
	request,
	status,
	priority,
	parent_request,
	vmd_retry,
	error_retry,
	request_update,
	worker_pid,
	ts,
	insert_date,
	action_date,
	userid,
	switch_id,
	action_id,
	error_code,
	initiator_id,
	sccode,
	customer_id,
	plcode,
	co_id
	)
 VALUES (
	v_next_free_value_req,
	2,
	10,
	null,
	0,
	0,
	null,
	0,
	SYSDATE,
	SYSDATE,
	SYSDATE, 
	'ADMX', 
	'BYPASS',
	5,
	0,
	1,
	1,
	v_customer_id,
	1001,
	v_co_id
	);

UPDATE	directory_number_view
SET	dn_status_requ = 'd',
	dn_status_mod_date = SYSDATE,
	dn_moddate = SYSDATE,
	rec_version =  rec_version + 1
WHERE	dn_id IN
	(
	SELECT	dn_id
	FROM	contr_services_cap
	WHERE	co_id = v_co_id
	AND	cs_deactiv_date IS NULL
	);

UPDATE	storage_medium
SET	sm_status_requ = 'd',
	sm_status_mod_date = SYSDATE,
	sm_moddate = SYSDATE,
	sm_userlastmod = c_username,
	rec_version = rec_version + 1
WHERE	sm_serialnum IN 
	(
	SELECT	cd_sm_num
	FROM	contr_devices
	WHERE	co_id = v_co_id
	AND	cd_deactiv_date IS NULL
	);

UPDATE	PORT
SET	port_status_requ = 'd',
	port_statusmoddat = SYSDATE,
	port_moddate = SYSDATE,
	port_userlastmod = c_username,
	port_deactiv_date = SYSDATE,
	rec_version = rec_version + 1
WHERE	port_id IN
	(
	SELECT	port_id
	FROM	contr_devices
	WHERE	co_id = v_co_id
	AND	cd_deactiv_date IS NULL
	);

FOR	services IN
	(
	SELECT	DISTINCT sncode,
		profile_id,
		rec_version
	FROM	pr_serv_status_hist
	WHERE	co_id = v_co_id
	AND	status IN ('A', 'S')
	)
LOOP		
	UPDATE	app_sequence_value
	SET	next_free_value = next_free_value + 1 
	WHERE	app_sequence_id = 
		(
		SELECT	app_sequence_id
		FROM	app_sequence
		WHERE	app_sequence_key = c_app_sequence_key_prs
		)
	RETURNING	next_free_value
	INTO	v_next_free_value_prs;

	INSERT	INTO pr_serv_status_hist
		(
		co_id,
		sncode,
		histno,
		profile_id,
		rec_version,
		transactionno,
		entry_date,
		reason,
		status,
		request_id
		)
	VALUES	(
		v_co_id,
		services.sncode,
		v_next_free_value_prs,
		services.profile_id,
		services.rec_version,
		v_next_free_value_trx,
		SYSDATE,
		1,
		'D',
		v_next_free_value_req
		);
END	LOOP;

UPDATE	contr_services_cap
SET	cs_request = v_next_free_value_req,
	rec_version = rec_version + 1
WHERE	co_id = v_co_id;

UPDATE	contr_devices
SET	cd_moddate = SYSDATE,
	cd_pending_state = 'd',
	rec_version = rec_version + 1
WHERE	co_id = v_co_id;

INSERT	INTO contract_history
	(
	co_id,
	ch_seqno,
	ch_status,
	ch_reason,
	ch_validfrom,
	ch_pending,
	entdate,
	userlastmod,
	request,
	rec_version
	)
(
SELECT	v_co_id,
	MAX( ch_seqno ) + 1,
	'd',
	8,
	SYSDATE,
	'X',
	SYSDATE,
	c_username,
	v_next_free_value_req,
	1
FROM	contract_history
WHERE	co_id = v_co_id
);
END	LOOP;

UPDATE	directory_number
SET	dn_status = 'r'
WHERE	dn_num IN (
	SELECT	dn_num
	FROM	test_dn
	);

COMMIT;

END;
/
