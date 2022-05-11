/*
1. Find the films with less duration, show the title and rating.
2. Write a query that returns the title of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
3. Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
4. Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
*/

/*1*/
SELECT f1.title, f1.rating
	FROM film f1 
	WHERE f1.`length` <= ALL (SELECT f2.`length` 
		FROM film f2  
		WHERE f1.film_id <> f2.film_id);

/*2*/
SELECT f1.title, f1.rating
	FROM film f1 
	WHERE f1.`length` < ALL (SELECT f2.`length` 
		FROM film f2  
		WHERE f1.film_id <> f2.film_id);

/*3*/
SELECT CONCAT(firt_name, last_name) AS 'Nombre completo', first_name, last_name,
	(SELECT DISTINCT(amount)
          FROM payment p
         WHERE customer.customer_id = p.customer_id 
           AND amount <= ALL (SELECT amount 
                                FROM payment p2
                               WHERE customer.customer_id = p2.customer_id))
			AS min_amount 
	FROM customer
	order by min_amount;

/*3 Other way*/
SELECT first_name, last_name,
	(SELECT MIN(amount)
          FROM payment p
         WHERE customer.customer_id = p.customer_id)
	AS min_amount
FROM customer
order by min_amount;

/*4*/
SELECT first_name, last_name,
	(SELECT CONCAT(MIN(amount), ' - ', MAX(amount))
          FROM payment p
         WHERE customer.customer_id = p.customer_id)
	AS min_max_amount
FROM customer
order by min_max_amount;