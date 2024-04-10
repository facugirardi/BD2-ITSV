USE sakila;

SELECT title, special_features FROM film WHERE rating = 'PG-13';

SELECT length FROM film;

SELECT title, rental_rate, replacement_cost FROM film WHERE replacement_cost BETWEEN 20.00 AND 24.00;

SELECT film.title, film.description, film.rating FROM film 
WHERE film.special_features like "%Behind the Scenes%";

SELECT actor.first_name, actor.last_name FROM actor
INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
INNER JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'ZOOLANDER FICTION';

SELECT address.address, city.city, country.country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE store.store_id = 1;

SELECT film1.title AS title1, film2.title AS title2, film1.rating
FROM film film1
JOIN film film2 ON film1.rating = film2.rating AND film1.film_id <> film2.film_id;

SELECT film.title, film.release_year, staff.first_name AS manager_of_store2
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN store ON store.store_id = inventory.store_id
INNER JOIN staff ON store.manager_staff_id = staff.staff_id
WHERE store.store_id = 2;
