CREATE	TABLE removed_requests
	(
	request	NUMBER,
	removal_date	DATE
);

CREATE OR REPLACE PROCEDURE remove_pending_requests
AS
BEGIN
FOR	i IN
	(
	SELECT	request
	FROM	mdsrrtab
	WHERE	status IN (12, 16)
)
LOOP
INSERT	INTO gmd_request_history
	(
	request,
	plcode,
	status,
	ts,
	userid,
	customer_id,
	vmd_retry,
	error_retry,
	co_id,
	insert_date,
	request_update,
	priority,
	action_date,
	switch_id,
	sccode,
	worker_pid,
	action_id,
	data_1,
	data_2,
	data_3,
	error_code,
	parent_request,
	provisioning_flag,
	rating_flag,
	in_trigger,
	fu_flag,
	ext_sent,
	ext_received,
	res_pause,
	gmdext_task,
	offline_charging_flag,
	pre_processing,
	post_processing,
	ext_notification,
	target,
	sub_target,
	effective_date,
	instance_id,
	acknowledgement_code,
	worker_host,
	initiator_id,
	response_timestamp,
	sending_timestamp,
	age_out_date,
	crm_flag
	)
SELECT	request,
	plcode,
	8,
	ts,
	userid,
	customer_id,
	vmd_retry,
	error_retry,
	co_id,
	insert_date,
	request_update,
	priority,
	action_date,
	switch_id,
	sccode,
	worker_pid,
	action_id,
	data_1,
	data_2,
	data_3,
	error_code,
	parent_request,
	provisioning_flag,
	rating_flag,
	in_trigger,
	fu_flag,
	ext_sent,
	ext_received,
	res_pause,
	gmdext_task,
	offline_charging_flag,
	pre_processing,
	post_processing,
	ext_notification,
	target,
	sub_target,
	effective_date,
	instance_id,
	acknowledgement_code,
	worker_host,
	initiator_id,
	response_timestamp,
	sending_timestamp,
	age_out_date,
	crm_flag
FROM	mdsrrtab
WHERE	request = i.request;

UPDATE	contract_history
SET	ch_pending = NULL
WHERE	request = i.request;

DELETE	FROM mdsrrtab
WHERE	request = i.request;

INSERT	INTO removed_requests
	(
	request,
	removal_date
)
VALUES	(
	i.request,
	SYSDATE
	);
END	LOOP;
COMMIT;
END;
/
