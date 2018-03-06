LOAD	DATA
INFILE	*
INTO	TABLE mpdhmtab
APPEND
FIELDS	TERMINATED BY ';'
	(
	hmcode	SEQUENCE( MAX ),
	hlcode	CONSTANT '1',
	des,
	dirnum_npcode	CONSTANT '1',
	shdes	POSITION(1)
)
BEGINDATA
Barrackpore
Belmont
Carenage
Chin Chin
Crown Point
Haleland Park
La Romain
Moriah
Nelson
Poole/Fonrose
Thompson
