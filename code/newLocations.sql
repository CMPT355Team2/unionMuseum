
DROP TABLE IF EXISTS templocations CASCADE;

CREATE TABLE templocations 
AS SELECT * FROM ( 
	VALUES (
	:location_name,
	:location_museum_name,
	:location_sponsor_name,
	:location_security,
	:location_insurance_value,
	:location_length,
	:location_width,
	:location_height,
	:location_capacity_min,
	:location_capacity_max)) 
AS abc (
	loclname, 
	locmname, 
	locsname, 
	locsecurity, 
	locinsvalue, 
	locmeterlen, 
	locmeterwid, 
	locmeterhei, 
	loccapacitymin, 
	loccapacitymax
	);

insert into locations
	SELECT loclname, locmname, locsname, locsecurity, locinsvalue, locmeterlen, locmeterwid, locmeterhei, loccapacitymin, loccapacitymax
	FROM templocations
	where (locsecurity ISNULL and locinsvalue ISNULL) and locmeterlen NOTNULL and locmeterwid NOTNULL and locmeterhei NOTNULL and loccapacitymin NOTNULL and loccapacitymax NOTNULL
	;

insert into locations
	SELECT loclname, locmname, locsname, locsecurity, locinsvalue, locmeterlen, locmeterwid, locmeterhei, loccapacitymin, loccapacitymax
	FROM templocations
	where (locsecurity NOTNULL and locinsvalue NOTNULL) and locmeterlen ISNULL and locmeterwid ISNULL and locmeterhei ISNULL and loccapacitymin ISNULL and loccapacitymax ISNULL
	;

DROP TABLE IF EXISTS templocations CASCADE;
