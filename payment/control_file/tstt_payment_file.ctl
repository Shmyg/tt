LOAD	DATA
INTO	TABLE tstt_payment_file
APPEND
FIELDS	TERMINATED BY ';'
TRAILING	NULLCOLS
	(
	ent_date	SYSDATE,
	rectype,
	reversal_flag,
	payment_ref,
	payment_date	DATE 'DD.MM.YYYY',
	customer_ref,
	amount		"TO_NUMBER (:amount, '9999.99')",
	currency,
	document_ref,
	comments,
	handling_reason_code,
	file_name
	)
