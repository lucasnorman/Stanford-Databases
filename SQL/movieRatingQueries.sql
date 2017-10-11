-- Question 1
-- find the titles of all movies directed by steven spielberg
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

-- Question 2
-- Find all years that have a movie that received a rating of 4 or 5,
-- and sort them in increasing order.

SELECT distinct year
FROM Movie, Rating
WHERE Rating.mID = Movie.mID and stars >= 4
order by year;

-- Question 3
-- Find the titles of all movies that have no ratings.
SELECT title
FROM Movie
WHERE mID not in (SELECT mID
                  FROM Rating)
;

-- Question 4
-- Some reviewers didn't provide a date with their rating.
-- Find the names of all reviewers who have ratings with a NULL value for the date.
SELECT distinct name
FROM Reviewer, Rating
WHERE Reviewer.rID = Rating.rID and ratingDate is NULL;

-- Question 5
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate.
-- Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
SELECT name, title, stars, ratingDate
FROM Movie, Rating, Reviewer
WHERE Movie.mID = Rating.mID and Reviewer.rID = Rating.rID
order by name, title, stars;

-- Question 6
/* For all cases WHERE the same reviewer rated the same movie twice and gave it a higher rating the second time,
return the reviewer's name and the title of the movie. */
SELECT name, title
FROM Movie, Reviewer, (SELECT R1.rID, R1.mID
  FROM Rating R1, Rating R2
  WHERE R1.rID = R2.rID
  and R1.mID = R2.mID
  and R1.stars < R2.stars
  and R1.ratingDate < R2.ratingDate) R
WHERE Movie.mID = R.mID
and Reviewer.rID = R.rID;

-- Question 7
-- For each movie that has at least one rating,
-- find the highest number of stars that movie received.
-- Return the movie title and number of stars. Sort by movie title.
SELECT title, stars
FROM Movie, ( SELECT Movie.mID, stars
              FROM Movie, Rating
              WHERE Movie.mID = Rating.mID
              except
              SELECT R1.mID, R1.stars
              FROM Rating R1, Rating R2
              WHERE R1.mID = R2.mID
              and R1.stars < R2.stars) Stars
WHERE Movie.mID = Stars.mID
order by title;

-- Question 8
-- For each movie, return the title and the 'rating spread',
-- that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread FROM highest to lowest, then by movie title.
SELECT title, max-min as spread
FROM Movie, ( SELECT mID, min(stars) as min, max(stars) as max
              FROM Rating
              group by mID ) minMax
WHERE Movie.mID = minMax.mID
order by spread DESC, title;

-- Question 9
-- Find the difference between the average rating of movies released before 1980
-- and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie,
-- then the average of those averages for movies before 1980 and movies after.
-- Don't just calculate the overall average rating before and after 1980.)
SELECT (SELECT avg(av)
        FROM (SELECT mid, year, avg(stars) as av
              FROM rating join movie using(mid)
              group by mid)
        WHERE year < 1980)
     - (SELECT avg(av)
        FROM (SELECT mid, year, avg(stars) as av
              FROM rating join movie using(mid)
              group by mid)
        WHERE year > 1980)
