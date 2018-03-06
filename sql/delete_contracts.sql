/*
||	Deletes all contracts and contract-related data from BSCS DB
||	Part of the cleanup procedure, can be used to prepare clean BUsiness Config
||
||	Created by Serge Shmygelskyy aka Shmyg
||	mailto: serge.shmygelskyy@gmail.com
||
||	$Log: delete_contracts.sql,v $
||	Revision 1.3  2016/06/08 15:31:56  shmyg
||	*** empty log message ***
||
||	Revision 1.2  2016/05/02 01:01:08  shmyg
||	*** empty log message ***
||
||	Revision 1.1  2016/04/27 14:26:46  shmyg
||	Added cleanup procedure
||
*/
DELETE	FROM pr_serv_attrib_hist_nnp;
DELETE	FROM pr_serv_status_hist;
DELETE	FROM pr_serv_spcode_hist;
DELETE	FROM contr_services_cap;
DELETE	FROM contr_devices;
DELETE	FROM contr_vas;
DELETE	FROM parameter_value;
DELETE	FROM fup_account_exp;
DELETE	FROM pr_serv_attrib_hist;
DELETE	FROM profile_service_adv_charge;
DELETE	FROM pr_serv_ovwaccfee_hist;
DELETE	FROM profile_service;
DELETE	FROM contr_devices;
DELETE	FROM contr_services_cap;
DELETE	FROM contract_history;
DELETE	FROM urh_cms_lock;
DELETE	FROM tickler_records where co_id is not null;
DELETE	FROM mpufdtab;
DELETE	FROM contr_tariff_options;
DELETE	FROM contract_carry_over_hist;
DELETE	FROM contract_contact;
DELETE	FROM contract_service;
DELETE	FROM rateplan_hist;
DELETE	FROM concurrent_request;
DELETE	FROM fup_accounts_hist;
DELETE	FROM fup_accounts_head;
DELETE	FROM contr_turnover;
DELETE	FROM purchased_bundle_co_takeover;
DELETE	FROM concurrent_request_history;
DELETE	FROM promo_qual_restrict;
DELETE	FROM cdh_process_contr;
DELETE	FROM cds_contract;
DELETE	FROM info_contr_text;
DELETE	FROM info_contr_combo;
DELETE	FROM info_contr_check;
DELETE	FROM port;
DELETE	FROM storage_medium;
DELETE	FROM gmd_response;
DELETE	FROM urh_cms_lock;
DELETE	FROM urh_contract_periods;
DELETE	FROM urh_process_contr;
DELETE	FROM fees;
DELETE	FROM gmd_request_history
WHERE	request	NOT IN
	(
	SELECT	request_id
	FROM	customer_family
	);
DELETE	FROM gmd_request_base
WHERE	request_id	NOT IN
	(
	SELECT	request_id
	FROM	customer_family
	);
DELETE	FROM mdsrrtab;
DELETE	FROM contract_all;
