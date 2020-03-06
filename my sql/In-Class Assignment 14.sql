USE weight;



DROP TRIGGER trigger_participants;
#DROP TRIGGER trigger_ae_log;

############
# TRIGGERS #
############
#Trigger for Participants Table
/*Limit tx_group to values of 1 or 2*/
/*Limit age range: 18 to 55*/
/*Limit prediabetes value to 0 or 1*/
DELIMITER //
CREATE TRIGGER trigger_participants
	BEFORE INSERT ON participants
    FOR EACH ROW
BEGIN
	IF NEW.tx_group NOT IN (1, 2) THEN
    SIGNAL SQLSTATE 'HY000'
	SET MESSAGE_TEXT = 'The value for tx_group must equal 1 or 2';
END IF;
    IF NEW.age NOT BETWEEN 18 AND 56 THEN
    SIGNAL SQLSTATE 'HY000'
	SET MESSAGE_TEXT = 'The value for age must be between 18 and 55';
END IF;
	IF NEW.prediabetes NOT IN (1, 2) THEN
    SIGNAL SQLSTATE 'HY000'
	SET MESSAGE_TEXT = 'The value for prediabetes must be equal to 0 or 1';
END IF;
END//


#Trigger for adverse event log table
DELIMITER //
CREATE TRIGGER trigger_ae_log
/*Limit event_date to dates between 6/15/2017 and today*/
	BEFORE INSERT ON adverse_event_log
    FOR EACH ROW
BEGIN
	IF NEW.event_date NOT BETWEEN '2017-06-15' and CURDATE() THEN
    SIGNAL SQLSTATE 'HY000'
	SET MESSAGE_TEXT = 'The date must be between 6/15/2017 and todays date';
END IF;
END//




##############
# DATA ENTRY #
##############



/****Think about the order in which to enter data into the tables to avoid errors 
related to orphaned records****/

#Enter data into participants table
INSERT INTO participants (tx_group, age, height, prediabetes)
	VALUES
(1, 46, 1.67, 0),
(2, 54, 1.83, 0),
(2, 49, 1.74, 1),
(1, 47, 1.88, 0),
(1, 39, 1.57, 1 );



#Enter data into visits table
INSERT INTO visits (participant_id, visit_type, weight)
	VALUES
(1, 0, 68.04),
(2, 0, 91.63),
(3, 0, 81.19),
(1, 4, 65.77),
(4, 0, 102.05),
(2, 4, 92.08),
(5, 0, 73.49),
(1, 8, 64.86);

select * from visits;

#Enter data into adverse_events table
INSERT INTO adverse_event(adverse_event_id, adverse_event_type)
	VALUES
(1, "Excessive fatigue"),
(2, "Reaction to medication"),
(3, "Abnormal lab results"),
(4, "Hospitalization"),
(5, "Skin rash"),
(6, "Other");

#Enter data into the diagnoses table
INSERT INTO diagnoses (diagnosis_code, diagnosis_name)
	VALUES
(460, "Acute nasopharyngitis (common cold)"),
(461, "Acute sinusitis"),
(462, "Acute pharyngitis"),
(463, "Acute tonsillitis"),
(464, "Acute laryngitis and tracheitis"),
(465, "Acute upper respiratory infections of multiple or unspecified sites"),
(466, "Acute bronchitis and bronchiolitis"),
(470, "Deviated nasal septum"),
(471, "Nasal polyps"),
(472, "Chronic pharyngitis and nasopharyngitis"),
(473, "Chronic sinusitis"),
(474, "Chronic disease of tonsils and adenoids"),
(475, "Peritonsillar abscess"),
(476, "Chronic laryngitis and laryngotracheitis"),
(477, "Allergic rhinitis"),
(478, "Other diseases of upper respiratory tract"),
(510, "Empyema"),
(511, "Pleurisy"),
(512, "Pneumothorax"),
(513, "Abscess of lung and mediastinum"),
(514, "Pulmonary congestion and hypostasis"),
(515, "Postinflammatory pulmonary fibrosis");



#Enter data into adverse_event_log table
INSERT INTO adverse_event_log(visit_id, adverse_event_id, event_date)
	VALUES
    (4, 3, "2017-08-29"), #HAd to change visit ids because auto generated started at 179
	(5, 1, "2017-09-30"),
	(8, 3, "2017-11-12");
    
#Enter data into the current_dxs table


INSERT INTO current_dxs(visit_id, diagnosis_code)
	VALUES
(1, 470),
(1, 460),
(1, 462),
(3, 515),
(3, 471),
(4, 470),
(4, 460),
(7, 477),
(8, 470),
(8, 460);


##############################################################
##############################################################
#Stop and add the DX lookuptable
##############################################################
##############################################################
#Copy the data from medications_2 into the medications table

INSERT INTO medications (medication_id, medication_name)
 SELECT medication_id, medication_name
 FROM medications_2; 
 
#Drop the medications_2 table
DROP TABLE medications_2;





#Enter data into the current_meds table
INSERT INTO current_meds(visit_id, medication_id)
	VALUES
(1, 6),
(1, 7086),
(2, 371),
(3, 4241),
(4, 6),
(5, 3500),
(6, 371),
(7, 4241),
(8, 6),
(8, 7086);
    
    



SELECT * FROM visits;
SELECT * FROM current_meds;


#########
# VIEWS #
#########
#weight_per_visit
CREATE OR REPLACE VIEW weight_per_visit AS
	SELECT participant_id, visit_id,
		CASE
			WHEN visit_type = 0 THEN "Baseline"
            WHEN visit_type = 4 THEN "Week 4"
            WHEN visit_type = 8 THEN "Week 8"
            WHEN visit_type = 12 THEN "Week 12"
            WHEN visit_type = 16 THEN "Week 16"
            WHEN visit_type = 20 THEN "Week 20"
		END AS visit_type_label,
        weight
	FROM visits
    ORDER BY participant_id, visit_type;


#meds_per_visit
CREATE OR REPLACE VIEW meds_per_visit AS
	SELECT a.participant_id, a.visit_type_label, COUNT(DISTINCT(b.medication_id)) as med_count
	FROM weight_per_visit as a
    LEFT JOIN current_meds as b
		ON a.visit_id=b.visit_id
	GROUP BY a.participant_id, a.visit_type_label
    ORDER BY med_count DESC, a.participant_id;





#diagnosis_summary
CREATE OR REPLACE VIEW diagnosis_summary AS
	SELECT a.diagnosis_name, count(b.visit_id) AS dx_count
	FROM diagnoses AS a
	LEFT JOIN current_dxs as b
		ON a.diagnosis_code=b.diagnosis_code
	GROUP BY a.diagnosis_name
	ORDER BY dx_count DESC;











