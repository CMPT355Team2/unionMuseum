DROP TABLE IF EXISTS tempInstitutions;

CREATE TABLE tempInstitutions(
	insinsname VARCHAR(50) PRIMARY KEY,
	insphone VARCHAR(50),
	insaddress VARCHAR(50),
	ceemail VARCHAR(50) NOT NULL
);

INSERT INTO tempInstitutions(insinsname,insphone,insaddress,ceemail)
VALUES(
	:new_institution_name,
	:institution_phone_number,
	:institution_address,
	:institution_email
);

INSERT INTO institutions ( insinsname, insphone, insaddress) 
SELECT insinsname, insphone, insaddress FROM tempInstitutions;

INSERT INTO changedemail ( ceinsname,
							 ceemail,
						     cesdate,
						     ceedate)
SELECT insinsname, ceemail, CURRENT_DATE, NULL FROM tempInstitutions;

DROP TABLE IF EXISTS tempInstitutions;



