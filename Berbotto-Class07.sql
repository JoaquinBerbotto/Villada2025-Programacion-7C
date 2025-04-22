USE sakila;

#1
SELECT title, rating
FROM film
WHERE length = (SELECT MIN(length) FROM film);


#2
SELECT title
FROM film
WHERE length = (SELECT MIN(length) FROM film)
AND (SELECT COUNT(*) FROM film WHERE length = (SELECT MIN(length) FROM film)) = 1;


#3A (min)
SELECT c.customer_id, c.first_name, c.last_name, a.address, p.min_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN (
    SELECT customer_id, MIN(amount) AS min_payment
    FROM payment
    GROUP BY customer_id
) p ON c.customer_id = p.customer_id;

#3B (all)
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, a.address, p.amount AS min_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount <= ALL (
    SELECT p2.amount
    FROM payment p2
    WHERE p2.customer_id = c.customer_id
);

#3C (any)
SELECT c.customer_id, c.first_name, c.last_name, a.address, p.amount
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.amount < ANY (
    SELECT amount
    FROM payment
    WHERE customer_id = c.customer_id AND amount IS NOT NULL
);

#4
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    a.address,
    (SELECT MAX(amount) FROM payment p WHERE p.customer_id = c.customer_id) AS max_payment,
    (SELECT MIN(amount) FROM payment p WHERE p.customer_id = c.customer_id) AS min_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id;

