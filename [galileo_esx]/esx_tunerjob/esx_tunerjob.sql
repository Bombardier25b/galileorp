USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_tuner', 'Tuner', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_tuner', 'Tuner', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('tuner', 'Tuner')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('tuner',0,'recrue','Recrue',12,'{}','{}'),
	('tuner',1,'novice','Novice',24,'{}','{}'),
	('tuner',2,'experimente','Experimente',36,'{}','{}'),
	('tuner',3,'chief','Chef d\'équipe',48,'{}','{}'),
	('tuner',4,'boss','Patron',0,'{}','{}')
;
