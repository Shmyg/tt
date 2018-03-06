/*
|| 
|| Billing cycles configuration
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160601_billcycle_definition.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160601_billcycle_definition.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Billing cycles configuration';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_author	CONSTANT VARCHAR2(30) := 'SHMYG';
   
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
	c_author,
	c_bug_id
FROM	sysadm.rm_mig_script
);

-- Real job here
UPDATE	billcycle_definition
SET	fup_account_period_id = 1;

DELETE	fup_accounts_period_table
WHERE	fup_account_period_id != 1;

DELETE	billcycle_group_member
WHERE	billcycle NOT IN ('01', '99');

DELETE	custgroup_billcycle
WHERE	billcycle NOT IN ('01', '99');

DELETE	billcycle_definition
WHERE	billcycle NOT IN ('01', '99');

UPDATE	billcycle_definition
SET	description = 'Normal billcycle'
WHERE	billcycle = '01';

COMMIT;
                
END;
/
