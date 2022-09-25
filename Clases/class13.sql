use sakila;


/*1 Add a new customer - To store 1 - For address use an existing address. The one that has the biggest address_id in 'United States'*/
INSERT INTO sakila.customer
(store_id, first_name, last_name, email, address_id, active)
SELECT 1, 'Pepe', 'Suarez', 'pepesuarez@gmail.com', MAX(a.address_id), 1
FROM address a
WHERE (SELECT c.country_id
		FROM country c, city c1
		WHERE c.country = "United States"
		AND c.country_id = c1.country_id
		AND c1.city_id = a.city_id);
		
	
/*2 Add a rental*/
SELECT *
FROM customer
WHERE last_name = "Suarez";

INSERT INTO sakila.rental
(rental_date, inventory_id, customer_id, return_date, staff_id)
SELECT CURRENT_TIMESTAMP, 
		(SELECT MAX(r.inventory_id)
		 FROM inventory r
		 INNER JOIN film USING(film_id)
		 WHERE film.title = "ARABIA DOGMA"
		 LIMIT 1), 
		 600,
		 NULL,
		 (SELECT staff_id
		  FROM staff
		  INNER JOIN store USING(store_id)
		  WHERE store.store_id = 2
		  LIMIT 1);
		  
		 
		 
/*3- Update film year based on the rating*/
UPDATE sakila.film
SET release_year='2001'
WHERE rating = "G";

UPDATE sakila.film
SET release_year='2005'
WHERE rating = "PG";

UPDATE sakila.film
SET release_year='2010'
WHERE rating = "PG-13";

UPDATE sakila.film
SET release_year='2015'
WHERE rating = "R";

UPDATE sakila.film
SET release_year='2020'
WHERE rating = "NC-17";


/*4- Return a film*/
SELECT rental_id, rental_rate, customer_id, staff_id
FROM film
INNER JOIN inventory USING(film_id)
INNER JOIN rental USING(inventory_id)
WHERE rental.return_date IS NULL
LIMIT 1;

UPDATE sakila.rental
SET  return_date=CURRENT_TIMESTAMP
WHERE rental_id=11496;

/*5- Try to delete a film*/

DELETE film FROM film WHERE film_id = 1;

/*Resultado
Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`,
CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`)
ON UPDATE CASCADE)
La solucion para esto es borrar primero(en order de hijo a padre) las row a las que la pelicula esta relacionada.
Tambien se puede desactivar FOREIGN KEY CHECK y luego volver a activarlo, pero esto no es recomendable*/

/*6- Rent a film*/
SELECT inventory_id, film_id

FROM inventory

WHERE inventory_id NOT IN (SELECT inventory_id

FROM inventory

	INNER JOIN rental USING (inventory_id)

	WHERE return_date IS NULL)

INSERT INTO sakila.rental

(rental_date, inventory_id, customer_id, staff_id)

VALUES(

CURRENT_DATE(),

10,

(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),

(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 10))

);

INSERT INTO sakila.payment

(customer_id, staff_id, rental_id, amount, payment_date)

VALUES(

(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),

(SELECT staff_id FROM staff LIMIT 1),

(SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1) ,

(SELECT rental_rate FROM film WHERE film_id = 2),

CURRENT_DATE());
