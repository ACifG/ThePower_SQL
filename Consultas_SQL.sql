/*
 * Ejercicio 1.
 * Crea un Esquema de la BBDD.
 */
-- El esquema lo podemos encontrar en la misma carpeta.

/* Ejercicio 2. 
 * Muestra todos los nombres de todas las películas con una clasificación por edades de 'R'
 */

select *
from film f
where f.rating = 'R' -- Se filtra por el rating de la película
order by f.release_year desc; -- no tengo claro a que se refiere cuando habla de clasificación por edades, así que ordeno por fecha

/* 
Ejercicio 3.
 Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 
y 40.
*/

select actor_id, concat(first_name, ' ', last_name) as ActorName
from actor
where actor_id between 30 and 40;

/* 
Ejercicio 4.
Obtén las películas cuyo idioma coincide con el idioma original.
*/

select *
from film f
where f.language_id = f.original_language_id or f.original_language_id is not null; -- devuelve una tabla vacía porque todas son NULL.

/* 
Ejercicio 5.
Ordena las películas por duración de forma ascendente.
*/

select  f.film_id, f.title, f.length  
from film f
order by length asc;

/* 
EJERCICIO 6
 Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su 
apellido.
*/

select a.actor_id, concat(a.first_name, ' ', a.last_name ) as actor_name
from actor a
where a.last_name like '%ALLEN%'; -- añado posibles letras y caracteres antes y después ya que dice que 'contenga'

/* 
Ejercicio 7 
Encuentra la cantidad total de películas en cada clasificación de la tabla 
“filmˮ y muestra la clasificación junto con el recuento.
*/

select COUNT(f.film_id) as N_Peliculas, f.rating 
from film f
group by f.rating 
order by f.rating asc;

/* 
Ejercicio 8.
Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una 
duración mayor a 3 horas en la tabla film.
*/

select f.title, f.length, f.rating -- Mostramos rating y lenght para comprobar que está OK.
from film f
where f.rating = 'PG-13' and f.length > 3*60; -- al estar indicadas en minutos, lo indicamos en minutos


/*
Ejercicio 9. 
Encuentra la variabilidad de lo que costaría reemplazar las películas.
*/

-- La variabilidad es la varianza, por lo que necesitamos usar funciones de agregación como VARIANCE()
-- Normalmente se mide la varianza junto con la desviación típica y la media, por lo que vamos a mostrar ambas métricas.
select VARIANCE(f.replacement_cost) as varianza, 
	   STDDEV(f.replacement_cost) as desv_estandar, 
	   AVG(f.replacement_cost) as media,
	   (STDDEV(f.replacement_cost)/AVG(f.replacement_cost)) as CV
from film f;



/* 
Ejercicio 10.
 Encuentra la mayor y menor duración de una película de nuestra BBDD.
*/
select max(f.length), min(f.length)
from film f

-- Podríamos obtener los títulos de dichas películas
select f.title, f.length
from film f
where f.length = (
	select MAX(length)
	from film
	) or f.length = (
	select MIN(length)
	from film
	)
order by length asc;


/*
Ejercicio 11.
Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
*/

-- Para saber el costo necesitamos la tabla payment
-- Para saber las fechas de alquiler necesitamos la tabla rental.
-- Por tanto, debemos realizar una subconsulta dentro de la consulta principal

select r.rental_id, r.rental_date, p.amount
from rental r
inner join payment p
on r.rental_id = p.rental_id 
order by r.rental_date desc
limit 1 
offset 2;

-- También puede hacerse con subconsultas
select r.rental_id, r.rental_date, p.amount 
from rental r
join payment p 
on r.rental_id = p.rental_id
where r.rental_date = (
	select r.rental_date
	from rental r
	order by r.rental_date desc
	limit 1 offset 2)
limit 1 offset 2



/*
 Ejercicio 12. 
 Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ
 ni ‘Gʼ en cuanto a su clasificación.
 */
