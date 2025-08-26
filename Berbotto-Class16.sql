use sakila;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 

(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),

(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),

(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);

DELIMITER $$
CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
     employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedat = NOW(); 
END$$
DELIMITER ;

UPDATE employees 
SET 
    lastName = 'Phan'
WHERE
    employeeNumber = 1056;

SELECT 
    *
FROM
    employees_audit;

#1
insert into employees 
(lastName, firstName, employeeNumber, extension, email, officeCode, reportsTo, jobTitle)
values
('Merentiel', 'Miguel Angel', 2025,  'x113', null, '2', 2010, 'RRHH');

/*
 En este caso, al intentar agregar un registro con el campo email en null, la base lo rechaza. 
 Esto pasa porque en la definicion de la tabla se especifico que la columna email es not null, 
 es decir, obligatoria. Esta restriccion evita que ingresen datos incompletos o invalidos, 
 reforzando la consistencia de la informacion, incluso si alguien intenta saltarse validaciones desde la aplicacion.
*/

#2

update employees set employeeNumber = employeeNumber - 20;

/*
 Al ejecutar esta sentencia (sin clausula where) mysql nos advierte que afectara todas las filas. 
 La operacion resta 20 al valor de employeeNumber de cada empleado, y como existe un trigger de auditoria, 
 cada cambio queda guardado en la tabla employees_audit, registrando el numero anterior, apellido y la fecha.
*/

update employees set employeeNumber = employeeNumber + 20;

/*
 En este segundo intento, ocurre un problema: al volver a sumar 20, se generan claves primarias duplicadas. 
 Por ejemplo, dos empleados terminan teniendo el mismo employeeNumber, lo cual rompe la restriccion de clave unica. 
 Por eso mysql detiene la ejecucion. Para resolver esto habria que aplicar la actualizacion en un orden 
 que evite superponer identificadores.
*/

 #3
alter table employees add column age int check (age between 16 and 70);

insert into employees 
(lastName, firstName, employeeNumber, extension, email, officeCode, reportsTo, jobTitle, age)
values
('Disalvo', 'Martin', 9921,  'x370', 'anashe@ejemplo.com', '1', null, 'Marketing', 31); -- funciona

insert into employees 
(lastName, firstName, employeeNumber, extension, email, officeCode, reportsTo, jobTitle, age)
values
('Benavidez', 'Geronimo', 9935, 'x371', 'fantasma@ejemplo.com', '1', null, 'Tomato Slicer', 14); -- error 

/*
 Con esta modificacion, la tabla ahora tiene un campo age que solo acepta valores en el rango de 16 a 70. 
 El primer insert se ejecuta bien porque cumple la condicion, mientras que el segundo falla porque el valor 14
 no respeta la restriccion check.
*/

#4

/*
 Las tres tablas estan relacionadas mediante claves foraneas. 
 film tiene la pk film_id, actor tiene actor_id y film_actor actua como tabla de relacion (n:m). 
 Gracias a estas fk, un actor solo puede asociarse a peliculas registradas y viceversa, 
 evitando que se guarden combinaciones con peliculas o actores inexistentes.
*/

#5

alter table employees
add column lastUpdate datetime default now(),
add column lastUpdateUser char(50);

delimiter $$
create trigger user_date_time_insert
before insert on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;

delimiter $$
create trigger user_date_time_update
before update on employees
for each row
begin
    set new.lastUpdate = now();
    set new.lastUpdateUser = user();
end$$
delimiter ;

insert into employees 
(lastName, firstName, employeeNumber, extension, email, officeCode, reportsTo, jobTitle)
values
('Merentiel', 'Miguel Angel', 2025,  'x113', 'bestia@gmail.com', '2', 2010, 'RRHH');

/*
 Con la columna lastUpdate y los triggers creados, cada vez que se inserta o modifica un empleado se registra la fecha y hora 
 del cambio junto con el usuario de mysql que lo realizo. Esto permite llevar un historial de auditoria directamente en la tabla.
*/

#6

show triggers like 'film';

/*
 Existen tres triggers asociados:
*/

/*
 ins_film (after)
 Este trigger se ejecuta despues de insertar en film. 
 Su funcion es copiar los datos basicos (id, titulo y descripcion) en film_text, 
 manteniendo ambas tablas sincronizadas.
*/

/*
 upd_film (after)
 Este trigger actua tras un update en film. 
 Primero comprueba si hubo cambios en los campos relevantes (id, titulo o descripcion). 
 Si los hubo, actualiza la fila correspondiente en film_text con los nuevos valores. 
 Asi se garantiza que la tabla film_text siempre refleje los datos actualizados.
*/

/*
 del_film (after)
 Este se dispara cuando se borra una pelicula. 
 Elimina tambien el registro asociado en film_text, evitando que queden entradas huerfanas.
*/
