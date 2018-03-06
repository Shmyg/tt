INSERT	INTO	gl_account_package
	(
	SELECT	*
	FROM	gl_account_package@uat2
	WHERE	gl_acc_pack_id NOT IN
		(
		SELECT	gl_acc_pack_id
		FROM	gl_account_package
		)
	);

INSERT	INTO	gl_account_package_version
	(
	SELECT	*
	FROM	gl_account_package_version@uat2
	WHERE	gl_acc_pack_id NOT IN
		(
		SELECT	gl_acc_pack_id
		FROM	gl_account_package_version
		)
	);

UPDATE	mpulktmb	tm
SET	sub_gl_acc_pack_id =
	(
	SELECT	sub_gl_acc_pack_id
	FROM	mpulktmb@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	),
	acc_gl_acc_pack_id = 
	(
	SELECT	acc_gl_acc_pack_id
	FROM	mpulktmb@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	),
	usg_gl_acc_pack_id =
	(
	SELECT	usg_gl_acc_pack_id
	FROM	mpulktmb@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	);

UPDATE	mpulktm1	tm
SET	sub_gl_acc_pack_id =
	(
	SELECT	sub_gl_acc_pack_id
	FROM	mpulktm1@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	),
	acc_gl_acc_pack_id = 
	(
	SELECT	acc_gl_acc_pack_id
	FROM	mpulktm1@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	),
	usg_gl_acc_pack_id =
	(
	SELECT	usg_gl_acc_pack_id
	FROM	mpulktm1@uat2
	WHERE	tmcode = tm.tmcode
	AND	spcode = tm.spcode
	AND	sncode = tm.sncode
	AND	vscode = tm.vscode
	);
