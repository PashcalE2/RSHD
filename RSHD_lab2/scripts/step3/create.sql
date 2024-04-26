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
grant select, insert, update, delete on table sickorange, building, street to s311817;

-- bash
-- psql -h pg100 -p 9142 -d sickorangecity -U s311817
--
