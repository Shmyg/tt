BEGIN
FOR	i IN 6380000..6389999                                
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'San Juan',
		'Copper'
	);
END	LOOP;
FOR	i IN 6740000..6749999  
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'San Juan',
		'Copper'
	);
END	LOOP;
FOR	i IN 6750000..6759999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'San Juan',
		'Copper'
	);
END	LOOP;
FOR	i IN 6760000..6769999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'San Juan',
		'Copper'
	);
END	LOOP;
END;
/
