CREATE DATABASE IF NOT EXISTS imdb;

USE imdb;

CREATE TABLE IF NOT EXISTS film (
    film_id INT AUTO_INCREMENT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    release_year INT NOT NULL,
    PRIMARY KEY (film_id)
);

CREATE TABLE IF NOT EXISTS actor (
    actor_id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (actor_id)
);

CREATE TABLE film_actor (
    actor_id INT,
    film_id INT,
    PRIMARY KEY (actor_id, film_id)
);

ALTER TABLE film
ADD COLUMN last_update DATETIME;

ALTER TABLE actor
ADD COLUMN last_update DATETIME;

ALTER TABLE film_actor
ADD CONSTRAINT fk_actor_id FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
ADD CONSTRAINT fk_film_id FOREIGN KEY (film_id) REFERENCES film(film_id);


INSERT INTO actor (first_name, last_name) VALUES
('Guillermo', 'Francella'),
('Ricardo', 'Darin'),
('Alejo', 'Vaquero'),
('Diego', 'Peretti');

INSERT INTO film (title, description, release_year) VALUES
('El Robo Del Siglo', 'Esta es la historia de uno de los robos a bancos más famosos de la historia argentina.', 2020),
('Carancho', 'Un accidente de tránsito cruza los destinos de una apasionada médica que lucha por salvar vidas y un locuaz abogado que busca clientes en las guardias.', 2010),
('Toy Story', 'Una pelicula e jueguetes que cobran vida.', 1999),
('El Robo Del Siglo', 'Esta es la historia de uno de los robos a bancos más famosos de la historia argentina.', 2020);

INSERT INTO film_actor (actor_id, film_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);
