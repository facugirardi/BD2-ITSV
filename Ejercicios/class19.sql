USE sakila;

# 1
# Create a user data_analyst.
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'pass';

# Uses localhost
CREATE USER 'data_analyst'@'%' IDENTIFIED BY 'pass';


# 2
# Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
SHOW GRANTS FOR data_analyst;

# 3
# Login with this user and try to create a table. Show the result of that operation.
# mysql -u data_analyst -p
  
CREATE TABLE neighborhood (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL, 
  PRIMARY KEY  (ID),
) ENGINE=INNODB;

# Esto da error ya que no tiene permisos para crear tablas.

# 4
# Try to update a title of a film. Write the update script.

SELECT title FROM film WHERE film_id = 1;
UPDATE film SET title='FILM' WHERE film_id = 1;

# 5
# With root or any admin user revoke the UPDATE permission. Write the command

REVOKE UPDATE ON sakila.*  FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

# 6
# Login again with data_analyst and try again the update done in step 4. Show the result.

UPDATE film SET title='FILM' WHERE film_id = 1;
# Esto da error ya que no tiene permisos para usar UPDATE en tablas.
