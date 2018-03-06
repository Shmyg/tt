UPDATE	directory_number
SET	dn_status = 'w',
	dn_moddate = TO_DATE( '01.01.2099 06:00', 'DD.MM.YYYY hh24:mi'),
	dn_status_mod_date = TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi'),
	dn_entdate = TO_DATE( '01.01.2016 06:00', 'DD.MM.YYYY hh24:mi'),
	dn_assign_date = NULL 
WHERE	dn_status = 'r'
AND	dn_num BETWEEN '18686180491' AND '18686180499'
/

COMMIT
/
