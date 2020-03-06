#Add a new schema called `weight`
CREATE SCHEMA weight;


#Write a statement that applies all subsequent code to the weighin schema
USE weight;


/*CREATE THE FOLLOWING TABLES IN AN APPROPRIATE ORDER TO ALLOW CREATION OF FOREIGN KEYS IN THE CREATE TABLE STATEMENT.
  ADD THE RELEVANT SQL CODE TO CREATE EACH TABLE (AND INDEXES) UNDER EACH COMMENT*/

#Participants table and index
CREATE TABLE participants (
	PRIMARY KEY (participant_id),
    participant_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    tx_group  TINYINT(1),
    age TINYINT(4) UNSIGNED,
    height FLOAT(4, 2) UNSIGNED,
    prediabetes TINYINT(1)
);

CREATE INDEX tx_group
	ON participants(tx_group);


#Visits table and indexes
CREATE TABLE visits (
	PRIMARY KEY (visit_id),
    visit_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    participant_id SMALLINT(4) UNSIGNED NOT NULL,
    visit_type TINYINT(1)  NOT NULL,
	weight FLOAT(5, 2),
    FOREIGN KEY (participant_id) REFERENCES participants(participant_id)
		ON UPDATE CASCADE
);

#ALTER TABLE visits 
#	MODIFY weight FLOAT(5,2);

CREATE INDEX weight
	ON visits(weight);
CREATE INDEX visit_type
	ON visits(visit_type);
CREATE INDEX participant_id
	ON visits(participant_id);

    
#Adverse Events lookup table
CREATE TABLE adverse_event(
	PRIMARY KEY (adverse_event_id),
    adverse_event_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    adverse_event_type VARCHAR(255)  NOT NULL
);    



#Adverse Event Log table and indexes
CREATE TABLE adverse_event_log(
	PRIMARY KEY (event_log_id),
    event_log_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    visit_id SMALLINT(4) UNSIGNED  NOT NULL,
    adverse_event_id SMALLINT(4) UNSIGNED  NOT NULL,
    adverse_event_other TEXT,
    event_date DATE,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (adverse_event_id) REFERENCES adverse_event(adverse_event_id)
		ON UPDATE CASCADE
);


CREATE INDEX visit_id
	ON adverse_event_log(visit_id);
CREATE INDEX adverse_event_id
	ON adverse_event_log(adverse_event_id);
CREATE INDEX event_date
	ON adverse_event_log(event_date);


#Medications lookup table
CREATE TABLE medications(
	PRIMARY KEY (medication_id),
    medication_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    medication_name CHAR(255)
);

#Current Meds table and indexes
CREATE TABLE current_meds(
	PRIMARY KEY (current_med_id),
    current_med_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    visit_id SMALLINT(4) UNSIGNED  NOT NULL,
    medication_id SMALLINT(4) UNSIGNED  NOT NULL,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (medication_id) REFERENCES medications(medication_id)
		ON UPDATE CASCADE
);

CREATE INDEX visit_id
	ON current_meds(visit_id);
CREATE INDEX medication_id
	ON current_meds(medication_id);


#Diagnoses lookup table
CREATE TABLE diagnoses(
	PRIMARY KEY (diagnosis_code),
    diagnosis_code SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    diagnosis_name CHAR(255)
);



#Current Diagnoses table and indexes
CREATE TABLE current_dxs(
	PRIMARY KEY (current_dx_id),
    current_dx_id SMALLINT(4) UNSIGNED AUTO_INCREMENT,
    visit_id SMALLINT(4) UNSIGNED,
    diagnosis_code SMALLINT(4) UNSIGNED,
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (diagnosis_code) REFERENCES diagnoses(diagnosis_code)
		ON UPDATE CASCADE
);

CREATE INDEX visit_id
	ON current_dxs(visit_id);
CREATE INDEX diagnosis_code
	ON current_dxs(diagnosis_code);



/*REMEMBER TO CREATE AND SUBMIT THE RESULTING EER DIAGRAM ONCE TABLES HAVE BEEN CREATED*/


    




    