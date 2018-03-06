SELECT	dn_num,
	dn_status
FROM	directory_number
WHERE	dn_num IN (
	SELECT	dn_num
	FROM	test_dn
	);
