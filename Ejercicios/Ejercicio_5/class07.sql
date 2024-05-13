USE sakila;

# 1
SELECT title, rating FROM film WHERE LENGTH =  (SELECT MIN(`length`) FROM film);

# 2
SELECT title FROM film f1 WHERE LENGTH < ALL (SELECT LENGTH FROM film f2 WHERE f1.film_id != f2.film_id);

# 3
SELECT c.*, MIN(p.amount) AS lowest_amount,a.* FROM payment p
INNER JOIN customer c ON c.customer_id=p.customer_id
INNER JOIN ADDRESS a ON c.address_id=a.address_id 
GROUP BY p.customer_id;

SELECT p.amount AS lowest_amount,c.*,a.* FROM payment p
INNER JOIN customer c ON c.customer_id=p.customer_id
INNER JOIN ADDRESS a ON c.address_id=a.address_id 
WHERE p.amount <= all(SELECT amount FROM payment p2 WHERE p.customer_id=p2.customer_id)
GROUP BY p.customer_id, p.amount;

# 4
SELECT c.*, (SELECT MAX(p.amount) FROM payment p WHERE c.customer_id=p.customer_id) AS highest, (SELECT MIN(amount) FROM payment p WHERE c.customer_id=p.customer_id) AS lowest FROM customer c;
