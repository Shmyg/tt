/*
|| Script to create directory numbers
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: dn_creation_c2f.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.4  2016/05/02 19:24:33  shmyg
|| *** empty log message ***
||
|| Revision 1.3  2016/05/02 01:01:08  shmyg
|| *** empty log message ***
||
|| Revision 1.2  2016/04/26 21:29:45  shmyg
|| Fixed directory number creation
||
|| Revision 1.1  2016/04/26 14:30:18  shmyg
|| *** empty log message ***
||
*/

DECLARE
	c_app_sequence_key	CONSTANT VARCHAR2(100) := 'MAX_RA_DN_ID';
	v_next_free_value	PLS_INTEGER;
	c_plcode		CONSTANT PLS_INTEGER := 1001;
	c_hlcode		CONSTANT PLS_INTEGER := 1;
	c_status		CONSTANT VARCHAR2(1) := 'w';
	c_dn_assign		CONSTANT PLS_INTEGER := 1;
	c_external_ind		CONSTANT VARCHAR2(1) := 'N';
	c_block_ind		CONSTANT VARCHAR2(1) := 'N';
	c_dirnum_npcode		CONSTANT PLS_INTEGER := 1;
	c_rscode		CONSTANT PLS_INTEGER := 2;
	c_prefix		CONSTANT VARCHAR2(12) := '1867';
	c_ndc			CONSTANT VARCHAR2(3) := '867';
	c_dealer_id		CONSTANT PLS_INTEGER := 2;
	c_hmcode		CONSTANT PLS_INTEGER := 2;
	c_local_prefix_len	CONSTANT PLS_INTEGER := 4;
	c_dn_type		CONSTANT PLS_INTEGER := 21;
	c_business_unit_id	CONSTANT PLS_INTEGER := 2;

BEGIN

FOR	i IN 6180584..6180593
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
	VALUES	(
		v_next_free_value,
		c_plcode,
		c_ndc,
		c_hlcode,
		c_prefix || i,
		c_status,
		TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi' ),
		c_dealer_id,
		NULL,
		c_dn_type,
		c_dn_assign,
		TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi' ),
		TO_DATE( '01.01.2099 06:00', 'DD.MM.YYYY hh24:mi' ),
		c_hmcode,
		c_local_prefix_len,
		c_external_ind,
		c_block_ind,
		0,
		c_dirnum_npcode,
		c_business_unit_id,
		c_rscode
		);
END	LOOP;

END;
/
