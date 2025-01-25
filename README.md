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


## Business Problem 
1. Count the number of Movies vs TV Shows
   
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
Objective: Determine the distribution of content types on Netflix.
