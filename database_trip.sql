-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: Academic_Trip_Database
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `Course`
--

DROP TABLE IF EXISTS `Course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Course` (
  `course_id` varchar(10) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `faculty_id` varchar(10) NOT NULL,
  PRIMARY KEY (`course_id`),
  KEY `fy_pk` (`faculty_id`),
  CONSTRAINT `fy_pk` FOREIGN KEY (`faculty_id`) REFERENCES `Faculty` (`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Course`
--

LOCK TABLES `Course` WRITE;
/*!40000 ALTER TABLE `Course` DISABLE KEYS */;
INSERT INTO `Course` VALUES ('COU001','Computer Science','FAC001');
/*!40000 ALTER TABLE `Course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Destination`
--

DROP TABLE IF EXISTS `Destination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Destination` (
  `destination_id` varchar(10) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Destination`
--

LOCK TABLES `Destination` WRITE;
/*!40000 ALTER TABLE `Destination` DISABLE KEYS */;
INSERT INTO `Destination` VALUES ('DES001','Nairobi'),('DES002','Narobi');
/*!40000 ALTER TABLE `Destination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Driver`
--

DROP TABLE IF EXISTS `Driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Driver` (
  `driver_id` varchar(10) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `phone_number` int NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`driver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Driver`
--

LOCK TABLES `Driver` WRITE;
/*!40000 ALTER TABLE `Driver` DISABLE KEYS */;
INSERT INTO `Driver` VALUES ('DEFAULT','Default','Driver',0,'default@transport.com');
/*!40000 ALTER TABLE `Driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Driver_Vehicle`
--

DROP TABLE IF EXISTS `Driver_Vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Driver_Vehicle` (
  `driver_vehicle_id` varchar(10) NOT NULL,
  `driver_id` varchar(10) NOT NULL,
  `vehicle_id` varchar(10) NOT NULL,
  `assignment_start` date NOT NULL,
  `assigment_end` date NOT NULL,
  PRIMARY KEY (`driver_vehicle_id`),
  KEY `d_pk` (`driver_id`),
  KEY `v_pk` (`vehicle_id`),
  CONSTRAINT `d_pk` FOREIGN KEY (`driver_id`) REFERENCES `Driver` (`driver_id`),
  CONSTRAINT `v_pk` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicle` (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Driver_Vehicle`
--

LOCK TABLES `Driver_Vehicle` WRITE;
/*!40000 ALTER TABLE `Driver_Vehicle` DISABLE KEYS */;
INSERT INTO `Driver_Vehicle` VALUES ('DV001','DEFAULT','DEFAULT','2025-02-25','2025-02-26'),('DV002','DEFAULT','DEFAULT','2025-02-26','2025-02-27'),('DV003','DEFAULT','DEFAULT','2025-02-26','2025-02-27'),('DV004','DEFAULT','DEFAULT','2025-02-26','2025-02-27'),('DV005','DEFAULT','DEFAULT','2025-02-26','2025-02-27');
/*!40000 ALTER TABLE `Driver_Vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Faculty`
--

DROP TABLE IF EXISTS `Faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Faculty` (
  `faculty_id` varchar(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Faculty`
--

LOCK TABLES `Faculty` WRITE;
/*!40000 ALTER TABLE `Faculty` DISABLE KEYS */;
INSERT INTO `Faculty` VALUES ('FAC001','Science');
/*!40000 ALTER TABLE `Faculty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Incharge`
--

DROP TABLE IF EXISTS `Incharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Incharge` (
  `incharge_id` varchar(10) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone_number` int NOT NULL,
  `email` varchar(100) NOT NULL,
  `faculty_id` varchar(10) NOT NULL,
  PRIMARY KEY (`incharge_id`),
  KEY `fi_pk` (`faculty_id`),
  CONSTRAINT `fi_pk` FOREIGN KEY (`faculty_id`) REFERENCES `Faculty` (`faculty_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Incharge`
--

LOCK TABLES `Incharge` WRITE;
/*!40000 ALTER TABLE `Incharge` DISABLE KEYS */;
INSERT INTO `Incharge` VALUES ('INC001','Bosire','Omwoyo',726072711,'austin@gmail.com','FAC001');
/*!40000 ALTER TABLE `Incharge` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Incharge_Group`
--

DROP TABLE IF EXISTS `Incharge_Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Incharge_Group` (
  `incharge_group_id` varchar(10) NOT NULL,
  `incharge_id` varchar(10) NOT NULL,
  `group_id` varchar(10) NOT NULL,
  PRIMARY KEY (`incharge_group_id`),
  KEY `i_pk` (`incharge_id`),
  KEY `c_pk` (`group_id`),
  CONSTRAINT `c_pk` FOREIGN KEY (`group_id`) REFERENCES `Trip_Group` (`group_id`),
  CONSTRAINT `g_pk` FOREIGN KEY (`group_id`) REFERENCES `Trip_Group` (`group_id`),
  CONSTRAINT `i_pk` FOREIGN KEY (`incharge_id`) REFERENCES `Incharge` (`incharge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Incharge_Group`
--

LOCK TABLES `Incharge_Group` WRITE;
/*!40000 ALTER TABLE `Incharge_Group` DISABLE KEYS */;
INSERT INTO `Incharge_Group` VALUES ('ING001','INC001','GRP001'),('ING002','INC001','GRP002'),('ING003','INC001','GRP003'),('ING004','INC001','GRP004'),('ING005','INC001','GRP005'),('ING006','INC001','GRP006'),('ING007','INC001','GRP007'),('ING008','INC001','GRP008'),('ING009','INC001','GRP009'),('ING010','INC001','GRP010'),('ING011','INC001','GRP011'),('ING012','INC001','GRP012');
/*!40000 ALTER TABLE `Incharge_Group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Trip`
--

DROP TABLE IF EXISTS `Trip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Trip` (
  `trip_id` varchar(10) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `incharge_group_id` varchar(10) NOT NULL,
  `driver_vehicle_id` varchar(10) DEFAULT NULL,
  `destination_id` varchar(10) NOT NULL,
  PRIMARY KEY (`trip_id`),
  KEY `dv_pk` (`driver_vehicle_id`),
  KEY `ig_pk` (`incharge_group_id`),
  KEY `destination_id` (`destination_id`),
  CONSTRAINT `dv_pk` FOREIGN KEY (`driver_vehicle_id`) REFERENCES `Driver_Vehicle` (`driver_vehicle_id`),
  CONSTRAINT `ig_pk` FOREIGN KEY (`incharge_group_id`) REFERENCES `Incharge_Group` (`incharge_group_id`),
  CONSTRAINT `Trip_ibfk_1` FOREIGN KEY (`destination_id`) REFERENCES `Destination` (`destination_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Trip`
--

LOCK TABLES `Trip` WRITE;
/*!40000 ALTER TABLE `Trip` DISABLE KEYS */;
INSERT INTO `Trip` VALUES ('TRP001','2025-02-28','2025-02-28','ING008',NULL,'DES001'),('TRP002','2025-03-08','2025-03-06','ING009',NULL,'DES002'),('TRP003','2025-02-28','2025-03-02','ING010',NULL,'DES001'),('TRP004','2027-02-10','2027-02-11','ING011',NULL,'DES001'),('TRP005','2026-03-26','2026-03-27','ING012',NULL,'DES001');
/*!40000 ALTER TABLE `Trip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Trip_Group`
--

DROP TABLE IF EXISTS `Trip_Group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Trip_Group` (
  `group_id` varchar(10) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `student_number` int NOT NULL,
  `course_id` varchar(10) NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Trip_Group`
--

LOCK TABLES `Trip_Group` WRITE;
/*!40000 ALTER TABLE `Trip_Group` DISABLE KEYS */;
INSERT INTO `Trip_Group` VALUES ('GRP001','Computer Science',110,'COU001'),('GRP002','Computer Science',110,'COU001'),('GRP003','Computer Science',110,'COU001'),('GRP004','Computer Science',110,'COU001'),('GRP005','Computer Science',110,'COU001'),('GRP006','Computer Science',110,'COU001'),('GRP007','Computer Science',110,'COU001'),('GRP008','Computer Science',111,'COU001'),('GRP009','Computer Science',240,'COU001'),('GRP010','Computer Science',200,'COU001'),('GRP011','Computer Science',200,'COU001'),('GRP012','Computer Science',140,'COU001');
/*!40000 ALTER TABLE `Trip_Group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vehicle`
--

DROP TABLE IF EXISTS `Vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Vehicle` (
  `vehicle_id` varchar(10) NOT NULL,
  `make` varchar(10) NOT NULL,
  `model` varchar(20) NOT NULL,
  `year` date NOT NULL,
  `capacity` int NOT NULL,
  `plate_number` varchar(8) NOT NULL,
  PRIMARY KEY (`vehicle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vehicle`
--

LOCK TABLES `Vehicle` WRITE;
/*!40000 ALTER TABLE `Vehicle` DISABLE KEYS */;
INSERT INTO `Vehicle` VALUES ('DEFAULT','Default','Vehicle','2025-02-25',0,'DEFAULT');
/*!40000 ALTER TABLE `Vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('lecturer','transport') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'lecturer1','lecpass','lecturer'),(2,'transport1','tranpass','transport');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-26 11:59:56
