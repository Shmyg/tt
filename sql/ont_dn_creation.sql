--- DO NOT USE, THE FILE IS WRONG, USE JUST VALUES

DECLARE
	c_local_prefix_len	CONSTANT PLS_INTEGER := 0;
	c_external_ind		CONSTANT VARCHAR2(1) := 'N';
	c_block_ind		CONSTANT VARCHAR2(1) := 'N';
	c_dirnum_npcode		CONSTANT PLS_INTEGER := 1;
	c_rscode		CONSTANT PLS_INTEGER := 144;
	c_prefix		CONSTANT VARCHAR2(12) := '110000000000';
	c_hmcode		CONSTANT PLS_INTEGER := 13;
	c_dealer_id		CONSTANT PLS_INTEGER := 2;
	c_dn_type		CONSTANT PLS_INTEGER := 40;

BEGIN

FOR	i IN 1..999
LOOP

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
	
	-- ONT numbers
	INSERT	INTO directory_number
		(
		dn_id,
		plcode,
		hlcode,
		dn_num,
		dn_status,
		dn_status_mod_date,
		dn_assign,
		local_prefix_len,
		external_ind,
		block_ind,
		rec_version,
		dirnum_npcode,
		hmcode,
		rscode,
		dealer_id,
		dn_type,
		business_unit_id
		)
	VALUES	(
		v_next_free_value,
		c_plcode,
		c_hlcode,
		c_prefix || i,
		c_status,
		TRUNC( SYSDATE ),
		c_dn_assign,
		c_local_prefix_len,
		c_external_ind,
		c_block_ind,
		0,
		c_dirnum_npcode,
		c_hmcode,
		c_rscode,
		c_dealer_id,
		c_dn_type,
		c_business_unit_id
		);
END	LOOP;

END;
/
