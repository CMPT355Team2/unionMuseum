-- Ruida Xie
-- rux793
-- 11194258
-- test code

DROP view testForCollections if EXISTS CASCADE;
drop view testForExhitbition_collection if EXISTS CASCADE;
--1. test domain
\dD

--2.test tables
--i.	Select all potentially borrowed collections from my “collections” table and the new “works” table. If they have the same data, this test is pass.
CREATE VIEW testForCollections
	AS SELECT 
		collections.colalphakey AS "Alpha Key in Collections Table",
		nsworks.nswsacronym AS "Alpha Key in Works Table",
		collections.colnumkey AS "Numeric Key in Collections Table",
		(nsworks.nswscode) * '-1' + '1909145' AS "Numeric Key in Works Table",
		collections.acqsource AS "status in collections table",
		nsowners.nsowstatus AS "status in collections table"
	from
		collections, nsworks, nsowners
	where
		(((collections.colnumkey - '1909145') * '-1' = nsworks.nswscode 
		and (collections.colnumkey - '1909145') * '-1' = nsowners.nsowcode)
		or ((collections.colnumkey - '1909145') = nsworks.nswscode 
		and (collections.colnumkey - '1909145') = nsowners.nsowcode))
		and nsworks.nswscode = nsowners.nsowcode 
		and nsowners.nsowstatus = 'potentially borrowed'
		and collections.acqsource = 'potentially borrowed'
;

SELECT * from testForCollections;

--ii.	Select all works belongs to one specific exhibition from my “exhibition_collection” table and the new “works_exhibitions” table. If they have the same data, this test is pass.
CREATE VIEW testForExhitbition_collection
	AS SELECT
		exhibition_collection.ecalphakey AS "Alpha Key",
		nsworks_exhibitions.nsweacronym AS "Alpha Key",
		exhibition_collection.ecnumkey AS "Numeric Key",
		(nsworks_exhibitions.nswecode) * '-1' + '1909145' AS "Numeric Key",
		exhibition_collection.eccname AS "exhibition name"
	from
		exhibition_collection, nsworks_exhibitions
	where
		(((exhibition_collection.ecnumkey - '1909145') * '-1' = nsworks_exhibitions.nswecode
		or (exhibition_collection.ecnumkey - '1909145') = nsworks_exhibitions.nswecode))
		and exhibition_collection.eccname = 'East meets west'
		and nsworks_exhibitions.nsweename = 'East meets west'
;

SELECT * from testForExhitbition_collection

--iii.	Select all works in lobby from my “collection_location” table and the new “works_locations” table. If they have the same data, this test is pass.
SELECT * from collection_location where cllname = 'lobby';
SELECT * from nsworks_locations where nswllname = 'lobby';

--v.	Show all locations’ information stored in the new “locations” table, it should have 11 rows.
SELECT count (*) from nslocations;

--vi.	Select one specific location, compare the data between my “locations” table and the new “locations” table. If they have the same data, this test is pass.
SELECT * from locations where loclname = 'lobby';
SELECT nsloclname, nslocmeterlen, nslocmeterwid, nslocmeterhei, nsloccapacitymin, nsloccapacitymax from nslocations where nsloclname = 'lobby';

--viii.	Select one exhibition from the new “exhibitions” table compare it with my old “exhibitions” table. If they are the same, this test is pass.
SELECT exicname, estcdate, eencdate, exidescription from exhibitions where exicname = 'East meets west';
SELECT nsexename, nsexsdate, nsexedate, nsexedesc from nsexhibitions where nsexename = 'East meets west';
--ix.	Select one exhibition from my “exhibition_location” table and the new “exhibitions_locations” table. If they have the same data, this test is pass.
SELECT * from exhibition_location where elcname = 'East meets west';
select nselname, nselsdate, nsellname, nseledate from nsexhibitions_locations where nselname = 'East meets west';
--x.	Check the “institutions” table, it should have 18 rows.
SELECT count (*) from nsinstitutions ;
--xi.	The transactions table should have 33 rows.
SELECT count (*) from nstransactions;
--xiii.	Create 3 view for changedvalue, changedcount and chenagedemail table to check whether I created them correctly.
SELECT count (*) from nschangedvalue;
SELECT * from nschangedcount;
SELECT * from nschangedemail;
