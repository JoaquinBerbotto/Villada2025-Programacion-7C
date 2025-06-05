USE sakila;

#1
SELECT  co.country_id, co.country, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY  co.country_id, co.country
ORDER BY co.country, co.country_id;

#2
SELECT co.country, COUNT(ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country
HAVING COUNT(ci.city_id) > 10
ORDER BY city_count DESC;

#3
SELECT cu.first_name, cu.last_name, a.address, COUNT(r.rental_id) AS total_rentals, SUM(p.amount) AS total_spent
FROM customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN rental r ON cu.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, a.address
ORDER BY total_spent DESC;

#4
SELECT c.name AS category, AVG(f.length) AS avg_duration
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY avg_duration DESC;

#5
SELECT f.rating, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.rating
ORDER BY total_sales DESC;
