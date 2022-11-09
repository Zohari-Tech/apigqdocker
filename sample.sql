-- Adminer 4.8.1 MySQL 5.5.5-10.9.3-MariaDB-1:10.9.3+maria~ubu2204 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `coredb`;
CREATE DATABASE `coredb` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `coredb`;

DELIMITER ;;

CREATE PROCEDURE `GetAppServiceInfo`(IN `APPKEY` VARCHAR(64), IN `SERVICE_CODE` VARCHAR(64))
BEGIN
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
END;;

DELIMITER ;

DROP TABLE IF EXISTS `AppAccounts`;
CREATE TABLE `AppAccounts` (
  `AppID` int(11) NOT NULL,
  `CountryID` int(11) NOT NULL,
  `Float` decimal(19,4) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  KEY `CountryID` (`CountryID`),
  KEY `AppID` (`AppID`),
  CONSTRAINT `AppAccounts_ibfk_1` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `AppAccounts_ibfk_2` FOREIGN KEY (`AppID`) REFERENCES `Apps` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Apps`;
CREATE TABLE `Apps` (
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
  KEY `StatusID` (`StatusID`),
  CONSTRAINT `Apps_ibfk_1` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`),
  CONSTRAINT `Apps_ibfk_2` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Apps` (`ID`, `Name`, `Code`, `StatusID`, `CountryID`, `Multinational`, `Secret`) VALUES
(1,	'TestApp',	'62ea315fb47687d9cbbf6827',	2,	1,	0,	'7kTpE!RVy4q4ni0OuITyjz7VpZq!&DhSw');

DROP TABLE IF EXISTS `AppServices`;
CREATE TABLE `AppServices` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `AppCode` varchar(64) NOT NULL,
  `ServiceCode` varchar(64) NOT NULL,
  `StatusID` int(11) NOT NULL,
  `Settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`Settings`)),
  PRIMARY KEY (`ID`),
  KEY `AppCode` (`AppCode`),
  KEY `ServiceCode` (`ServiceCode`),
  KEY `StatusID` (`StatusID`),
  CONSTRAINT `AppServices_ibfk_1` FOREIGN KEY (`AppCode`) REFERENCES `Apps` (`Code`),
  CONSTRAINT `AppServices_ibfk_2` FOREIGN KEY (`ServiceCode`) REFERENCES `Services` (`Code`),
  CONSTRAINT `AppServices_ibfk_3` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `AppServices` (`ID`, `AppCode`, `ServiceCode`, `StatusID`, `Settings`) VALUES
(1,	'62ea315fb47687d9cbbf6827',	'62dfa03aeabc77e249463105',	3,	'{}'),
(2,	'62ea315fb47687d9cbbf6827',	'634bb3da9c0b0d8dc9de1cf9',	3,	'{}'),
(3,	'62ea315fb47687d9cbbf6827',	'634bad70be9431c13b9f0b59',	3,	'{}'),
(4,	'62ea315fb47687d9cbbf6827',	'634ba5c563db4ac99cf44fbc',	3,	'{}'),
(5,	'62ea315fb47687d9cbbf6827',	'6368e6e929a61a58bfd56be2',	3,	'{}'),
(6,	'62ea315fb47687d9cbbf6827',	'6368e655d3a92ea46d688ef3',	3,	'{}'),
(7,	'62ea315fb47687d9cbbf6827',	'6368b392bc8a317cc150d581',	3,	'{}');

