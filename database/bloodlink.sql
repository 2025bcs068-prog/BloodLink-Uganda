-- MySQL dump 10.13  Distrib 8.4.10, for Linux (x86_64)
--
-- Host: localhost    Database: bloodlink_uganda
-- ------------------------------------------------------
-- Server version	8.4.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `blood_bank`
--

DROP TABLE IF EXISTS `blood_bank`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_bank` (
  `blood_bank_id` int NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `region_id` int NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_national_hub` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`blood_bank_id`),
  KEY `region_id` (`region_id`),
  CONSTRAINT `blood_bank_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_bank`
--

LOCK TABLES `blood_bank` WRITE;
/*!40000 ALTER TABLE `blood_bank` DISABLE KEYS */;
INSERT INTO `blood_bank` VALUES (1,'Kampala National Blood Bank',1,'Nakasero, Kampala','0787004799',1),(2,'Mbarara Regional Blood Bank',3,'Mbarara Referral Hospital','0765490021',1),(3,'Mbale Regional Blood Bank',4,'Mbale Referral Hospital','0700100003',1),(4,'Gulu Regional Blood Bank',6,'Gulu Referral Hospital','0702973488',1),(5,'Jinja Hospital Blood Bank',8,'Jinja Referral Hospital','0701885677',0);
/*!40000 ALTER TABLE `blood_bank` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_request`
--

DROP TABLE IF EXISTS `blood_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_request` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `hospital_id` int NOT NULL,
  `blood_type_id` int NOT NULL,
  `units_needed` int NOT NULL,
  `urgency` enum('Routine','Urgent','Emergency') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Routine',
  `request_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('Pending','Partially Fulfilled','Fulfilled','Cancelled') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `requested_by` int NOT NULL,
  PRIMARY KEY (`request_id`),
  KEY `patient_id` (`patient_id`),
  KEY `hospital_id` (`hospital_id`),
  KEY `blood_type_id` (`blood_type_id`),
  KEY `requested_by` (`requested_by`),
  KEY `idx_request_status` (`status`,`urgency`),
  CONSTRAINT `blood_request_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_request_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_request_ibfk_3` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_type` (`blood_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_request_ibfk_4` FOREIGN KEY (`requested_by`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_request`
--

LOCK TABLES `blood_request` WRITE;
/*!40000 ALTER TABLE `blood_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `blood_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_type`
--

DROP TABLE IF EXISTS `blood_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_type` (
  `blood_type_id` int NOT NULL AUTO_INCREMENT,
  `type_code` varchar(3) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`blood_type_id`),
  UNIQUE KEY `type_code` (`type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_type`
--

LOCK TABLES `blood_type` WRITE;
/*!40000 ALTER TABLE `blood_type` DISABLE KEYS */;
INSERT INTO `blood_type` VALUES (1,'A+'),(2,'A-'),(5,'AB+'),(6,'AB-'),(3,'B+'),(4,'B-'),(7,'O+'),(8,'O-');
/*!40000 ALTER TABLE `blood_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blood_unit`
--

DROP TABLE IF EXISTS `blood_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `blood_unit` (
  `unit_id` int NOT NULL AUTO_INCREMENT,
  `donation_id` int NOT NULL,
  `blood_type_id` int NOT NULL,
  `blood_bank_id` int NOT NULL,
  `collection_date` date NOT NULL,
  `expiry_date` date NOT NULL,
  `volume_ml` int NOT NULL DEFAULT '450',
  `status` enum('In Storage','Reserved','Issued','Expired','Discarded') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'In Storage',
  PRIMARY KEY (`unit_id`),
  UNIQUE KEY `donation_id` (`donation_id`),
  KEY `blood_bank_id` (`blood_bank_id`),
  KEY `idx_unit_type_status` (`blood_type_id`,`status`,`expiry_date`),
  CONSTRAINT `blood_unit_ibfk_1` FOREIGN KEY (`donation_id`) REFERENCES `donation` (`donation_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_unit_ibfk_2` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_type` (`blood_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `blood_unit_ibfk_3` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_bank` (`blood_bank_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blood_unit`
--

LOCK TABLES `blood_unit` WRITE;
/*!40000 ALTER TABLE `blood_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `blood_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation`
--

DROP TABLE IF EXISTS `donation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation` (
  `donation_id` int NOT NULL AUTO_INCREMENT,
  `donor_id` int NOT NULL,
  `drive_id` int DEFAULT NULL,
  `blood_bank_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `donation_date` date NOT NULL,
  `volume_ml` int NOT NULL DEFAULT '450',
  `status` enum('Completed','Rejected') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Completed',
  PRIMARY KEY (`donation_id`),
  KEY `donor_id` (`donor_id`),
  KEY `drive_id` (`drive_id`),
  KEY `blood_bank_id` (`blood_bank_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `donation_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donation_ibfk_2` FOREIGN KEY (`drive_id`) REFERENCES `donation_drive` (`drive_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `donation_ibfk_3` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_bank` (`blood_bank_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donation_ibfk_4` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation`
--

LOCK TABLES `donation` WRITE;
/*!40000 ALTER TABLE `donation` DISABLE KEYS */;
/*!40000 ALTER TABLE `donation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_eligibility_after_donation` AFTER INSERT ON `donation` FOR EACH ROW BEGIN
    IF NEW.status = 'Completed' THEN
        INSERT INTO donor_eligibility (donor_id, last_donation_date, next_eligible_date, status)
        VALUES (NEW.donor_id, NEW.donation_date, DATE_ADD(NEW.donation_date, INTERVAL 90 DAY), 'Deferred')
        ON DUPLICATE KEY UPDATE
            last_donation_date = NEW.donation_date,
            next_eligible_date = DATE_ADD(NEW.donation_date, INTERVAL 90 DAY),
            status = 'Deferred';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `donation_drive`
--

DROP TABLE IF EXISTS `donation_drive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation_drive` (
  `drive_id` int NOT NULL AUTO_INCREMENT,
  `drive_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `blood_bank_id` int NOT NULL,
  `region_id` int NOT NULL,
  `drive_date` date NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `target_units` int DEFAULT NULL,
  PRIMARY KEY (`drive_id`),
  KEY `blood_bank_id` (`blood_bank_id`),
  KEY `region_id` (`region_id`),
  CONSTRAINT `donation_drive_ibfk_1` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_bank` (`blood_bank_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donation_drive_ibfk_2` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation_drive`
--

LOCK TABLES `donation_drive` WRITE;
/*!40000 ALTER TABLE `donation_drive` DISABLE KEYS */;
/*!40000 ALTER TABLE `donation_drive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor`
--

DROP TABLE IF EXISTS `donor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor` (
  `donor_id` int NOT NULL AUTO_INCREMENT,
  `national_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8mb4_general_ci NOT NULL,
  `date_of_birth` date NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `blood_type_id` int NOT NULL,
  `region_id` int NOT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `registered_date` date NOT NULL DEFAULT (curdate()),
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `photo_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`donor_id`),
  UNIQUE KEY `national_id` (`national_id`),
  KEY `region_id` (`region_id`),
  KEY `idx_donor_type_region` (`blood_type_id`,`region_id`),
  CONSTRAINT `donor_ibfk_1` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_type` (`blood_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `donor_ibfk_2` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor`
--

LOCK TABLES `donor` WRITE;
/*!40000 ALTER TABLE `donor` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donor_eligibility`
--

DROP TABLE IF EXISTS `donor_eligibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donor_eligibility` (
  `eligibility_id` int NOT NULL AUTO_INCREMENT,
  `donor_id` int NOT NULL,
  `last_donation_date` date DEFAULT NULL,
  `next_eligible_date` date DEFAULT NULL,
  `status` enum('Eligible','Deferred','Ineligible') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Eligible',
  `deferral_reason` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`eligibility_id`),
  UNIQUE KEY `donor_id` (`donor_id`),
  KEY `idx_eligibility_next` (`next_eligible_date`,`status`),
  CONSTRAINT `donor_eligibility_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donor_eligibility`
--

LOCK TABLES `donor_eligibility` WRITE;
/*!40000 ALTER TABLE `donor_eligibility` DISABLE KEYS */;
/*!40000 ALTER TABLE `donor_eligibility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital`
--

DROP TABLE IF EXISTS `hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `hospital_name` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `region_id` int NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `linked_blood_bank_id` int DEFAULT NULL,
  PRIMARY KEY (`hospital_id`),
  KEY `region_id` (`region_id`),
  KEY `linked_blood_bank_id` (`linked_blood_bank_id`),
  CONSTRAINT `hospital_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `hospital_ibfk_2` FOREIGN KEY (`linked_blood_bank_id`) REFERENCES `blood_bank` (`blood_bank_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital`
--

LOCK TABLES `hospital` WRITE;
/*!40000 ALTER TABLE `hospital` DISABLE KEYS */;
INSERT INTO `hospital` VALUES (1,'Mulago National Referral Hospital',1,'Mulago Hill, Kampala','0700200001',1),(2,'Mbarara Regional Referral Hospital',3,'Mbarara City','0700200002',2),(3,'Mbale Regional Referral Hospital',4,'Mbale City','0700200003',3),(4,'Gulu Regional Referral Hospital',6,'Gulu City','0700200004',4),(5,'Jinja Regional Referral Hospital',8,'Jinja City','0700200005',5);
/*!40000 ALTER TABLE `hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medical_screening`
--

DROP TABLE IF EXISTS `medical_screening`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_screening` (
  `screening_id` int NOT NULL AUTO_INCREMENT,
  `donation_id` int NOT NULL,
  `hemoglobin_level` decimal(4,2) DEFAULT NULL,
  `hiv_test` enum('Negative','Positive','Pending') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `hepatitis_b_test` enum('Negative','Positive','Pending') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `hepatitis_c_test` enum('Negative','Positive','Pending') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `syphilis_test` enum('Negative','Positive','Pending') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `screening_result` enum('Passed','Failed','Pending') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  `screened_by` int NOT NULL,
  PRIMARY KEY (`screening_id`),
  UNIQUE KEY `donation_id` (`donation_id`),
  KEY `screened_by` (`screened_by`),
  CONSTRAINT `medical_screening_ibfk_1` FOREIGN KEY (`donation_id`) REFERENCES `donation` (`donation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `medical_screening_ibfk_2` FOREIGN KEY (`screened_by`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_screening`
--

LOCK TABLES `medical_screening` WRITE;
/*!40000 ALTER TABLE `medical_screening` DISABLE KEYS */;
/*!40000 ALTER TABLE `medical_screening` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_create_unit_after_pass` AFTER UPDATE ON `medical_screening` FOR EACH ROW BEGIN
    IF NEW.screening_result = 'Passed' AND OLD.screening_result <> 'Passed' THEN
        INSERT INTO blood_unit (donation_id, blood_type_id, blood_bank_id,
                                 collection_date, expiry_date, volume_ml, status)
        SELECT d.donation_id, don.blood_type_id, d.blood_bank_id,
               d.donation_date, DATE_ADD(d.donation_date, INTERVAL 35 DAY),
               d.volume_ml, 'In Storage'
        FROM donation d
        JOIN donor don ON don.donor_id = d.donor_id
        WHERE d.donation_id = NEW.donation_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('M','F') COLLATE utf8mb4_general_ci NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `blood_type_id` int NOT NULL,
  `hospital_id` int NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `photo_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  KEY `blood_type_id` (`blood_type_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `patient_ibfk_1` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_type` (`blood_type_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `patient_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `region_id` int NOT NULL AUTO_INCREMENT,
  `region_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `sub_region` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`region_id`),
  UNIQUE KEY `region_name` (`region_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region`
--

LOCK TABLES `region` WRITE;
/*!40000 ALTER TABLE `region` DISABLE KEYS */;
INSERT INTO `region` VALUES (1,'Kampala','Central'),(2,'Wakiso','Central'),(3,'Mbarara','Western'),(4,'Mbale','Eastern'),(5,'Tororo','Eastern'),(6,'Gulu','Northern'),(7,'Arua','West Nile'),(8,'Jinja','Eastern');
/*!40000 ALTER TABLE `region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reminder_notification`
--

DROP TABLE IF EXISTS `reminder_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reminder_notification` (
  `reminder_id` int NOT NULL AUTO_INCREMENT,
  `donor_id` int NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `channel` enum('SMS','Call','Email') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'SMS',
  `scheduled_date` date NOT NULL,
  `sent_status` enum('Pending','Sent','Failed') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`reminder_id`),
  KEY `donor_id` (`donor_id`),
  CONSTRAINT `reminder_notification_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `donor` (`donor_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reminder_notification`
--

LOCK TABLES `reminder_notification` WRITE;
/*!40000 ALTER TABLE `reminder_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `reminder_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `request_fulfillment`
--

DROP TABLE IF EXISTS `request_fulfillment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_fulfillment` (
  `fulfillment_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `unit_id` int NOT NULL,
  `issued_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `issued_by` int NOT NULL,
  PRIMARY KEY (`fulfillment_id`),
  UNIQUE KEY `unit_id` (`unit_id`),
  KEY `request_id` (`request_id`),
  KEY `issued_by` (`issued_by`),
  CONSTRAINT `request_fulfillment_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `blood_request` (`request_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `request_fulfillment_ibfk_2` FOREIGN KEY (`unit_id`) REFERENCES `blood_unit` (`unit_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `request_fulfillment_ibfk_3` FOREIGN KEY (`issued_by`) REFERENCES `staff` (`staff_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `request_fulfillment`
--

LOCK TABLES `request_fulfillment` WRITE;
/*!40000 ALTER TABLE `request_fulfillment` DISABLE KEYS */;
/*!40000 ALTER TABLE `request_fulfillment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_mark_unit_issued` AFTER INSERT ON `request_fulfillment` FOR EACH ROW BEGIN
    UPDATE blood_unit SET status = 'Issued' WHERE unit_id = NEW.unit_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `staff_role` enum('Blood Bank Officer','Lab Technician','Hospital Nurse','Admin') COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `blood_bank_id` int DEFAULT NULL,
  `hospital_id` int DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `photo_path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `blood_bank_id` (`blood_bank_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`blood_bank_id`) REFERENCES `blood_bank` (`blood_bank_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `hospital` (`hospital_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'db_Administrator','Admin','admin','admin123',1,NULL,NULL,NULL,NULL),(2,'Grace Namara','Blood Bank Officer','gnamara','grace123',1,NULL,NULL,NULL,NULL),(3,'Peter Okello','Lab Technician','pokello','peter123',2,NULL,NULL,NULL,NULL),(4,'Sarah Atim','Hospital Nurse','satim','sarah123',NULL,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_donor_eligibility_report`
--

DROP TABLE IF EXISTS `v_donor_eligibility_report`;
/*!50001 DROP VIEW IF EXISTS `v_donor_eligibility_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_donor_eligibility_report` AS SELECT 
 1 AS `donor_id`,
 1 AS `full_name`,
 1 AS `phone`,
 1 AS `blood_type`,
 1 AS `region_name`,
 1 AS `last_donation_date`,
 1 AS `next_eligible_date`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_donors_due_for_reminder`
--

DROP TABLE IF EXISTS `v_donors_due_for_reminder`;
/*!50001 DROP VIEW IF EXISTS `v_donors_due_for_reminder`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_donors_due_for_reminder` AS SELECT 
 1 AS `donor_id`,
 1 AS `full_name`,
 1 AS `phone`,
 1 AS `type_code`,
 1 AS `next_eligible_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_emergency_fulfillment_report`
--

DROP TABLE IF EXISTS `v_emergency_fulfillment_report`;
/*!50001 DROP VIEW IF EXISTS `v_emergency_fulfillment_report`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_emergency_fulfillment_report` AS SELECT 
 1 AS `request_id`,
 1 AS `patient_name`,
 1 AS `blood_type`,
 1 AS `urgency`,
 1 AS `request_date`,
 1 AS `status`,
 1 AS `issued_date`,
 1 AS `minutes_to_fulfill`,
 1 AS `hospital_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_live_inventory`
--

DROP TABLE IF EXISTS `v_live_inventory`;
/*!50001 DROP VIEW IF EXISTS `v_live_inventory`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_live_inventory` AS SELECT 
 1 AS `bank_name`,
 1 AS `region_id`,
 1 AS `type_code`,
 1 AS `units_available`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_donor_eligibility_report`
--

/*!50001 DROP VIEW IF EXISTS `v_donor_eligibility_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_donor_eligibility_report` AS select `d`.`donor_id` AS `donor_id`,`d`.`full_name` AS `full_name`,`d`.`phone` AS `phone`,`bt`.`type_code` AS `blood_type`,`r`.`region_name` AS `region_name`,`de`.`last_donation_date` AS `last_donation_date`,`de`.`next_eligible_date` AS `next_eligible_date`,`de`.`status` AS `status` from (((`donor` `d` join `blood_type` `bt` on((`bt`.`blood_type_id` = `d`.`blood_type_id`))) join `region` `r` on((`r`.`region_id` = `d`.`region_id`))) left join `donor_eligibility` `de` on((`de`.`donor_id` = `d`.`donor_id`))) order by `de`.`next_eligible_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_donors_due_for_reminder`
--

/*!50001 DROP VIEW IF EXISTS `v_donors_due_for_reminder`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_donors_due_for_reminder` AS select `d`.`donor_id` AS `donor_id`,`d`.`full_name` AS `full_name`,`d`.`phone` AS `phone`,`bt`.`type_code` AS `type_code`,`de`.`next_eligible_date` AS `next_eligible_date` from ((`donor` `d` join `donor_eligibility` `de` on((`de`.`donor_id` = `d`.`donor_id`))) join `blood_type` `bt` on((`bt`.`blood_type_id` = `d`.`blood_type_id`))) where ((`d`.`is_active` = true) and (`de`.`next_eligible_date` <= curdate()) and exists(select 1 from `reminder_notification` `rn` where ((`rn`.`donor_id` = `d`.`donor_id`) and (`rn`.`sent_status` = 'Pending'))) is false) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_emergency_fulfillment_report`
--

/*!50001 DROP VIEW IF EXISTS `v_emergency_fulfillment_report`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_emergency_fulfillment_report` AS select `br`.`request_id` AS `request_id`,`p`.`full_name` AS `patient_name`,`bt`.`type_code` AS `blood_type`,`br`.`urgency` AS `urgency`,`br`.`request_date` AS `request_date`,`br`.`status` AS `status`,`rf`.`issued_date` AS `issued_date`,timestampdiff(MINUTE,`br`.`request_date`,`rf`.`issued_date`) AS `minutes_to_fulfill`,`h`.`hospital_name` AS `hospital_name` from ((((`blood_request` `br` join `patient` `p` on((`p`.`patient_id` = `br`.`patient_id`))) join `blood_type` `bt` on((`bt`.`blood_type_id` = `br`.`blood_type_id`))) join `hospital` `h` on((`h`.`hospital_id` = `br`.`hospital_id`))) left join `request_fulfillment` `rf` on((`rf`.`request_id` = `br`.`request_id`))) order by `br`.`urgency`,`br`.`request_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_live_inventory`
--

/*!50001 DROP VIEW IF EXISTS `v_live_inventory`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_live_inventory` AS select `bb`.`bank_name` AS `bank_name`,`bb`.`region_id` AS `region_id`,`bt`.`type_code` AS `type_code`,count(0) AS `units_available` from ((`blood_unit` `bu` join `blood_bank` `bb` on((`bb`.`blood_bank_id` = `bu`.`blood_bank_id`))) join `blood_type` `bt` on((`bt`.`blood_type_id` = `bu`.`blood_type_id`))) where ((`bu`.`status` = 'In Storage') and (`bu`.`expiry_date` >= curdate())) group by `bb`.`bank_name`,`bb`.`region_id`,`bt`.`type_code` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-13 17:04:23
