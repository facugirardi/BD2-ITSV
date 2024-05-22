# BD2-ITSV
### Table creation

Example

```sql
CREATE TABLE contacts
( contact_id INT(11) NOT NULL AUTO_INCREMENT,
  last_name VARCHAR(30) NOT NULL,
  first_name VARCHAR(25),
  birthday DATE,
  CONSTRAINT contacts_pk PRIMARY KEY (contact_id)
);
```

### Altering Tables
#### Add Primary Keys

Example

```sql
ALTER TABLE contacts
  ADD CONSTRAINT contacts_pk
    PRIMARY KEY (last_name, first_name);
```

#### Add column

Example

```sql
ALTER TABLE contacts
  ADD last_name varchar(40) NOT NULL
    AFTER contact_id;
```

#### Modify column definition (datatype)

Example

```sql
ALTER TABLE contacts
  MODIFY last_name varchar(50) NULL;
```

#### Drop column

```sql
ALTER TABLE table_name
  DROP COLUMN column_name;
```

#### Rename column

Example

```sql
ALTER TABLE contacts
  CHANGE COLUMN contact_type ctype
    varchar(20) NOT NULL;
```

#### Rename table

```sql
ALTER TABLE table_name
  RENAME TO new_table_name;
```

Example

```sql
ALTER TABLE contacts
  RENAME TO people;
```

#### Add Foreign Key 

Example

```sql
CREATE TABLE products
( product_name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  category VARCHAR(25),
  CONSTRAINT products_pk PRIMARY KEY (product_name, location)
);

CREATE TABLE inventory
( inventory_id INT PRIMARY KEY,
  product_name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  quantity INT,
  min_level INT,
  max_level INT
);

ALTER TABLE inventory ADD 
  CONSTRAINT fk_inventory_products
    FOREIGN KEY (product_name, location)
    REFERENCES products (product_name, location);
```

# DML
Data manipulation language operations are:

- SELECT
- INSERT
- UPDATE

## SELECT

```sql
SELECT A1, A2, A3..., An
FROM T1, T2, T3,..., Tn
WHERE condition
```

### Operators in The WHERE Clause

| Comparison Operator | Description                                           |
|---------------------|-------------------------------------------------------|
| =                   | Equal                                                 |
| <=>                 | Equal (MySql, safe to compare NULL values)            |
| <>                  | Not Equal                                             |
| !=                  | Not Equal                                             |
| >                   | Greater Than                                          |
| >=                  | Greater Than or Equal                                 |
| <                   | Less Than                                             |
| <=                  | Less Than or Equal                                    |
| BETWEEN             | Within a range (inclusive)                            |
| NOT                 | Negates a condition                                   |
| IS NULL             | NULL value                                            |
| IS NOT NULL         | Non-NULL value                                        |
| LIKE                | Pattern matching with % and _                         |
| IN ( )              | Matches a value in a list                             |
| EXISTS              | Condition is met if subquery returns at least one row |

# Simple queries

## Conditions
```sql
SELECT title, rating, length
FROM film
WHERE length > 100;
```
```sql
SELECT title, `length` FROM film
WHERE `length` BETWEEN 100 AND 120;
```

## Mutilple Tables
```sql
SELECT city, district
FROM address, city
WHERE address.city_id = city.city_id;
```

## Adding distinct
```sql
SELECT [DISTINCT] country, city
FROM address, city, country
WHERE address.city_id = city.city_id
AND city.country_id = country.country_id;
```

## Conditions with columns in different tables 
```sql
SELECT title, name
FROM film, `language`
WHERE film.language_id = language.language_id
AND film.`length` > 100 AND language.name = 'English'
```

## Ambigous column names
```sql
SELECT title, category_id
 FROM film, film_category, category
WHERE film.film_id = film_category.film_id 
  AND film_category.category_id = category.category_id
``` 

## Adding Order BY
```sql
SELECT title, special_features, rental_rate, name
 FROM film, film_category, category
WHERE film.film_id = film_category.film_id 
  AND film_category.category_id = category.category_id
ORDER BY rental_rate DESC
```
### More than one column
```sql
SELECT title, special_features, rental_rate, name
 FROM film, film_category, category
WHERE film.film_id = film_category.film_id 
  AND film_category.category_id = category.category_id
ORDER BY rental_rate DESC, special_features ASC
```
## Using Limit
```sql
SELECT * FROM actor
LIMIT 10;
```

## Like

| Wildcard | Explanation                                                          |
|----------|----------------------------------------------------------------------|
| %        | Allows you to match any string of any length (including zero length) |
| _        | Allows you to match on a single character                            |