DROP TABLE IF EXISTS `Continents`;
CREATE TABLE `Continents` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `Code` varchar(2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Continents` (`ID`, `Name`, `Code`) VALUES
(1,	'Asia',	'AS'),
(2,	'Africa',	'AF'),
(3,	'Europe',	'EU'),
(4,	'North America',	'NA'),
(5,	'South America',	'SA'),
(6,	'Oceania',	'OC'),
(8,	'Antarctica',	'AN');

DROP TABLE IF EXISTS `Countries`;
CREATE TABLE `Countries` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `CurrencyName` varchar(32) NOT NULL,
  `ContinentID` int(11) NOT NULL,
  `ISOCountryCode` varchar(3) NOT NULL,
  `ISOCurrencyCode` varchar(3) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ISOCurrencyCode` (`ISOCurrencyCode`),
  KEY `ContinentID` (`ContinentID`),
  CONSTRAINT `Countries_ibfk_1` FOREIGN KEY (`ContinentID`) REFERENCES `Continents` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Countries` (`ID`, `Name`, `CurrencyName`, `ContinentID`, `ISOCountryCode`, `ISOCurrencyCode`) VALUES
(1,	'Kenya',	'Ksh.',	2,	'KEN',	'KES');

DROP TABLE IF EXISTS `RequestLogs`;
CREATE TABLE `RequestLogs` (
  `ID` varchar(64) NOT NULL,
  `SysID` varchar(64) NOT NULL,
  `ServiceCode` varchar(64) NOT NULL,
  `ApplicationCode` varchar(64) NOT NULL,
  `CallBack` varchar(64) NOT NULL,
  `CreatedAt` datetime NOT NULL,
  `UpdatedAt` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE current_timestamp(),
  `RawRequest` longtext NOT NULL,
  `RawResponses` longtext NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `ServiceCode` (`ServiceCode`),
  KEY `ApplicationCode` (`ApplicationCode`),
  CONSTRAINT `RequestLogs_ibfk_1` FOREIGN KEY (`ApplicationCode`) REFERENCES `Apps` (`Code`),
  CONSTRAINT `RequestLogs_ibfk_2` FOREIGN KEY (`ServiceCode`) REFERENCES `Services` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `Services`;
CREATE TABLE `Services` (
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
  KEY `CountryID` (`CountryID`),
  CONSTRAINT `Services_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `Status` (`ID`),
  CONSTRAINT `Services_ibfk_2` FOREIGN KEY (`CountryID`) REFERENCES `Countries` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Services` (`ID`, `Name`, `Description`, `ServiceURL`, `CountryID`, `StatusID`, `Statics`, `Headers`, `HttpMethod`, `Code`, `format`, `type`, `Environment`) VALUES
(1,	'Mpesa-STK',	'Mpesa STK Online Payment',	'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',	1,	1,	'{\"BusinessShortCode\":\"174379\",\"CONSUMER_SECRET\":\"psa3rMtGLbMPI9Jc\",\"CONSUMER_KEY\":\"Jj8TrQstN3kxRrQx06Etge3UUK73bAmh\",\"InitiatorName\":\"testapi\",\"InitiatorPassword\":\"Safaricom999!*!\",\"PartyA\":\"600990\",\"PartyB\":\"600000\",\"PassKey\":\"bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919\",\"PhoneNumber\":\"254702079491\",\"TOKEN_URL\":\"https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials\",\"Callback\":\"https://9627-197-248-20-39.in.ngrok.io/public/callback/62dfa03aeabc77e249463105\"}',	'{\"Content-Type\":[\"application/json\"]}',	'POST',	'62dfa03aeabc77e249463105',	'JSON',	'ASYNC',	'PRODUCTION'),
(2,	'SAF_AIRT_PAY',	'Safaricom Airtime charging',	'https://dtsvc.safaricom.com:8480/api/public/SDP/paymentRequest',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634bad70be9431c13b9f0b59',	'JSON',	'ASYNC',	'TESTBED'),
(3,	'SAF_SDP_SUB',	'Safaricom sub to airtime payment',	'https://dtsvc.safaricom.com:8480/api/public/SDP/activate',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\",\"MAIN_URL\":\"https://dtsvc.safaricom.com:8480/api/public/SDP/activate\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634ba5c563db4ac99cf44fbc',	'JSON',	'ASYNC',	'TESTBED'),
(4,	'SAFSDP_UNSUB',	'Safaricom unsub to airtime payment',	'https://dtsvc.safaricom.com:8480/api/public/SDP/deactivate',	1,	1,	'{\"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\"PARTNER_CODE\":\"415\",\"USERNAME\":\"Musren_API\",\"PASSWORD\":\"vX4445z2^QsL\",\"MAIN_URL\":\"https://dtsvc.safaricom.com:8480/api/public/SDP/deactivate\"}',	'{\"Content-Type\": [\"application/json\"], \"Accept\": [\"application/json\"]}',	'POST',	'634bb3da9c0b0d8dc9de1cf9',	'JSON',	'ASYNC',	'TESTBED'),
(10,	'HE_CHARGE',	'Header enrichment airtime charging.',	'http://hesdp.safaricom.com:1212/api/v1/charge',	1,	1,	'{\r\n\"offerCode\":\"001023100500\",\r\n\"CpId\":\"231\",\r\n\"callBackUrl\":\"https://posthere.io/93b3-4a3b-b21c\"\r\n}',	'{\r\n    \"Accept-Encoding\": \"application/json\",\r\n    \"Accept-Language\": \"EN\",\r\n    \"Content-Type\": \"application/json\",\r\n    \"X-App\": \"ussd\",\r\n    \"X-Source-Division\": \"DIT\",\r\n    \"X-Source-CountryCode\": \"KE\",\r\n    \"X-Source-Operator\": \"Safaricom\",\r\n    \"X-Source-System\": \"web-portal\",\r\n    \"X-Version\": \"1.0.0\"\r\n}',	'POST',	'6368b392bc8a317cc150d581',	'JSON',	'SYNC',	'TESTBED'),
(11,	'HE_ACTIVATE',	'Header enrichment activation of the masked MSISDN to charging',	'http://hesdp.safaricom.com:1212/api/v1/activate',	1,	1,	'{\r\n\"SERVICE_CALLBACK\":\"https://posthere.io/93b3-4a3b-b21c\",\r\n\"serviceUrl\":\"http://hesdp.safaricom.com:1212/api/v1/activate\",\r\n   \"TOKEN_URL\":\"https://dtsvc.safaricom.com:8480/api/auth/login\",\r\n   \"PARTNER_CODE\":\"415\",\r\n   \"USERNAME\":\"Musren_API\",\r\n   \"PASSWORD\":\"vX4445z2^QsL\",\r\n}',	'{\r\n    \"Accept-Encoding\": \"application/json\",\r\n    \"Accept-Language\": \"EN\",\r\n    \"Content-Type\": \"application/json\",\r\n    \"X-App\": \"ussd\",\r\n    \"X-Source-Division\": \"DIT\",\r\n    \"X-Source-CountryCode\": \"KE\",\r\n    \"X-Source-Operator\": \"Safaricom\",\r\n    \"X-Source-System\": \"web-portal\",\r\n    \"X-Version\": \"1.0.0\"\r\n}\r\n',	'POST',	'6368e655d3a92ea46d688ef3',	'JSON',	'SYNC',	'TESTBED'),
(12,	'HE_DEACTIVE',	'Deactivate masked subscriber ',	'http://hesdp.safaricom.com:1212/api/v1/deactivate',	1,	1,	'{\r\n\"CpId\":\"231\",\r\n\"callBackUrl\":\"https://posthere.io/93b3-4a3b-b21c\"\r\n}',	'{\r\n    \"Accept-Encoding\": \"application/json\",\r\n    \"Accept-Language\": \"EN\",\r\n    \"Content-Type\": \"application/json\",\r\n    \"X-App\": \"ussd\",\r\n    \"X-Source-Division\": \"DIT\",\r\n    \"X-Source-CountryCode\": \"KE\",\r\n    \"X-Source-Operator\": \"Safaricom\",\r\n    \"X-Source-System\": \"web-portal\",\r\n    \"X-Version\": \"1.0.0\"\r\n}',	'POST',	'6368e6e929a61a58bfd56be2',	'JSON',	'SYNC',	'TESTBED'),
(13,	'HE_MASKED',	'Get the browsers phone number from HE to continue with subscription',	'http://header.safaricombeats.co.ke/',	1,	1,	'{}',	'{}',	'GET',	'6368e733f4528c5c93554742',	'XML',	'SYNC',	'TESTBED');

DROP TABLE IF EXISTS `Status`;
CREATE TABLE `Status` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  `Code` varchar(8) NOT NULL,
  `Description` text NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Code` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `Status` (`ID`, `Name`, `Code`, `Description`) VALUES
(1,	'Service OK',	'S200',	'Indicates a service is operational'),
(2,	'App OK',	'A200',	'The Application is active and operational'),
(3,	'App Service OK',	'AS200',	'Application has is authorized to access this service.'),
(4,	'Transaction Pending Ack',	'TRX201',	'Transaction has been accepted and is pending acknowledgement'),
(5,	'Transaction Failed',	'TRX400',	'Transaction has Failed to be processed'),
(6,	'Transaction Escalated',	'TRX500',	'Transaction requires manual reconcilliation'),
(7,	'Transaction Success',	'TRX200',	'Transaction has been completed successfully'),
(8,	'Accepted by processor',	'TRX204',	'Processing partner has accepted the transaction');

DROP TABLE IF EXISTS `Transactions`;
CREATE TABLE `Transactions` (
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
  KEY `StatusCode` (`StatusCode`),
  CONSTRAINT `Transactions_ibfk_1` FOREIGN KEY (`AppCode`) REFERENCES `Apps` (`Code`),
  CONSTRAINT `Transactions_ibfk_2` FOREIGN KEY (`CurrencyCode`) REFERENCES `Countries` (`ISOCurrencyCode`),
  CONSTRAINT `Transactions_ibfk_3` FOREIGN KEY (`ServiceCode`) REFERENCES `Services` (`Code`),
  CONSTRAINT `Transactions_ibfk_4` FOREIGN KEY (`StatusCode`) REFERENCES `Status` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2022-11-08 12:33:39
