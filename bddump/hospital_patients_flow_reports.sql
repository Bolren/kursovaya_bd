-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hospital
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `patients_flow_reports`
--

DROP TABLE IF EXISTS `patients_flow_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients_flow_reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `dep_id` int NOT NULL,
  `admitted_sum` int NOT NULL,
  `discharged_sum` int NOT NULL,
  `r_year` int NOT NULL,
  `r_month` int NOT NULL,
  PRIMARY KEY (`report_id`),
  UNIQUE KEY `report_id_UNIQUE` (`report_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients_flow_reports`
--

LOCK TABLES `patients_flow_reports` WRITE;
/*!40000 ALTER TABLE `patients_flow_reports` DISABLE KEYS */;
INSERT INTO `patients_flow_reports` VALUES (43,1,0,0,2024,6),(44,2,0,0,2024,6),(45,3,0,0,2024,6),(46,4,0,0,2024,6),(47,5,0,0,2024,6),(48,6,0,0,2024,6),(49,7,0,0,2024,6),(50,8,0,0,2024,6),(51,9,0,0,2024,6),(52,10,0,0,2024,6),(53,11,0,0,2024,6),(54,12,0,0,2024,6),(55,13,0,0,2024,6),(56,14,0,0,2024,6),(57,1,0,0,2023,5),(58,2,1,1,2023,5),(59,3,0,0,2023,5),(60,4,0,0,2023,5),(61,5,0,0,2023,5),(62,6,0,0,2023,5),(63,7,0,0,2023,5),(64,8,0,0,2023,5),(65,9,0,0,2023,5),(66,10,0,0,2023,5),(67,11,0,0,2023,5),(68,12,0,0,2023,5),(69,13,0,0,2023,5),(70,14,1,1,2023,5);
/*!40000 ALTER TABLE `patients_flow_reports` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 18:14:49
