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

--- 5. The cats form a line grouped by color. Inside each color group the cats order themselves 
---		by name. Every cat must have a unique number for its place in the line.
---		We must assign each cat a unique number while maintaining their color & name ordering.
SELECT ROW_NUMBER() OVER(ORDER BY color, name) AS number, name, color
FROM windowfunctions.cats;

--- 6. We would like to find the heaviest cat. Order all our cats by weight.
---		The two heaviest cats should both be 1st. The next heaviest should be 3rd.
SELECT RANK() OVER(ORDER BY weight DESC) AS rank, name, weight
FROM windowfunctions.cats;

--- 7. For cats age means seniority, we would like to rank the cats by age (oldest first).
---		However we would like their ranking to be sequentially increasing.
SELECT DENSE_RANK() OVER(ORDER BY age DESC) AS rank, name, age
FROM windowfunctions.cats;

--- 8. Each cat would like to know what percentage of cats weigh less than it.
SELECT name, weight, percent_rank() OVER(ORDER BY weight) as perc
FROM windowfunctions.cats;

--- 9. Each cat would like to know what weight percentile it is in. 
---		This requires casting to an integer.
SELECT name, weight, CAST((cume_dist() OVER(ORDER BY weight ))*100 AS INTEGER) as perc
FROM windowfunctions.cats;

---10. 