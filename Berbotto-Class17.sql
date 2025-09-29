use sakila;
set profiling = 1;

#1
select * 
from customer c
where c.active in (1);

select * 
from customer c
where c.active not in (1);

select c.first_name, c.last_name, c.email, co.country 
from customer c
inner join address a using(address_id)
inner join city ci using(city_id)
inner join country co using(country_id)
where co.country in ('canada','mexico','brazil');

explain
select c.first_name, c.last_name, c.email, co.country 
from customer c
inner join address a using(address_id)
inner join city ci using(city_id)
inner join country co using(country_id)
where co.country in ('canada','mexico','brazil');

show profiles;

-- sin indice la consulta tarda aprox 0.0034 segs

create index idx_country on country(country);

select c.first_name, c.last_name, c.email, co.country 
from customer c
inner join address a using(address_id)
inner join city ci using(city_id)
inner join country co using(country_id)
where co.country in ('canada','mexico','brazil');

show profiles;

-- con indice la consulta mejora, bajando a aprox 0.0020 segs


#2
select * 
from film f
where f.release_year = 2006;

show profiles; -- 0.0083 s

select * 
from film f
where f.length > 120;

show profiles; -- 0.0060 s

-- la consulta por release_year es mas rapida porque tiene un valor fijo y aprovecha el indice interno, en cambio length no

#3
select * from film;

select film_id, title, description
from film
where description like '%Epic%';

show profiles; -- 0.0048 s

alter table film
add fulltext(title, description);

select film_id, title, description
from film
where match(title, description) against('Epic');

show profiles; --  0.0021 s

-- al usar fulltext sobre title y description, la busqueda textual se nota mucho mas rapida
