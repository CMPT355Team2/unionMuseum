DROP TABLE IF EXISTS tempdoors CASCADE;
DROP VIEW IF EXISTS newDoors CASCADE;


CREATE TABLE tempdoors 
AS SELECT * FROM ( 
	VALUES (
	:location_name_1,
	:museum_name_1,
	:sponsor_name_1,
	:location_name_2,
	:museum_name_2,
	:sponsor_name_2)) 
AS abc (
	drlname1, 
	drmname1, 
	drsname1, 
	drlname2, 
	drmname2, 
	drsname2
	);



insert into doors 
	SELECT tempdoors.drlname1, tempdoors.drmname1, tempdoors.drsname1, tempdoors.drlname2, tempdoors.drmname2, tempdoors.drsname2
	FROM tempdoors, doors
	where ((tempdoors.drlname1, tempdoors.drmname1, tempdoors.drsname1, tempdoors.drlname2, tempdoors.drmname2, tempdoors.drsname2) NOT IN (SELECT doors.drlname1, doors.drmname1, doors.drsname1, doors.drlname2, doors.drmname2, doors.drsname2 FROM doors))
	and (tempdoors.drmname1 in ('Museum of Moving Image', 'Seattle Art Museum', 'Birmingham Museum and Art Gallery', 'Prado Museum', 'Art Gallery NSW')
	and tempdoors.drmname1 = tempdoors.drmname2 
	and tempdoors.drlname1 <> tempdoors.drlname2 
	and tempdoors.drlname1 in (SELECT loclname FROM locations where tempdoors.drmname1 = locmname and locsecurity ISNULL) 
	and tempdoors.drlname2 in (SELECT loclname FROM locations where tempdoors.drmname2 = locmname and locsecurity ISNULL)
	and tempdoors.drsname1 = tempdoors.drsname2
	and tempdoors.drsname1 = 'patron')
	;

CREATE VIEW newDoors
	AS SELECT 
		doors.drlname1 AS "Location Name 1",
		doors.drmname1 AS "Museum Name 1",
		doors.drsname1 AS "Sponsor Name 1",
		doors.drlname2 AS "Location Name 2",
		doors.drmname2 AS "Museum Name 2",
		doors.drsname2 AS "Sponsor Name 2"
	FROM
		doors, tempdoors
	where
		doors.drlname1 = tempdoors.drlname1 and doors.drlname2 = tempdoors.drlname2
;



