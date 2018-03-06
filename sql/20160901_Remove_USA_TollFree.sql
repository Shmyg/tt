/*
|| Script to delete US toll-free numbers from the list of zones
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
|| 
|| $Log: 20160901_Remove_USA_TollFree.sql,v $
|| Revision 1.1  2016/09/07 12:56:46  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160901_Remove_USA_TollFree.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Deletion of the US toll-free zone';
	c_bug_id	CONSTANT PLS_INTEGER := '3880';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	v_mig_script_id PLS_INTEGER;
	c_des		VARCHAR2(100) := 'PAY 800 USA 1';

BEGIN
/*
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

*/
	DELETE	FROM mpulkgvm
	WHERE	zpcode =
		(
		SELECT	zpcode
		FROM	mpuzptab
		WHERE	des = c_des
		);

	DELETE	FROM mpulkgv2
	WHERE	zpcode =
		(
		SELECT	zpcode
		FROM	mpuzptab
		WHERE	des = c_des
		);

	DELETE	FROM mpuzptab
	WHERE	des = c_des;
END;
/