```sql
SELECT *
FROM film
WHERE special_features LIKE '%Trailers%'
```
When searching for characters _ %, they have to be escaped with \ (default escape character)

```sql
SELECT * FROM address
WHERE address LIKE '%\_%';
```
## Arithmetics
```sql
SELECT title, description, rental_rate * 150 AS "In Pesos" 
FROM film
```

## Set Operators

- UNION
- INTERSECT (Not supported by Mysql)
- EXCEPT (Not supported by Mysql)

### UNION
```sql
SELECT name AS val FROM category
WHERE name LIKE 'A%' OR name LIKE 'M%'
UNION 
SELECT title  FROM film
WHERE title LIKE 'A%' OR title LIKE 'S%'
```
Union eliminates duplicates and sort the result, to see all the values UNION ALL has to be used.

## Table Variables

```sql
SELECT f.title, f.special_features, f.rental_rate, c.name
 FROM film f, film_category fc,  category c 
WHERE f.film_id = fc.film_id 
  AND fc.category_id = c.category_id
ORDER BY f.rental_rate DESC, f.special_features ASC
```

```sql
SELECT f1.title, f2.title, f1.`length` 
  FROM film f1, film f2
WHERE f1.`length` = f2.`length`
```

```sql
SELECT f1.title, f2.title, f1.`length` 
  FROM film f1, film f2
WHERE f1.`length` = f2.`length` AND f1.film_id <> f2.film_id;
```


## Subqueries in WHERE

### IN Operator

The IN operator allows you to specify multiple values in a WHERE clause. The IN operator is a shorthand for multiple OR conditions.

Example 1:

```sql
-- Find customers who paid between $3 and $4
SELECT first_name,last_name 
  FROM customer,payment 
 WHERE customer.customer_id = payment.customer_id 
   AND payment.amount BETWEEN 3 AND 4; 
```

```sql
SELECT first_name,last_name 
  FROM customer 
 WHERE customer_id IN (SELECT customer_id 
                         FROM payment 
                        WHERE amount BETWEEN 3 AND 4); 
```

Just adding DISTINCT to the first query gives us the same result.

Example 2:

```sql
SELECT first_name 
  FROM customer,payment 
 WHERE customer.customer_id = payment.customer_id 
   AND payment.amount = 0.99 
   AND first_name LIKE ( 'W%' ) 
 ORDER BY first_name; 
```

```sql
SELECT first_name 
  FROM customer 
 WHERE customer_id IN (SELECT customer_id 
                         FROM payment 
                        WHERE amount = 0.99) 
   AND first_name LIKE ( 'W%' ) 
 ORDER BY first_name; 
```

In this case, adding DISTINCT gives us the wrong result. So we have to use a subquery.

### EXCEPT as subquery

```sql
SELECT first_name, last_name 
  FROM customer 
 WHERE customer_id IN (SELECT customer_id 
                         FROM payment 
                        WHERE amount = 0.99) 
   AND customer_id NOT IN (SELECT customer_id 
                             FROM payment 
                            WHERE amount = 1.99) 
   AND first_name LIKE ( 'W%' ) 
```

### EXISTS Operator

The EXISTS operator is used to test for the existence of any record in a subquery. The EXISTS operator returns true if the subquery returns one or more records.

Example: find customers that share the first name.

If you run this query it will give you the wrong result.

```sql
SELECT first_name,last_name 
  FROM customer c1 
 WHERE EXISTS (SELECT * 
                 FROM customer c2 
                WHERE c1.first_name = c2.first_name) 
```

This one gives you the correct one instead (a customer should not be compared against itself):

```sql
SELECT first_name,last_name 
  FROM customer c1 
 WHERE EXISTS (SELECT * 
                 FROM customer c2 
                WHERE c1.first_name = c2.first_name 
                  AND c1.customer_id <> c2.customer_id) 
```

#### Finding max

```sql
-- Find films with the max duration
SELECT title,`length` 
  FROM film f1 
 WHERE NOT EXISTS (SELECT * 
                     FROM film f2 
                    WHERE f2.`length` > f1.`length`); 
```

## ALL / ANY

**ALL** means “return TRUE if the comparison is TRUE for ALL of the values in the column that the subquery returns.” 
For example:

```sql
SELECT s1 FROM t1 WHERE s1 > ALL (SELECT s1 FROM t2);
```

