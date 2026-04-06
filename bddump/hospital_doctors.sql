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
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctors` (
  `doc_id` int NOT NULL AUTO_INCREMENT,
  `surname` varchar(45) NOT NULL,
  `passport` varchar(45) NOT NULL,
  `address` varchar(45) NOT NULL,
  `birthday` date NOT NULL,
  `speciality` varchar(45) NOT NULL,
  `hiring_date` date NOT NULL,
  `dismiss_date` date DEFAULT NULL,
  `dep_id` int NOT NULL,
  PRIMARY KEY (`doc_id`),
  UNIQUE KEY `doc_id_UNIQUE` (`doc_id`),
  KEY `dep_id_idx` (`dep_id`),
  CONSTRAINT `dep_id` FOREIGN KEY (`dep_id`) REFERENCES `department` (`dep_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctors`
--

LOCK TABLES `doctors` WRITE;
/*!40000 ALTER TABLE `doctors` DISABLE KEYS */;
INSERT INTO `doctors` VALUES (1,'Иванов','4501 123456','Москва','1980-05-15','Хирургия','2010-03-01',NULL,1),(2,'Петрова','4502 234567','Москва','1975-12-20','Терапия','2008-07-15',NULL,2),(3,'Сидоров','4503 345678','Санкт-Петербург','1982-08-10','Кардиология','2015-11-20',NULL,3),(4,'Козлова','4504 456789','Москва','1978-03-25','Неврология','2012-09-10','2023-01-15',4),(5,'Васильев','4505 567890','Казань','1985-11-30','Офтальмология','2018-04-05',NULL,5),(6,'Николаева','4506 678901','Москва','1970-07-12','Педиатрия','2005-01-20',NULL,6),(7,'Фёдоров','4507 789012','Новосибирск','1983-09-18','Хирургия','2016-08-12',NULL,1),(8,'Алексеева','4508 890123','Москва','1976-04-08','Гинекология','2011-06-30',NULL,7),(9,'Дмитриев','4509 901234','Екатеринбург','1981-01-22','Урология','2014-03-15','2022-12-10',8),(10,'Семёнова','4510 012345','Москва','1979-06-05','Эндокринология','2013-10-25',NULL,9),(11,'Павлов','4511 123456','Краснодар','1984-12-14','Травматология','2019-02-18',NULL,10),(12,'Макарова','4512 234567','Москва','1977-08-28','Психиатрия','2009-05-22',NULL,11),(13,'Орлов','4513 345678','Ростов-на-Дону','1986-03-17','Инфектология','2020-07-08',NULL,12),(14,'Волкова','4514 456789','Москва','1974-10-03','Онкология','2007-12-01',NULL,13),(15,'Лебедев','4515 567890','Воронеж','1980-02-19','Ревматология','2017-09-14',NULL,14),(16,'Новиков','4516 678901','Москва','1990-09-10','Педиатрия','2021-06-01',NULL,6),(17,'Соколов','4517 789012','Москва','1965-03-08','Хирургия','1995-01-15',NULL,1),(18,'Морозова','4518 890123','Санкт-Петербург','1982-11-12','Неврология','2015-04-20','2023-10-30',4),(19,'Егоров','4519 901234','Хабаровск','1978-07-25','Терапия','2016-11-05',NULL,2);
/*!40000 ALTER TABLE `doctors` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 18:14:50
