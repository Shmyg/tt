BEGIN
FOR	i IN 6320000..6329999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Diego Martin',
		'Copper'
	);
END	LOOP;
FOR	i IN 6330000..6339999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Diego Martin',
		'Copper'
	);
END	LOOP;
FOR	i IN 6370000..6379999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Diego Martin',
		'Copper'
	);
END	LOOP;
FOR	i IN 6940000..6943999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Diego Martin',
		'Copper'
	);
END	LOOP;
FOR	i IN 6950000..6959999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Diego Martin',
		'Copper'
	);
END	LOOP;
END;
/
