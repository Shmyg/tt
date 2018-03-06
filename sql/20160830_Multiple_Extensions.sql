/*
|| Script to allow using multiple extensions.
|| Workflow:
|| 1. Create parameter
|| 2. Create basic service
|| 3. Assign the parameter to the service
|| 4. Modify existing extension services to accomodate the new basic one
|| 5. Modify tariff models to include conditional charge
||
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160830_Multiple_Extensions.sql,v $
|| Revision 1.3  2016/08/31 11:22:13  shmyg
|| Added vscode for multiple extensions script
||
|| Revision 1.2  2016/08/31 08:40:25  shmyg
|| Modified multiple extensions script
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160830_Multiple_Extensions.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Configuration of parameterized extension service';
	c_bug_id	CONSTANT PLS_INTEGER := '3880';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
	v_parameter_id	PLS_INTEGER;
	v_svcode	PLS_INTEGER;
	c_prm_shdes	CONSTANT VARCHAR2(10) := 'NEXT';
	c_shdes		CONSTANT VARCHAR2(2) := 'EE';
	c_tmcode	CONSTANT PLS_INTEGER := 3;
	c_spcode	CONSTANT PLS_INTEGER := 85;
	c_name		CONSTANT VARCHAR2(100) := 'Number of extensions';
	v_vscode	PLS_INTEGER;

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

-- Creating parameter
UPDATE  app_sequence_value
SET     next_free_value = next_free_value + 1 
WHERE   app_sequence_id = 
        (
	SELECT  app_sequence_id
	FROM    app_sequence
	WHERE   app_sequence_key = 'MAX_PARAMETER_ID'
	)
RETURNING       next_free_value - 1
INTO    v_parameter_id;

INSERT	INTO mkt_parameter
	(
	parameter_id,
	sccode,
	prm_des,
	shdes,
	port_ind,
	net_ind,
	charge_ind,
	value_change_ind,
	parameter_change_ind,
	vas_ind,
	rec_version,
	multiple_values_ind,
	max_number_parameter,
	min_number_parameter,
	parameter_area_id,
	override_ind,
	resource_like,
	print_ind,
	response_prm_ind,
	rating_ind,
	purpose,
	service_offering_contrib_flag
	)
VALUES	(
	v_parameter_id,
	'1',
	c_name,
	c_prm_shdes,
	'N',
	'N',
	'Y',
	'Y',
	'Y',
	'Y',
	1,
	'N',
	'',
	1,
	1,
	'Y',
	'N',
	'Y',
	'N',
	'N',
	'',
	''
	);

INSERT	INTO mkt_parameter_action
	(
	sccode,
	parameter_id,
	action,
	rec_version
	)
VALUES	(
       	1,
	v_parameter_id,
	128,
	1
	);

INSERT	INTO mkt_parameter_action
	(
	sccode,
	parameter_id,
	action,
	rec_version
	)
VALUES	(
	1,
	v_parameter_id,
	1,
	1
	);

INSERT	INTO mkt_parameter_action
	(
	sccode,
	parameter_id,
	action,
	rec_version
	)
VALUES	(
	1,
	v_parameter_id,
	32,
	1
	);

INSERT	INTO mkt_parameter_ext_code
	(
	sccode,
	parameter_id,
	external_code,
	rec_version
	)
VALUES	(
	1,
	v_parameter_id,
	'GSM' || v_parameter_id,
	1
	);

INSERT	INTO mkt_parameter_level
	(
	sccode,
	parameter_id,
	parameter_level_id,
	rec_version
	)
VALUES	(
	1,
	v_parameter_id,
	1,
	1
	);

INSERT	INTO mkt_parameter_range
	(
	sccode,
	parameter_id,
	prm_format,
	range_from,
	range_to,
	prm_default,
	prm_picture_format,
	rec_version
	)
VALUES	(
	1,
	v_parameter_id,
	'',
	1,
	100,
	1,
       	999,
	1
	);

-- Creating basic service
UPDATE  app_sequence_value
SET     next_free_value = next_free_value + 1 
WHERE   app_sequence_id = 
        (
	SELECT  app_sequence_id
	FROM    app_sequence
	WHERE   app_sequence_key = 'MAX_SVCODE' 
	)
RETURNING       next_free_value - 1
INTO    v_svcode;

INSERT	INTO mpssvtab
	(
	svcode,
	des,
	srvcode,
	srvind,
	service_change_ind,
	parameter_change_ind,
	allowed_prim_serv,
	srv_type,
	sccode,
	rec_version,
	srv_subtype
	)
VALUES 	(
	v_svcode,
	c_name,
	c_shdes,
	3,
	'Y',
	'Y',
	'',
	'V',
	1,
	1,
	'A'
	);

INSERT	INTO mpdoptab
	(
	srvcode,
	srvind,
	sccode,
	action,
	rec_version
	)
(
SELECT	srvcode,
	srvind,
	1,
	1,
	0
FROM 	mpssvtab
WHERE 	svcode = v_svcode
);

INSERT	INTO mpdoptab
	(
	srvcode,
	srvind,
	sccode,
	action,
	rec_version
	)
(
SELECT	srvcode,
	srvind,
	1,
	32,
	0
FROM 	mpssvtab
WHERE 	svcode = v_svcode
);

INSERT	INTO service_parameter
	(
	sccode,
	svcode,
	parameter_id,
	prm_no,
	rec_version
	)
VALUES	(
	1,
	v_svcode, 
	v_parameter_id,
	1,
	0
	);

-- Updating existing services
FOR	rec IN
	(
	SELECT	sncode,
		ROWNUM AS rn,
		DECODE (shdes, 'OCPE5', 6, 10) AS fee
	FROM	mpusntab
	WHERE	shdes IN ( 'OCPE5', 'OCPE6' )
	)
LOOP

	UPDATE	mpusntab
	SET	snind = 'Y'
	WHERE	sncode = rec.sncode;

	UPDATE	mpulknxc
	SET	sccode = 1,
		snind	= 'V'
	WHERE	sncode = rec.sncode;

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
		rec.sncode,
		1,
		1,
		v_svcode,
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

	INSERT	INTO mpupvtab
	VALUES	(rec.rn);

	UPDATE	mpulktm1
	SET	prm_print_ind = 'Y',
		pv_combi_id = rec.rn
	WHERE	tmcode = c_tmcode
	AND	spcode = c_spcode
	AND	sncode = rec.sncode;
	
	UPDATE	mpulktmb
	SET	prm_print_ind = 'Y',
		pv_combi_id = rec.rn
	WHERE	tmcode = c_tmcode
	AND	spcode = c_spcode
	AND	sncode = rec.sncode;

	SELECT	MAX( vscode )
	INTO	v_vscode
	FROM	mpulktmb
	WHERE	tmcode = c_tmcode;

	FOR	i IN 1..100
	LOOP
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
			rec.rn,
			v_vscode,
			i,
			c_name,
			0,
			rec.fee * i,
			1
			);
		
		INSERT	INTO mpulkpvb
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
			rec.rn,
			v_vscode,
			i,
			c_name,
			0,
			rec.fee * i,
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
			rec.rn,
			v_vscode,
			i,
			1, 
			v_parameter_id,
			c_name,
			i,
			'',
			'',
			1, 
			1
			);

		INSERT	INTO mpulkpvm
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
			rec.rn,
			v_vscode,
			i,
			1, 
			v_parameter_id,
			c_name,
			i,
			'',
			'',
			1, 
			1
			);
	END	LOOP;	
END	LOOP;
COMMIT;
END;
/