select f.title, f.rating
from film f
where f.rating not in ('NC-17','G')


/*
 Ejercicio 13 
Encuentra el promedio de duración de las películas para cada 
clasificación de la tabla film y muestra la clasificación junto con el 
promedio de duración.
*/
SELECT avg(f.length), f.rating, count(f.film_id) film_nums -- Para dar más info, damos el número de pelis de cada categoría
from film f
group by rating;


/* 
Ejercicio 14. 
 Encuentra el título de todas las películas que tengan una duración mayor 
a 180 minutos.
*/
select f.title, f.length
from film f
where f.length > 180
order by f.length desc;

/* 
Ejercicio 15. 
¿Cuánto dinero ha generado en total la empresa?
*/

select SUM(p.amount) as Facturacion
from payment p

/*
Ejercicio 16. 
Muestra los 10 clientes con mayor valor de id. 
*/

select c.customer_id, concat(c.first_name,' ', c.last_name) as FullName
from customer c
order by c.customer_id desc
limit 10;

/*
Ejercicio 17. 
 Encuentra el nombre y apellido de los actores que aparecen en la 
película con título ‘Egg Igbyʼ.
*/
select a.first_name as Nombre, a.last_name as Apellidos
from film_actor fa
join actor a on fa.actor_id = a.actor_id
join film f on fa.film_id = f.film_id 
where f.title like 'Egg Igby';

/* 
Ejercicio 18. 
Selecciona todos los nombres de las películas únicos.
*/
select distinct f.title
from film f;

/* 
Ejercicio 19. 
Encuentra el título de las películas que son comedias y tienen una 
duración mayor a 180 minutos en la tabla “filmˮ
*/

select f.title, c.name 
from film_category fc
join film f on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id 
where f.length > 180 and c.name = 'Comedy'

-- Haciendo uso de subconsultas, aunque solo sacaríamo el nomber de las películas
select f.title
from film f
where f.length > 180 and f.film_id in (
	select film_id
	from film_category fc
	join category c on fc.category_id = c.category_id 
	where c.name = 'Comedy'
)

/*
Ejercicio 20. 
Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.
*/

select c.name as categoria, AVG(f.length) as promedio_duracion
from film f
join film_category fc on f.film_id = fc.film_id 
join category c on c.category_id = fc.category_id 
group by c.name
having AVG(f.length) > 110
order by promedio_duracion desc;


/*
Ejercicio 21. 
¿Cuál es la media de duración del alquiler de las películas?
*/
select (extract(day from r.return_date - r.rental_date)) as media_duración_alquiler
from rental r;

/* 
 * Ejercicio 22. 
 * Crea una columna con el nombre y apellidos de todos los actores y 
 * actrices.
 */
select concat(a.first_name, ' ', a.last_name) as NombreApellidos
from actor a;

/* 
 * Ejercicio 23.
 * Números de alquiler por día, ordenados por cantidad de alquiler de 
 * forma descendente.
 */ 
select count(distinct r.rental_id ) Num_alquileres, rental_date::date as fecha
from rental r 
group by rental_date::date
order by rental_date::date desc;

/* 
 * Ejercicio 24. 
 * Encuentra las películas con una duración superior al promedio.
 */
select f.title, f.length
from film f
where f.length > (
select avg(f2.length)
from film f2)
order by f.length asc;

/*
Ejercicio 25. 
Averigua el número de alquileres registrados por mes.
*/

select count(distinct r.rental_id) as Num_Alquiler, to_char(r.rental_date, 'MM-YYYY') as Mes
from rental r
group by to_char(r.rental_date, 'MM-YYYY');

/* 
Ejercicio 26. 
Encuentra el promedio, la desviación estándar y varianza del total pagado.
*/

select avg(p.amount), stddev(p.amount), variance(p.amount), (stddev(p.amount)/avg(p.amount)*100) as CV
from payment p;

