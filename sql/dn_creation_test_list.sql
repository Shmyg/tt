/*
|| Script to create directory numbers in test
|| from the list provided by TSTT
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: dn_creation_test_list.sql,v $
|| Revision 1.1  2016/09/22 13:31:09  shmyg
|| *** empty log message ***
||
*/

DECLARE
	c_app_sequence_key	CONSTANT VARCHAR2(100) := 'MAX_RA_DN_ID';
	v_next_free_value	PLS_INTEGER;
	c_plcode		CONSTANT PLS_INTEGER := 1001;
	c_hlcode		CONSTANT PLS_INTEGER := 1;
	c_status		CONSTANT VARCHAR2(1) := 'r';
	c_dn_assign		CONSTANT PLS_INTEGER := 1;
	c_external_ind		CONSTANT VARCHAR2(1) := 'N';
	c_block_ind		CONSTANT VARCHAR2(1) := 'N';
	c_dirnum_npcode		CONSTANT PLS_INTEGER := 1;
	c_rscode		CONSTANT PLS_INTEGER := 2;
	c_prefix		CONSTANT VARCHAR2(12) := '1868';
	c_ndc			CONSTANT VARCHAR2(3) := '868';
	c_dealer_id		CONSTANT PLS_INTEGER := 2;
	c_local_prefix_len	CONSTANT PLS_INTEGER := 4;
	c_dn_type		CONSTANT PLS_INTEGER := 21;
	c_business_unit_id	CONSTANT PLS_INTEGER := 2;

BEGIN

	UPDATE	app_sequence_value
	SET	next_free_value = next_free_value + 1 
	WHERE	app_sequence_id = 
		(
		SELECT	app_sequence_id
		FROM	app_sequence
		WHERE	app_sequence_key = c_app_sequence_key
		)
	RETURNING	next_free_value
	INTO	v_next_free_value;

	INSERT	INTO directory_number
		(
		dn_id,
		plcode,
		ndc,
		hlcode,
		dn_num,
		dn_status,
		dn_status_mod_date,
		dealer_id,
		dn_assign_date,
		dn_type,
		dn_assign,
		dn_entdate,
		dn_moddate,
		hmcode,
		local_prefix_len,
		external_ind,
		block_ind,
		rec_version,
		dirnum_npcode,
		business_unit_id,
		rscode
		)
	(
	SELECT	v_next_free_value + ROWNUM - 1,
		c_plcode,
		c_ndc,
		c_hlcode,
		c_prefix || dn.dn_num,
		c_status,
		TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi' ),
		c_dealer_id,
		NULL,
		c_dn_type,
		c_dn_assign,
		TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi' ),
		TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi' ),
		mp.hmcode,
		c_local_prefix_len,
		c_external_ind,
		c_block_ind,
		0,
		c_dirnum_npcode,
		c_business_unit_id,
		c_rscode
	FROM	shmyg.test_dn	dn,
		mpdhmtab	mp
	WHERE	dn.area = mp.shdes
	);

	UPDATE	app_sequence_value
	SET	next_free_value =  
		(
		SELECT	MAX (dn_id) + 1
		FROM	directory_number
		)
	WHERE	app_sequence_id = 
		(
		SELECT	app_sequence_id
		FROM	app_sequence
		WHERE	app_sequence_key = c_app_sequence_key
		);
	COMMIT;
END;
/
