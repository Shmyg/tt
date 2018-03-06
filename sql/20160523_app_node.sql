/*
|| Low-level BSCS configuration (APP_NODE adn GMD)
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160523_app_node.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160523_app_node.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_description	CONSTANT VARCHAR2(100) := 'APP_NODE and GMD configuration';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.13';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
BEGIN

INSERT	INTO rm_mig_script
	(
	mig_script_id,
	mig_script_name
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename 
FROM	sysadm.rm_mig_script
);

-- Real job here
DELETE	FROM cdh_process_contr;
DELETE	FROM cdh_process_package;
DELETE	FROM cdh_instance;
DELETE	FROM bch_instance;
DELETE	FROM app_instance;

DELETE	FROM app_node
WHERE	app_node_id > 1;

UPDATE	app_node
SET	ordinal_value = 1;

COMMIT;

END;
/
