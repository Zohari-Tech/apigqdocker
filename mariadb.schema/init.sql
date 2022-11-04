-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: coredb:3306
-- Generation Time: Aug 29, 2022 at 12:17 PM
-- Server version: 10.4.25-MariaDB-1:10.4.25+maria~focal
-- PHP Version: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Payments`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `GetAppServiceInfo`$$
CREATE DEFINER=`payuser`@`%` PROCEDURE `GetAppServiceInfo` (IN `APPKEY` VARCHAR(64), IN `SERVICE_CODE` VARCHAR(64))   BEGIN
   SELECT
    AppServices.ServiceCode,
    AppServices.AppCode,
    AppServices.Settings,
    Apps.Secret,
    Apps.Multinational,
    Apps.CountryID AS AppCountry,
    AppServiceStatus.Description AS StatusDesciption,
    AppServiceStatus.Code AS StatusCode,
    AppStatus.Code AS AppStatusCode,
    AppStatus.Description AS AppStatusCodeDesc,
    ServiceStatus.Description AS ServiceStatusCodeDesc,
    ServiceStatus.Code AS ServiceStatusCode,
    Countries.ISOCurrencyCode AS CurrencyCode,
    ServiceSpecs.ServiceURL,
    ServiceSpecs.Statics,
    ServiceSpecs.HttpMethod,
    ServiceSpecs.CountryID AS ServiceCountry,
    ServiceSpecs.Headers,
    ServiceSpecs.`format`,
    ServiceSpecs.`type`
FROM
    AppServices
LEFT JOIN Apps ON AppServices.AppCode = Apps.Code
LEFT JOIN Services ON AppServices.ServiceCode = Services.Code
LEFT JOIN Countries ON Apps.CountryID = Countries.ID
LEFT JOIN `Status` AS AppServiceStatus
ON
    AppServices.StatusID = AppServiceStatus.ID
LEFT JOIN `Status` AS AppStatus
ON
    Apps.StatusID = AppStatus.ID
LEFT JOIN `Status` AS ServiceStatus
ON
    Services.StatusID = ServiceStatus.ID
LEFT JOIN `Services` AS ServiceSpecs ON AppServices.ServiceCode = ServiceSpecs.Code
WHERE
    AppServices.AppCode = APPKEY AND AppServices.ServiceCode = SERVICE_CODE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `AppAccounts`
--
-- Creation: Aug 02, 2022 at 10:58 AM
--

DROP TABLE IF EXISTS `AppAccounts`;
CREATE TABLE IF NOT EXISTS `AppAccounts` (
  `AppID` int(11) NOT NULL,
  `CountryID` int(11) NOT NULL,
  `Float` decimal(19,4) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  KEY `CountryID` (`CountryID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `AppAccounts`
--

-- --------------------------------------------------------

--
-- Table structure for table `Apps`
--
-- Creation: Aug 03, 2022 at 08:33 AM
--

