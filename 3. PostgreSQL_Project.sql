/*
	Question 22: 
	Task : Write a query that outputs only the top earner per position_title including first_name and position_title and their salary.
		   		   
	QUERY IDEATION: "RANK" the "POSITION_TITLE" by "SALARY" through "OVER & PARTITION BY" window fuction as subquery in the "FROM" Clause
				    and use "WHERE" clause in the outer query to filter the first rank
*/
-- Solution 22

SELECT
	FIRST_NAME,
	POSITION_TITLE,
	SALARY
FROM
	(
		SELECT
			FIRST_NAME,
			POSITION_TITLE,
			SALARY,
			RANK() OVER (PARTITION BY POSITION_TITLE ORDER BY SALARY DESC) AS RANK
		FROM EMPLOYEES
	)
WHERE RANK = 1;


/*
	Question 21: 
	Task : a) Write a query that returns the following: emp_id, first_name, last_name, position_title, salary
			  and a column that returns the average salary for every position_title. Order the results by the emp_id.
		   b) How many people earn less than there avg_position_salary? Write a query that answers that question.
		   	  Ideally, the output just shows that number directly.
		   c) Write a query that returns a running total of the salary development by the start_date.
		   	  In your calculation, you can assume their salary has not changed over time, 
			  and you can disregard the fact that people have left the company (write the query as if they were still working for the company).
		   
	QUERY IDEATION: Use window function OVER(PARTITION BY POSITION_TITLE) and aggregate to get the avergae salary into a new column for all entries
*/
-- Solution 21 a)

SELECT
	EMP_ID,
	FIRST_NAME,
	LAST_NAME,
	POSITION_TITLE,
	SALARY,
	ROUND(AVG(SALARY) OVER (PARTITION BY POSITION_TITLE), 2) AS AVG_POSITION_SALARY
FROM EMPLOYEES
ORDER BY 1

-- Solution 21 b)

SELECT
	COUNT(*)
FROM
	(
	SELECT
		EMP_ID,
		SALARY,
		ROUND(AVG(SALARY) OVER (PARTITION BY POSITION_TITLE), 2) AS AVG_POSITION_SALARY
		FROM EMPLOYEES
	)
WHERE SALARY < AVG_POSITION_SALARY

-- Solution 21 c)

SELECT
	EMP_ID,
	SALARY,
	START_DATE,
	SUM(SALARY) OVER (ORDER BY	START_DATE) AS RUUNING_TOTAL_OF_SALARY
FROM EMPLOYEES


/*
	Question 20: 
	Task : a) Write a query that returns the average salaries for each positions with appropriate roundings.
		   b) Write a query that returns the average salaries per division.
		   
	QUERY IDEATION: Use "GROUP BY" on postition_title and aggregate salary as avergae salary
*/
-- Solution 20 a)

SELECT
	POSITION_TITLE,
	ROUND(AVG(SALARY), 2)
FROM EMPLOYEES
GROUP BY POSITION_TITLE
ORDER BY 2

-- Solution 20 b)

SELECT
	DIVISION,
	ROUND(AVG(SALARY), 2)
FROM EMPLOYESS E
	LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY DIVISION 
ORDER BY 2

/*
	Question 19: 
	Task : a) Write a query that adds a column called manager that contains  first_name and last_name (in one column) in the data output.
		   Secondly, add a column called is_active with 'false' if the employee has left the company already, otherwise the value is 'true'.
		   b) Create a view called v_employees_info from that previous query.
		   
	QUERY IDEATION: Create a "CASE" statement to check if the employee left the company. If the "END_DATE" is null then the employee is working
					else left the company. Use SELF join the "EMPLOYEES" table on "MANAGER_ID" & "EMPLOYEE_ID" to find who is the manager to an employee
*/
-- Solution 19 a)

SELECT
	E.*,
	CASE
		WHEN E.END_DATE IS NULL THEN 'true'
		ELSE 'false'
	END AS IS_ACTIVE,
	M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E
	LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMP_ID

