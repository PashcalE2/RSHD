create tablespace ts_mwd84 location '/var/postgres/postgres6/mwd84';
create tablespace ts_orw97 location '/var/postgres/postgres6/orw97';
create tablespace ts_uzb16 location '/var/postgres/postgres6/uzb16';

-- bash
-- createdb -p 9142 -T template0 sickorangecity
--

create database sickorangecity with template = template0;

create table sickorange (
	id serial primary key,
	name text,
	birthdate date
) 
tablespace ts_mwd84;

create table building (
	id serial primary key,
	street_id int,
	foreign key street_id references street(id),
	name text
) 
tablespace ts_orw97;

create table street (
	id serial primary key,
	name text
) 
tablespace ts_uzb16;

create role s311817 login password '123';
grant select, insert, update, delete 
on table sickorange, building, street 
to s311817;

-- bash
-- psql -h pg100 -p 9142 -d sickorangecity -U s311817
--

select * from pg_tablespace;

select relname from 
pg_class pgc inner join pg_tablespace pgts
on pgc.reltablespace = pgts.oid;

-- select relname from pg_class where reltablespace in (select oid from pg_tablespace);


insert into sickorange values (default, 'SickOrange3812536', '01/01/2000');
insert into sickorange values (default, 'SickOrange812738', '01/02/2001');
insert into sickorange values (default, 'SickOrange1234512', '02/01/2000');
insert into sickorange values (default, 'SickOrange94721', '03/03/2003');
insert into sickorange values (default, 'SickOrange712637', '11/11/2000');
insert into sickorange values (default, 'SickOrange761273', '09/11/2006');
insert into sickorange values (default, 'SickOrange9812378', '10/28/2000');
insert into sickorange values (default, 'SickOrange761237', '07/17/2004');

insert into street values (default, 'Main');
insert into street values (default, 'Branch13231');
insert into street values (default, 'Branch3211');
insert into street values (default, 'Branch98392');

insert into building values (default, 1, 'Building132763172');
insert into building values (default, 1, 'Building18237');
insert into building values (default, 1, 'Building9812376');
insert into building values (default, 1, 'Building1236712');
insert into building values (default, 2, 'Building99999');
insert into building values (default, 2, 'Building182620');
insert into building values (default, 2, 'Building87123671');
insert into building values (default, 3, 'Building11111111');
insert into building values (default, 3, 'Building331823782');
insert into building values (default, 3, 'Building323232323');
insert into building values (default, 3, 'Building8718273');
insert into building values (default, 3, 'Building9919237');
insert into building values (default, 3, 'Building3267666');
insert into building values (default, 4, 'Building8129362');
insert into building values (default, 4, 'Building993827');
insert into building values (default, 4, 'Building38382173');
