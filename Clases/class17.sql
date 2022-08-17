use sakila;

#1) Create two or three queries using address table in sakila db:
select postal_code
from address
where 20000 < postal_code and postal_code < 80000
order by postal_code asc;
#0.016 sec

select *
from address a
join city cty on a.city_id = cty.city_id
join country ctry on cty.country_id = ctry.country_id
where postal_code % 2 = 0
order by ctry.country_id;
#0.015 sec

create index postalCode on address(postal_code);

#after indez duration:
#0.000
#0.000

#2) Run queries using actor table, searching for first and last name columns independently.
# Explain the differences and why is that happening?

select first_name
from actor
where first_name like "%ll%"
order by first_name;

select last_name
from actor
where last_name like "%ll%"
order by last_name;


#3) Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST.
# Explain the results.

select `description`
from film
where `description` like "%epic%";

select `description`
from film_text
where match(`description`) against("epic");