-- Solution 19 b)

CREATE VIEW AS V_EMPLOYEES_INFO AS 
SELECT
	E.*,
	CASE
		WHEN E.END_DATE IS NULL THEN 'true'
		ELSE 'false'
	END AS IS_ACTIVE,
	M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E
	LEFT JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMP_ID

/*
	Question 18: 
	Task : a) Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
		   b) The responsible people decided to rename the position_title Customer Support to Customer Specialist.
		   c) All SQL Analysts including Senior SQL Analysts get a raise of 6%.
*/
-- Solution 18

UPDATE EMPLOYEES
SET	POSITION = 'Senior SQL Analyst'
WHERE EMP_ID = 25;
UPDATE EMPLOYEES
SET	SALARY = 7200
WHERE EMP_ID = 25;

UPDATE EMPLOYEES
SET	POSITION_TITLE = 'Customer Specialist'
WHERE POSITION_TITLE = 'Customer Support'

UPDATE EMPLOYEES
SET	SALARY = SALARY * 1.06
WHERE POSITION_TITLE = 'SQL Analyst'

/*
	Question 17: 
	Task : Insert the following values into the departments table.
*/
-- Solution 17

INSERT INTO
	DEPARTMENTS
VALUES
	(1, 'Analytics', 'IT'),
	(2, 'Finance', 'Administration'),
	(3, 'Sales', 'Sales'),
	(4, 'Website', 'IT'),
	(5, 'Back Office', 'Administration')


/*
	Question 16: 
	Task : Insert the following values into the employees table. There will be most likely an error when you try to insert the values.
		   So, try to insert the values and then fix the error.
*/
-- Solution 16

INSERT INTO 
	EMPLOYEES
VALUES
(1,'Morrie','Conaboy','CTO',21268.94,'2005-04-30','1983-07-10',1,1,NULL,NULL),
(2,'Miller','McQuarter','Head of BI',14614.00,'2019-07-23','1978-11-09',1,1,1,NULL),
(3,'Christalle','McKenny','Head of Sales',12587.00,'1999-02-05','1973-01-09',2,3,1,NULL),
(4,'Sumner','Seares','SQL Analyst',9515.00,'2006-05-31','1976-08-03',2,1,6,NULL),
(5,'Romain','Hacard','BI Consultant',7107.00,'2012-09-24','1984-07-14',1,1,6,NULL),
(6,'Ely','Luscombe','Team Lead Analytics',12564.00,'2002-06-12','1974-08-01',1,1,2,NULL),
(7,'Clywd','Filyashin','Senior SQL Analyst',10510.00,'2010-04-05','1989-07-23',2,1,2,NULL),
(8,'Christopher','Blague','SQL Analyst',9428.00,'2007-09-30','1990-12-07',2,2,6,NULL),
(9,'Roddie','Izen','Software Engineer',4937.00,'2019-03-22','2008-08-30',1,4,6,NULL),
(10,'Ammamaria','Izhak','Customer Support',2355.00,'2005-03-17','1974-07-27',2,5,3,'2013-04-14'),
(11,'Carlyn','Stripp','Customer Support',3060.00,'2013-09-06','1981-09-05',1,5,3,NULL),
(12,'Reuben','McRorie','Software Engineer',7119.00,'1995-12-31','1958-08-15',1,5,6,NULL),
(13,'Gates','Raison','Marketing Specialist',3910.00,'2013-07-18','1986-06-24',1,3,3,NULL),
(14,'Jordanna','Raitt','Marketing Specialist',5844.00,'2011-10-23','1993-03-16',2,3,3,NULL),
(15,'Guendolen','Motton','BI Consultant',8330.00,'2011-01-10','1980-10-22',2,3,6,NULL),
(16,'Doria','Turbat','Senior SQL Analyst',9278.00,'2010-08-15','1983-01-11',1,1,6,NULL),
(17,'Cort','Bewlie','Project Manager',5463.00,'2013-05-26','1986-10-05',1,5,3,NULL),
(18,'Margarita','Eaden','SQL Analyst',5977.00,'2014-09-24','1978-10-08',2,1,6,'2020-03-16'),
(19,'Hetty','Kingaby','SQL Analyst',7541.00,'2009-08-17','1999-04-25',1,2,6,NULL),
(20,'Lief','Robardley','SQL Analyst',8981.00,'2002-10-23','1971-01-25',2,3,6,'2016-07-01'),
(21,'Zaneta','Carlozzi','Working Student',1525.00,'2006-08-29','1995-04-16',1,3,6,'2012-02-19'),
(22,'Giana','Matz','Working Student',1036.00,'2016-03-18','1987-09-25',1,3,6,NULL),
(23,'Hamil','Evershed','Web Developper',3088.00,'2022-02-03','2012-03-30',1,4,2,NULL),
(24,'Lowe','Diamant','Web Developper',6418.00,'2018-12-31','2002-09-07',1,4,2,NULL),
(25,'Jack','Franklin','SQL Analyst',6771.00,'2013-05-18','2005-10-04',1,2,2,NULL),
(26,'Jessica','Brown','SQL Analyst',8566.00,'2003-10-23','1965-01-29',1,1,2,NULL);