/*
Ejercicio 27.
¿Qué películas se alquilan por encima del precio medio?
*/

select f.title, p.amount 
from inventory i
join rental r on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id 
join payment p on r.rental_id = p.rental_id 
where p.amount > (
	select avg(p2.amount)
	from payment p2
	)
order by p.amount asc;

/*
Ejercicio 28. 
Muestra el id de los actores que hayan participado en más de 40 
películas.
*/
select fa.actor_id, count(fa.film_id) as numero_peliculas
from film_actor fa
group by fa.actor_id 
having count(fa.film_id)>40;

/*
Ejercicio 29. 
Obtener todas las películas y, si están disponibles en el inventario, 
mostrar la cantidad disponible.
*/
select f.film_id , count(i.store_id) as cantida_disponible
from film f 
join inventory i on f.film_id = i.film_id 
group by f.film_id
order by f.film_id asc;

/* Ejercicio 30. 
 * Obtener los actores y el número de películas en las que ha actuado.
 * */

select a.actor_id, count(fa.film_id) as Num_peliculas
from film_actor fa
join actor a on a.actor_id = fa.actor_id 
group by a.actor_id
order by a.actor_id;


/*
 * Ejercicio 31
 * Obtener todas las peliculas y mostrar los actores que han actuado en ellas,
 * incluso si algunas no tienen actores asociados.
 */

select fa.film_id, 
	   (select f.title
	   from film f
	   where f.film_id = fa.film_id) as Nombre_Pelicula,
	   (select concat(a.first_name, ' ', a.last_name)
	   from actor a
	   where a.actor_id = fa.actor_id) as Actor
from film_actor fa
order by fa.film_id asc, Actor asc;

-- otra opción con joins
select fa.film_id, f.title, concat(a.first_name ,' ', a.last_name) as NombreActor
from film_actor fa
join film f on f.film_id = fa.film_id 
join actor a on a.actor_id = fa.actor_id 
where f.film_id = fa.film_id and
a.actor_id = fa.actor_id -- estas dos líneas creo que son redundantes.
order by f.film_id asc, nombreactor asc;

/* 
Ejercicio 32. 
Obtener todos los actores y mostrar las películas en las que han 
actuado, incluso si algunos actores no han actuado en ninguna película.
*/
-- mediante subconsultas
select fa.actor_id,
		(select concat(a.first_name, ' ', a.last_name )
		from actor a
		where a.actor_id = fa.actor_id) as actor,
		(select f.title 
		from film f
		where f.film_id = fa.film_id) as peliculas
from film_actor fa;

-- mediante join
select a.actor_id, concat(a.first_name, ' ', a.last_name) as Actor, f.title
from film_actor fa
join film f on fa.film_id = f.film_id
join actor a on fa.actor_id = a.actor_id 
order by a.actor_id asc, f.title asc;

/* 
 * Ejercicio 33.
 Obtener todas las películas que tenemos y todos los registros de 
alquiler.
 */

select i.inventory_id, count(i.store_id) as Cantidad_inventario, count(r.rental_id) as Registros_alquiler
from inventory i
join rental r on i.inventory_id = r.inventory_id 
group by i.inventory_id 
order by i.inventory_id asc;

/* 
 * Ejercicio 34.
 * Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
 */
-- consulta mediante join
select c.customer_id, concat(c.first_name, ' ', c.last_name) as NombreCliente, sum(p.amount)
from customer c
join payment p on p.customer_id = c.customer_id
group by c.customer_id
order by sum(p.amount) desc
limit 5;

-- consulta mediante subconsultas
select c.customer_id, 
		concat(c.first_name, ' ', c.last_name) as NombreCliente, 
		(select sum(p.amount)
		from payment p
		where p.customer_id = c.customer_id) as DineroGastado
from customer c
group by c.customer_id
order by DineroGastado desc
limit 5;


/* 
Ejercicio 35
Selecciona todos los actores cuyo primer nombre es 'Johnny'.
*/

