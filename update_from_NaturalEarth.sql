/*************************************************
* create and fill all traveller.geo information  *
*************************************************/
DROP SCHEMA IF EXISTS geo CASCADE;

CREATE SCHEMA geo;

CREATE TABLE geo.adm0
(
  id INTEGER PRIMARY KEY, 
  sovereignt VARCHAR (32) NOT NULL,
  sov3 VARCHAR (3) not null, 
  fqn VARCHAR (114) NOT NULL,
  name_en VARCHAR (52),
  name_es VARCHAR (52),
  name_pt VARCHAR (52),
  row_created_ TIMESTAMP WITH TIME ZONE DEFAULT current_timestamp
);

INSERT INTO geo.adm0
SELECT sovereignt, sov_a3, name_long, formal_en,formal_es,formal_pt
FROM import.adm0
;