/*
	Question 15: 
	Task : Alter the employees table in the following way:
			a) Set the column department_id to not null.
			b) Add a default value of CURRENT_DATE to the column start_date.
			c) Add the column end_date with an appropriate data type (one that you think makes sense).
			d) Add a constraint called birth_check that doesn't allow birth dates that are in the future.
			e) Rename the column job_position to position_title.

	QUERY IDEATION: 
*/
-- Solution 15

ALTER TABLE employees 
ALTER COLUMN department_id SET NOT NULL,
ALTER COLUMN start_date SET DEFAULT CURRENT_DATE,
ADD COLUMN end_date DATE,
ADD CONSTRAINT birth_check CHECK(birth_date < CURRENT_DATE);
ALTER TABLE employees
RENAME job_position TO position_title;


/*
	Question 14: 
	Task : In your company there hasn't been a database table with all the employee and department information yet.
			You need to set up the table called employees in the following way: There should be NOT NULL constraints for the following columns:
			first_name, last_name , job_position, start_date DATE, birth_date DATE
			
	QUERY IDEATION: Create TABLE and specify "NOT NULL" for those column as mentioned above. 
					Let the "EMP_ID" be the "PRIMARY KEY" & dataype br "SERIAL" and the "STORE_ID" is the "FOREGIN KEY" referencing to another existing "STORE" table
*/
-- Solution 14

CREATE TABLE EMPLOYEES (
	EMP_ID SERIAL PRIMARY KEY,
	FIRST_NAME TEXT NOT NULL,
	LAST_NAME TEXT NOT NULL,
	JOB_POSITION TEXT NOT NULL,
	SALARY DECIMAL(8, 2),
	START_DATE DATE NOT NULL,
	BIRTH_DATE DATE NOT NULL,
	STORE_ID INT REFERENCES STORE (STORE_ID),
	DEPARTMENT_ID INT,
	MANAGER_ID INT
)

CREATE TABLE DEPARTMENTS (
	DEPARTMENT_ID SERIAL PRIMARY KEY,
	DEPARTMENT TEXT NOT NULL,
	DIVISION TEXT NOT NULL
)



/*
	Question 13:
	Task : Calculate the total rental count and total rental amount for each customer, and list customers who have rented more than the average number of films.
	
	QUERY IDEATION: Create two CTE common table expression one for calculating the total rental count & total rental amount, this could be done by "LEFT JOIN"
					"PAYMENT" table onto "CUSTOMER" table and use "GROUP BY" clause  for grouping values by "CUSTOMER_ID", "FIRST_NAME" & "LAST_NAME".
					The second CTE can be used to filter the customer who spend higher than the average spend by referencing the first CTE in the "FROM" clause
					and in "WHERE" clause to filter total spent is greater than avergae total spent
*/
-- Solution 13

