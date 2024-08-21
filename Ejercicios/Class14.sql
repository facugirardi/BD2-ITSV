#1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

  SELECT concat(cu.first_name, ' ', cu.lASt_name),a.address, ci.city FROM customer cu INNER JOIN address a USING(address_id) INNER JOIN city ci USING(city_id) INNER JOIN country co USING(country_id) WHERE co.country='Argentina';

#Write a query that shows the film title, language and rating. Rating shall be shown AS the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use CASE.

  SELECT title, CASE rating
        WHEN 'G' THEN 'G (General Audiences) – All ages admitted.'
        WHEN 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
        WHEN 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
        WHEN 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
        WHEN 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.'
        ELSE 'Not Rated'
    end AS rating_formated,
    l.`name` FROM film INNER JOIN `language` l USING(language_id);
    
#Write a search query that shows all the films (title and release year) an actor was part of. 
#Assume the actor comes from a text box introduced by hand from a web page. 
  SELECT f.title, f.releASe_year, concat(a.first_name, ' ',a.lASt_name) AS nombre FROM film_actor fa INNER JOIN film f USING(film_id) INNER JOIN actor a USING(actor_id) WHERE lower(concat(a.first_name, ' ',a.lASt_name)) = lower('PENELOPE GUINESS');

#Find all the rentals done in the months of May and June.
#Show the film title, customer name and if it was returned or not. 
#There should be returned column with two possible values 'Yes' and 'No'.

  SELECT f.title, c.first_name, CASE 
  WHEN r.return_date  IS NOT NULL THEN 'Yes'
  ELSE 'No' end AS Returned
   FROM rental r 
   INNER JOIN inventory USING(inventory_id)
   INNER JOIN film f USING(film_id)
   INNER JOIN customer c USING(customer_id)
   WHERE month(rental_date)=5 or month(rental_date)=6;
 
 #4 
 SELECT title, CAST(rental_rate AS signed) AS rental_rate_int FROM film;
 SELECT title, convert(rental_rate, signed) AS rental_rate_int FROM film;
 
 #5
SELECT ifnull(rental_rate, 0) AS rental_rate
FROM film;

SELECT COALESCE(rental_rate, 0) AS rental_rate
FROM film;
