UPDATE	directory_number
SET	dn_status = 'r'
WHERE	dn_status = 'd'
AND	dn_num IN (
	SELECT	dn_num
	FROM	test_dn
	);
