--Netfilx Project

DROP TABLE IF EXISTS Netflix;

CREATE TABLE Netflix 
(	
	show_id	VARCHAR (6),
	type 	VARCHAR (10) ,
	title 	VARCHAR (150),
	director VARCHAR (208),
	casts	VARCHAR (1000),
	country	VARCHAR (150),
	date_added	VARCHAR (50),
	release_year	INT,
	rating VARCHAR (10),	
	duration VARCHAR(15),
	listed_in	VARCHAR (100),
	description	VARCHAR (250)	
);

SELECT * FROM  Netflix;

SELECT 
	COUNT (*) AS total_content 
FROM  Netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
SELECT 
	DISTINCT type
FROM netflix;

SELECT 
	type, 
	COUNT(*) AS Total_content 
FROM netflix
GROUP BY type; 

-- 2. Find the most common rating for movies and TV shows

SELECT 
	type,
	ranking
FROM
(
	SELECT 
		type,
		rating,
		COUNT (*),
		RANK () OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM  Netflix
	GROUP BY 1,2
) as t1
WHERE
	ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
	FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	DISTINCT(UNNEST (STRING_TO_ARRAY(COUNTRY,','))) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 5. Identify the longest duration movie

SELECT DURATION FROM NETFLIX

SELECT * FROM 
(
	SELECT DISTINCT title as movie,
	split_part(duration,' ',1):: numeric as duration 
  	FROM netflix
  	WHERE type ='Movie'
) as subquery
WHERE
duration = (SELECT MAX (split_part(duration,' ',1):: numeric ) 
			FROM netflix);


-- 6. Find content added in the last 5 years

SELECT 
	*
FROM netflix 
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
	

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT 
	* 
FROM netflix 
WHERE director ILIKE '%Binayak Das%';


-- 8. List all TV shows with more than 5 seasons

SELECT 
	*
	-- SPLIT_PART (duration, ' ', 1) as Seasons
	FROM netflix 
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART (duration, ' ', 1):: numeric > 5 


--9. Count the number of content items in each genre
SELECT 
    DISTINCT(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


-- 10.Find each year and the average numbers of content release in United Kingdom on netflix. 
--return top 5 year with highest avg content release!

SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	COUNT(*) as yearly_content,
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'United Kingdom') :: numeric * 100 
	,2)as avg_content_per_year
FROM netflix
WHERE country = 'United Kingdom'
GROUP BY 1
ORDER BY year DESC 


--11. List all movies that are documentaries

SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries'


--12. Find all content without a director

SELECT *
FROM netflix
WHERE director is NULL;


--13. Find how many movies actor 'Chris Packham' appeared in last 10 years!

SELECT *
FROM netflix
WHERE casts LIKE '%Chris Packham%'
AND release_year > EXTRACT(year FROM CURRENT_DATE) - 10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in United Kingdom.

SELECT 
	UNNEST (STRING_TO_ARRAY(CASTS, ',')) AS Actor, 
	COUNT (*) AS Actor_Count 
FROM netflix
WHERE COUNTRY = 'United Kingdom' AND CASTS IS NOT NULL
GROUP BY Actor
ORDER BY 2 DESC
LIMIT 10;

/*15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.*/

SELECT 
	category,
	COUNT (*) AS content_count
FROM (
	SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categoized_content
GROUP BY 1;
