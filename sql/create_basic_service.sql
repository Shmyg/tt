DECLARE

	v_svcode	PLS_INTEGER;
	v_des		VARCHAR2(100) := 'Extensions - Residential';
	v_shdes		VARCHAR2(2) := 'EE';
	v_parameter_id	PLS_INTEGER := 68;

BEGIN

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
	v_des,
	v_shdes,
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

UPDATE	mpssvtab 
SET 	import_export_flag =
	(import_export_flag + 2 - bitand( import_export_flag, 2 ))
WHERE	svcode = v_svcode;

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

UPDATE	mpssvtab 
SET 	import_export_flag =
	(import_export_flag + 2 - bitand( import_export_flag, 2 ))
WHERE	svcode = v_svcode;

END;
/
