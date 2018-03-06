BEGIN
	DBMS_OUTPUT.ENABLE(2000000);
	GEN_UDR_DDL.CREATETABLE
	(
		'RTX_ST' -- piosContextKey VARCHAR2
		,'UDR_ST_CRLP' -- piosTableName VARCHAR2 DEFAULT NULL
		,TRUE -- piobExecute
	);
	--
-- Correct public synonyms --
DABUTIL.CREATESYNONYM (piosOwner => 'PUBLIC',
	piosSynonymName => 'RTX_ST',
	piosSchema => 'SYSADM',
	piosObjectName => 'UDR_ST_CRLP');
--
DABUTIL.CREATESYNONYM (piosOwner => 'PUBLIC',
	piosSynonymName => 'BCH_ST',
	piosSchema => 'SYSADM',
	piosObjectName => 'UDR_ST_CRLP');
--
DABUTIL.CREATESYNONYM (piosOwner => 'PUBLIC',
	piosSynonymName => 'BCH_ST_APPEND',
	piosSchema => 'SYSADM',
	piosObjectName => 'UDR_ST_CRLP');
END;
/
