/*
|| Creates EMM user and a view for him
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160419_dn_lookup_view.sql,v $
|| Revision 1.2  2016/09/19 09:55:00  shmyg
|| Added sequence configuration script
||
|| Revision 1.1  2016/04/21 19:28:35  shmyg
|| *** empty log message ***
||
*/
create user emm identified by emm;
grant create session to emm;
grant select on directory_number to emm;
grant create view to emm;

CREATE	OR REPLACE VIEW emm.dn_lookup
AS
SELECT	DECODE (business_unit_id, 2, 1868) country,
	dn_num,
	dn_status
FROM	sysadm.directory_number
WHERE	dn_status NOT IN ('r', 'f')
/
