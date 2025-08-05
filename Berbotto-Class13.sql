use sakila;

-- 1)

insert into customer (
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    create_date
)
values (
    1,
    'Joaquin',
    'Berbotto',
    'joa@pepe.com',
    (
        select address_id
        from address
        where district = 'United States'
        order by address_id desc
        limit 1
    ),
    current_timestamp
);

-- 2)

insert into rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
)
values (
    current_timestamp,
    (
        select i.inventory_id
        from inventory i
        join film f on i.film_id = f.film_id
        where f.title = 'ACADEMY DINOSAUR'
        order by i.inventory_id desc
        limit 1
    ),
    (
        select customer_id
        from customer
        order by customer_id desc
        limit 1
    ),
    (
        select staff_id
        from staff
        where store_id = 2
        limit 1
    )
);

-- 3)

update film
set release_year = 2001
where rating = 'G';

update film
set release_year = 2002
where rating = 'PG';

update film
set release_year = 2003
where rating = 'PG-13';

update film
set release_year = 2004
where rating = 'R';

update film
set release_year = 2005
where rating = 'NC-17';

-- 4)

update rental
set return_date = current_timestamp
where rental_id = (
    select rental_id
    from rental
    where return_date is null
    order by rental_date desc
    limit 1
);

-- 5)

-- Paso 1: eliminar pagos

delete from payment
where rental_id in (
    select rental_id
    from rental
    where inventory_id in (
        select inventory_id
        from inventory
        where film_id = (
            select film_id
            from film
            where title = 'ACADEMY DINOSAUR'
            limit 1
        )
    )
);

-- Paso 2: eliminar rentals

delete from rental
where inventory_id in (
    select inventory_id
    from inventory
    where film_id = (
        select film_id
        from film
        where title = 'ACADEMY DINOSAUR'
        limit 1
    )
);

-- Paso 3: eliminar del inventario

delete from inventory
where film_id = (
    select film_id
    from film
    where title = 'ACADEMY DINOSAUR'
    limit 1
);

-- Paso 4: eliminar la película

delete from film
where title = 'ACADEMY DINOSAUR';

-- uso inventory_id 5 (reemplazar si es necesario)

insert into rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
)
values (
    current_timestamp,
    5,
    (
        select customer_id
        from customer
        order by customer_id desc
        limit 1
    ),
    (
        select staff_id
        from staff
        where store_id = 1
        limit 1
    )
);

insert into payment (
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
values (
    (
        select customer_id
        from customer
        order by customer_id desc
        limit 1
    ),
    (
        select staff_id
        from staff
        where store_id = 1
        limit 1
    ),
    (
        select rental_id
        from rental
        order by rental_id desc
        limit 1
    ),
    4.99,
    current_timestamp
);



