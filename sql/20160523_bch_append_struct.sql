/*
|| Creates UDR partition configuration to have UDR table partitioned
|| by ENTRY_DATE_TIMESTAMP and creates partitions for the next 10 years
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160523_bch_append_struct.sql,v $
|| Revision 1.1  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160523_bch_append_struct.sql';
	c_version	CONSTANT VARCHAR2(3) := '1.0';
	c_description	CONSTANT VARCHAR2(100) := 'UDR partititoning';
	c_track		CONSTANT VARCHAR2(100) := 'PCV1.13';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_user		CONSTANT VARCHAR2(30) := 'SHMYG';
	c_context	CONSTANT VARCHAR2(30) := 'BCH_ST_APPEND';
	v_mig_script_id PLS_INTEGER;
   
BEGIN

INSERT	INTO rm_mig_script
	(
	mig_script_id,
	mig_script_name
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename 
FROM	sysadm.rm_mig_script
);

-- Real job here
DELETE	uds_partit_col_values
WHERE	partition_id IN 
	(
	SELECT	partition_id
	FROM	uds_partition
	WHERE	table_name IN
		(
		SELECT	name
		FROM	uds_tables	ut,
			uds_context	uc
		WHERE	ut.uds_context_id = uc.uds_context_id
		AND	uc.uds_context_key = c_context
		)
	);

DELETE	uds_partition
WHERE	table_name IN
	(
	SELECT	name
	FROM	uds_tables	ut,
		uds_context	uc
	WHERE	ut.uds_context_id = uc.uds_context_id
	AND	uc.uds_context_key = c_context
	);

DELETE	uds_tables
WHERE	uds_context_id =
	(
	SELECT	uds_context_id
	FROM	uds_context
	WHERE	uds_context_key = c_context
	);

DELETE	uds_partition_columns
WHERE	partition_template_id IN
	(
	SELECT	partition_template_id
	FROM	uds_partition_template
	START	WITH uds_context_id =
       		(
		SELECT	uds_context_id
		FROM	uds_context
		WHERE	uds_context_key = c_context
		)
	CONNECT	BY parent_partition_id = PRIOR partition_template_id
	);

DELETE	uds_partition_template
WHERE	partition_template_id IN
	(
	SELECT	partition_template_id
	FROM	uds_partition_template
	START	WITH UDS_CONTEXT_ID IN
       		(
		SELECT	UDS_CONTEXT_ID
		FROM	UDS_CONTEXT
		WHERE	UDS_CONTEXT_KEY IN (c_context)
		)
	CONNECT	BY parent_partition_id = PRIOR partition_template_id
	);

INSERT INTO uds_tables
	(
	name,
	end_date,
	fu_table_name,
	uds_context_id,
	view_relevance
	)
VALUES	(
	c_context || '_CRLP',
	TRUNC(SYSDATE,'DD'),
	c_context || '_CRLP',
	(
	SELECT	uds_context_id
	FROM	uds_context
	WHERE	uds_context_key = c_context
	),
	'X'
	);


INSERT	INTO uds_partition_template
	(
	partition_template_id,
	uds_context_id,
	partition_method,
	parent_partition_id,
	shdes
	)
SELECT	(
	SELECT	NVL(MAX(partition_template_id),0)
	FROM	uds_partition_template
	) + ROWNUM,
	uds_context_id,
	'R',
	NULL,
	uds_context_key || '_RANGE'
FROM	uds_context
WHERE	uds_context_key = c_context;


INSERT	INTO uds_partition_columns
	(
	partition_template_id,
	column_name,
	column_position,
	partition_col_id
	)
SELECT	partition_template_id,
	'ENTRY_DATE_TIMESTAMP',
	1,
	(
	SELECT	NVL( MAX( partition_col_id ), 0 )
	FROM	uds_partition_columns
	) + ROWNUM
FROM	uds_context		u,
	uds_partition_template	t
WHERE	uds_context_key = c_context
AND	u.uds_context_id = t.uds_context_id;

FOR	i IN 1..120
LOOP
	INSERT	INTO uds_partition
		(
		partition_id,
		partition_name,
		seqnum,
		table_name
		)
	SELECT	(
		SELECT	NVL(MAX(PARTITION_ID),0)
		FROM	UDS_PARTITION
		) + ROWNUM,
		'PART_' || TO_CHAR ( ADD_MONTHS( TO_DATE ('201605', 'YYYYMM') , i), 'YYYYMM'),
		1,
		t.name
	FROM	uds_context	c,
		uds_tables	t
	WHERE	c.uds_context_key = c_context
	AND	c.uds_context_id = t.uds_context_id;
END	LOOP;

INSERT	INTO uds_partit_col_values
	(
	partition_id,
	partition_col_id,
	column_value_num,
	column_value_char,
	column_value_date
	)
SELECT	p.partition_id,
	pc.partition_col_id,
	NULL,
	NULL,
	ADD_MONTHS(TO_DATE(SUBSTR(P.PARTITION_NAME, 6), 'YYYYMM'),1)-1
FROM	uds_context		c,
	uds_tables		t,
	uds_partition		p,
	uds_partition_template	pt,
	uds_partition_columns	pc
WHERE	c.uds_context_key = c_context
AND	c.uds_context_id = t.uds_context_id
AND	p.table_name = t.name
AND	c.uds_context_id = pt.uds_context_id
AND	pt.partition_template_id = pc.partition_template_id;

COMMIT;

END;
/
