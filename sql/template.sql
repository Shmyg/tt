/*
|| Template for SQL scripts for TSTT project
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: template.sql,v $
|| Revision 1.4  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.3  2016/04/15 22:14:45  shmyg
|| Added promotions
||
|| Revision 1.2  2016/04/08 21:16:53  shmyg
|| Script for reference numbers added
||
|| Revision 1.1  2016/04/05 20:02:54  shmyg
|| Added template for SQL fixes and a script to fix 528519
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := 'aaaa';
	c_description	CONSTANT VARCHAR2(100) := '';
	c_bug_id	CONSTANT PLS_INTEGER := '';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
   
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

-- Real job here


COMMIT;

END;
/
