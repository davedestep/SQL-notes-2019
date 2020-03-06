#QUESTION 1 - LARGEST WEIGHT CHANGE BETWEEN TWO CONSECUTIVE VISITS
USE weight;

#Can't delete duplicates because of foreign key constraint and dont feel like rerunning code to create schema without duplicates
#Ignore this
/*
SELECT 
    participant_id, 
    weight, 
    ROW_NUMBER() OVER ( 
        PARTITION BY weight 
        ORDER BY weight
    ) AS row_num 
FROM visits;

SELECT 
    participant_id 
FROM (
    SELECT 
        participant_id,
        ROW_NUMBER() OVER (
            PARTITION BY weight
            ORDER BY weight) AS row_num
    FROM 
        visits
) t
WHERE 
    row_num > 1;
    
   
DELETE FROM visits 
WHERE 
    participant_id IN (
    SELECT 
        participant_id 
    FROM (
        SELECT 
            participant_id,
            ROW_NUMBER() OVER (
                PARTITION BY weight
                ORDER BY weight) AS row_num
        FROM 
            visits
        
    ) t
    WHERE row_num > 1
);
    */
    
  /*DELETE v1 FROM visits v1
INNER JOIN visits v2 
WHERE 
    v1.participant_id < v2.participant_id AND 
    v1.weight = v2.weight;
*/

  
  
  /***************************************************/
/*Question 1*/
  /***************************************************/

#Weight database had data entered multiple times, deleting duplicates did not work and dont feel like rerunning schema code from 13 and 14
SELECT v1.participant_id, v1.visit_type, v1.weight, v2.visit_type, v2.weight, v2.weight-v1.weight as diff
FROM visits as v1
INNER JOIN visits as v2
	ON v1.participant_id=v2.participant_id AND 
		v1.visit_type=(v2.visit_type-4)
GROUP BY v1.participant_id, v1.visit_type, v1.weight, v2.visit_type, v2.weight;
#Grouping to not show duplicates from data entry in asignment 14    





#####################################
# USE THE DATA BELOW FOR QUESTION 2 #
#####################################

CREATE SCHEMA clinics;

USE clinics;

CREATE TABLE clinics (
	clinic_id VARCHAR(6), 
    location_cat VARCHAR(8)
);

INSERT INTO clinics 
	VALUES
	('ABC','rural'),
	('DEFG','suburban'),
	('HIJKL','urban'),
	('MNOPQR','suburban'),
	('STUV','rural'),
	('WXYZA','rural'),
	('BCDEF','urban'),
	('GHIJK','suburban'),
	('LMN',	'suburban'),
	('OPQ',	'rural'),
    ('RSTNLE', 'urban');

CREATE TABLE participants (
	partic_id TINYINT(3), 
	clinic_id VARCHAR(6)
);

