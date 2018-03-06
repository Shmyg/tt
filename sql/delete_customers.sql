/*
|| Deletes all customer and customer-related data
	FROM	BSCS DB except 2
|| which are used as a default dealer and something yet else
|| Part of the cleanup procedure, can be used to prepare clean BUsiness Config
||
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: delete_customers.sql,v $
|| Revision 1.7  2016/10/12 13:03:42  shmyg
|| Final release, end of the project
||
|| Revision 1.6  2016/09/22 13:31:09  shmyg
|| *** empty log message ***
||
|| Revision 1.5  2016/09/19 09:55:00  shmyg
|| Added sequence configuration script
||
|| Revision 1.4  2016/08/18 07:55:16  shmyg
|| *** empty log message ***
||
|| Revision 1.3  2016/06/08 15:31:56  shmyg
|| *** empty log message ***
||
|| Revision 1.2  2016/05/02 01:01:08  shmyg
|| *** empty log message ***
||
|| Revision 1.1  2016/04/27 14:26:46  shmyg
|| Added cleanup procedure
||
*/

DELETE	FROM tickler_records;

DELETE	FROM imb_document
WHERE	customer_id > 2;

DELETE	FROM induced_payment
WHERE	document_id IN
	(
	SELECT	ohxact
	FROM	orderhdr_all
	WHERE	customer_id > 2
	);

DELETE	FROM rateplan_hist_occ
WHERE	customer_id > 2;

DELETE	FROM payment_arrangement_customer
WHERE	payment_id IN
	(
	SELECT	payment_id
	FROM	payment_all
	WHERE	customer_id > 2
	);

DELETE	FROM payment_all
WHERE	customer_id > 2;

DELETE	FROM cust_busunit_hist
WHERE	customer_id > 2;

DELETE	FROM billcycle_assignment_history
WHERE	customer_id > 2;

DELETE	FROM billing_account_version
WHERE	billing_account_id IN
	(
	SELECT	BILLING_ACCOUNT_ID
	FROM	billing_account
	WHERE	customer_id > 2
	);

DELETE	FROM fees
WHERE	customer_id > 2;

DELETE	FROM cashdetail
WHERE	cadxact IN
	(
	SELECT	caxact
	FROM	cashreceipts_all
	WHERE	customer_id > 2
	);

DELETE	FROM cashreceipts_all
WHERE	customer_id > 2;

DELETE	FROM ordertrailer_tax_items
WHERE	otxact IN
	(
	SELECT	ohxact
	FROM	orderhdr_all
	WHERE	customer_id > 2
	);

DELETE	FROM orderpromotrailer
WHERE	otxact IN
	(
	SELECT	ohxact
	FROM	orderhdr_all
	WHERE	customer_id > 2
	);

DELETE	FROM ordertrailer
WHERE	otxact IN
	(
	SELECT	ohxact
	FROM	orderhdr_all
	WHERE	customer_id > 2
	);

DELETE	FROM ordertax_items
WHERE	otxact IN
	(
	SELECT	ohxact
	FROM	orderhdr_all
	WHERE	customer_id > 2
	);

DELETE	FROM DCH_COLLECTIBLE_CTRL
WHERE	customer_id > 2;

DELETE	FROM orderhdr_all
WHERE	customer_id > 2;

DELETE	FROM billing_account
WHERE	customer_id > 2;

DELETE	FROM BCH_CUST_BILLED_AMOUNT
WHERE	customer_id > 2;

DELETE	FROM RLH_CUST_RATED_AMOUNT
WHERE	customer_id > 2;

DELETE	FROM RLH_OPEN_AMOUNT_LIMIT
WHERE	customer_id > 2;

DELETE	FROM ccontact_all
WHERE	customer_id > 2;

DELETE	FROM customer_family
WHERE	customer_id > 2;

DELETE	FROM customer_history
WHERE	customer_id > 2;

DELETE	FROM customer_role
WHERE	customer_id > 2;

DELETE	FROM individual_taxation
WHERE	customer_id > 2;

DELETE	FROM info_cust_text
WHERE	customer_id > 2;

DELETE	FROM info_cust_combo
WHERE	customer_id > 2;

DELETE	FROM bch_cust_history
WHERE	customer_id > 2;

DELETE	FROM contr_turnover
WHERE	customer_id > 2;

DELETE	FROM lbc_date_hist
WHERE	customer_id > 2;

DELETE	FROM customer_turnover
WHERE	customer_id > 2;

DELETE	FROM imb_customer
WHERE	customer_id > 2;

DELETE	FROM scheduled_job
WHERE	customer_id > 2;

DELETE	FROM scheduled_job_history
WHERE	customer_id > 2;

DELETE	FROM promo_assign_state
WHERE	customer_id > 2;

DELETE	FROM promo_assign
WHERE	customer_id > 2;

DELETE	FROM customer_base
WHERE	customer_id > 2;

DELETE	FROM info_cust_check
WHERE	customer_id > 2;

DELETE	FROM dr_documents;

DELETE	FROM bgh_bill_image_ref;

DELETE	FROM protection_status_hist;

DELETE	FROM payment_plan_bscs
WHERE	customer_id > 2;

DELETE	FROM bch_process_cust;

DELETE	FROM bch_process_package;

DELETE	from bch_process;

DELETE	FROM customer_all
WHERE	customer_id > 2;
