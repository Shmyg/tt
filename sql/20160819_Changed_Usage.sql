/*
|| Script to make recurring charges changeable for some of the services
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160819_Changed_Usage.sql,v $
|| Revision 1.1  2016/08/25 16:32:46  shmyg
|| More scripts
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160819_Changed_Usage.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Making recurrent charge changeable for some services';
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
	

UPDATE	mpulktm1
SET	amtind = 'C'
WHERE	sncode IN
	(
	SELECT	sncode
	FROM	mpusntab
	WHERE	shdes IN ( 'IPT02', 'FBBR6', 'VWL14' )
	);

UPDATE	mpulktmb
SET	amtind = 'C'
WHERE	sncode IN
	(
	SELECT	sncode
	FROM	mpusntab
	WHERE	shdes IN ( 'IPT02', 'FBBR6', 'VWL14' )
	);

--COMMIT;
END;
/
