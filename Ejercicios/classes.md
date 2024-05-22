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
