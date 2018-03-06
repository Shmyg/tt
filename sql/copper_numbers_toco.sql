BEGIN

FOR	i IN 6700000..6709999
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
