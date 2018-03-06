begin
execute immediate 'ALTER TABLE sysadm.refnum_value DISABLE CONSTRAINT fk_refval_refper';

UPDATE	refnum_base
SET	refnum_maintenance_type = 'A',
	range_autoextension_type = 'A',
	business_unit_ind = 'Y';

DELETE	FROM refnum_value
WHERE	(refnum_id, period_cnt) IN
	(
	SELECT	refnum_id,
		period_cnt 
	FROM	refnum_period	rp
	WHERE	period_start_date !=
		(
		SELECT	max(period_start_date)
	       	FROM	refnum_period
	       	WHERE	refnum_id = rp.refnum_id
		)
	);

DELETE	FROM refnum_period rp
WHERE 	period_start_date !=
	(
	SELECT	max(period_start_date)
	FROM	refnum_period
	WHERE	refnum_id = rp.refnum_id
	);

UPDATE	refnum_value
SET	refnum_version = 1,
	period_cnt = 1,
	range_cnt = 1,
	range_active_ind = 'Y',
	last_reference_date = TO_DATE('01.01.2016', 'DD.MM.YYYY'),
	next_ref_value =  1,
	rec_version = 0;

UPDATE	refnum_period
SET	refnum_version = 1,
	period_cnt = 1,
	period_start_date = TO_DATE('01.01.2016', 'DD.MM.YYYY'),
	period_active_ind = 'Y',
	rec_version = 0;

UPDATE	refnum_version
SET	period_type = 'N';

execute immediate 'ALTER TABLE sysadm.refnum_value ENABLE CONSTRAINT fk_refval_refper';

DELETE	FROM dr_documents;
DELETE	FROM bgh_bill_image_ref;

end;
/
