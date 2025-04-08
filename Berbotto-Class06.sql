use sakila;

#1
SELECT first_name, last_name
FROM actor a1
WHERE EXISTS (
       SELECT *
         FROM actor a2
        WHERE a1.last_name = a2.last_name
          AND a1.actor_id <> a2.actor_id
)ORDER BY last_name, first_name;

#2
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
	   SELECT actor_id
		 FROM film_actor
);

#3
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
       SELECT customer_id
         FROM rental
        GROUP BY customer_id
       HAVING COUNT(DISTINCT inventory_id) = 1
 );

#4
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
       SELECT customer_id
         FROM rental
        GROUP BY customer_id
       HAVING COUNT(DISTINCT inventory_id) > 1
 );

#5
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
       SELECT actor_id
         FROM film_actor
        WHERE film_id IN (
              SELECT film_id FROM film
               WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
        )
 )
;

#6
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
   SELECT actor_id
	 FROM film_actor
	WHERE film_id = (
		  SELECT film_id FROM film WHERE title = 'BETRAYED REAR'
	)
)
AND actor_id NOT IN (
   SELECT actor_id
	 FROM film_actor
	WHERE film_id = (
		  SELECT film_id FROM film WHERE title = 'CATCH AMISTAD'
	)
)
;

#7
SELECT first_name, last_name
FROM actor
	WHERE actor_id IN (
	   SELECT actor_id
		 FROM film_actor
		WHERE film_id = (SELECT film_id FROM film WHERE title = 'BETRAYED REAR')
	)
	AND actor_id IN (
	   SELECT actor_id
		 FROM film_actor
		WHERE film_id = (SELECT film_id FROM film WHERE title = 'CATCH AMISTAD')
	)
;

#8
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
   SELECT actor_id
	 FROM film_actor
	WHERE film_id IN (
		  SELECT film_id FROM film
		   WHERE title IN ('BETRAYED REAR', 'CATCH AMISTAD')
	)
)
;