-- CTE 1: calculate the total spending of the customer
WITH
	CUSTOMER_SPENDING_CTE AS (
		SELECT
			C.CUSTOMER_ID,
			C.FIRST_NAME,
			C.LAST_NAME,
			SUM(P.AMOUNT) AS TOTAL_SPENT
		FROM CUSTOMER C
			LEFT JOIN PAYMENT P ON C.CUSTOMER_ID = P.CUSTOMER_ID
		GROUP BY
			C.CUSTOMER_ID,
			C.FIRST_NAME,
			C.LAST_NAME
	),
	-- CTE 2: finding the high spending customer
	HIGH_SPENDING_CUSTOMER_CTE AS (
		SELECT
			CUSTOMER_ID,
			FIRST_NAME,
			LAST_NAME,
			TOTAL_SPENT
		FROM CUSTOMER_SPENDING_CTE
		WHERE
			TOTAL_SPENT > (
				SELECT
					AVG(TOTAL_SPENT)
				FROM
					CUSTOMER_SPENDING_CTE
			)
	)
SELECT
	H.CUSTOMER_ID,
	H.FIRST_NAME,
	H.LAST_NAME,
	H.TOTAL_SPENT,
	F.FILM_ID,
	F.TITLE
FROM HIGH_SPENDING_CUSTOMER_CTE H
	LEFT JOIN RENTAL R ON H.CUSTOMER_ID = R.CUSTOMER_ID
	LEFT JOIN INVENTORY I ON R.INVENTORY_ID = I.INVENTORY_ID
	JOIN FILM F ON I.FILM_ID = F.FILM_ID


/*
	Question 12:
	Task: Create a list that shows the "average customer lifetime value" grouped by the different districts.
	
	QUERY IDEATION: Use multiple "LEFT JOIN" to combine "PAYMENT" table with the "ADDRESS" table and calcualte the total "AMOUNT"
					spent by each "CUSTOMER_ID" in each "DISTRICT" through "GROUP BY" clause as a subquery. In the outer query,
					calcualte the avergae "AMOUNT" per "DISTRICT" using "GROUP BY" clause.
*/
-- Solution 12

SELECT
	DISTRICT,
	ROUND(AVG(TOTAL), 2) AVG_CUSTOMER_SPENT
FROM
	(
		SELECT
			C.CUSTOMER_ID,
			DISTRICT,
			SUM(AMOUNT) TOTAL
		FROM PAYMENT P
			LEFT JOIN CUSTOMER C ON C.CUSTOMER_ID = P.CUSTOMER_ID
			LEFT JOIN ADDRESS A ON C.ADDRESS_ID = A.ADDRESS_ID
		GROUP BY DISTRICT, C.CUSTOMER_ID
		ORDER BY SUM(AMOUNT) DESC
	) SUBQUERY_1
GROUP BY DISTRICT
ORDER BY ROUND(AVG(TOTAL), 2) DESC


/*
	Question 11:
	Task: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.
	
	QUERY IDEATION: Use correlated subquery to calcualte the average "LENGTH" of films by their "REPLACEMENT_COST". In the outer query, filter the "LENGTH" where 
					it's greater the avergae.
*/
-- Solution 11

SELECT
	TITLE,
	LENGTH
FROM FILM F1
WHERE LENGTH > (
		SELECT
			AVG(LENGTH)
		FROM FILM F2
		WHERE F1.REPLACEMENT_COST = F2.REPLACEMENT_COST
				)
ORDER BY LENGTH ASC


/*
	Question 10:
	Task: Create a query that shows average daily revenue of all Sundays.

	QUERY IDEATION: First, calcualte the total "AMOUNT" from "PAYMENT" table by sunday as a subquery and use it in "FROM" clause
					and then calculate the average amount in the outer query.
*/
-- Solution 10