Suppose that there is a row in table t1 containing (10). The expression is TRUE if table t2 contains (-5,0,+5)
because 10 is greater than all three values in t2.
The expression is FALSE if table t2 contains (12,6,NULL,-100) because there is a single value 12 in table t2 
that is greater than 10. The expression is unknown (that is, NULL) if table t2 contains (0,NULL,1).

Finally, the expression is TRUE if table t2 is empty. So, the following expression is TRUE when table t2 is empty:
```sql
SELECT * FROM t1 WHERE 1 > ALL (SELECT s1 FROM t2);
```

```sql
SELECT title,length 
  FROM film 
 WHERE length >= ALL (SELECT length 
                        FROM film);
```                         


```sql
UPDATE film SET length = 200 WHERE film_id = 182;

SELECT title,length 
  FROM film f1 
 WHERE length > ALL (SELECT length 
                       FROM film f2
                      WHERE f2.film_id <> f1.film_id);
```


**ANY** means  “return TRUE if the comparison is TRUE for ANY of the values in the column that the subquery returns.”
For example:

```sql
SELECT s1 FROM t1 WHERE s1 > ANY (SELECT s1 FROM t2);
```

Suppose that there is a row in table t1 containing (10). The expression is TRUE if table t2 contains (21,14,7) 
because there is a value 7 in t2 that is less than 10. 
The expression is FALSE if table t2 contains (20,10), or if table t2 is empty

```sql
SELECT title,length 
  FROM film f1 
 WHERE NOT length <= ANY (SELECT length 
                       FROM film f2 
                      WHERE f2.film_id <> f1.film_id);

UPDATE film SET length = 185 WHERE film_id = 182;                       
```

```sql
-- Films whose replacement cost is higher than the lowest replacement cost 
SELECT title,replacement_cost 
  FROM film 
 WHERE replacement_cost > ANY (SELECT replacement_cost 
                                 FROM film) 
 ORDER BY replacement_cost; 

-- Same query with exists
 SELECT title,replacement_cost 
  FROM film f1 
 WHERE EXISTS (SELECT * 
                 FROM film f2 
                WHERE f1.replacement_cost > f2.replacement_cost) 
 ORDER BY replacement_cost; 
```

## Subqueries in FROM

```sql
SELECT title,description,
rental_rate,
rental_rate * 150 AS in_pesos 
  FROM film 
 WHERE rental_rate * 150 > 10.0 
   AND rental_rate * 150 < 70.0;

-- Can be written

SELECT * 
  FROM (SELECT title,description,rental_rate,rental_rate * 150 AS in_pesos 
          FROM film) g 
 WHERE in_pesos > 10.0 
   AND in_pesos < 70.0; 

```    

## Subqueries in SELECT

This is an example to show that this can also be done, there are simpler ways of
doing this:

```sql
SELECT customer_id, 
       first_name, 
       last_name, 
       (SELECT DISTINCT amount 
          FROM payment 
         WHERE customer.customer_id = payment.customer_id 
           AND amount >= ALL (SELECT amount 
                                FROM payment 
                               WHERE customer.customer_id = payment.customer_id))
	   AS max_amount 
  FROM customer 
 ORDER BY max_amount DESC, 
        customer_id DESC;
``` 
Is equivalent to

```sql
SELECT customer_id,
	   first_name,
	   last_name,
	   (SELECT MAX(amount) 
	      FROM payment 
	     WHERE payment.customer_id = customer.customer_id) AS max_amount
  FROM customer
 ORDER BY max_amount DESC,
          customer_id DESC;
``` 

```sql
SELECT customer.customer_id, 
       first_name, 
       last_name, 
       MAX(amount) max_amount 
  FROM customer, payment 
 WHERE customer.customer_id = payment.customer_id 
 GROUP BY customer_id, first_name, last_name 
 ORDER BY max_amount DESC, customer_id DESC 
 ```

## Aggregations

*  The MIN() function returns the smallest value of the selected column.

*  The MAX() function returns the largest value of the selected column.

*  The COUNT() function returns the number of rows that matches a specified criteria.

*  The AVG() function returns the average value of a numeric column.

*  The SUM() function returns the total sum of a numeric column.

#### Simple example

```sql
-- Find the minimum payment of users whose last name starts with R
SELECT MIN(amount)
  FROM customer, payment
 WHERE customer.customer_id = payment.customer_id
   AND customer.last_name LIKE 'R%'
```

#### Using Count
```sql
--
SELECT COUNT(*)
  FROM inventory
  WHERE store_id = 1;

SELECT COUNT(DISTINCT film_id)
  FROM inventory
  WHERE store_id = 1;
```