INSERT INTO participants
VALUES
('70','ABC'),
('46','HIJKL'),
('15','MNOPQR'),
('6','STUV'),
('6','STUV'),
('82','STUV'),
('9','DEFG'),
('52','WXYZA'),
('29','STUV'),
('3','GHIJK'),
('60','LMN'),
('88','DEFG'),
('1','HIJKL'),
('69','HIJKL'),
('59','STUV'),
('36','WXYZA'),
('24','ABC'),
('67','MNOPQR'),
('71','HIJKL'),
('19','STUV'),
('34','LMN'),
('25','LMN'),
('45','OPQ'),
('49','HIJKL'),
('31','LMN'),
('13','DEFG'),
('83','WXYZA'),
('18','WXYZA'),
('73','WXYZA'),
('22','STUV'),
('61','OPQ'),
('90','GHIJK'),
('78','MNOPQR'),
('80','LMN'),
('91','ABC'),
('33','HIJKL'),
('16','OPQ'),
('14','WXYZA'),
('77','WXYZA'),
('50','WXYZA'),
('32','WXYZA'),
('54','RSTUVW'),
('97','ABC'),
('99','DEFG'),
('55','STUV'),
('7','OPQ'),
('66','GHIJK'),
('96','HIJKL'),
('44','RSTUVW'),
('10','MNOPQR'),
('98','STUV'),
('11','GHIJK'),
('40','STUV'),
('2','HIJKL'),
('47','MNOPQR'),
('26','LMN'),
('95','OPQ'),
('68','OPQ'),
('76','OPQ'),
('94','MNOPQR'),
('35','RSTUVW'),
('62','RSTUVW'),
('17','HIJKL'),
('4','GHIJK'),
('30','GHIJK'),
('39','OPQ'),
('89','LMN'),
('87','HIJKL'),
('57','HIJKL'),
('74','MNOPQR'),
('85','HIJKL'),
('100','STUV'),
('53','STUV'),
('43','HIJKL'),
('92','ABC'),
('56','GHIJK'),
('58','LMN'),
('23','OPQ'),
('64','LMN'),
('75','LMN'),
('79','MNOPQR'),
('8','DEFG'),
('84','DEFG'),
('37','DEFG'),
('5','RSTUVW'),
('86','HIJKL'),
('28','GHIJK'),
('48','LMN'),
('27','WXYZA'),
('12','STUV'),
('63','DEFG'),
('20','STUV'),
('81','STUV'),
('38','ABC'),
('72','OPQ'),
('21','WXYZA'),
('42', NULL),
('51','HIJKL'),
('41','LMN'),
('95','OPQ'),
('93','DEFG');

###############################################

#QUESTION 2 - ACHIEVING A FULL JOIN IN MYSQL

SELECT c.clinic_id, p.partic_id
FROM clinics as c
LEFT JOIN participants as p
ON c.clinic_id=p.clinic_id
WHERE partic_id is null
UNION
SELECT c.clinic_id, p.partic_id
FROM clinics as c
RIGHT JOIN participants as p
ON c.clinic_id=p.clinic_id
WHERE c.clinic_id is null;


#####################################
# USE THE DATA BELOW FOR QUESTION 3 #
#####################################

CREATE SCHEMA class;

USE class;

CREATE TABLE ta (
	ta_name VARCHAR(8)
);

INSERT INTO ta
	VALUES
    ('Baoyi'),
    ('Jannie'),
    ('Sammi');

CREATE TABLE student (
	student_name VARCHAR(15)
);

INSERT INTO student
	VALUES
    ('Amanda H.'),
    ('Amanda K.'),
    ('Bing Bing'),
    ('Carolina'),
    ('Catherine'),
    ('Charles'),
    ('Connie'),
    ('Dave'),
    ('Hallie'),
    ('Iris'),
    ('Jai'),
    ('Jun'),
    ('Keyanna'),
    ('Lenka'),
    ('Mary'),
    ('Matt'),
    ('Naama'),
    ('Naina'),
    ('Olya'),
    ('Rocky'),
    ('Samantha'),
    ('Sarah'),
    ('Shali'),
    ('Sunder'),
    ('Tianna'),
    ('Tiffany'),
    ('Zohar');
 


#QUESTION 3 - TA GRADING ROSTER

CREATE VIEW grading AS
SELECT t.ta_name, s.student_name
FROM TA as t, student as s
WHERE ta_name="Baoyi" AND student_name REGEXP '^[A-G]'
UNION
SELECT t.ta_name, s.student_name
FROM TA as t, student as s
WHERE ta_name="Jannie" AND student_name REGEXP '^[H-M]'
UNION
SELECT t.ta_name, s.student_name
FROM TA as t, student as s
WHERE ta_name="Sammi" AND student_name REGEXP '^[N-Z]';

SELECT * 
FROM grading
ORDER BY ta_name, student_name;


SELECT ta_name, COUNT(student_name)
FROM grading
GROUP BY ta_name;

#Baoyi	8
#Jannie	8
#Sammi	11
