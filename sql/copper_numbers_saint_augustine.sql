BEGIN
FOR	i IN 6620000..6629999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'St. Augustine',
		'Copper'
	);
END	LOOP;
FOR	i IN 6630000..6639999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'St. Augustine',
		'Copper'
	);
END	LOOP;
FOR	i IN 6450000..6459999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'St. Augustine',
		'Copper'
	);
END	LOOP;
FOR	i IN 6960000..6962999                            
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'St. Augustine',
		'Copper'
	);
END	LOOP;
FOR	i IN 6400000..6409999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'St. Augustine',
		'Copper'
	);
END	LOOP;
END;
/
