DROP DATABASE IF EXISTS imdb;
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

CREATE TABLE film (
    film_id INT AUTO_INCREMENT NOT NULL,
    title VARCHAR(100),
    description TEXT,
    release_year INT,
    CONSTRAINT pk_film PRIMARY KEY (film_id)
);

CREATE TABLE actor (
    actor_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    CONSTRAINT pk_actor PRIMARY KEY (actor_id)
);

CREATE TABLE film_actor (
    actor_id INT NOT NULL,
    film_id INT NOT NULL,
    CONSTRAINT pk_film_actor PRIMARY KEY (actor_id, film_id),
    CONSTRAINT fk_actor FOREIGN KEY (actor_id) REFERENCES actor(actor_id) ON DELETE CASCADE,
    CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES film(film_id) ON DELETE CASCADE
);

INSERT INTO actor (first_name, last_name) VALUES
('Javier', 'Bardem'),
('Penélope', 'Cruz'),
('Ricardo', 'Darín'),
('Gael', 'García Bernal'),
('Salma', 'Hayek');

INSERT INTO film (title, description, release_year) VALUES
('Mar adentro', 'Historia de un hombre que lucha por su derecho a morir con dignidad.', 2004),
('El secreto de sus ojos', 'Un crimen que obsesiona a un hombre por decadas.', 2009),
('Babel', 'Cuatro historias interconectadas a través de la tragedia y la incomunicacion.', 2006),
('Frida', 'La vida de la iconica pintora mexicana Frida Kahlo.', 2002),
('Vicky Cristina Barcelona', 'Dos mujeres se enamoran del mismo pintor en Barcelona.', 2008);

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 5),
(3, 2),
(4, 3),
(5, 4);

SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM film_actor;