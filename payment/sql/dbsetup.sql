CREATE	TABLE sysadm.tstt_payment_file
	(
	ent_date	DATE,
	rectype		VARCHAR2(12),
	reversal_flag	VARCHAR2(1),
	payment_ref	VARCHAR2(30),
	payment_date	DATE,
	customer_ref	VARCHAR2(24),
	amount		NUMBER,
	currency	VARCHAR2(3),
	document_ref	VARCHAR2(30),
	comments	VARCHAR2(60),
	handling_reason_code	VARCHAR2(15),
	file_name	VARCHAR2(60)
	)
/
