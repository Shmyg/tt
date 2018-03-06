BEGIN
FOR	i IN 6650000..6659999                                
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Chaguanas',
		'Copper'
	);
END	LOOP;
FOR	i IN 6710000..6719999  
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Chaguanas',
		'Copper'
	);
END	LOOP;
FOR	i IN 6720000..6729999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Chaguanas',
		'Copper'
	);
END	LOOP;
FOR	i IN 6930000..6934999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Chaguanas',
		'Copper'
	);
END	LOOP;
FOR	i IN 6730000..6737999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Chaguanas',
		'Copper'
	);
END	LOOP;
END;
/
