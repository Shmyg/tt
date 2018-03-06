/*
|| Script created as a part of clean-up procedure for Ericsson TSTT project
|| Deletes all on-hold contracts associated to the directory numbers from
|| TEST_DN table
|| Workflow is identical to the SOI command CONTRACT.CANCEL
|| Status of all directory numbers is set to 'r' so they're available for reuse
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: delete_onhold_contracts.sql,v $
|| Revision 1.4  2016/05/02 22:35:03  shmyg
|| Added pending request verification for cleanup
||
|| Revision 1.3  2016/04/01 19:06:31  shmyg
|| Truly the first production release
||
*/

DECLARE
	v_customer_id	PLS_INTEGER;
	c_username	CONSTANT VARCHAR2(30) := 'ADMX';

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
	AND	ch.ch_status = 'o'
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

SELECT	customer_id
INTO	v_customer_id
FROM	contract_all
WHERE	co_id = contracts.co_id;

UPDATE	customer_all
SET	user_lastmod = 'ADMX',
	csmoddate = SYSDATE,
	rec_version = rec_version + 1
WHERE	customer_id = v_customer_id;

UPDATE	directory_number_view
SET	dn_status = 'd',
	dn_status_mod_date = SYSDATE,
	dn_moddate = SYSDATE,
	rec_version =  rec_version + 1
WHERE	dn_id IN
	(
	SELECT	dn_id
	FROM	contr_services_cap
	WHERE	co_id = contracts.co_id
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
	WHERE	co_id = contracts.co_id
	AND	cd_deactiv_date IS NULL
	);

UPDATE	port
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
	WHERE	co_id = contracts.co_id
	AND	cd_deactiv_date IS NULL
	);

DELETE	FROM pr_serv_spcode_hist
WHERE	co_id = contracts.co_id;

DELETE	FROM mpufdtab
WHERE	co_id = contracts.co_id;

DELETE	FROM contract_carry_over_hist
WHERE	co_id = contracts.co_id;

DELETE	FROM contr_vas
WHERE	co_id = contracts.co_id;

DELETE	FROM contr_devices
WHERE	co_id = contracts.co_id;

DELETE	FROM contr_services_cap
WHERE	co_id = contracts.co_id;

DELETE	FROM contract_history
WHERE	co_id = contracts.co_id;

DELETE	FROM pr_serv_status_hist
WHERE	co_id = contracts.co_id;

DELETE	FROM pr_serv_attrib_hist_nnp
WHERE	co_id = contracts.co_id;

DELETE	FROM pr_serv_ovwaccfee_hist
WHERE	co_id = contracts.co_id;

DELETE	FROM parameter_value
WHERE	co_id = contracts.co_id;

DELETE	FROM parameter_value_base
WHERE	prm_value_id IN (
	SELECT	prm_value_id
	FROM	parameter_value
	WHERE	co_id = contracts.co_id
	);

DELETE	FROM profile_service
WHERE	co_id = contracts.co_id;

DELETE	FROM contract_service
WHERE	co_id = contracts.co_id;

DELETE	FROM tickler_tracking
WHERE	tickler_number IN
	(
	SELECT	tickler_number
	FROM	tickler_records
	WHERE	co_id = contracts.co_id
	);

DELETE	FROM tickler_records
WHERE	co_id = contracts.co_id;

DELETE	FROM CCONTACT_ALL
WHERE	customer_id = v_customer_id
and	ccseq = -1
and	rec_version = 1;

DELETE	FROM urh_cms_lock
WHERE	contract_id = contracts.co_id;

DELETE	FROM urh_process_contr
WHERE	contract_id = contracts.co_id;

DELETE	FROM contr_tariff_options
WHERE	co_id = contracts.co_id;

DELETE	FROM contract_contact
WHERE	co_id = contracts.co_id;

DELETE	FROM contract_all
WHERE	co_id = contracts.co_id;

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
