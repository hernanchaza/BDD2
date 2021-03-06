 use sakila;

/*1*/
select first_name, last_name from actor a1
where exists (select * from actor a2
				where a1.last_name = a2.last_name
				and a1.actor_id <> a2.actor_id)
order by last_name;

/*2*/
SELECT first_name, last_name
    FROM actor a
    WHERE NOT EXISTS(SELECT first_name, last_name
                        FROM film_actor fa
                        WHERE a.actor_id = fa.actor_id);

/*3*/
SELECT first_name, last_name
    FROM customer c
    WHERE 1=(SELECT COUNT(*)
                FROM rental r
                WHERE c.customer_id = r.customer_id);					 

/*4*/
SELECT first_name, last_name
    FROM customer c
    WHERE 1<(SELECT COUNT(*)
                FROM rental r
                WHERE c.customer_id = r.customer_id);
               
/*5*/
                       
SELECT last_name, first_name
  FROM actor 
 WHERE actor_id IN (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'BETRAYED REAR'))
   or actor_id in (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'CATCH AMISTAD'));
/*6*/
SELECT last_name, first_name
  FROM actor 
 WHERE actor_id IN (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'BETRAYED REAR'))
   and actor_id not in (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'CATCH AMISTAD'));

/*7*/
SELECT last_name, first_name
  FROM actor 
 WHERE actor_id IN (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'BETRAYED REAR'))
   and actor_id in (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'CATCH AMISTAD'));
/*8*/
SELECT last_name, first_name
  FROM actor 
 WHERE actor_id not IN (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'BETRAYED REAR'))
   and actor_id not in (SELECT actor_id 
                         FROM film_actor 
                        WHERE film_id in (SELECT film_id
                        							from film
                        							where title like 'CATCH AMISTAD'));

/*1. List all the actors that share the last name. Show them in order
2. Find actors that don't work in any film
3. Find customers that rented only one film
4. Find customers that rented more than one film
5. List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
6. List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
7. List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
8. List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
*/
