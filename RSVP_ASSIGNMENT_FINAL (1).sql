USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT  COUNT(*) FROM movie;

-- Number of rows are 7997

SELECT  COUNT(*) FROM genre;

-- Number of rows are 14662

SELECT  COUNT(*) FROM ratings;

-- Number of rows are 7997

SELECT  COUNT(*) FROM director_mapping;

-- Number of rows are 3867

SELECT  COUNT(*) FROM names;

-- Number of rows are 25735

SELECT  COUNT(*) FROM role_mapping;

-- Number of rows are 15615




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select 
sum( case when id is null then 1 else 0 end) as id ,
sum( case when title is null then 1 else 0 end) as title,
sum( case when year is null then 1 else 0 end) as year,
sum( case when date_published is null then 1 else 0 end) as date_published,
sum( case when duration is null then 1 else 0 end) as duration,
sum( case when country is null then 1 else 0 end) as country,
sum( case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income,
sum( case when languages is null then 1 else 0 end) as languages,
sum( case when production_company is null then 1 else 0 end) as production_company
from movie ;

-- below are the 4 columns with null values
/* country                           --20
   worlwide_gross_income             --3724
   languages                         --194
   production_company                --528  */




-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select year,count(*) as number_of_movies from movie
group by year;

-- Maximum movies are released in 2017 and minimum are released in 2019
/* 
year    number_of_movies
2017	3052
2018	2944
2019	2001   */


select
 month(date_published) as month_num,
 count(*) as number_of_movies 
 from movie
group by month_num 
order by month_num;

-- Maximum movies released in March-824 and minimum  movies released in December-438
/*
month_num	number_of_movies
1			 804
2			 640
3			 824
4			 680
5			 625
6			 580
7			 493
8		     678
9			 809
10			 801
11			 625
12			 438 
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select  count(*)
 from movie where year ='2019' and 
 (country LIKE  '%INDIA%'  or country LIKE  '%USA%') ;
 
 -- The movies produced in USA or India in the year 2019 are 1059
 
 
 
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) from genre;

-- Below are the 13 unique list of genres

/*
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others  */



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select count(id) as total,g.genre from movie as m
inner join genre as g
where g.movie_id = m.id
group by genre 
order by total desc ;

-- Drama genre had the highest number of movies 4285 produced.
/*
# total	genre
4285	Drama
2412	Comedy
1484	Thriller
1289	Action
1208	Horror
906	    Romance
813	    Crime
591	    Adventure
555	    Mystery
375	    Sci-Fi
342	    Fantasy
302	    Family
100	    Others
*/



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH only_one 
as (select movie_id from genre
group by movie_id
having count(distinct genre)=1
)
select count(*) from only_one;



-- Movies that belong to only one genre are 3289


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select genre, round(avg(duration),3) as avg_duration
from movie as m
inner join genre as g
where g.movie_id = m.id
group by genre
order by avg_duration desc ;

-- The average duration of movies of genre action has the highest duration of 113(rounded) minutes and horror genre movies has the lowest of 93(rounded) minutes
/*
# genre	    avg_duration
Action	    112.883
Romance	    109.534
Crime	    107.052
Drama	    106.775
Fantasy	    105.140
Comedy	    102.623
Adventure	101.871
Mystery	    101.800
Thriller	101.576
Family	    100.967
Others	    100.160
Sci-Fi	    97.941
Horror	    92.724
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre, count(id) as movie_count,
Rank() OVER(order by count(id) desc) AS genre_rank
from movie as m
inner join genre as g
where g.movie_id = m.id
group by genre;
 
 -- The Thriller genre has the rank 3 preceeded by drama and comedy with 1484 movies produced.
 /*
 # genre	movie_count	  genre_rank
Drama	    4285	      1
Comedy	    2412	      2
Thriller	1484	      3
Action	    1289	      4
Horror	    1208	      5
Romance 	906	          6
Crime	    813	          7
Adventure	591	          8
Mystery	    555           9
Sci-Fi	    375	          10
Fantasy	    342	          11
Family	    302	          12
Others	    100	          13
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select 
min(avg_rating) as min_avg_rating,
max(avg_rating) as max_avg_rating,
min(total_votes) as min_total_votes,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;

/*
# min_avg_rating,      max_avg_rating, 		min_total_votes, 	max_total_votes, 	min_median_rating,	 max_median_rating
'1.0',   			   '10.0', 			    '100', 				'725138', 			'1',				 '10'    
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select title,avg_rating,dense_rank()over(order by avg_rating desc )as movie_rank from 
movie as m
inner join ratings as r
where M.id=r.movie_id 
limit 10;

-- below are the list of top 10 movies based on average ratings
/*
# title	                                      avg_rating	movie_rank
Kirket	                                       10.0	         1
Love in Kilnerry	                           10.0	         1
Gini Helida Kathe	                           9.8	         2
Runam	                                       9.7	         3
Fan	                                           9.6	         4
Android Kunjappan Version 5.25	               9.6	         4
Yeh Suhaagraat Impossible	                   9.5	         5
Safe	                                       9.5	         5
The Brighton Miracle	                       9.5	         5
Shibu	                                       9.4	         6
 
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


select  median_rating,count(movie_id) as movie_count
from ratings
group by median_rating 
order by movie_count desc;

-- Below is the summarised table and movies with median_rating of 7 has the highest movie count of 2257 and movies with median_rating of 1 has the lowest count of 94 movies

/*
# median_rating	   movie_count
	   7	          2257
	   6	          1975
       8	          1030
	   5	          985
       4	          479
       9	          429
       10	          346
       3	          283
       2	          119
       1	          94
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with hit_movie_company as(
select  production_company,count(movie_id) as movie_count,
dense_rank()over(order by count(movie_id) desc) as prod_company_rank
from ratings as r
inner join movie as m
where m.id =r.movie_id 
and avg_rating > 8 
and production_company is not  null
group by production_company)
select * from hit_movie_company 
where prod_company_rank =1;

-- Production house that has produced the most number of hit movies (average rating > 8) are below

/*
# production_company	movie_count	prod_company_rank
Dream Warrior Pictures	3	        1
National Theatre Live	3	        1
*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 
select genre, count(id) as movie_count
from movie as m
inner join ratings as r
on m.id =r.movie_id
inner join genre as g
on m.id =g.movie_id
where year=2017
and month(date_published) =3
and country like '%USA%'
and total_votes > 1000
group by genre
order by movie_count desc;

/*
# genre	  movie_count
Drama	  24
Comedy	  9
Action	  8
Thriller  8
Sci-Fi	  7
Crime	  6
Horror	  6
Mystery	  4
Romance	  4
Fantasy	  3
Adventure 3
Family	  1
*/






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select title, avg_rating, genre
from movie as m
inner join ratings as r
on m.id =r.movie_id
inner join genre as g
on m.id =g.movie_id
where avg_rating >8
and title like 'THE%'
group by title
order by avg_rating desc;

/*
# title	                avg_rating	  genre
The Brighton Miracle	9.5	          Drama
The Colour of Darkness	9.1	          Drama
The Blue Elephant 2	    8.8	          Drama
The Irishman	        8.7	          Crime
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	        8.4           Crime
Theeran Adhigaaram Ondru 8.3	      Action
The King and I	        8.2	          Drama
*/





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select  count(id) as total
from movie as m
inner join ratings as r
on m.id =r.movie_id
where median_rating = 8
and date_published between '2018-04-01' and '2019-04-01'
group by median_rating;

-- 361 Movies were given a median rating of 8 which are released between 1 April 2018 and 1 April 2019.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select  languages,sum(total_votes) as votes
from movie as m
inner join ratings as r
on m.id =r.movie_id
where languages like '%German%'
union all
select  languages,sum(total_votes) as votes
from movie as m
inner join ratings as r
on m.id =r.movie_id
where languages like '%Italian%';

-- from the above query result we can say German movies get more votes than Italian movies
/*
# languages	votes
  German	4421525
  Italian	2559540
*/


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
sum( case when name is null then 1 else 0 end) as name_nulls,
sum(case when height is null then 1 else 0 end) as height_nulls,
sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_nulls,
sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies
 from names;
 
 -- The result of null check on name table are below
 /*
 # name_nulls		height_nulls		date_of_birth_nulls		known_for_movies
   0				17335				13431					15226
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


with top_3_genre as (
select genre, count(m.id) as movie_count,Rank() OVER(order by count(m.id) desc) AS genre_rank
 from movie as m
inner join genre as g
on g.movie_id = m.id
inner join ratings as r
on r.movie_id = m.id
where  avg_rating >8
group by genre
 limit 3)
select  n.name as director_name , Count(d.movie_id) as movie_count
from director_mapping as d
inner join genre as g
using (movie_id)
inner join names as n
 on n.id = d.name_id
 inner join top_3_genre
 using (genre)
 inner join ratings as r
using  (movie_id)
where  avg_rating  > 8
group by name
order by movie_count desc limit 3;


-- The top 3 directors from top three genres with average rating greater than 8 are below
/*
# director_name		movie_count
James Mangold		4
Anthony Russo		3
Soubin Shahir		3
*/
 


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select n.name,count(m.id) as movie_count
from role_mapping as rm
inner join movie as m
on m.id =rm.movie_id
inner join ratings as r
using  (movie_id)
inner join names as n
on n.id =rm.name_id
where r.median_rating >=8
and category = 'actor'
group by n.name
order by movie_count  desc limit 2;

-- the top two actors whose movies have a median rating >= 8 are below
/* 
# name			movie_count
Mammootty		8
Mohanlal		5
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,sum(total_votes) as vote_count, rank() over(order by sum(total_votes) desc) as prod_comp_rank
from movie as m
inner join ratings as r
on m.id=r.movie_id
group by production_company
limit 3;

--  The top three production houses based on the number of votes
/*
# production_company	vote_count	prod_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



select  n.name as actor_name,total_votes,count(m.id) as movie_count,
round(sum(avg_rating*total_votes)/SUM(total_votes),2) as actor_avg_rating,
rank() over(order by round(sum(avg_rating*total_votes)/SUM(total_votes),2) desc) as actor_rank
from movie as m
inner join ratings as r
on m.id=r.movie_id
inner join role_mapping as rm
on m.id=rm.movie_id
inner join names as n
on rm.name_id=n.id
where rm.category = 'actor'
and m.country like  '%india%'
group by name
having count(r.movie_id) >= 5
limit 5;

-- Below the list of actors  with movies released in India based on their average ratings

/*
# actor_name			total_votes		movie_count	 actor_avg_rating		actor_rank
Vijay Sethupathi		20364				5		 8.42					1
Fahadh Faasil			3684				5		 7.99					2
Yogi Babu				223					11		 7.83		            3
Joju George			    413					5		 7.58	                4
Ammy Virk				169					6		 7.55	                5
*/



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select  n.name as actress_name,total_votes,count(m.id) as movie_count,
round(sum(avg_rating*total_votes)/SUM(total_votes),2) as actor_avg_rating,
rank() over(order by round(sum(avg_rating*total_votes)/SUM(total_votes),2) desc) as actor_rank
from movie as m
inner join ratings as r
on m.id=r.movie_id
inner join role_mapping as rm
on m.id=rm.movie_id
inner join names as n
on rm.name_id=n.id
where rm.category = 'actress'
and m.languages like '%hindi%'
and m.country like '%india%'
group by name
having count(r.movie_id) >= 3 limit 5;

--  below is the list top five actresses in Hindi movies released in India based on their average ratings
/*
# actress_name		total_votes	movie_count	actor_avg_rating	actor_rank
Taapsee Pannu		2269			3		7.74				1
Kriti Sanon			14978			3		7.05				2
Divya Dutta			345				3		6.88				3
Shraddha Kapoor	    3349			3		6.63				4
Kriti Kharbanda		1280			3		4.80				5
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

Select title,avg_rating,
case 
when avg_rating >8 then 'Superhit movies'
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating between 5 and 7 then 'One-time-watch movies'
when avg_rating < 5 then 'Flop movies'
else 'your raiting is not good'
end as  avg_rating_category
from movie as m
inner join genre as g
on m.id=g.movie_id
inner join ratings as r
on m.id=r.movie_id
where  genre like '%thriller%' 
 order by avg_rating desc ;

-- fWe categorized the thriller genre movies based on their avg_rating and classified them.


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

Select genre,round(avg(duration),2) as avg_duration,
sum(round(avg(duration),2))over(order by genre ) as running_total_duration,
avg(round(avg(duration))) over(order by genre ) as moving_avg_duration		
from movie as m
inner join genre as g
on m.id=g.movie_id
group by genre
order by avg_duration desc;

-- Below is the genre-wise running total and moving average of the average movie duration

/*
# genre	  avg_duration	running_total_duration	moving_avg_duration
Action	  112.88	112.88	113.0000
Romance	  109.53	1141.51	103.9091
Crime	  107.05	424.42	106.2500
Drama	  106.77	531.19	106.4000
Fantasy	  105.14	737.30	105.4286
Comedy	  102.62	317.37	106.0000
Adventure 101.87	214.75	107.5000
Mystery	  101.80	931.82	103.6667
Thriller  101.58	1341.03	103.3077
Family	  100.97	632.16	105.5000
Others	  100.16	1031.98	103.3000
Sci-Fi	  97.94	    1239.45	103.4167
Horror	  92.72	    830.02	103.8750

*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with genre_selection as(
with top_genre as(
select genre, count(title) as movie_count,
	rank() over(order by count(title) desc) as genre_rank
from movie as m
	inner join ratings as r on r.movie_id=m.id
	inner join genre as g on g.movie_id=m.id
group by genre)
select genre
from top_genre
where genre_rank<4),
-- top genres have been identified. Now we will use these to find the top 5 movies as required.
top_five as(
select genre, year, title as movie_name,
			   CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') as decimal(10)) as worlwide_gross_income ,
               dense_rank() over(partition by year order by CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') as decimal(10))  desc ) as movie_rank
from movie as m 
	inner join genre as g on m.id= g.movie_id
where genre in (select genre from genre_selection))
select *
from top_five
where movie_rank<=5;

-- Top 3 Genres based on most number of movies

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;