select a.actor_id, concat(a.first_name, ' ', a.last_name) as NombreActor
from actor a 
where a.first_name like 'Johnny';

/*
Ejercicio 36. 
 Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como 
Apellido.
*/

select a.first_name as Nombre, a.last_name as Apellido
from actor a


/* 
Ejercicio 37.
Encuentra el ID del actor más bajo y más alto en la tabla actor.
*/

select min(a.actor_id), max(a.actor_id)
from actor a

/*
Ejercicio 38.
Cuenta cuántos actores hay en la tabla “actorˮ.
*/

select count(a.actor_id) as Numero_Actores
from actor a

/* 
Ejecicio 39
Selecciona todos los actores y ordénalos por apellido en orden 
ascendente.
*/
select a.last_name, a.first_name, a.actor_id 
from actor a
order by a.last_name desc;

/*
 * Ejercicio 40.
 * Selecciona las primeras 5 películas de la tabla “filmˮ.
 */

select f.film_id, f.title
from film f
limit 5;

/* 
Ejercicio 41.
Agrupa los actores por su nombre y cuenta cuántos actores tienen el 
mismo nombre. ¿Cuál es el nombre más repetido?
*/

WITH conteo AS (
  SELECT a.first_name,
         COUNT(*) AS Num_Actores
  FROM actor a
  GROUP BY a.first_name
)
SELECT *
FROM conteo
WHERE Num_Actores = (SELECT MAX(Num_Actores) FROM conteo);

-- Esta opción "pierde" información ya que solo toma 1 registro, pero podríamos tener varios
-- nombres con el mismo número de apariciones.
SELECT a.first_name,
       COUNT(*) AS Num_Actores
FROM actor a
GROUP BY a.first_name
ORDER BY Num_Actores desc
limit 1;

/*
 * Ejercicio 42. 
Encuentra todos los alquileres y los nombres de los clientes que los 
realizaron.
 */

select rental_id, (select concat (c.first_name , ' ', c.last_name )
					from customer c
					where r.customer_id = c.customer_id ) as Nombre_Cliente
from rental r;


/* 
Ejercicio 43.
Muestra todos los clientes y sus alquileres si existen, incluyendo 
aquellos que no tienen alquileres.
*/

select c.customer_id, 
		concat(c.first_name, ' ', c.last_name) as Name,
		r.rental_id
from customer c
left join rental r on c.customer_id = r.customer_id 
order by c.customer_id asc;

-- mediante una CTE donde solo guardamos los rental_id y los clientes.
with clientes_alquiler as (
	select r.rental_id, r.customer_id 
	from rental r
	)
select c.customer_id, 
		concat(c.first_name, ' ', c.last_name) as Cliente,
		ca.rental_id
from customer c
left join clientes_alquiler ca on ca.customer_id = c.customer_id 
order by c.customer_id;

/* 
 * Ejercicio 44. 
 Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor 
 esta consulta? ¿Por qué? Deja después de la consulta la contestación.
 */
select * 
from film f;

select *
from category c;

select *
from film f
cross join category c;

/* El valor que podría aportar esta consulta sería el mostrar las posibles combinaciones
 * para cada película, pero no nos daría información precisa ya que entre film y category 
 * no hay coincidencias. Para unir ambas tablas necesitaríamos utilizar la tabla film_category.
 */
 
/*
 * Ejercicio 45. 
 * Encuentra los actores que han participado en películas de la categoría 
 * 'Action'
*/
-- Mediante JOIN
select distinct a.actor_id, concat(a.first_name, ' ', a.last_name) as Actor--, f.title as Pelicula, c.name as Categoria
from actor a
join film_actor fa on a.actor_id = fa.actor_id 
join film f on f.film_id = fa.film_id 
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id 
where c.name = 'Action';

