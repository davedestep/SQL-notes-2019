USE sakila;

#Question 1 - there are 200 actors in the sakila dataset
SELECT COUNT(last_name) AS count_last
FROM actor;

#Question 2 - there are two actors with the first name "Scarlett"
SELECT COUNT(first_name) AS count_first
FROM actor
WHERE first_name = "Scarlett";

#Question 3- Kilmer, Nolte, and Temple occurs 4 or more times
SELECT last_name, count(last_name) AS count_last 
FROM actor 
GROUP BY last_name
HAVING count_last>3;

#Question 4 - 
/*SANDRA	KILMER
REESE	KILMER
MENA	TEMPLE
FAY	KILMER
WARREN	NOLTE
SALMA	NOLTE
ALBERT	NOLTE
RUSSELL	TEMPLE
JAYNE	NOLTE
MINNIE	KILMER
OPRAH	KILMER
BURT	TEMPLE
THORA	TEMPLE*/

SELECT first_name, last_name
FROM actor
WHERE last_name IN (SELECT last_name 
	FROM actor 
	GROUP BY last_name
	HAVING COUNT(last_name)>3);

#Question 5 - The customers come from 376 different districts
SELECT COUNT(DISTINCT(a.district))
FROM address as a
INNER JOIN customer as b
	ON a.address_id=b.address_id;

# Question 6 - There are 108 countries that customers come from
SELECT COUNT(DISTINCT(a.country)) as count_countries
FROM country as a
INNER JOIN city as b
	ON a.country_id=b.country_id
INNER JOIN address as c
	ON b.city_id=c.city_id
INNER JOIN customer as d
	ON c.address_id=d.address_id;
    
#Question 7 - Gina Degeneres has the most movies at 42. (if you were to group by actor name, there are two Susan Davis's, so must group by acotr id)
SELECT a.first_name, a.last_name, COUNT(b.film_id) AS total_films
FROM actor as a
LEFT JOIN film_actor as b
	ON a.actor_id=b.actor_id
GROUP BY b.actor_id
ORDER BY total_films DESC
LIMIT 1;


#Question 8 - The top action film actor in this database is Natalie Hopkins, who has starred in 6 action movies
SELECT c.category_id, a.first_name, a.last_name, COUNT(b.film_id) AS total_films
FROM actor as a
LEFT JOIN film_actor as b
	ON a.actor_id=b.actor_id
INNER JOIN film_category as c
	on b.film_id=c.film_id
WHERE category_id=1
GROUP BY b.actor_id, c.category_id
ORDER BY total_films DESC
LIMIT 1;


#Question 9 - Music has the fewest at 51
SELECT a.name, b.category_id, count(b.film_id) as cat_counts
FROM category as a
INNER JOIN film_category as b
	ON a.category_id=b.category_id
GROUP BY b.category_id
ORDER BY cat_counts
LIMIT 1;


#Question 10 - The average length of all movies is 115 minutes
SELECT AVG(length)
FROM film;

#Question 11
/*
Action	1	111.6094
Animation	2	111.0152
Children	3	109.8000
Classics	4	111.6667
Comedy	5	115.8276
Documentary	6	108.7500
Drama	7	120.8387
Family	8	114.7826
Foreign	9	121.6986
Games	10	127.8361
Horror	11	112.4821
Music	12	113.6471
New	13	111.1270
Sci-Fi	14	108.1967
Sports	15	128.2027
Travel	16	113.3158
*/

SELECT c.name, b.category_id, AVG(a.length) AS average_length
FROM film as a
INNER JOIN film_category as b
	ON a.film_id=b.film_id
INNER JOIN category as c
	ON c.category_id=b.category_id
GROUP BY b.category_id;


#Question 12 - The longest length is 185 with many movies tied for longest:
/*CHICAGO NORTH
CONTROL ANTHEM
DARN FORRESTER
GANGS PRIDE
HOME PITY
MUSCLE BRIGHT
POND SEATTLE
SOLDIERS EVOLUTION
SWEET BROTHERHOOD
WORST BANGER*/

SELECT title, length 
FROM film
WHERE length = (select MAX(length) FROM film)
ORDER BY length DESC;


#Question 13 - The average rental period is ~ 5 dayes
SELECT AVG(DATEDIFF(return_date, rental_date)) AS average_rental
FROM rental;

#Question 14 - Kennth Gooden, Brittany Riley, and Kevin Schuler
SELECT a.first_name, a.last_name, AVG(DATEDIFF(return_date, rental_date)) as average_rental
FROM customer AS a 
INNER JOIN rental AS b
    ON a.customer_id=b.customer_id
GROUP BY b.customer_id
ORDER BY average_rental DESC;


#Question 15 - Jon had customers spend a higher amount: 4.245, Mike's average was 4.156
SELECT a.first_name, AVG(b.amount) AS avg_rental
FROM STAFF as a
LEFT JOIN payment as b
	on a.staff_id=b.staff_id
GROUP BY a.first_name;


#Question 16 - How many rentals are from each country?
#Afghanistan has the fewest rentals, while India, China and the US have the most rentals
#Looks like rentals are well diversified geographically, hitting the largest markets 
#Why does India have more rentals than China?

SELECT e.country, count(a.rental_id) as country_count
FROM rental as a
INNER JOIN customer as b
	ON a.customer_id=b.customer_id
INNER JOIN address as c
	ON b.address_id=c.address_id
INNER JOIN CITY as d
	ON c.city_id=d.city_id
INNER JOIN country as e
	ON d.country_id=e.country_id
GROUP BY e.country
ORDER BY country_count DESC;




