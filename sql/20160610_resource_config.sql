/*
|| Resource configuration
|| Created by Serge Shmygelskyy aka Shmyg
|| mailto: serge.shmygelskyy@gmail.com
||
|| $Log: 20160610_resource_config.sql,v $
|| Revision 1.1  2016/06/10 13:23:32  shmyg
|| Added resource script
||
||
*/

DECLARE

	c_filename	CONSTANT VARCHAR2(100) := '20160610_resource_config.sql';
	c_description	CONSTANT VARCHAR2(100) := 'Configuration of resources for Copper and Fiber';
	c_bug_id	CONSTANT PLS_INTEGER := '0';
	c_author	CONSTANT VARCHAR2(30) := 'SHMYG';
	v_rscode	PLS_INTEGER;
   
BEGIN

INSERT	INTO sysadm.rm_mig_script
	(
	mig_script_id,
	mig_script_name,
	des,
	author,
	bug_id
	)
(
SELECT	NVL (MAX (mig_script_id), 0) + 1,
	c_filename,
	c_description,
	c_author,
	c_bug_id
FROM	sysadm.rm_mig_script
);

-- Real job here
UPDATE	mpddrtab
SET	des = 'ISDN, TSTT FTTH numbers',
	shdes = 'FTTH'
WHERE	rscode = 10;

INSERT	INTO mpddrtab
	(
	rscode,
	des,
	resource_len_max,
	rec_version,
	shdes,
	special_validation_ind
	)
(
SELECT	MAX( rscode ) + 1,
	'ISDN, TSTT copper numbers',
	15,
	0,
	'Copper',
	NULL
FROM	mpddrtab
);

SELECT	MAX( rscode )
INTO	v_rscode
FROM	mpddrtab;

INSERT	INTO res_dirnum_structure
	(
	sccode,
	dirnum_npcode,
	rscode,
	dirnum_structure_def,
	dirnum_structure_des,
	dirnum_label,
	dirnum_format,
	dirnum_active_flag,
	dirnum_mmp_flag,
	dirnum_local_prefix_type,
	dirnum_subpart_without_ac,
	dirnum_ndc_type,
	support_vpn_rule,
	vpn_relation_type,
	dirnum_npcode_rscode_def,
	assignment_rule,
	inter_hplmn_assignment
	)
(
SELECT	sccode,
	dirnum_npcode,
	v_rscode,
	dirnum_structure_def,
	dirnum_structure_des,
	dirnum_label,
	dirnum_format,
	dirnum_active_flag,
	dirnum_mmp_flag,
	dirnum_local_prefix_type,
	dirnum_subpart_without_ac,
	dirnum_ndc_type,
	support_vpn_rule,
	vpn_relation_type,
	dirnum_npcode_rscode_def,
	assignment_rule,
	inter_hplmn_assignment
FROM	res_dirnum_structure
WHERE	rscode = 10
);

COMMIT;
                
END;
/
