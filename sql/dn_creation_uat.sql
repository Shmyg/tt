/*
|| Script to create directory numbers from the list provided by TSTT
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: dn_creation_uat.sql,v $
|| Revision 1.1  2016/07/05 16:50:55  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/06/08 15:31:56  shmyg
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

	SELECT	MAX( dn_id )
	INTO	v_next_free_value
	FROM	directory_number;

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
	SELECT	v_next_free_value + ROWNUM,
		c_plcode,
		c_ndc,
		c_hlcode,
		dn.dn_num,
		c_status,
		TRUNC( SYSDATE ),
		c_dealer_id,
		TRUNC( SYSDATE ),
		c_dn_type,
		c_dn_assign,
		TRUNC( SYSDATE ),
		TRUNC( SYSDATE) ,
		mp.hmcode,
		c_local_prefix_len,
		c_external_ind,
		c_block_ind,
		0,
		c_dirnum_npcode,
		c_business_unit_id,
		c_rscode
	FROM	shmyg.uat_numbers	dn,
		mpdhmtab		mp
	WHERE	dn.exchange = mp.shdes
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
END;
/
