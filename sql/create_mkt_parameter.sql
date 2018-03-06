DECLARE
	v_parameter_id	PLS_INTEGER;
	v_prm_des	VARCHAR2(100) := 'Number of extensions';
	v_prm_shdes	VARCHAR2(10) := 'NEXT';
	c_app_sequence_key	CONSTANT VARCHAR2(100) := 'MAX_PARAMETER_ID';	

BEGIN

UPDATE  app_sequence_value
SET     next_free_value = next_free_value + 1 
WHERE   app_sequence_id = 
        (
	SELECT  app_sequence_id
	FROM    app_sequence
	WHERE   app_sequence_key = c_app_sequence_key
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
	v_prm_des,
	v_prm_shdes,
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
       	'1',
	v_parameter_id,
	'128',
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
	'1',
	v_parameter_id,
	'1',
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
	'1',
	v_parameter_id,
	'32',
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

INSERT	INTO mkt_parameter_level (sccode,parameter_id,parameter_level_id, rec_version)
VALUES	('1', v_parameter_id, '1', 1 );

UPDATE	mkt_parameter
SET	import_export_flag = ( import_export_flag + 2 - bitand( import_export_flag, 2 ))
WHERE	parameter_id = v_parameter_id;

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

END;
/
