--- 1. The cats must be ordered by name and will enter an elevator one by one.
---		We would like to know what the running total weight is.
SELECT name, SUM(weight) OVER(ORDER BY name) AS running_total_weight
FROM windowfunctions.cats;

--- 2. The cats must by ordered first by breed and second by name. They are about to enter 
---		an elevator one by one. When all the cats of the same breed have entered they leave.
---		We would like to know what the running total weight of the cats is.
SELECT name, breed, SUM(weight) OVER(PARTITION BY breed ORDER BY name) as running_total_weight
FROM windowfunctions.cats
ORDER BY breed;

--- 3. The cats would like to see the average of the weight of them, the cat just after them 
---		and the cat just before them. The first and last cats are content to have an average
---		weight of consisting of 2 cats not 3.
SELECT name, weight, AVG(weight) OVER(ORDER BY name ROWS between 1 preceding and 1 following) 
as average_weight FROM windowfunctions.cats;

--- 4. The cats must by ordered by weight descending and will enter an elevator one by one. 
---		We would like to know what the running total weight is.
SELECT name, SUM(weight) OVER(ORDER BY weight DESC) as running_total
FROM windowfunctions.cats;



