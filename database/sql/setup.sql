show databases;

create database if not exists homepage;
create user if not exists homepage identified by 'homepage';
grant select on homepage.* to homepage@'%';

show databases;

create table homepage.notes (
  id bigint,
  note_id varchar(255) not null primary key,
  note_type varchar(255),
  url varchar(255),
  image varchar(255),
  is_public tinyint(1),
  --
  name varchar(255),
  --
  created_at timestamp,
  updated_at timestamp
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
;