DROP TABLE IF EXISTS `Apps`;
CREATE TABLE IF NOT EXISTS `Apps` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(16) NOT NULL,
  `Code` varchar(64) NOT NULL,
  `StatusID` int(11) NOT NULL,
  `CountryID` int(11) NOT NULL,
  `Multinational` tinyint(1) NOT NULL,
  `Secret` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code` (`Code`),
  KEY `CountryID` (`CountryID`),
  KEY `StatusID` (`StatusID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Apps`
--

INSERT INTO `Apps` (`ID`, `Name`, `Code`, `StatusID`, `CountryID`, `Multinational`, `Secret`) VALUES
(1, 'TestApp', '62ea315fb47687d9cbbf6827', 2, 1, 0, '7kTpE!RVy4q4ni0OuITyjz7VpZq!&DhSw');

-- --------------------------------------------------------

--
-- Table structure for table `AppServices`
--
-- Creation: Aug 03, 2022 at 08:39 AM
--

DROP TABLE IF EXISTS `AppServices`;
CREATE TABLE IF NOT EXISTS `AppServices` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `AppCode` varchar(64) NOT NULL,
  `ServiceCode` varchar(64) NOT NULL,
  `StatusID` int(11) NOT NULL,
  `Settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`Settings`)),
  PRIMARY KEY (`ID`),
  KEY `AppCode` (`AppCode`),
  KEY `ServiceCode` (`ServiceCode`),
  KEY `StatusID` (`StatusID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `AppServices`
--

INSERT INTO `AppServices` (`ID`, `AppCode`, `ServiceCode`, `StatusID`, `Settings`) VALUES
(1, '62ea315fb47687d9cbbf6827', '62dfa03aeabc77e249463105', 3, '{}'),
(2,	'62ea315fb47687d9cbbf6827',	'634bb3da9c0b0d8dc9de1cf9',	3,	'{}'),
(3,	'62ea315fb47687d9cbbf6827',	'634bad70be9431c13b9f0b59',	3,	'{}'),
(4,	'62ea315fb47687d9cbbf6827',	'634ba5c563db4ac99cf44fbc',	3,	'{}');
-- --------------------------------------------------------

--
-- Stand-in structure for view `AppServicesInfo`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `AppServicesInfo`;
CREATE TABLE IF NOT EXISTS `AppServicesInfo` (
`ServiceCode` varchar(64)
,`AppCode` varchar(64)
,`Settings` longtext
,`Secret` varchar(64)
,`Multinational` tinyint(1)
,`AppCountry` int(11)
,`StatusDesciption` text
,`StatusCode` varchar(8)
,`AppStatusCode` varchar(8)
,`AppStatusCodeDesc` text
,`ServiceStatusCodeDesc` text
,`ServiceStatusCode` varchar(8)
,`CurrencyCode` varchar(3)
,`ServiceURL` varchar(64)
,`Statics` longtext
,`HttpMethod` varchar(6)
,`ServiceCountry` int(11)
,`Headers` longtext
);

-- --------------------------------------------------------

--
-- Table structure for table `Continents`
--
-- Creation: Aug 02, 2022 at 11:06 AM
--

DROP TABLE IF EXISTS `Continents`;
CREATE TABLE IF NOT EXISTS `Continents` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `Code` varchar(2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Continents`
--

INSERT INTO `Continents` (`ID`, `Name`, `Code`) VALUES
(1, 'Asia', 'AS'),
(2, 'Africa', 'AF'),
(3, 'Europe', 'EU'),
(4, 'North America', 'NA'),
(5, 'South America', 'SA'),
(6, 'Oceania', 'OC'),
(8, 'Antarctica', 'AN');

-- --------------------------------------------------------

--
-- Table structure for table `Countries`
--
-- Creation: Aug 02, 2022 at 09:46 AM
--

DROP TABLE IF EXISTS `Countries`;
CREATE TABLE IF NOT EXISTS `Countries` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `CurrencyName` varchar(32) NOT NULL,
  `ContinentID` int(11) NOT NULL,
  `ISOCountryCode` varchar(3) NOT NULL,
  `ISOCurrencyCode` varchar(3) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISOCurrencyCode` (`ISOCurrencyCode`),
  KEY `ContinentID` (`ContinentID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Countries`
--

INSERT INTO `Countries` (`ID`, `Name`, `CurrencyName`, `ContinentID`, `ISOCountryCode`, `ISOCurrencyCode`) VALUES
(1, 'Kenya', 'Ksh.', 2, 'KEN', 'KES');

-- --------------------------------------------------------

--
-- Table structure for table `Services`
--
-- Creation: Aug 11, 2022 at 07:23 AM
--

DROP TABLE IF EXISTS `Services`;
CREATE TABLE IF NOT EXISTS `Services` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(12) NOT NULL,
  `Description` text NOT NULL,
  `ServiceURL` varchar(64) NOT NULL,
  `CountryID` int(11) NOT NULL,
  `StatusID` int(11) NOT NULL,
  `Statics` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `HttpMethod` varchar(6) NOT NULL,
  `Code` varchar(64) NOT NULL,
  `format` enum('JSON','XML') NOT NULL,
  `type` enum('SYNC','ASYNC') NOT NULL,
  `Environment` enum('PRODUCTION','TESTBED') NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code` (`Code`),
  KEY `StatusID` (`StatusID`),
  KEY `CountryID` (`CountryID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Services`
--

INSERT INTO `Services` (`ID`, `Name`, `Description`, `ServiceURL`, `CountryID`, `StatusID`, `Statics`, `Headers`, `HttpMethod`, `Code`, `format`, `type`, `Environment`) VALUES
(1, 'Mpesa-STK', 'Mpesa STK Online Payment', 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest', 1, 1, '{\"BusinessShortCode\":\"174379\",\"CONSUMER_SECRET\":\"psa3rMtGLbMPI9Jc\",\"CONSUMER_KEY\":\"Jj8TrQstN3kxRrQx06Etge3UUK73bAmh\",\"InitiatorName\":\"testapi\",\"InitiatorPassword\":\"Safaricom999!*!\",\"PartyA\":\"600990\",\"PartyB\":\"600000\",\"PassKey\":\"bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919\",\"PhoneNumber\":\"254702079491\",\"TOKEN_URL\":\"https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials\",\"Callback\":\"https://9627-197-248-20-39.in.ngrok.io/public/callback/62dfa03aeabc77e249463105\"}', '{\"Content-Type\":[\"application/json\"]}', 'POST', '62dfa03aeabc77e249463105', 'JSON', 'ASYNC', 'PRODUCTION'),
(2,	'SAF_AIRT_PAY',	'Safaricom Airtime charging',	'https://dtsvc.safaricom.com:8480/api/public/SDP/paymentRequest',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634bad70be9431c13b9f0b59',	'JSON',	'ASYNC',	'TESTBED'),
(3,	'SAF_SDP_SUB',	'Safaricom sub to airtime payment',	'https://dtsvc.safaricom.com:8480/api/public/SDP/activate',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\",\"MAIN_URL\":\"https://dtsvc.safaricom.com:8480/api/public/SDP/activate\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634ba5c563db4ac99cf44fbc',	'JSON',	'ASYNC',	'TESTBED'),
(4,	'SAFSDP_UNSUB',	'Safaricom unsub to airtime payment',	'https://dtsvc.safaricom.com:8480/api/public/SDP/deactivate',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\",\"MAIN_URL\":\"https://dtsvc.safaricom.com:8480/api/public/SDP/deactivate\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634bb3da9c0b0d8dc9de1cf9',	'JSON',	'ASYNC',	'TESTBED');
-- --------------------------------------------------------

--
-- Table structure for table `Status`
--
-- Creation: Aug 03, 2022 at 08:40 AM
--

DROP TABLE IF EXISTS `Status`;
CREATE TABLE IF NOT EXISTS `Status` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `Code` varchar(8) NOT NULL,
  `Description` text NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Status`
--

INSERT INTO `Status` (`ID`, `Name`, `Code`, `Description`) VALUES
(1, 'Service OK', 'S200', 'Indicates a service is operational'),
(2, 'App OK', 'A200', 'The Application is active and operational'),
(3, 'App Service OK', 'AS200', 'Application has is authorized to access this service.'),
(4, 'Transaction Pending Ack', 'TRX201', 'Transaction has been accepted and is pending acknowledgement'),
(5, 'Transaction Failed', 'TRX400', 'Transaction has Failed to be processed'),
(6, 'Transaction Escalated', 'TRX500', 'Transaction requires manual reconcilliation'),
(7, 'Transaction Success', 'TRX200', 'Transaction has been completed successfully'),
(8, 'Accepted by processor', 'TRX204', 'Processing partner has accepted the transaction');

-- --------------------------------------------------------

--
-- Table structure for table `Transactions`
--
-- Creation: Aug 15, 2022 at 08:13 AM
--

DROP TABLE IF EXISTS `Transactions`;
CREATE TABLE IF NOT EXISTS `Transactions` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ExternalCode` varchar(64) NOT NULL,
  `TPCODE` varchar(64) DEFAULT NULL,
  `MSISDN` varchar(32) NOT NULL,
  `AccountNumber` varchar(32) NOT NULL,
  `Code` varchar(64) NOT NULL,
  `Amount` decimal(15,4) NOT NULL,
  `Narration` text NOT NULL,
  `CurrencyCode` varchar(3) NOT NULL,
  `CustomerName` varchar(32) NOT NULL,
  `Mode` varchar(20) NOT NULL,
  `CallbackURL` varchar(64) NOT NULL,
  `AppCode` varchar(64) NOT NULL,
  `ServiceCode` varchar(64) NOT NULL,
  `Metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `AckDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `StatusCode` varchar(20) NOT NULL,
  `TPStatusDesc` varchar(64) NOT NULL,
  `PaymentDate` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ID`),
  KEY `AppCode` (`AppCode`),
  KEY `CountryCode` (`CurrencyCode`),
  KEY `ServiceCode` (`ServiceCode`),
  KEY `StatusCode` (`StatusCode`)
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Transactions`
--

-- --------------------------------------------------------

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AppAccounts`
--
ALTER TABLE `AppAccounts`
  ADD CONSTRAINT `AppAccounts_ibfk_1` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `AppAccounts_ibfk_2` FOREIGN KEY (`AppID`) REFERENCES `Apps` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Apps`
--
ALTER TABLE `Apps`
  ADD CONSTRAINT `Apps_ibfk_1` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`),
  ADD CONSTRAINT `Apps_ibfk_2` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`);

--
-- Constraints for table `AppServices`
--
ALTER TABLE `AppServices`
  ADD CONSTRAINT `AppServices_ibfk_1` FOREIGN KEY (`AppCode`) REFERENCES `Apps` (`Code`),
  ADD CONSTRAINT `AppServices_ibfk_2` FOREIGN KEY (`ServiceCode`) REFERENCES `Services` (`Code`),
  ADD CONSTRAINT `AppServices_ibfk_3` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`);

--
-- Constraints for table `Countries`
--
ALTER TABLE `Countries`
  ADD CONSTRAINT `Countries_ibfk_1` FOREIGN KEY (`ContinentID`) REFERENCES `Continents` (`ID`);

--
-- Constraints for table `Services`
--
ALTER TABLE `Services`
  ADD CONSTRAINT `Services_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`),
  ADD CONSTRAINT `Services_ibfk_2` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`);

--
-- Constraints for table `Transactions`
--
ALTER TABLE `Transactions`
  ADD CONSTRAINT `Transactions_ibfk_1` FOREIGN KEY (`AppCode`) REFERENCES `Apps` (`Code`),
  ADD CONSTRAINT `Transactions_ibfk_2` FOREIGN KEY (`CurrencyCode`) REFERENCES `Countries` (`ISOCurrencyCode`),
  ADD CONSTRAINT `Transactions_ibfk_3` FOREIGN KEY (`ServiceCode`) REFERENCES `Services` (`Code`),
  ADD CONSTRAINT `Transactions_ibfk_4` FOREIGN KEY (`StatusCode`) REFERENCES `Status` (`Code`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
