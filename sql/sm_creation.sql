/*
|| Creation of storage medium
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: sm_creation.sql,v $
|| Revision 1.1  2016/04/26 14:30:18  shmyg
|| *** empty log message ***
||
*/

DECLARE
	c_app_sequence_key_sm	CONSTANT VARCHAR2(100) := 'MAX_RA_SM_ID';
	c_app_sequence_key_pt	CONSTANT VARCHAR2(100) := 'MAX_RA_PORT_ID';
	v_next_free_value_sm	PLS_INTEGER;
	v_next_free_value_pt	PLS_INTEGER;
	c_plcode		CONSTANT PLS_INTEGER := 1001;
	c_hlcode		CONSTANT PLS_INTEGER := 1;
	c_status		CONSTANT VARCHAR2(1) := 'r';
	c_port_npcode		CONSTANT PLS_INTEGER := 60;
	c_business_unit_id	CONSTANT PLS_INTEGER := 2;
	c_prefix		CONSTANT VARCHAR2(12) := '120000000000';

BEGIN

FOR	i IN 1..999
LOOP

	UPDATE	app_sequence_value
	SET	next_free_value = next_free_value + 1 
	WHERE	app_sequence_id = 
		(
		SELECT	app_sequence_id
		FROM	app_sequence
		WHERE	app_sequence_key = c_app_sequence_key_sm
		)
	RETURNING	next_free_value
	INTO	v_next_free_value_sm;
	
	INSERT	INTO storage_medium
		(
		sm_id,
		plcode,
		sm_serialnum,
		sm_status,
		sm_status_mod_date,
		external_ind,
		rec_version
		)
	VALUES	(
		v_next_free_value_sm,
		c_plcode,
		c_prefix || i,
		c_status,
		TRUNC( SYSDATE ),
		'Y',
		0
		);

	UPDATE	app_sequence_value
	SET	next_free_value = next_free_value + 1 
	WHERE	app_sequence_id = 
		(
		SELECT	app_sequence_id
		FROM	app_sequence
		WHERE	app_sequence_key = c_app_sequence_key_pt
		)
	RETURNING	next_free_value
	INTO	v_next_free_value_pt;

	INSERT	INTO port
		(
		port_id,
		plcode,
		hlcode,
		port_num,
		port_status,
		port_statusmoddat,
		sm_id,
		port_activ_date,
		port_entdate,
		port_moddate,
		port_userlastmod,
		external_ind,
		rec_version,
		port_npcode,
		business_unit_id
		)
	VALUES	(
		v_next_free_value_pt,
		c_plcode,
		c_hlcode,
		c_prefix || i,
		c_status,
		TRUNC( SYSDATE ),
		v_next_free_value_sm,
		TRUNC( SYSDATE ),
		TRUNC( SYSDATE ),
		TRUNC( SYSDATE ),
		'SYSADM',
		'Y',
		0,
		c_port_npcode,
		c_business_unit_id
		);
END	LOOP;
END;
/


