/*
|| Script to move 'Additional Jack' service to the right package
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160825_Add_Jack_change.sql,v $
|| Revision 1.1  2016/08/25 16:32:46  shmyg
|| More scripts
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160825_Add_Jack_change.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Moving Add. Jack service to the right package';
	c_bug_id	CONSTANT PLS_INTEGER := '3980';
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
	
update mpulktmb set sncode = 318
where spcode = 83 and sncode =327;


COMMIT;
END;
/
