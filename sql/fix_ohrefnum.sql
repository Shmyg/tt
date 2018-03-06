DECLARE
	y	PLS_INTEGER := 0;
BEGIN
FOR	i IN
	(
	SELECT	ohrefnum
	FROM	orderhdr_all
	GROUP	BY ohrefnum
	HAVING	COUNT(*) > 1
)

LOOP
	y := 1;

	FOR	k IN
		(
		SELECT	ohxact
		FROM	orderhdr_all
		WHERE	ohrefnum = i.ohrefnum
		)
	LOOP
		UPDATE	orderhdr_all
		SET	ohrefnum = SUBSTR(ohrefnum, 1, 4 ) || y || SUBSTR( ohrefnum, 6)
		WHERE	ohxact = k.ohxact;
	y := y+1;
	END	LOOP;	

END	LOOP;
END;
/
