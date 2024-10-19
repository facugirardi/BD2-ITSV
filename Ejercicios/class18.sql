#Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
drop procedure copies_of_film;

delimiter $$ 
create procedure copies_of_film(in film int,in store int, out amount_of_copies int)
begin
	select count(*) into amount_of_copies from inventory where film_id=film and store_id=store; 
end $$ 
delimiter ;
call copies_of_film(2,2,@amount);
select @amount;

#Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. 
#You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
drop procedure customer_by_country;

DELIMITER $$
CREATE PROCEDURE customer_by_country (IN country_name VARCHAR(255), OUT lista TEXT)
BEGIN
	declare finished boolean;
    declare cliente varchar(255);
	DECLARE customer_list CURSOR FOR SELECT concat(first_name," ",last_name) FROM customer inner join address using (address_id) inner join city using(city_id) inner join country co using(country_id) where co.country=country_name;
	declare continue handler for not found set finished = 1;
    set lista="";
    open customer_list;
    get_list:loop
		fetch customer_list into cliente;
        if finished = 1 then
			leave get_list;
		end if;
        if lista="" then
			set lista = cliente;
        else
			set lista = concat(lista, "; ", cliente);
		end if;
    end loop get_list;
END $$
delimiter ;
call customer_by_country("Argentina",@lista);
select @lista;

#Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.
show create procedure film_in_stock;

CREATE DEFINER=`user`@`localhost` PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
/*La funcion inventory_in_stock se encarga de comprobar si un articulo especifico en el inventario de la tienda esta disponible. 
  Recibe un inventory_id como parametro. 
  Primero, revisa si ese articulo ha sido alquilado alguna vez, contando las filas en la tabla rental que coinciden con el inventory_id proporcionado. 
  Si no se encuentran registros de alquileres, la funcion retorna TRUE, lo que significa que el articulo esta disponible.
  Si existen alquileres registrados, la funcion pasa a la segunda fase, donde revisa si alguno de esos alquileres aun no ha sido devuelto, es decir, 
  si el campo return_date es NULL. Cuenta cuantos alquileres de ese articulo no tienen fecha de devolucion. 
  Si el resultado es cero, lo que indica que todos los alquileres han sido devueltos, la funcion retorna TRUE, indicando que el articulo esta disponible. 
  Si hay al menos un alquiler sin devolver (return_date en NULL), la funcion retorna FALSE, señalando que el arti­culo sigue alquilado.*/

show create function inventory_in_stock;


CREATE DEFINER=`user`@`localhost` FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;
    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;
    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END

/*
El procedimiento film_in_stock tiene una finalidad similar, pero en lugar de verificar un solo arti­culo, 
devuelve la cantidad total de copias disponibles de una peli­cula especi­fica en una tienda determinada. 
Este procedimiento acepta dos parametros: p_film_id y p_store_id.
El funcionamiento del procedimiento se divide en dos etapas: primero, 
busca todos los inventory_id en la tabla inventory que correspondan al film_id y store_id dados, y verifica si esos arti­culos estan disponibles para alquilar. 
Para determinar la disponibilidad, utiliza la funcion inventory_in_stock, que ya fue descrita anteriormente.
Luego, el procedimiento cuenta cuantas copias de la pelicula estan disponibles (es decir, las que pasaron la validacion de inventory_in_stock) y 
guarda este numero en la variable p_film_count. Finalmente, esta variable se devuelve, 
indicando cuantas copias de la pelicula estan disponibles para alquiler en esa tienda especifica.*/