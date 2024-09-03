#1
INSERT INTO employees (employeeNumber,lastName,firstName, extension,officeCode,reportsTo,jobTitle,email)
VALUES (142,"GIRARDI","FACUNDO","a", 1, 1,"Employee",null);

#Error Code: 1048. Column 'email' cannot be null
#El email esta declarado con CONSTRAINT NOT NULL


#2
UPDATE employees SET employeeNumber = employeeNumber - 20;
# El valor del campo employeeNumber se reduce en 20 para todas las filas.

# Explain.
UPDATE employees SET employeeNumber = employeeNumber + 20;
# Aumenta en 20 el valor de employeeNumber para todas las filas de la tabla employees.


#3
ALTER TABLE employees 
ADD COLUMN age int DEFAULT 16, 
ADD CONSTRAINT check_age CHECK (age BETWEEN 16 AND 70);

#Error Code: 3819. Check constraint 'check_age' is violated.
#Esto pasa porque algunos valores no cumplen la condición. Al poner un valor por defecto, se ajustan automáticamente.


#4
#La integridad referencial entre estas tablas se asegura mediante una clave foránea que conecta
#la tabla film con la tabla actor a través de una tabla intermedia. Esta tabla intermedia almacena 
#las claves primarias de ambas tablas y evita que se elimine un registro de film o actor sin antes eliminar
#cualquier registro correspondiente en film_actor que incluya el elemento que se desea eliminar.


#5
ALTER TABLE employee
ADD COLUMN lastUpdate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN lastUpdateUser VARCHAR(50) NOT NULL DEFAULT CURRENT_USER();

DELIMITER $$

CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = CURRENT_TIMESTAMP;
    SET NEW.lastUpdateUser = CURRENT_USER();
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_employee_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = CURRENT_TIMESTAMP;
    SET NEW.lastUpdateUser = CURRENT_USER();
END$$

DELIMITER ;


#6

SELECT TRIGGER_NAME, EVENT_MANIPULATION, ACTION_TIMING, ACTION_STATEMENT
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'sakila' AND EVENT_OBJECT_TABLE = 'film_text';

DELIMITER $$

CREATE TRIGGER film_text_insert_trigger
BEFORE INSERT ON film_text
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM film WHERE film_id = NEW.film_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid film_id';
    END IF;

    SET NEW.title = (SELECT title FROM film WHERE film_id = NEW.film_id);
    SET NEW.description = (SELECT description FROM film WHERE film_id = NEW.film_id);
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER film_text_update_trigger
BEFORE UPDATE ON film_text
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM film WHERE film_id = NEW.film_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid film_id';
    END IF;

    SET NEW.title = (SELECT title FROM film WHERE film_id = NEW.film_id);
    SET NEW.description = (SELECT description FROM film WHERE film_id = NEW.film_id);
END$$

DELIMITER ;