-- Mediante subconsultas anidadas, pero solo podríamos obtener el nombre de los actores
select a.actor_id, concat(a.first_name, ' ', a.last_name) as Actor 
from actor a
where a.actor_id in (
					select fa.actor_id
					from film_actor fa
					where fa.film_id in (
										select fc.film_id
										from film_category fc 
										join category c on fc.category_id = c.category_id 
										where c.name = 'Action'
										)
					);

/*
Ejercicio 46
Encuentra todos los actores que no han participado en películas.
*/
SELECT a.actor_id, concat(a.first_name, ' ', a.last_name) as Actor
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

SELECT a.actor_id, concat(a.first_name, ' ', a.last_name) as Actor
FROM actor a
WHERE a.actor_id NOT IN (SELECT fa.actor_id FROM film_actor fa);

/* 
 * Ejercicio 47.
 * Seleccione el nombre de los actores y la cantidad de películas en las que han participado.
 */

select a.actor_id, concat(a.first_name, ' ', a.last_name ) as NombreActor, count(fa.film_id)
from actor a
join film_actor fa on a.actor_id = fa.actor_id 
group by a.actor_id
order by a.actor_id;

-- Mediante subconsultas 
select a.actor_id, 
		concat(a.first_name, ' ', a.last_name ) as NombreActor, 
		(	select count(fa.film_id )
			from film_actor fa
			where fa.actor_id = a.actor_id 
		)
from actor a
order by a.actor_id;

/*
Ejercicio 48. 
Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres 
de los actores y el número de películas en las que han participado.
*/

create view actor_num_peliculas as 
	select a.actor_id, concat(a.first_name, ' ', a.last_name ) as NombreActor, count(fa.film_id)
	from actor a
	join film_actor fa on a.actor_id = fa.actor_id 
	group by a.actor_id
	order by a.actor_id;
/* 
Ejercicio 49.
Calcula el número total de alquileres realizados por cada cliente.
*/

select r.customer_id, count(r.rental_id) as num_alquileres
from rental r
group by r.customer_id
order by num_alquileres desc;

/* 
Ejercicio 50.
Calcula la duración total de las peliculas de "Action"alter 
*/

select sum(f.length) duracion_total_action
from film f
join film_category fc on f.film_id = fc.film_id 
join category c on c.category_id = fc.category_id 
where c.name = 'Action';


/*
 * Ejercicio 51.
 * Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar
 * el total de alquileres por cliente
 */

WITH cliente_rentas_temporal AS (
    SELECT r.customer_id, COUNT(r.rental_id) AS num_alquileres
    FROM rental r
    GROUP BY r.customer_id
)
select *
from cliente_rentas_temporal
order by num_alquileres desc;

/* 
Ejercicio 52.
Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las 
películas que han sido alquiladas al menos 10 veces.
*/

with peliculas_alquiladas as (
	select f.title, count(r.rental_id) as num_alquileres
	from film f
	join inventory i on f.film_id = i.film_id 
	join rental r on r.inventory_id = i.inventory_id 
	group by f.film_id 
	having count(r.rental_id) >= 10
)
select * 
from peliculas_alquiladas
order by num_alquileres asc;

/*
Ejercicio 53. 
Encuentra el título de las películas que han sido alquiladas por el cliente 
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
los resultados alfabéticamente por título de película.
*/
SELECT f.title 
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id 
JOIN film f ON i.film_id = f.film_id 
WHERE r.return_date IS NULL 
  AND c.first_name = 'Tammy' 
  AND c.last_name = 'Sanders'
ORDER BY f.title ASC;

-- No existe ningún apellido Sanders en la tabla:
select concat(c.first_name, ' ', c.last_name) as nombre, f.title
from customer c
join rental r on r.customer_id = c.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
join film f on f.film_id = i.film_id
where c.last_name like '%Sanders%'


/*
Ejercicio 54.
Encuentra los nombres de los actores que han actuado en al menos una 
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
alfabéticamente por apellido.
*/

