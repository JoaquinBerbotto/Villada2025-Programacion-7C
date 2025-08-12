-- 1
select 
    lower(concat_ws(' ', c.first_name, c.last_name)) as full_name,
    lower(a.address) as address,
    lower(ci.city) as city
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where lower(co.country) = 'argentina';

-- 2
select 
    lower(f.title) as title,
    lower(l.name) as language,
    case f.rating
        when 'G' then 'general audiences'
        when 'PG' then 'parental guidance suggested'
        when 'PG-13' then 'parents strongly cautioned'
        when 'R' then 'restricted'
        when 'NC-17' then 'adults only'
        else 'unknown'
    end as rating_description
from film f
join language l on f.language_id = l.language_id;

-- 3
select 
    lower(f.title) as title,
    f.release_year
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where lower(concat_ws(' ', a.first_name, a.last_name)) like concat('%', lower(trim('actor name here')), '%');

-- 4
select 
    lower(f.title) as title,
    lower(concat_ws(' ', c.first_name, c.last_name)) as customer_name,
    if(r.return_date is not null, 'yes', 'no') as returned
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
where month(r.rental_date) in (5, 6);

-- 5
-- CAST y CONVERT en sakila
select 
    cast(r.rental_date as date) as rental_date_cast,
    convert(r.rental_date, date) as rental_date_convert
from rental r
limit 5;

-- INVESTIGACION CAST vs CONVERT:
-- CAST: convierte un valor a un tipo de dato especifico segun la sintaxis standard SQL.
-- CONVERT: en MySQL, hace lo mismo que CAST, pero su sintaxis tambien permite cambiar el conjunto de caracteres.
-- Ejemplo:
-- select cast('2025-08-12' as date);
-- select convert('2025-08-12', date);

#6
-- NVL, ISNULL, IFNULL, COALESCE
-- NVL: no existe en MySQL (es de Oracle), reemplaza valores nulos por uno especificado.
-- ISNULL: en MySQL es una funcion que devuelve 1 si el valor es nulo y 0 si no lo es.
-- IFNULL: en MySQL devuelve un valor alternativo si el primero es nulo.
-- COALESCE: devuelve el primer valor no nulo de una lista.
-- Ejemplo con sakila:
select 
    ifnull(r.return_date, 'not returned') as return_status_ifnull,
    coalesce(r.return_date, r.rental_date) as return_status_coalesce,
    isnull(r.return_date) as isnull_flag
from rental r
limit 5;
