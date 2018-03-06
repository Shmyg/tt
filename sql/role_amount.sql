SELECT	ri.role_name,
	sy.avthreshold,
	md.description
FROM	role_information	ri,
	sy_amountsrole		sa,
	sy_amountvalues		sy,
	modules			md
WHERE	ri.role_id = sa.role_id
AND	sa.au_avid = sy.av_id
AND	sy.AVMODFUNC = md.MODULENAME;