select a.actor_id, concat(a.first_name, ' ', a.last_name)
from actor a
join film_actor fa on fa.actor_id = a.actor_id 
join film f on fa.film_id = f.film_id 
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id 
where c.name like '%Sci%Fi%'

/*
Ejercicio 55.
Encuentra el nombre y apellido de los actores que han actuado en 
películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados 
alfabéticamente por apellido.
*/
select distinct a.first_name, a.last_name
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
where r.rental_date > (
    select MIN(r2.rental_date)
    from film f2
    join inventory i2 on f2.film_id = i2.film_id
    join rental r2 on i2.inventory_id = r2.inventory_id
    where f2.title = 'Spartacus Cheaper'
)
order by a.last_name asc, a.first_name asc;

/*
Ejercicio 56. 
Encuentra el nombre y apellido de los actores que no han actuado en 
ninguna película de la categoría ‘Musicʼ.
*/
select a.actor_id, a.first_name, a.last_name 
from actor a
where not exists (select 1
	from film_actor fa
	join film f on f.film_id = fa.film_id 
	join film_category fc on fc.film_id =f.film_id 
	join category c on fc.category_id = c.category_id
	where fa.actor_id = a.actor_id and c.name = 'Music'
	)
order by a.actor_id asc;

/*
Ejercicio 57.
Encuentra el título de todas las películas que fueron alquiladas por más 
de 8 días.
*/
select f.title, r.rental_date, r.return_date, extract(day from(r.return_date - r.rental_date)) as dias_alquiler
from rental r 
join inventory i on r.inventory_id = i.inventory_id 
join film f on i.film_id = f.film_id 
where extract(day from(r.return_date - r.rental_date)) > 8;

/*
Ejercicio 58. 
 Encuentra el título de todas las películas que son de la misma categoría 
que ‘Animationʼ.
*/
select f.title, c.category_id, c.name
from film f
join film_category fc on f.film_id = fc.film_id 
join category c on c.category_id = fc.category_id 
where c.name = 'Animation';

/* 
Ejercicio 59.
Encuentra los nombres de las películas que tienen la misma duración 
que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película.
*/
select f.title
from film f
where f.length = (
	select f2.length
	from film f2
	where f2.title = 'Dancing Fever'
) and f.title != 'Dancing Fever'
order by f.title asc;

/*
Ejercicio 60. 
Encuentra los nombres de los clientes que han alquilado al menos 7 
películas distintas. Ordena los resultados alfabéticamente por apellido.
*/

select c.customer_id, c.first_name, c.last_name
from customer c
where c.customer_id in (
	select r.customer_id 
	from rental r 
	group by r.customer_id 
	having count(distinct r.inventory_id) >= 7)
order by c.last_name asc;

-- solo con join
select c.customer_id, c.last_name, c.first_name 
from customer c
join rental r on c.customer_id = r.customer_id 
group by c.customer_id 
having count(distinct r.inventory_id) >= 7
order by c.last_name asc;

/*
Ejercicio 61
Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres.
*/
select c.category_id, c.name, count(r.inventory_id)
from rental r 
join inventory i on r.inventory_id = i.inventory_id 
join film f on f.film_id = i.film_id 
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id 
group by c.category_id 
order by c.category_id;

/*
Ejercicio 62.
 Encuentra el número de películas por categoría estrenadas en 2006.
*/
select count(distinct f.film_id)
from film f
where f.release_year = 2006;

/*
Ejercicio 63
Obtén todas las combinaciones posibles de trabajadores con las tiendas 
que tenemos.
*/
select *
from staff 
cross join store;

/*
Ejercicio 64.
Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas.
*/

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente, 
    COUNT(r.rental_id) AS cantidad_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id 
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY nombre_cliente;

-- Otra forma:
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
    (
        SELECT COUNT(r.rental_id)
        FROM rental r
        WHERE r.customer_id = c.customer_id
    ) AS cantidad_alquiladas
FROM customer c
ORDER BY nombre_cliente;