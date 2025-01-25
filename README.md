# Netflix Movies and TV Shows Analysis using SQL

![Netflix Logo](https://github.com/Oriakhi-Osariemen/Netflix_sql_project./blob/main/2772922.webp)

## Project Overview: Analyzing Netflix Movies and TV Shows Data Using SQL

This project focuses on performing an in-depth analysis of Netflix’s movie and TV show data using SQL. 
The objective is to derive actionable insights and address key business questions based on the dataset. 
Below, you’ll find a detailed summary of the project’s purpose, challenges addressed, solutions implemented, insights uncovered, and final conclusions.

## Objectives

1. Examine the distribution of content types (Movies vs. TV Shows).
2. Determine the most frequent ratings for both movies and TV shows.
3. Analyze content by release year, country, and duration.
4. Explore and categorize content using specific criteria and keywords.

## DataSet

Source: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Schema 

```sql
CREATE TABLE Netflix 
(
	show_id		VARCHAR (6),
	type 		VARCHAR (10) ,
	title 		VARCHAR (150),
	director 	VARCHAR (208),
	casts		VARCHAR (1000),
	country		VARCHAR (150),
	date_added	VARCHAR (50),
	release_year	INT,
	rating 		VARCHAR (10),	
	duration 	VARCHAR(15),
	listed_in	VARCHAR (100),
	description	VARCHAR (250)	
); 
```

## Business Problem 

1. Count the number of Movies vs TV Shows
```sql  
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
Objective: Determine the distribution of content types on Netflix.

2. Find the most common rating for movies and TV shows
```sql
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
```
Objective: Identify the most frequently occurring rating for each type of content.

3. List all movies released in a specific year (e.g., 2020)
```sql
SELECT * 
	FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;
```
Objective: Retrieve all movies released in a specific year(2020)

4. Find the top 5 countries with the most content on Netflix
```sql
SELECT 
	DISTINCT(UNNEST (STRING_TO_ARRAY(COUNTRY,','))) AS new_country,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
Objective: Identify the top 5 countries with the highest number of content items on Netflix.

5. Identify the longest duration movie
```sql
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
```
Objective: Retrive the longest time in a movie on Netflix.

6. Find content added in the last 5 years
```sql
SELECT 
	*
FROM netflix 
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```	
Objective: Retrieve content added to Netflix in the last 5 years.

7. Find all the movies/TV shows by director 'Binayak Da'!
```sql
SELECT 
	* 
FROM netflix 
WHERE director ILIKE '%Binayak Das%';
```
Objective: Retrive the contents (Movies/Tv Shows) by Binayak Da on Netflix.

8. List all TV shows with more than 5 seasons
```sql
SELECT 
	*
	-- SPLIT_PART (duration, ' ', 1) as Seasons
	FROM netflix 
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART (duration, ' ', 1):: numeric > 5 
```
Objective: Retrive Tv shows that has more than 5 seasons on Netflix.

9. Count the number of content items in each genre
```sql
SELECT 
    DISTINCT(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```
Objective: Retrive the number of content items on Netflix with the specific genre

10.Find each year and the average numbers of content release in United Kingdom on netflix,return top 5 year with highest avg content release!
```sql
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
```
Objective: Return the top 5 years with the highest average number of content in the United kingdom.

11. List all movies that are documentaries
```sql
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries'
```
Objective: Retrive the list of movies on Netflix that are documentaries.

12. Find all content without a director
```sql
SELECT *
FROM netflix
WHERE director is NULL;
```
Objective: Retunr the contents with null director.

13. Find how many movies actor 'Chris Packham' appeared in last 10 years!
```sql
SELECT *
FROM netflix
WHERE casts LIKE '%Chris Packham%'
AND release_year > EXTRACT(year FROM CURRENT_DATE) - 10;
```
Objective: Retrive the movied actor with the name Chris Packham which appeared in the last 10 years.

14. Find the top 10 actors who have appeared in the highest number of movies produced in United Kingdom.
```sql
SELECT 
	UNNEST (STRING_TO_ARRAY(CASTS, ',')) AS Actor, 
	COUNT (*) AS Actor_Count 
FROM netflix
WHERE COUNTRY = 'United Kingdom' AND CASTS IS NOT NULL
GROUP BY Actor
ORDER BY 2 DESC
LIMIT 10;
```
Objective: Retrive the top 10 actors who appeared more in movies producted in United Kingdom.

15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category
```sql
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
```
Objective: Categorize the content based on the presence of the keywords 'kill' and 'violence',Label content containing these keywords as 'Bad' and all other 
content as 'Good

## Findings and Conclusion

1. Content Distribution: The dataset showcases a diverse mix of movies and TV shows, spanning various ratings and genres.
2. Common Ratings: Analyzing the most frequent ratings offers valuable insights into the target audience and content preferences.
3. Geographical Insights: The data highlights the top content-producing countries and emphasizes United Kingdom significant contribution to Netflix’s library.
4. Content Categorization: Grouping content based on specific keywords provides a deeper understanding of the types of content available on the platform.
   
Overall, this analysis offers a detailed overview of Netflix’s content portfolio, delivering valuable insights that can guide content strategy and decision-making.









