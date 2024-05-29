USE sakila;

# 1
SELECT * FROM film f WHERE NOT f.film_id IN(SELECT film_id FROM inventory);
SELECT i.inventory_id, f.* FROM film f LEFT OUTER JOIN inventory i USING(film_id) WHERE i.inventory_id IS NULL;

# 2
SELECT f.title, i.inventory_id FROM film f
INNER JOIN inventory i USING(film_id)
LEFT OUTER JOIN rental r USING(inventory_id)
WHERE r.rental_id IS NULL;

# 3
SELECT concat(c.first_name, " ",c.last_name) AS complete_name, s.store_id, f.title FROM rental r
INNER JOIN customer c USING(customer_id)
INNER JOIN store s USING(store_id)
INNER JOIN inventory i USING(inventory_id)
INNER JOIN film f USING(film_id)
WHERE r.return_date IS NOT NULL;

# 4
SELECT s1.store_id AS 'Tienda',
CONCAT(co.country, ', ', ci.city) AS 'Location', CONCAT(sta.first_name, ' ', sta.last_name) AS 'Manager',
concat("$",(SELECT sum(p.amount) FROM rental 
INNER JOIN inventory USING(inventory_id) 
INNER JOIN store s2 USING(store_id) 
INNER JOIN payment p USING(rental_id) 
WHERE s1.store_id=s2.store_id)) AS total_sales
FROM store s1
INNER JOIN address USING(address_id)
INNER JOIN city ci USING(city_id)
INNER JOIN country co USING(country_id)
INNER JOIN staff sta ON sta.staff_id = s1.manager_staff_id;

# 5
SELECT a1.*, count(f_a.film_id) AS cantidad FROM actor a1
INNER JOIN film_actor f_a USING(actor_id)
INNER JOIN film f USING(film_id)
GROUP BY a1.actor_id
HAVING cantidad > all (
SELECT count(fa.film_id) AS cant_films FROM actor a2
INNER JOIN film_actor fa ON a2.actor_id = fa.actor_id 
WHERE a2.actor_id != a1.actor_id
GROUP BY a2.actor_id );