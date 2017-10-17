-- Question 1
-- Add the reviewer Roger Ebert to your database, with an rID of 209.
INSERT into Reviewer(rID, name)
  values (209, 'Roger Ebert');

-- Question 2
-- INSERT 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.
INSERT into Rating
  SELECT Rating.rID, Movie.mID, 5 as stars, null as ratingDate
  FROM Rating, Movie, Reviewer
  WHERE Rating.rID = Reviewer.rID
  and Reviewer.name = 'James Cameron';

-- Question 3
-- For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (UPDATE the existing tuples; don't INSERT new tuples.)
UPDATE Movie
set year = year + 25
WHERE mID in (
  SELECT Movie.mId
  FROM Movie, Rating
  WHERE Movie.mID = Rating.mID
  group by Movie.mID
  having avg(stars) >= 4
);

-- Question 4
-- Remove all ratings WHERE the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
DELETE FROM Rating
WHERE mID in (
  SELECT distinct Rating.mID
  FROM Movie, Rating
  WHERE Movie.mID = Rating.mID
  and (Movie.year > 2000 or Movie.year < 1970)
)
and stars < 4;
