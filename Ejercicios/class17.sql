# 1

SELECT
    address_id,
    address,
    postal_code
FROM
    address
WHERE
    postal_code LIKE '12345';


SELECT
    a.address_id,
    a.address,
    a.postal_code,
    c.city,
    co.country
FROM
    address a
JOIN
    city c ON a.city_id = c.city_id
JOIN
    country co ON c.country_id = co.country_id
WHERE
    a.postal_code LIKE '12345';


CREATE FULLTEXT INDEX postal_code ON address(postal_code);


SELECT
    a.address_id,
    a.address,
    a.postal_code,
    c.city,
    co.country
FROM
    address a
JOIN
    city c ON a.city_id = c.city_id
JOIN
    country co ON c.country_id = co.country_id
WHERE
    MATCH(postal_code) AGAINST('12345');


# 2

SELECT 
    actor_id,
    first_name,
    last_name
FROM 
    actor
WHERE 
    first_name = 'John';


SELECT 
    actor_id,
    first_name,
    last_name
FROM 
    actor
WHERE 
    last_name = 'Doe';


/* 

Al buscar por first_name o last_name en la tabla actor, si no hay índices en estas columnas, 
ambas consultas realizarán un escaneo completo de la tabla, lo que es lento en tablas grandes.
Si se tiene un índice en first_name, la búsqueda será más rápida porque el índice permite saltar 
directamente a las filas relevantes, y lo mismo ocurre con last_name si tiene un índice.

Para mejorar el rendimiento, se pueden crear índices en ambas columnas: 
*/

CREATE INDEX ind_first_name ON actor(first_name);
CREATE INDEX ind_last_name ON actor(last_name);

# Con los índices, ambas consultas se ejecutarán más rápido, evitando el escaneo completo de la tabla.



# 3
SELECT 
    film_id, 
    title, 
    description
FROM 
    film
WHERE 
    description LIKE '%action%';


SELECT 
    film_id, 
    title, 
    description
FROM 
    film_text
WHERE 
    MATCH(description) AGAINST('action');

