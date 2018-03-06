DECLARE
	TYPE	my_type
	IS	TABLE OF VARCHAR2(100)
	INDEX	 BY BINARY_INTEGER;
	my_table	sysadm.referencenumber.REFSTRARRAYTYPE;

	v_errcode	PLS_INTEGER;
BEGIN

referencenumber.GETACTIVEREFNUM
(
 PIOSBASETABLE =>  'ORDERHDR_ALL',
 PIOSBASECOLUMN =>  'OHREFNUM',
 PIOSVOUCHERSTATUS =>  null,
 PIONVOUCHERTYPE =>  null,
 PIONCOUNTTOALLOCATE =>  '10',
 PIONBUSINESSUNITID => '2',
 PIOSVIRTUALDATE => SYSDATE,
 POONERRCODE =>  v_errcode,
 POASREFNUMBERS =>  my_table
);

dbms_output.put_line(v_errcode);

DBMS_OUTPUT.PUT_LINE(my_table.count);
/*(
FOR i in my_table.first..my_table.count
LOOP
	DBMS_OUTPUT.PUT_LINE( my_table(i));
END	LOOP;
*/

END;
/

