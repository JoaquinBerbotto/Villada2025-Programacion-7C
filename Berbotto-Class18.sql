use sakila;

#1
delimiter $$
create function cantidad_copias2(
    p_film_id int,
    p_film_title varchar(255),
    p_store_id int
)
returns int
deterministic
reads sql data
begin
    declare v_film int default null;
    declare v_total int default 0;

    if p_film_id is not null and p_film_id > 0 then
        set v_film = p_film_id;
    else
        select film_id into v_film
        from film
        where title = p_film_title
        limit 1;
    end if;

    if v_film is null then
        return 0;
    end if;

    select count(*) into v_total
    from inventory i
    where i.film_id = v_film
      and i.store_id = p_store_id;

    return ifnull(v_total, 0);
end$$
delimiter ;

select cantidad_copias2(null, 'academy dinosaur', 1) as total_copias_por_titulo;
select cantidad_copias2(1, null, 1) as total_copias_por_id;


#2
delimiter //
create procedure clientes_por_pais2(
    in p_pais varchar(100),
    out p_lista text
)
begin
    declare done_flag smallint default 0;
    declare v_nombre varchar(200);

    declare cur_clientes cursor for
        select concat(c.first_name, ' ', c.last_name)
        from customer c
        join address a using(address_id)
        join city ci using(city_id)
        join country co using(country_id)
        where co.country = p_pais;

    declare continue handler for not found set done_flag = 1;

    set p_lista = '';

    open cur_clientes;
    read_loop: loop
        fetch cur_clientes into v_nombre;
        if done_flag = 1 then
            leave read_loop;
        end if;
        if p_lista = '' then
            set p_lista = v_nombre;
        else
            set p_lista = concat(p_lista, ';', v_nombre);
        end if;
    end loop;
    close cur_clientes;
end//
delimiter ;

call clientes_por_pais2('Brazil', @lista);
select @lista;


#3a
delimiter $$
create function is_inventory_available(
    p_inventory_id int
)
returns tinyint(1)
deterministic
reads sql data
begin
    declare v_exists int default 0;
    select exists(
        select 1
        from rental r
        where r.inventory_id = p_inventory_id
          and r.return_date is null
    ) into v_exists;

    if v_exists = 1 then
        return 0;
    else
        return 1;
    end if;
end$$
delimiter ;

#3b
delimiter //
create procedure count_films_in_store(
    in p_film_id int,
    in p_store_id int,
    out p_count int
)
begin
    select count(*) into p_count
    from inventory i
    where i.film_id = p_film_id
      and i.store_id = p_store_id
      and is_inventory_available(i.inventory_id) = 1;
end//
delimiter ;

#3c 
select is_inventory_available(inventory_id) as disponible, inventory_id from inventory limit 5;
call count_films_in_store(1, 1, @total_stock);
select @total_stock;
