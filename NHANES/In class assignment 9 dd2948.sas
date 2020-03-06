***********************************
* IN-CLASS ASSIGNMENT 9 SOLUTIONS *
***********************************;

*Download the SAS dataset called Demographics to your computer and change the libname
 statement below to reflect the folder in which you've saved the file.;

libname sql "/home/dmd12d0";
data demo;
set sql.Demographics;
run;

*Run PROC CONTENTS to show the variables included in the Demographics data;
proc contents data=sql.demographics order=varnum;
run;

*1. Write a SQL query to display a list of the distinct continents represented in the data;

proc sql;
SELECT DISTINCT CONT
FROM demo;
quit;
    

*2. List the total population of each continent, ordered from highest to lowest;
proc sql;
SELECT cont, sum(pop) as cont_pop
from demo
GROUP BY cont
ORDER BY cont_pop DESC;
quit;


*3. In the absence of a data dictionary, write a query that would help you determine
	which continent is represented by the number that had the highest population in #2.;
proc sql;
SELECT cont, MAX(ISONAME) as country
FROM demo
GROUP BY cont;
quit;
/*91	UNITED STATES
92	VENEZUELA
93	UNITED KINGDOM
94	ZIMBABWE
95	YEMEN
96	VANUATU*/

/*91= North America
92=Sout America
93=Europe
94=Africa
95=The Middle East and Asia
96=Oceania*/



*4. Write a query to calculate the number of individuals who reside in urban areas in each country
	and save it into a new table called sql.urban. Name the variable you calculate as total_urban_pop.;
proc sql;
    CREATE TABLE sql.urban AS
    SELECT isoname, pop, popurban, popurban*pop AS total_urban_pop
    FROM demo;
quit;

*5. Write a query to display the maximum population value in the dataset.;
proc sql;
SELECT MAX(pop)
FROM demo;
quit;

*6. Use the query you wrote in question 5 as a subquery to find the country or countries
	linked to the highest population value.;

proc sql;
SELECT isoname
FROM demo
WHERE pop IN (SELECT MAX(pop)
				FROM demo);
quit;
 /*Its China*/





