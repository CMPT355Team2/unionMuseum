-- 	'1444', 
-- 	'YHZ', 
-- 	'Seattle Art Museum', 
-- 	'A Branch of the Humidity Season', 
-- 	'Asia', 
-- 	'15th century', 
-- 	'Hanging Scroll', 
-- 	'Yang Huizhi', 
-- 	'1444-12-31', 
-- 	current_date, 
-- 	'Ming dynasty, Ubiquitous in Chinese painting, poetry, ornament, and in nature, the flowering plum (mei hua), is uncontested as China??s favorite blossom.'
-- 	'1444', 
-- 	'YHZ', 
-- 	'Seattle Art Museum',
-- 	'Chinese Kongzi College',
-- 	current_date,
-- 	null,
BEGIN


drop table if exists temp_works cascade;
delete from works where works.wscode = '1444' and works.wsacronym = 'YHZ';
create table temp_works (
    newcode code, 
    newacronym acronym, 
    newmname mname, 
    newwname wname, 
    newregion region, 
    newcentury century, 
    newcategory category, 
    newauthor author, 
    newcdatecom cdatecom, 
    newadateacq adateacq, 
    newwdesc wdesc, 
    newstatus status, 
    newinsvalue insvalue, 
    newinsname insname
);

insert into 
	temp_works
values (
	:new_work_code,
	:new_work_acronym,
	:new_work_mname, 
	:new_work_wname, 
	:new_work_region, 
	:new_work_century, 
	:new_work_category, 
	:new_work_author, 
	:new_work_cdatecom, 
	:new_work_adateacq, 
	:new_work_wdesc,
	:new_work_status,
	:new_work_insvalue,
	:new_work_insname
);


insert into 
	works
select 
	tw.newcode,
	tw.newacronym,
	tw.newmname,
	tw.newwname,
	tw.newregion,
	tw.newcentury,
	tw.newcategory,
	tw.newauthor,
	tw.newcdatecom,
	tw.newadateacq,
	tw.newwdesc
from 
	temp_works tw
where 
	tw.newwname is not null and
	tw.newauthor is not null and
	tw.newcdatecom is not null and
	tw.newwdesc is not null;



insert into 
	changedvalue
select
	tw.newcode,
	tw.newacronym,
	tw.newmname,
	tw.newadateacq,
	null,
	tw.newinsvalue
from 
	temp_works tw
where
	tw.newinsvalue is not null and
	tw.newadateacq is not null;



insert into 
	owners
select
	tw.newcode,
	tw.newacronym,
	tw.newmname,
	tw.newinsname,
	tw.newadateacq,
	null,
	tw.newstatus
from
	temp_works tw
where
	tw.newadateacq is not null and
	tw.newstatus is not null and
	tw.newinsname is not null;





