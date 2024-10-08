# 1

CREATE VIEW list_of_customers AS
	SELECT 	c.customer_id, CONCAT(c.first_name, ' ', c.last_name), a.address, a.postal_code, a.phone, ci.city, co.country,
    CASE
		WHEN c.active = 1 THEN 'active'
        ELSE 'inactive'
	END AS status, c.store_id
    FROM customer c
    INNER JOIN address a ON a.address_id = c.customer_id
    INNER JOIN city ci ON ci.city_id = a.city_id
    INNER JOIN country co ON co.country_id = ci.country_id;
    
SELECT * FROM list_of_customers;


# 2

CREATE VIEW film_details AS
	SELECT f.film_id, f.title, f.description, c.name, f.length, f.rating, GROUP_CONCAT(a.first_name, ' ', a.last_name)
    FROM film f
    INNER JOIN film_category fc ON fc.film_id = f.film_id
	INNER JOIN category c ON c.category_id = fc.category_id
    INNER JOIN film_actor fa ON fa.film_id = f.film_id
    INNER JOIN actor a ON a.actor_id = fa.actor_id
    GROUP BY f.film_id, f.title, f.description, c.name, f.length, f.rating;
    
SELECT * FROM film_details;


# 3

CREATE VIEW sales_by_film_category AS
SELECT 
    c.name AS category,
    SUM(p.amount) AS total_rental
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

SELECT * FROM sales_by_film_category;


# 4

CREATE VIEW actor_information AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

SELECT * FROM sales_by_film_category;


# 6 

-- Una vista materializada es un objeto de base de datos que almacena físicamente el resultado de una consulta, a diferencia de las vistas normales que solo guardan la definición de la consulta. Se usan para mejorar el rendimiento al evitar recalcular consultas complejas cada vez. Se pueden refrescar manualmente o programarse para actualizarse.

-- Alternativas: vistas normales, índices o capas de caché.

-- DBMS que las soportan: PostgreSQL, Oracle, y SQL Server (con "vistas indexadas").






