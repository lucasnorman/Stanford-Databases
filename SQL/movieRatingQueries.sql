-- Question 1
-- find the titles of all movies directed by steven spielberg
select title
from Movie
where director = 'Steven Spielberg';

-- Question 2
-- Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.

select distinct year
from Movie, Rating
where Rating.mID = Movie.mID and stars >= 4
order by year;

-- Question 3
-- Find the titles of all movies that have no ratings.
select title
from Movie
where mID not in (select mID
                  from Rating)
;

-- Question 4
-- Some reviewers didn't provide a date with their rating.
-- Find the names of all reviewers who have ratings with a NULL value for the date.
select distinct name
from Reviewer, Rating
where Reviewer.rID = Rating.rID and ratingDate is NULL;

-- Question 5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name, title, stars, ratingDate
from Movie, Rating, Reviewer
where Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

-- Question 6
/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
return the reviewer's name and the title of the movie. */
select name, title
from Movie, Reviewer, (select R1.rID, R1.mID
  from Rating R1, Rating R2
  where R1.rID = R2.rID
  and R1.mID = R2.mID
  and R1.stars < R2.stars
  and R1.ratingDate < R2.ratingDate) R
where Movie.mID = R.mID
and Reviewer.rID = R.rID;
