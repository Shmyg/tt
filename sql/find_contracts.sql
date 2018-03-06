SELECT	dn.dn_num,
	cs.co_id,
	ch.ch_status
FROM	contr_services_cap	cs,
	directory_number	dn,
	test_dn			td,
	contract_history	ch
WHERE	cs.dn_id = dn.dn_id
AND	dn.dn_num = td.dn_num
AND	ch.co_id = cs.co_id
AND	ch.ch_status IN ( 'a', 's', 'o' )
AND	ch.ch_seqno =
	(
	SELECT	MAX( ch_seqno )
	FROM	contract_history
	WHERE	co_id = ch.co_id
	)
ORDER	BY dn.dn_num
/
