create table issues (
id bigint not null primary key AUTO_INCREMENT,
summary varchar(256) not null ,
description varchar(256) not null
);

create table users (
username varchar(50) not null primary key,
password varchar(500) not null,
authority enum('ADMIN', 'USER') not null
);