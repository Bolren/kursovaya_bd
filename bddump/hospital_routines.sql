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
-- Dumping routines for database 'hospital'
--
/*!50003 DROP PROCEDURE IF EXISTS `department_workload_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `department_workload_report`(report_year int, report_month int)
BEGIN
	declare department_id integer;
    declare reserved_wards integer;
    declare seats_occupied integer;
    declare done integer default 0;
    declare record_exists integer default 0;
    
    declare occupation cursor for
        SELECT 
			d.dep_id,
			MAX(daily_patients.occupied_wards) AS occupied_wards_at_peak,
			MAX(daily_patients.patient_count) AS peak_load
		FROM department d
		JOIN wards w ON d.dep_id = w.dep_id
		JOIN (
			SELECT 
				w.dep_id,
				COUNT(DISTINCT h.patient_id) AS patient_count,
                COUNT(DISTINCT w.ward_id) AS occupied_wards
			FROM wards w
				JOIN patients p ON w.ward_id = p.ward_id
				JOIN medical_history h ON p.patient_id = h.patient_id
			WHERE YEAR(h.receipt_date) = report_year
				AND MONTH(h.receipt_date) = report_month
				AND h.receipt_date <= h.discharge_date 
				OR h.discharge_date IS NULL
			GROUP BY w.dep_id
		) daily_patients ON d.dep_id = daily_patients.dep_id
		GROUP BY d.dep_id;
        
    declare continue handler for NOT FOUND set done = 1;
    
    open occupation;
    fetch occupation into department_id, reserved_wards, seats_occupied;
    
    while done = 0 do
        select count(*) into record_exists 
        from department_workload_reports 
        where dep_id = department_id
		  and r_year = report_year 
          and r_month = report_month;
        
        if record_exists = 0 then
            insert into department_workload_reports (dep_id, reserved_wards, seats_taken, r_month, r_year)
            values (department_id, reserved_wards, seats_occupied, report_month, report_year);
            select "Отчёт успешно создан";
        else
            select "ERROR. Отчёт за данный период уже существует";
        end if;
        
        set record_exists = 0;
        fetch occupation into department_id, reserved_wards, seats_occupied;
    end while;
    
    close occupation;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `entry_statistics_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `entry_statistics_report`(report_year int, report_month int)
BEGIN
	declare doctor_id integer;
    declare entries_summa integer;
    declare done integer default 0;
    declare record_exists integer default 0;
    
    declare entries cursor for
		SELECT
		d.doc_id,
		COUNT(e.entry_id) AS total_notes
		FROM doctors d
			LEFT JOIN history_entries e ON d.doc_id = e.doc_id
            WHERE d.dismiss_date IS NULL
		GROUP BY d.doc_id
		ORDER BY total_notes DESC;
        
    declare continue handler for NOT FOUND set done = 1;
    
    open entries;
    fetch entries into doctor_id, entries_summa;
    
    while done = 0 do
        select count(*) into record_exists 
        from entry_statistics_reports 
        where doc_id = doctor_id
		  and r_year = report_year 
          and r_month = report_month;
        
        if record_exists = 0 then
            insert into entry_statistics_reports (doc_id, entry_amount, r_month, r_year)
            values (doctor_id, entries_summa, report_month, report_year);
            select "Отчёт успешно создан";
        else
            select "ERROR. Отчёт за данный период уже существует";
        end if;
        
        set record_exists = 0;
        fetch entries into doctor_id, entries_summa;
    end while;
    
    close entries;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `patients_flow_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `patients_flow_report`(report_year int, report_month int)
BEGIN
	declare department_id integer;
    declare admitted_summa integer;
    declare discharged_summa integer;
    declare done integer default 0;
    declare record_exists integer default 0;
    
    declare flow cursor for
		SELECT 
		d.dep_id,
		COUNT(DISTINCT admitted.patient_id) AS admitted_cnt,
		COUNT(DISTINCT discharged.patient_id) AS discharged_cnt
		FROM department d
		LEFT JOIN (
			-- Поступившие пациенты
			SELECT DISTINCT
				p.patient_id,
				w.dep_id
			FROM patients p
			JOIN medical_history mh ON p.patient_id = mh.patient_id
			JOIN wards w ON p.ward_id = w.ward_id
			WHERE YEAR(mh.receipt_date) = report_year
				AND MONTH(mh.receipt_date) = report_month
		) admitted ON d.dep_id = admitted.dep_id
		LEFT JOIN (
			-- Выписанные пациенты
			SELECT DISTINCT
				p.patient_id,
				w.dep_id
			FROM patients p
			JOIN medical_history mh ON p.patient_id = mh.patient_id
			JOIN wards w ON p.ward_id = w.ward_id
			WHERE YEAR(mh.discharge_date) = report_year
				AND MONTH(mh.discharge_date) = report_month
				AND mh.discharge_date IS NOT NULL
		) discharged ON d.dep_id = discharged.dep_id
		GROUP BY d.dep_id;
        
    declare continue handler for NOT FOUND set done = 1;
    
    open flow;
    fetch flow into department_id, admitted_summa, discharged_summa;
    
    while done = 0 do
        select count(*) into record_exists 
        from patients_flow_reports 
        where dep_id = department_id
		  and r_year = report_year 
          and r_month = report_month;
        
        if record_exists = 0 then
            insert into patients_flow_reports (dep_id, admitted_sum, discharged_sum, r_month, r_year)
            values (department_id, admitted_summa, discharged_summa, report_month, report_year);
            select "Отчёт успешно создан";
        else
            select "ERROR. Отчёт за данный период уже существует";
        end if;
        
        set record_exists = 0;
        fetch flow into department_id, admitted_summa, discharged_summa;
    end while;
    
    close flow;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 18:14:50
