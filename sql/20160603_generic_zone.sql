/*
|| Deletion of generic zone configuration
|| This configuration is never used, but makes TEH complain about it
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160603_generic_zone.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160603_generic_zone.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Deletion of generic zones';
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
DELETE zone_generic_module_result;
DELETE zone_generic_module;
DELETE zone_generic_function;

COMMIT;
                
END;
/
