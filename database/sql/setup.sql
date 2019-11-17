create database if not exists homepage;
create user if not exists homepage identified by 'homepage';
grant select on homepage.* to homepage@'%';
