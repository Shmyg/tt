BEGIN
FOR	i IN 6220000..6229999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'West',
		'Copper'
	);
END	LOOP;
FOR	i IN 6280000..6289999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'West',
		'Copper'
	);
END	LOOP;
END;
/
