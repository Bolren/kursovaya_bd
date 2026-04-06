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
-- Table structure for table `medical_history`
--

DROP TABLE IF EXISTS `medical_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medical_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `diagnosis` varchar(45) NOT NULL,
  `receipt_date` date NOT NULL,
  `discharge_date` date DEFAULT NULL,
  `patient_id` int NOT NULL,
  PRIMARY KEY (`history_id`),
  UNIQUE KEY `hist_id_UNIQUE` (`history_id`),
  KEY `pat_id_idx` (`patient_id`),
  CONSTRAINT `pat_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medical_history`
--

LOCK TABLES `medical_history` WRITE;
/*!40000 ALTER TABLE `medical_history` DISABLE KEYS */;
INSERT INTO `medical_history` VALUES (1,'Аппендицит','2023-03-15','2023-03-25',1),(2,'Грипп','2023-05-10','2023-05-20',6),(3,'Аритмия','2023-07-06','2023-07-20',11),(4,'Мигрень','2023-09-07','2023-09-20',15),(5,'Катаракта','2023-11-04','2023-11-18',19),(6,'Ангина','2023-02-02','2023-02-12',23),(7,'Миома','2023-04-06','2023-04-20',28),(8,'Простатит','2023-06-03','2023-06-17',32),(9,'Сахарный диабет','2023-08-05','2023-08-19',36),(10,'Перелом ноги','2023-10-04','2023-11-04',40),(11,'Депрессия','2023-12-06','2024-01-06',44),(12,'Кишечная инфекция','2024-01-02','2024-01-12',48),(13,'Рак желудка','2023-03-01','2023-06-01',52),(14,'Артрит','2023-05-08','2023-05-22',56),(16,'Холецистит','2024-01-10',NULL,2),(17,'Грыжа','2024-01-15',NULL,3),(18,'Панкреатит','2024-02-12',NULL,4),(19,'Язва желудка','2024-02-20',NULL,5),(20,'Бронхит','2024-01-08',NULL,7),(21,'Пневмония','2024-01-12',NULL,8),(22,'ОРВИ','2024-01-18',NULL,9),(23,'Гипертония','2024-01-22',NULL,10),(24,'Стенокардия','2024-02-11',NULL,12),(25,'Инфаркт','2024-01-16',NULL,13),(26,'Гипертонический криз','2024-02-14',NULL,14),(27,'Остеохондроз','2024-01-09',NULL,16),(28,'Инсульт','2024-01-13',NULL,17),(29,'Невралгия','2024-01-19',NULL,18),(30,'Глаукома','2024-01-08',NULL,20),(31,'Конъюнктивит','2024-01-13',NULL,21),(32,'Блефарит','2024-01-17',NULL,22),(33,'Бронхит','2024-01-05',NULL,24),(34,'Ветрянка','2024-01-10',NULL,25),(35,'Краснуха','2024-01-15',NULL,26),(36,'Скарлатина','2024-01-20',NULL,27),(37,'Эндометриоз','2024-01-11',NULL,29),(38,'Киста яичника','2024-01-16',NULL,30),(39,'Воспаление придатков','2024-01-21',NULL,31),(40,'Цистит','2024-01-07',NULL,33),(41,'Пиелонефрит','2024-01-12',NULL,34),(42,'Мочекаменная болезнь','2024-01-18',NULL,35),(43,'Гипотиреоз','2024-01-10',NULL,37),(44,'Ожирение','2024-01-15',NULL,38),(45,'Тиреотоксикоз','2024-01-20',NULL,39),(46,'Вывих плеча','2024-01-09',NULL,41),(47,'Ушиб позвоночника','2024-01-14',NULL,42),(48,'Сотрясение мозга','2024-01-24',NULL,43),(49,'Тревожное расстройство','2024-01-11',NULL,45),(50,'Шизофрения','2024-01-16',NULL,46),(51,'Биполярное расстройство','2024-01-21',NULL,47),(52,'Гепатит А','2024-01-07',NULL,49),(53,'Сальмонеллез','2024-01-12',NULL,50),(54,'Дизентерия','2024-01-17',NULL,51),(55,'Рак легких','2024-01-10',NULL,53),(56,'Рак кожи','2024-01-15',NULL,54),(57,'Лейкемия','2024-01-20',NULL,55),(58,'Артроз','2024-01-13',NULL,57),(59,'Подагра','2024-01-18',NULL,58),(60,'Ревматизм','2024-01-23',NULL,59),(63,'Перелом','2025-12-15',NULL,82),(64,'Головная боль','2025-12-16',NULL,66);
/*!40000 ALTER TABLE `medical_history` ENABLE KEYS */;
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
