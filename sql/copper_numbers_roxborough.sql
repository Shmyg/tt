BEGIN

FOR	i IN 6600000..6603000
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Scarborough',
		'Copper'
	);
END	LOOP;
FOR	i IN 6604000..6608999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Scarborough',
		'Copper'
	);
END	LOOP;
FOR	i IN 6609900..6609982
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Scarborough',
		'Copper'
	);
END	LOOP;
FOR	i IN 6609984..6609999
LOOP
	INSERT	INTO dn_list
		(
		dn_num,
		area,
		dn_type
	)
	VALUES	(
		i,
		'Scarborough',
		'Copper'
	);
END	LOOP;
END;
/
