/*
|| Script to update configuration for CUSTNUM sequence
|| and clean up the wrong customers
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160919_Sequence_Fix.sql,v $
|| Revision 1.1  2016/09/19 09:55:00  shmyg
|| Added sequence configuration script
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160919_Sequence_Fix.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Configuration of CUSTNUM sequence';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
	c_des		VARCHAR2(100) := 'CUSTNUM configuration';

BEGIN

INSERT	INTO sysadm.rm_mig_script
	(
	mig_script_id,
	mig_script_name,
	des,
	author,
	bug_id
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename,
	c_description,
	c_user,
	c_bug_id
FROM	sysadm.rm_mig_script
);

UPDATE	customer_all
SET	custnum = RPAD(REGEXP_REPLACE(custnum, 'CUST0000', ''), 8, '0')
WHERE	custnum LIKE 'CUST%';

UPDATE	customer_all
SET	custnum = rpad(REGEXP_REPLACE(custnum, 'test', ''), 8, '0')
WHERE	custnum LIKE 'test%';

UPDATE	customer_all
SET	custnum = lpad(1, 8, '0')
WHERE	custnum LIKE '0.0000%';

UPDATE	customer_all
SET	custnum = lpad(2, 8, '0')
WHERE	custnum LIKE 'DUMMY%';

UPDATE	APP_SEQUENCE
SET	select_statement = 'SELECT MAX(custnum) + 1 FROM customer_all WHERE customer_id > 1',
	string_sequence_length = 8
WHERE	app_sequence_key = 'MAX_CUST_NUM';

UPDATE	app_sequence_composition
SET	value_suffix = NULL,
	value_prefix = NULL
WHERE	app_sequence_id =
	(
	SELECT	app_sequence_id
	FROM	app_sequence
	WHERE	app_sequence_key = 'MAX_CUST_NUM'
	);

COMMIT;

END;
/
