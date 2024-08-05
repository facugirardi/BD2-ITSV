USE sakila;


#Add a new customer
#To store 1
#For address use an existing address. The one that has the biggest address_id in 'United States'

INSERT INTO customer(store_id,address_id, first_name, last_name, email) VALUES(
  1,
  (SELECT max(address_id) FROM address a INNER JOIN city c ON c.city_id=a.city_id INNER JOIN country co ON c.country_id=co.country_id WHERE co.country='United States'),
  'Facundo Girardi',
  'asdasdas',
  'facundo@gmail.com'
  );


#Add a rental
#Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
#Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
#Select any staff_id from Store 2.

INSERT INTO rental (rental_date,inventory_id, staff_id, customer_id) VALUES(
  now(),
  (SELECT inventory_id FROM inventory i INNER JOIN film f ON f.film_id=i.film_id WHERE f.title='PRIDE ALAMO' LIMIT 1),
  (SELECT max(staff_id) FROM staff WHERE store_id=2), 3);


#Update film year based on the rating
#For example if rating is 'G' release date will be '2001'
#You can choose the mapping between rating and year.
#Write as many statements are needed.

UPDATE film
SET release_year= '2001'
WHERE rating='G';
UPDATE film
SET release_year= '2002'
WHERE rating='PG';
UPDATE film
SET release_year= '2003'
WHERE rating='NC-17';
UPDATE film
SET release_year= '2004'
WHERE rating='PG-13';
UPDATE film
SET release_year= '2005'
WHERE rating='R';
SELECT * FROM film ORDER BY rating;


#Return a film
#Write the necessary statements and queries for the following steps.
#Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
#Use the id to return the film.

UPDATE rental 
SET return_date=now()
WHERE rental_id=(SELECT max(rental_id) WHERE return_date IS NULL);
SELECT * FROM rental WHERE rental_id= 16053;


#Try to delete a film
#Check what happens, describe what to do.
#Write all the necessary delete statements to entirely remove the film from the DB.
  
DELETE FROM film WHERE film_id=1;
#Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE)

DELETE FROM film_actor WHERE film_id=1;
DELETE FROM film_category WHERE film_id=1;
DELETE FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id=1);
DELETE FROM inventory WHERE film_id=1;
DELETE FROM film WHERE film_id=1;
SELECT * FROM film ORDER B film_id ASC;


#Rent a film
#Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
#Add a rental entry
#Add a payment entry
#Use sub-queries for everything, except for the inventory id that can be used directly in the queries.

SELECT inventory_id FROM inventory i LEFT OUTER JOIN rental r USING(inventory_id) WHERE r.rental_id IS NULL LIMIT 1;
INSERT INTO rental (rental_date,inventory_id,customer_id,staff_id) VALUES (
	NOW(), 
	(4587), 
    (SELECT customer_id FROM customer LIMIT 1), 
    (SELECT staff_id FROM staff LIMIT 1));
    
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT customer_id FROM rental WHERE inventory_id = 4587 LIMIT 1),
    (SELECT staff_id FROM rental WHERE inventory_id = 4587 LIMIT 1),   
    (SELECT max(rental_id) FROM rental WHERE inventory_id = 4587),  
    466.43, 
    NOW() 
);


