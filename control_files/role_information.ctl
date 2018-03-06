LOAD	DATA
INFILE	role_information.dat
INTO	TABLE role_information
APPEND
FIELDS	TERMINATED BY ';'
	(
	role_id		SEQUENCE( MAX ),
	role_name,
	description,
	entdate		SYSDATE,
	moddate		SYSDATE,
	modifiable_indicator CONSTANT 1
	)
