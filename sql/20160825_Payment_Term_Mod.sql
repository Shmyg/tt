/*
|| Modification of the payment terms
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160825_Payment_Term_Mod.sql,v $
|| Revision 1.2  2016/08/30 12:29:47  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/08/25 16:32:47  shmyg
|| More scripts
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160825_Payment_Term_Mod.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Modification of the payment terms';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
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
	
UPDATE	terms_all
SET	termname = 'TT 29 days',
	termnet = 29;

COMMIT;
END;
/
