use sakila;

#1
create user 'usuario'@'%' identified by '1234';

#2
grant select, update, delete on sakila.* to 'usuario'@'%';

#3
create table tabla (
  nombre varchar(50)
);

-- Respuesta --> Error Code: 1142. CREATE command denied to user 'usuario'@'%' for table 'tabla'

#4
update film
set title = 'academia dinosaurio'
where title = 'ACADEMY DINOSAUR';

select film_id, title from film where title like '%academia%';

#5
revoke update on sakila.* from 'usuario'@'%';

#6
update film
set title = 'academy dinosaur'
where title = 'academia dinosaurio';

-- Respuesta --> UPDATE command denied to user 'usuario'@'%' for table 'film'