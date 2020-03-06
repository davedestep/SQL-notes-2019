#dd2948
###########################
#  IN-CLASS ASSIGNMENT 9  #
###########################
library(tidyverse)
#Install sqldf package
install.packages("sqldf")

#Load sqldf package
library(sqldf)

#Set working directory (point to folder where you have NHANES csv files)
setwd("C:\\Users\\daved\\OneDrive\\Columbia Notes\\SQL\\NHANES")

#Import the NHANES demographics csv file and call it "demo"
demo<-read.csv("NHANES_Demographics.csv")


#Import the NHANES triglycerides csv file and call it "tri"
tri<-read.csv("NHANES_Triglycerides.csv")


#Show the first few records of each dataframe to identify any common fields between them
head(demo)
head(tri)

#Respondent sequence number is the common field

#1. Write a query that would allow you to fill out table 1 and assign the results to an object called table1
demo<-demo %>% mutate(Race=recode(Race_Hispanic_origin_w_NH_Asian, 
                             "1"="Mexican American",
                             "2"="Other Hispanic",
                             "3"="Non-Hispanic White",
                             "4"="Non-Hispanic Black",
                             "6"="Non-Hispanic Asian",
                             "7"="Other Race - Including Multi-Racial"))

table1<-sqldf("SELECT Race, COUNT(Race_Hispanic_origin_w_NH_Asian) AS Frequency, ROUND(AVG(Age_in_years_at_screening), 1) AS MeanAge
                FROM demo 
                GROUP BY Race")


#2. Show the distribution of race by gender and display the race/gender combinations from highest to lowest 
#   frequency.  Note: when using SQL in R, you *can* refer to column aliases outside of the SELECT clause.
table2<-sqldf("SELECT gender, race, count(gender) as freq
      FROM demo
      GROUP BY race, gender
      ORDER BY freq DESC")


#3. Count the number of women who were pregnant at the time of screening.  Use the column alias preg_at_screen.
sqldf("SELECT count(Pregnancy_status_at_exam) as preg_at_screen
      FROM demo
      GROUP BY Pregnancy_status_at_exam
      HAVING Pregnancy_status_at_exam=1")


    
#4. How many men refused to provide annual household income?
sqldf("SELECT count(Annual_household_income) as num_refused
      FROM demo
      GROUP BY Annual_household_income
      HAVING Annual_household_income=77")



#5. What is the mean LDL level (mg/dL) for men and women?  Use column alias mean_ldl and round results to 
#   1 decimal place.  
    
sqldf("SELECT a.gender, avg(b.LDL_cholesterol_mg_dL) as mean_ldl
      FROM demo as a
      INNER JOIN tri as b
      ON a.Respondent_sequence_number=b.Respondent_sequence_number
      GROUP BY a.Gender")


#6. Display the minimum and maximum triglyceride levels (mmol/L) for each race.  Use column aliases min_tri and max_tri.
  

sqldf("SELECT a.race, MIN(b.Triglyceride_mmol_L) as min_tri, MAX(b.Triglyceride_mmol_L) as max_tri
      FROM demo as a
      INNER JOIN tri as b
      ON a.Respondent_sequence_number=b.Respondent_sequence_number
      GROUP BY a.race")

    
    
#7. Create a new data frame that can be used for future analyses that combines all demographic data and any 
#   matching triglyceride data.  Call it demo_tri.
    

demo_tri <- sqldf("SELECT a.*, b.*
                   FROM demo AS a
                   INNER JOIN trigly AS b
                   ON a.Respondent_sequence_number=b.Respondent_sequence_number")