SELECT
	AVG(TOTAL)
FROM
	(
		SELECT
			SUM(AMOUNT) AS TOTAL,
			DATE (PAYMENT_DATE),
			EXTRACT(DOW	FROM PAYMENT_DATE) AS WEEKDAY
		FROM PAYMENT
		WHERE EXTRACT(DOW FROM PAYMENT_DATE) = 0
		GROUP BY DATE (PAYMENT_DATE), WEEKDAY
	) SUBQUERY_1


/*
	Question 9:
	Task: Create a list with the average of the sales amount each staff_id has per customer.
	
	QUERY IDEATION: First, calcualte the total "AMOUNT" by each "CUSTOMER_ID" and billed byeach "STAFF_ID". This will give the total amount spent by 
					each customer for each staff. This calculation can be used within "FROM" clause as a subquery. 
					In the outer query calculate the avergae total amount by each "STAFF_ID".
*/
-- Solution 9

SELECT
	STAFF_ID,
	ROUND(AVG(TOTAL), 2) AS AVG_AMOUNT
FROM
	(
		SELECT
			SUM(AMOUNT) AS TOTAL,
			CUSTOMER_ID,
			STAFF_ID
		FROM PAYMENT
		GROUP BY CUSTOMER_ID, STAFF_ID
		ORDER BY CUSTOMER_ID
	) SUBQUERY_1
GROUP BY STAFF_ID


/*
	Question 8:
	Task: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
	
	QUERY IDEATION: Similar to question 7, Use multiple "LEFT JOIN" to combine the "PAYMENT" table with "CITY" table.
					In addition, join the "COUNTRY" table with "CITY" table using "COUNTRY_ID" to include the country name.
					Finally, use "GROUP BY" clause by concatenating the country name and city name.
*/
-- Solution 8

SELECT
	COUNTRY || ', ' || CITY AS LOCATION,
	SUM(AMOUNT)
FROM PAYMENT P
	LEFT JOIN CUSTOMER C ON P.CUSTOMER_ID = C.CUSTOMER_ID
	LEFT JOIN ADDRESS A ON A.ADDRESS_ID = C.ADDRESS_ID
	LEFT JOIN CITY CI ON CI.CITY_ID = A.CITY_ID
	LEFT JOIN COUNTRY CO ON CO.COUNTRY_ID = CI.COUNTRY_ID
GROUP BY COUNTRY || ', ' || CITY
ORDER BY SUM(AMOUNT) ASC


/* 
	Question 7:
	Task: Create the overview of the sales to determine the from which city (we are interested in the city in which the customer lives, 
		  not where the store is) most sales occur.

	QUERY IDEATION: Use "LEFT JOIN" to combine "PAYMENT" table with the "CUSTOMER" table using "CUSTOMER_ID". Then join "ADDRESS" table using "ADDRESS_ID"
					and subsequently join the "CITY" table using "CITY_ID". This combines each payment to the corresponding city where the customer lives.
					Finally, use "GROUP BY" to group the cities by aggregating the payment amount.
*/
-- Solution 7

SELECT
	CITY,
	SUM(AMOUNT)
FROM PAYMENT P
	LEFT JOIN CUSTOMER C ON P.CUSTOMER_ID = C.CUSTOMER_ID
	LEFT JOIN ADDRESS A ON A.ADDRESS_ID = C.ADDRESS_ID
	LEFT JOIN CITY CI ON CI.CITY_ID = A.CITY_ID
GROUP BY CITY
ORDER BY CITY DESC


/* 
	Question 6:
	Task: Create an overview of the addresses that are not associated to any customer.
	
	QUERY IDEATION: Use "LEFT JOIN" to combine the "ADDRESS" table with the "CUSTOMER" table. If there is no customer in an address, then the join creates 
					"NULL" values for the customer table. The use "IS NULL" in "WHERE" Clause to filter the details of those address.
*/
-- Solution 6

SELECT
	*
