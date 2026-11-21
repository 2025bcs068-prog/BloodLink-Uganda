-- BloodLink Uganda - sample data so the pages have something to show.
-- Run ONCE on an empty donor table.
USE bloodlink_uganda;

INSERT INTO donor (donor_id, national_id, full_name, gender, date_of_birth, phone, blood_type_id, region_id, weight_kg) VALUES
 (1, 'CM90010100AAAA', 'Namukasa Ruth',   'F', '1995-03-14', '0772000001', 7, 1, 62.5),
 (2, 'CM88020200BBBB', 'Okello David',    'M', '1992-07-02', '0772000002', 1, 6, 74.0),
 (3, 'CM91030300CCCC', 'Atim Grace',      'F', '1998-11-21', '0772000003', 3, 6, 58.0),
 (4, 'CM85040400DDDD', 'Mugisha Brian',   'M', '1989-01-30', '0772000004', 8, 3, 81.2),
 (5, 'CM93050500EEEE', 'Nabirye Sarah',   'F', '1996-09-09', '0772000005', 5, 8, 60.0),
 (6, 'CM87060600FFFF', 'Tumusiime Peter', 'M', '1990-05-17', '0772000006', 7, 3, 77.8);

INSERT INTO donor_eligibility (donor_id, last_donation_date, next_eligible_date, status, deferral_reason) VALUES
 (1, DATE_SUB(CURDATE(), INTERVAL 20 DAY),  DATE_ADD(CURDATE(), INTERVAL 70 DAY), 'Eligible',   NULL),
 (2, DATE_SUB(CURDATE(), INTERVAL 100 DAY), CURDATE(),                            'Eligible',   NULL),
 (3, DATE_SUB(CURDATE(), INTERVAL 10 DAY),  DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'Deferred',   'Low hemoglobin'),
 (4, DATE_SUB(CURDATE(), INTERVAL 5 DAY),   DATE_ADD(CURDATE(), INTERVAL 85 DAY), 'Eligible',   NULL),
 (5, NULL,                                  CURDATE(),                            'Eligible',   NULL),
 (6, DATE_SUB(CURDATE(), INTERVAL 30 DAY),  DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'Eligible',   NULL);

INSERT INTO donation (donation_id, donor_id, blood_bank_id, staff_id, donation_date, volume_ml, status) VALUES
 (1, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 450, 'Completed'),
 (2, 2, 1, 1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 450, 'Completed'),
 (3, 3, 2, 1, DATE_SUB(CURDATE(), INTERVAL 30 DAY), 450, 'Completed'),
 (4, 4, 3, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY),  450, 'Completed'),
 (5, 6, 3, 1, DATE_SUB(CURDATE(), INTERVAL 28 DAY), 450, 'Completed'),
 (6, 1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 33 DAY), 450, 'Completed');

INSERT INTO blood_unit (donation_id, blood_type_id, blood_bank_id, collection_date, expiry_date, volume_ml, status) VALUES
 (1, 7, 1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_ADD(CURDATE(), INTERVAL 22 DAY), 450, 'In Storage'),
 (2, 1, 1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY),  450, 'In Storage'),
 (3, 3, 2, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), 450, 'In Storage'),
 (4, 8, 3, DATE_SUB(CURDATE(), INTERVAL 5 DAY),  DATE_ADD(CURDATE(), INTERVAL 37 DAY), 450, 'In Storage'),
 (5, 7, 3, DATE_SUB(CURDATE(), INTERVAL 28 DAY), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 450, 'Reserved'),
 (6, 7, 1, DATE_SUB(CURDATE(), INTERVAL 33 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY),  450, 'In Storage');

INSERT INTO patient (patient_id, full_name, gender, date_of_birth, blood_type_id, hospital_id, phone) VALUES
 (1, 'Kato Joseph',   'M', '1980-04-12', 7, 1, '0782000001'),
 (2, 'Akello Mercy',  'F', '2001-08-25', 1, 2, '0782000002');

INSERT INTO blood_request (patient_id, hospital_id, blood_type_id, units_needed, urgency, requested_by) VALUES
 (1, 1, 7, 2, 'Emergency', 1),
 (2, 2, 1, 1, 'Routine',   1);
