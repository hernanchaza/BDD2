Use imdb;

create table if not exists film
(
    film_id int auto_increment not null,
    title varchar (20),
    description varchar,
    release_year year,
    constraint pk primary key (film_id)
);

create table if not exists actor
(
    actor_id int auto_increment not null,
    first_name varchar(20),
    last_name varchar(20),
    constraint pk primary key (actor_id)  
);

create table if not exists film_actor
(
	actor_id int,
	film_id int
);

alter table film add column last_update date;
alter table actor add column last_update date;
alter table film_actor add constraint fk_film foreign key (film_id) references film(film_id);
alter table film_actor add constraint fk_autor foreign key (actor_id) references actor(actor_id);

insert into film (title, description, release_year) values('Metegol', 'Se trata de un metegol', '2017');
insert into actor (first_name, last_name) values('Leonado', 'Di-Caprio');
insert into film_actor (actor_id, film_id) values(1, 1);