FROM ADDRESS A
	LEFT JOIN CUSTOMER C ON C.ADDRESS_ID = A.ADDRESS_ID
WHERE C.FIRST_NAME IS NULL


/* 
	Question 5:
	Task: Create an overview of the actors' first and last names and in how many movies they appear in.
	
	QUERY IDEATION: Similary to 3 & 4, "FILM" table does not have the actors "FIRST_NAME" & "LAST_NAME" which are present in "ACTOR" table. 
					The "FILM_ACTOR" table has both the primary key "ACTOR_ID" & "FILM_ID". Use "LEFT_JOIN" the tables subsquently.
					Finally, "GROUP BY" both "FIRST_NAME" & "LAST_NAME" to "COUNT" the number of movies each actor has acted.
*/
-- Solution 5

SELECT
	FIRST_NAME,
	LAST_NAME,
	COUNT(*)
FROM FILM F
	LEFT JOIN FILM_ACTOR FA ON F.FILM_ID = FA.FILM_ID
	LEFT JOIN ACTOR A ON FA.ACTOR_ID = A.ACTOR_ID
GROUP BY FIRST_NAME, LAST_NAME
ORDER BY COUNT(*) DESC


/*	
	Question 4:
	Task: Create an overview of how many movies (titles) there are in each category (name).
	
	QUERY IDEATION: Same as the previous question, the "FILM" table doesn't have the "NAME". So, follow the same pattern of joining tables.
					Use "GROUP BY" the "NAME", to "COUNT" the numbers of movies in each category name
*/
-- Solution 4

SELECT
	NAME,
	COUNT(TITLE)
FROM FILM F
	LEFT JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
	LEFT JOIN CATEGORY C ON C.CATEGORY_ID = FC.CATEGORY_ID
GROUP BY NAME
ORDER BY COUNT(TITLE) DESC


/*
	Question 3:
	Task: Create a list of the film titles including their title, length, and category name ordered descendingly by length. 
		  Filter the results to only the movies in the category 'Drama' or 'Sports'.

	QUERY IDEATION: The "FILM" table does not have the foreign key "CATEGORY_ID" linking to the "CATEGORY" table, which contains the "NAME" of the category.
					However, the "FILM_CATEGORY" table contains both the primary key "FILM_ID" & "CATEGORY_ID". 
					So, first "LEFT JOIN" the "FILM_CATEGORY" table using "FILM_ID" and then again "LEFT JOIN" the "CATEGORY" table using "CATEGORY_ID". 
					Finally, use "WHERE" clause to filter "DRAMA" and "SPORTS" categories.
*/ 
-- Solution 3

SELECT
	TITLE,
	NAME,
	LENGTH
FROM FILM F
	LEFT JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
	LEFT JOIN CATEGORY C ON C.CATEGORY_ID = FC.CATEGORY_ID
WHERE NAME = 'Sports' OR NAME = 'Drama'
ORDER BY LENGTH DESC


/*
	Question 2:
	Task: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
	low: 9.99 - 19.99; medium: 20.00 - 24.99; high: 25.00 - 29.99

	QUERY IDEATION: Use "CASE" to create buckets for the range of "REPLACEMENT_COST" and "COUNT" them by grouping "GROUP BY" the buckets
*/
-- Solution 2
 
SELECT
	CASE
		WHEN REPLACEMENT_COST BETWEEN 9.99 AND 19.99  THEN 'low'
		WHEN REPLACEMENT_COST BETWEEN 20 AND 24.99  THEN 'medium'
		ELSE 'high'
	END AS COST_RANGE,
	COUNT(*)
FROM FILM
GROUP BY COST_RANGE


/*
	Question 1:
	Task: Create a list of all the different (distinct) replacement costs of the films.

	QUERY IDEATION: Use "SELECT DISTINCT"
*/
-- Solution 1

SELECT DISTINCT
	REPLACEMENT_COST
FROM FILM
ORDER BY REPLACEMENT_COST
