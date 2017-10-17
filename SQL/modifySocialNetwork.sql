-- Question 1
-- It's time for the seniors to graduate. Remove all 12th graders FROM Highschooler.
DELETE FROM Highschooler
WHERE grade == 12;

-- Question 2
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
DELETE FROM Likes
WHERE ID1 in (
  SELECT ID1 FROM (
    SELECT L1.ID1, L1.ID2
    FROM Friend, Likes L1
    WHERE Friend.ID1 = L1.ID1
    and Friend.ID2 = L1.ID2
    except
    SELECT L1.ID1, L1.ID2
    FROM Likes L1, Likes L2
    WHERE L1.ID1 = L2.ID2
    and L1.ID2 = L2.ID1
  )
)
;

-- Question 3
-- For all cases WHERE A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
INSERT into Friend
  SELECT F1.ID1, F2.ID2
  FROM Friend F1, Friend F2
  WHERE F1.ID2 = F2.ID1
  -- friends with oneself
  and F1.ID1 <> F2.ID2
  -- already exist friendship
  except
  SELECT * FROM Friend
;
