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

---10. We are worried our cats are too fat and need to diet. 
---		We would like to group the cats into quartiles by their weight.
SELECT name, weight, ntile(4) OVER(ORDER BY weight) AS weight_quartile
FROM windowfunctions.cats;

---11. Cats are fickle. Each cat would like to lose weight to be the equivalent weight 
--- 	of the cat weighing just less than it. Print a list of cats, their weights and 
---		the weight difference between them and the nearest lighter cat ordered by weight.
SELECT name, weight, 
COALESCE(CAST(weight - LAG(weight, 1) OVER(ORDER BY weight) AS DECIMAL(5,1)), 0) AS weight_to_lose
FROM windowfunctions.cats;

---12. The cats now want to lose weight according to their breed. Each cat would like to 
---		lose weight to be the equivalent weight of the cat in the same breed weighing just 
---		less than it. Print a list of cats, their breeds, weights and the weight difference 
---		between them and the nearest lighter cat of the same breed.
SELECT name, breed, weight,
COALESCE(CAST(weight - LAG(weight, 1) OVER(PARTITION BY breed ORDER BY weight) AS DECIMAL(5,1)), 0) 
AS weight_to_lose
FROM windowfunctions.cats ORDER BY weight;

---13. Cats are vain. Each cat would like to pretend it has the lowest weight for its color.
---		Print cat name, color and the minimum weight of cats with that color.
SELECT name, color,
NTH_VALUE(weight, 1) OVER(PARTITION BY color ORDER BY weight) AS lowest_weight_by_color
FROM windowfunctions.cats
ORDER BY color, name;

---14. Each cat would like to see the next heaviest cat's weight when grouped by breed. 
---		If there is no heavier cat print 'fattest cat'. Print a list of cats, their weights 
---		and either the next heaviest cat's weight or 'fattest cat'
SELECT name, weight, 
COALESCE(CAST(LEAD(weight, 1) OVER(PARTITION by breed ORDER BY weight)AS VARCHAR ), 
		 'fattest cat') AS next_heaviest_cat
FROM windowfunctions.cats
ORDER BY weight;

---15. The cats have decided the correct weight is the same as the 4th lightest cat. 
---		All cats shall have this weight. Except in a fit of jealous rage they decide to set 
---		the weight of the lightest three to 99.9 Print a list of cats, their weights and their imagined weight 
SELECT name, weight, 
COALESCE(NTH_VALUE(weight, 4) OVER(ORDER BY weight), 99.9) AS imagined_weight
FROM windowfunctions.cats;

---16. The cats want to show their weight by breed. The cats agree that they should show the 
---		second lightest cat's weight (so as not to make other cats feel bad).
---		Print a list of breeds, and the second lightest weight of that breed
SELECT DISTINCT(breed),
NTH_VALUE(weight, 2) OVER(PARTITION BY breed ORDER BY weight RANGE BETWEEN UNBOUNDED 
						  PRECEDING AND UNBOUNDED FOLLOWING) AS imagined_weight
FROM windowfunctions.cats
ORDER BY breed;

---17. Each cat would like to see what half, third and quartile they are in for their weight.
SELECT name, weight,
NTILE(2) OVER NTILE_WINDOW as by_half,
NTILE(3) OVER NTILE_WINDOW as by_thirds,
NTILE(4) OVER NTILE_WINDOW as by_quarters
FROM windowfunctions.cats 
WINDOW NTILE_WINDOW AS
(ORDER BY weight)
ORDER BY weight, name;

---18. We would like to group our cats by color. 
---		Return 3 rows, each row containing a color and a list of cat names.
SELECT color, ARRAY_AGG(name) 
FROM windowfunctions.cats 
GROUP BY color
ORDER BY color DESC;

---19. We would like to find the average weight of cats grouped by breed. 
---		Also, in the same query find the average weight of cats grouped by 
---		breed whose age is over 1.
SELECT breed, 
AVG(weight) AS avg_weight,
AVG(weight) FILTER (WHERE age > 1) AS avg_old_weight
FROM windowfunctions.cats
GROUP BY breed
ORDER BY breed;