LOAD	DATA
INFILE	contracts.dat
INTO	TABLE test_dn
TRUNCATE
FIELDS	TERMINATED BY ';'
	(
	dn_num
	)
