use sakila;

#1
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL;

#2
SELECT f.title, i.inventory_id
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

#3
SELECT c.first_name, c.last_name, c.store_id, f.title, r.rental_date, r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

#4
SELECT s.store_id, SUM(p.amount) AS total_sales
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
GROUP BY s.store_id;

#5
/*

1. Definición original:
------------------------------------------------------------
CREATE DEFINER=CURRENT_USER SQL SECURITY INVOKER VIEW actor_info AS
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
        (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
         FROM sakila.film f
         INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id
         INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id
         WHERE fc.category_id = c.category_id
           AND fa.actor_id = a.actor_id)
    ) ORDER BY c.name SEPARATOR '; ') AS film_info
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN sakila.film_category fc ON fa.film_id = fc.film_id
LEFT JOIN sakila.category c ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;

------------------------------------------------------------
2. Desglose paso a paso:
------------------------------------------------------------

- Se selecciona la información del actor:
    a.actor_id, a.first_name, a.last_name

- Se utiliza GROUP_CONCAT con un subquery para generar el campo `film_info`:

    GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ', (...)))

  Dentro de ese CONCAT, hay un subquery que recupera todas las películas
  del actor para una categoría específica:

    SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
    FROM film f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    WHERE fc.category_id = c.category_id
      AND fa.actor_id = a.actor_id

  Este subquery hace lo siguiente:
    - Filtra todas las películas (`film`) que pertenecen a la categoría `c.name`
    - Y en las que actuó el actor actual (`a.actor_id`)
    - Agrupa y ordena alfabéticamente los títulos con GROUP_CONCAT.

- El resultado del subquery se concatena con el nombre de la categoría (`c.name`)
  y se agrupan todas esas combinaciones por actor usando el GROUP_CONCAT exterior.

- El resultado se ordena por nombre de categoría (`ORDER BY c.name`)
  y se separa con `;`.

3. JOINs utilizados:
------------------------------------------------------------

FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film_category fc ON fa.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id

- Se utilizan LEFT JOINs para incluir también actores que no tienen
  ninguna película asociada.

- Se agrupa por actor para construir una única fila por actor.

4. Ejemplo de salida:
------------------------------------------------------------

| actor_id | first_name | last_name | film_info                                               |
|----------|------------|-----------|----------------------------------------------------------|
| 1        | PENELOPE   | GUINESS   | Action: ACADEMY DINOSAUR, ALIEN CENTER; Comedy: ...     |
| 2        | NICK       | WAHLBERG  | Drama: BIRDCAGE CASPER, DOGMA FAMILY; Sci-Fi: ...       |

*/

#6
/*
¿Qué son las Materialized Views?

Definición:
Una materialized view (vista materializada) es una vista cuyo resultado es almacenado físicamente en disco 
(a diferencia de las vistas normales, que son virtuales y se calculan en tiempo de consulta).

¿Para qué se usan?
- Aceleran consultas complejas y pesadas (especialmente con muchas joins o agregaciones).
- Útiles en entornos de análisis de datos o reportes donde los datos cambian poco y se consultan mucho.
- Mejoran el rendimiento a costa de ocupar más espacio y requerir actualizaciones manuales o programadas.

📚 ¿Dónde existen?
| DBMS              | ¿Soporta vistas materializadas? | Observaciones                     |
|------------------|----------------------------------|-----------------------------------|
| Oracle           | ✅ Sí                            | Muy potente y configurable        |
| PostgreSQL       | ✅ Sí                            | Desde versión 9.3                 |
| SQL Server       | ❌ No directamente               | Pero se pueden emular con índices |
| MySQL            | ❌ No nativo                     | Se puede emular con triggers      |
| MariaDB          | ❌ No nativo                     | Igual que MySQL                   |
| BigQuery         | ✅ Sí                            | Usadas para acelerar análisis     |
| Snowflake        | ✅ Sí                            | Soporte eficiente en la nube      |

Alternativas en MySQL:
- Crear una tabla de resumen y llenarla con un INSERT INTO ... SELECT ...
- Usar eventos programados para actualizar la tabla periódicamente
- Simular la vista con procedimientos almacenados o triggers
*/
