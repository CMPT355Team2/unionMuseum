DROP TABLE IF EXISTS templocations CASCADE;
DROP VIEW IF EXISTS newLocations CASCADE;

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
	SELECT templocations.loclname, templocations.locmname, templocations.locsname, templocations.locsecurity, templocations.locinsvalue, templocations.locmeterlen, templocations.locmeterwid, templocations.locmeterhei, templocations.loccapacitymin, templocations.loccapacitymax
	FROM templocations, locations
	where ((templocations.loclname, templocations.locmname, templocations.locsname) NOT IN (SELECT loclname, locmname, locsname FROM locations))
	and ((templocations.locsecurity NOTNULL and templocations.locinsvalue NOTNULL) and templocations.locmeterlen ISNULL and templocations.locmeterwid ISNULL and templocations.locmeterhei ISNULL and templocations.loccapacitymin ISNULL and templocations.loccapacitymax ISNULL)
	;

insert into locations
	SELECT templocations.loclname, templocations.locmname, templocations.locsname, templocations.locsecurity, templocations.locinsvalue, templocations.locmeterlen, templocations.locmeterwid, templocations.locmeterhei, templocations.loccapacitymin, templocations.loccapacitymax
	FROM templocations, locations
	where ((templocations.loclname, templocations.locmname, templocations.locsname) NOT IN (SELECT loclname, locmname, locsname FROM locations))
	and ((templocations.locsecurity NOTNULL and templocations.locinsvalue NOTNULL) and templocations.locmeterlen ISNULL and templocations.locmeterwid ISNULL and templocations.locmeterhei ISNULL and templocations.loccapacitymin ISNULL and templocations.loccapacitymax ISNULL)
	;


CREATE VIEW newLocations
	AS SELECT 
		locations.loclname AS "Location Name",
		locations.locmname AS "Museum Name",
		locations.locsname AS "Sponsor Name",
		locations.locsecurity AS "Security Name",
		locations.locinsvalue AS "Insurance Value",
		locations.locmeterlen AS "Location Length",
		locations.locmeterwid AS "Location Width",
		locations.locmeterhei AS "Location Height",
		locations.loccapacitymin AS "Minimum Capacity",
		locations.loccapacitymax AS "Maximum Capacity"
	FROM
		locations, templocations
	where
		locations.loclname = templocations.loclname and locations.locmname = templocations.locmname
;