#### When to use subqueries

```sql
-- wrong result
SELECT AVG(length)
  FROM film, inventory
 WHERE film.film_id = inventory.film_id
   AND inventory.store_id = 1

-- right result
SELECT AVG (length)
  FROM film
 WHERE film_id IN (SELECT film_id
 					 FROM inventory
 					WHERE store_id = 1)
```

```sql
-- same AS above
SELECT  str1.av
FROM ( SELECT AVG(length) av
         FROM film
        WHERE film_id IN (SELECT film_id
 		             	        	FROM inventory
 					                 WHERE store_id = 1)) AS str1
```


```sql
SELECT other_stores.av
FROM ( SELECT AVG(length) av
         FROM film
        WHERE film_id NOT IN (SELECT film_id
 		             			FROM inventory
 					           WHERE store_id = 1)) AS other_stores
```

```sql
-- complex example: Calculate diff between average film length
-- in store 1 vs other stores

SELECT  str1.av - other_stores.av
FROM (
SELECT AVG(length) av
  FROM film
 WHERE film_id IN (SELECT film_id
 					 FROM inventory
 					WHERE store_id = 1)) AS str1,
(SELECT AVG(length) av
  FROM film
 WHERE film_id NOT IN (SELECT film_id
 					 FROM inventory
 					WHERE store_id = 1)) AS other_stores
```

Similar but with subqueries in select

```sql
SELECT
(SELECT AVG(length) av
  FROM film
 WHERE film_id IN (SELECT film_id
 					 FROM inventory
 					WHERE store_id = 1))
  -
(SELECT AVG(length) av
  FROM film
 WHERE film_id NOT IN (SELECT film_id
 					 FROM inventory
 					WHERE store_id = 1)) AS diff_avg
FROM film;
```
## Group By

The GROUP BY clause is used in a SELECT statement to collect data across multiple records and group the results by one or more columns.

### Syntax

```sql
SELECT expression1, expression2, ... expression_n,
       aggregate_function (expression)
FROM tables
[WHERE conditions]
GROUP BY expression1, expression2, ... expression_n;
```

```sql
SELECT rating, title
  FROM film
ORDER BY rating

-- Find films amounts per rating
SELECT rating, COUNT(*)
  FROM film
 GROUP BY rating

-- Find films durations per rating
SELECT rating, AVG(length)
  FROM film
 GROUP BY rating
```

```sql
-- Find films durations per rating and special_features
 SELECT rating, special_features, `length`
  FROM film
 ORDER BY rating, special_features

-- Using other aggretation functions
SELECT rating, special_features, MIN(`length`), MAX(`length`)
  FROM film
 GROUP BY rating, special_features

-- Working with aggregated columns on outer select.
SELECT mx - mn AS diff
FROM (SELECT rating, special_features, MIN(`length`) AS mn, MAX(`length`) AS mx
 	    FROM film
        GROUP BY rating, special_features) t1
```
## Having

The HAVING clause is used in combination with the GROUP BY clause to restrict the groups of returned rows to only those whose the condition is TRUE.

#### Syntax

```sql
SELECT expression1, expression2, ... expression_n, 
       aggregate_function (expression)
FROM tables
[WHERE conditions]
GROUP BY expression1, expression2, ... expression_n
HAVING condition;
```

#### Example

```sql
-- Find customers that rented only one film
SELECT c.customer_id, first_name, last_name, COUNT(*)
  FROM rental r1, customer c
 WHERE c.customer_id = r1.customer_id
GROUP BY c.customer_id, first_name, last_name
HAVING COUNT(*) = 1
```

```sql
-- Show the films' ratings where the minimum film duration in that group is greater than 46
SELECT rating, MIN(`length`)
FROM film
GROUP BY rating
HAVING MIN(`length`) > 46
```

```sql
-- Show ratings that have less than 195 films
SELECT rating, COUNT(*) AS total
FROM film
GROUP BY rating
HAVING COUNT(*) < 195

-- same but with subqueries
SELECT DISTINCT rating,
(SELECT COUNT(*) FROM film f3 WHERE f3.rating = f1.rating) AS total
FROM film f1
WHERE (SELECT COUNT(*) 
FROM film f2 WHERE f1.rating = f2.rating) < 195
```

```sql
-- Show ratings where their film duration average is grater than all films duration average.
SELECT rating, AVG(`length`)
FROM film
GROUP BY rating
HAVING AVG(`length`) > (SELECT AVG(`length`) FROM film)
```
