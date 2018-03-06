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
Arima
Arouca
Chaguanas
Chaguaramas
Chatam
Claxton Bay
Couva
Cumberbatch
Diego Martin
Freeport
Fyzabad
Gasparilo
La Brea
Marabella
Maracas
Maraval
Mausica
Mayaro
Mt. Pleasant
Palo Seco
Penal
Piarco
Point Fortin
Port of Spain
Princes Town
Rio Claro
Roxborough
San Fernando
Sangre Grande
San Juan
Santa Cruz
Santa Rosa
Scarborough
Siparia
St. Augustine
Tobago
Toco
Trincity
West
