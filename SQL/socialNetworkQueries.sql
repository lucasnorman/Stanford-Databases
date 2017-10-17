-- Question 1
-- Find the names of all students who are friends with someone named Gabriel.
SELECT H2.name
FROM Highschooler H1, Highschooler H2, Friend
WHERE H1.ID = Friend.ID1
and H1.name = 'Gabriel'
and H2.ID = Friend.ID2;

-- Question 2
-- For every student who likes someone 2 or more grades younger than themselves,
-- return that student's name and grade, and the name and grade of the student they like.
SELECT h1.name, h1.grade, h2.name, h2.grade
FROM highschooler h1, highschooler h2, likes
WHERE h1.ID = likes.ID1
and h2.ID = likes.ID2
and h1.grade - 2 >= h2.grade;

-- Question 3
-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, (
  SELECT L1.ID1, L1.ID2
  FROM Likes L1, Likes L2
  WHERE L1.ID2 = L2.ID1
  and L1.ID1 = L2.ID2
) as Pair
WHERE H1.ID = Pair.ID1
and H2.ID = Pair.ID2
and H1.name < H2.name;

-- Question 4
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
SELECT name, grade
FROM Highschooler
WHERE ID not in (
  SELECT ID1 FROM Likes
  union
  SELECT ID2 FROM Likes
)
order by grade, name;

-- Question 5
-- For every situation WHERE student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, (
  SELECT ID1, ID2
  FROM Likes
  WHERE ID2 not in (SELECT ID1 FROM Likes)
) as foo
WHERE H1.ID = sL.ID1
and H2.ID = foo.ID2;

-- Question 6
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
SELECT name, grade
FROM Highschooler, (
  SELECT ID1 FROM Friend
  except
  SELECT ID1
  FROM Friend, Highschooler H1, Highschooler H2
  WHERE Friend.ID1 = H1.ID
  and Friend.ID2 = H2.ID
  and H1.grade <> H2.grade
) as SameGrade
WHERE SameGrade.ID1 = Highschooler.ID
order by grade, name;

-- Question 7
-- For each student A who likes a student B WHERE the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
SELECT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2, (
  SELECT * FROM Likes
  except
  -- A likes B and A/B are friends
  SELECT Likes.ID1, Likes.ID2
  FROM Likes, Friend
  WHERE Friend.ID1 = Likes.ID1 and Friend.ID2 = Likes.ID2
) as LikeNotFriend
WHERE F1.ID1 = LikeNotFriend.ID1
and F2.ID1 = LikeNotFriend.ID2
-- has a shared friend
and F1.ID2 = F2.ID2
and H1.ID = LikeNotFriend.ID1
and H2.ID = LikeNotFriend.ID2
and H3.ID = F2.ID2;

-- Question 8
-- Find the difference between the number of students in the school and the number of different first names.
SELECT count(ID) - count(distinct name)
FROM Highschooler;

-- Question 9
-- Find the name and grade of all students who are liked by more than one other student.
SELECT name, grade
FROM Highschooler, (
  SELECT count(ID1) as count, ID2
  FROM Likes
  group by ID2
) as LikeCount
WHERE Highschooler.ID = LikeCount.ID2
and count > 1;
