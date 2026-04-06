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
-- Table structure for table `wards`
--

DROP TABLE IF EXISTS `wards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wards` (
  `ward_id` int NOT NULL AUTO_INCREMENT,
  `index_number` int NOT NULL,
  `ward_type` varchar(45) NOT NULL,
  `seats_num` int NOT NULL,
  `dep_id` int NOT NULL,
  PRIMARY KEY (`ward_id`),
  UNIQUE KEY `ward_id_UNIQUE` (`ward_id`),
  KEY `dep_id_idx` (`dep_id`),
  KEY `dep_id1_idx` (`dep_id`),
  CONSTRAINT `dep_id1` FOREIGN KEY (`dep_id`) REFERENCES `department` (`dep_id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wards`
--

LOCK TABLES `wards` WRITE;
/*!40000 ALTER TABLE `wards` DISABLE KEYS */;
INSERT INTO `wards` VALUES (1,101,'обычная',6,1),(2,102,'реанимационная',2,1),(3,103,'VIP',2,1),(4,201,'обычная',8,2),(5,202,'реанимационная',3,2),(6,203,'VIP',1,2),(7,301,'обычная',5,3),(8,302,'реанимационная',2,3),(9,303,'VIP',2,3),(10,401,'обычная',6,4),(11,402,'реанимационная',3,4),(12,403,'VIP',2,4),(13,501,'обычная',7,5),(14,502,'реанимационная',2,5),(15,503,'VIP',1,5),(16,601,'обычная',8,6),(17,602,'реанимационная',3,6),(18,603,'VIP',2,6),(19,701,'обычная',6,7),(20,702,'реанимационная',2,7),(21,703,'VIP',2,7),(22,801,'обычная',5,8),(23,802,'реанимационная',2,8),(24,803,'VIP',1,8),(25,901,'обычная',6,9),(26,902,'реанимационная',2,9),(27,903,'VIP',2,9),(28,1001,'обычная',7,10),(29,1002,'реанимационная',4,10),(30,1003,'VIP',2,10),(31,1101,'обычная',4,11),(32,1102,'реанимационная',2,11),(33,1103,'VIP',1,11),(34,1201,'обычная',6,12),(35,1202,'реанимационная',2,12),(36,1203,'VIP',2,12),(37,1301,'обычная',5,13),(38,1302,'реанимационная',2,13),(39,1303,'VIP',1,13),(40,1401,'обычная',6,14),(41,1402,'реанимационная',2,14),(42,1403,'VIP',2,14);
/*!40000 ALTER TABLE `wards` ENABLE KEYS */;
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
