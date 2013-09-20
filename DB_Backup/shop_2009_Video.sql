-- Adminer 3.6.2 MySQL dump

SET NAMES utf8;
SET foreign_key_checks = 0;
SET time_zone = 'SYSTEM';
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
  `AddressID` int(11) NOT NULL AUTO_INCREMENT,
  `UsersID` varchar(60) DEFAULT NULL,
  `Street` varchar(100) DEFAULT NULL,
  `ZIPCode` int(11) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `State` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AddressID`),
  KEY `UsersID` (`UsersID`),
  CONSTRAINT `address_ibfk_2` FOREIGN KEY (`UsersID`) REFERENCES `users` (`UsersID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `attrib`;
CREATE TABLE `attrib` (
  `AttribID` int(11) NOT NULL AUTO_INCREMENT,
  `AttribName` varchar(255) NOT NULL,
  PRIMARY KEY (`AttribID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `attrib` (`AttribID`, `AttribName`) VALUES
(1,	'Roast'),
(2,	'Body'),
(3,	'Acidity'),
(4,	'Taste'),
(5,	'Notes'),
(6,	'Package'),
(7,	'Country');

DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog` (
  `BlogID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `BlogName` varchar(150) NOT NULL,
  `BlogContent` text,
  PRIMARY KEY (`BlogID`),
  KEY `ProductID` (`ProductID`),
  KEY `CategoryID` (`CategoryID`),
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `blog_ibfk_2` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `CategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(45) DEFAULT NULL,
  `CategorySeoName` varchar(45) DEFAULT NULL,
  `CategoryDescription` longtext,
  `CategoryStatus` int(11) NOT NULL DEFAULT '3',
  `HigherCategoryID` int(11) DEFAULT NULL,
  `CategoryPhoto` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`CategoryID`),
  KEY `HigherCategoryID_idx` (`HigherCategoryID`),
  KEY `CategoryStatus` (`CategoryStatus`),
  CONSTRAINT `category_ibfk_2` FOREIGN KEY (`HigherCategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `category_ibfk_3` FOREIGN KEY (`CategoryStatus`) REFERENCES `categorystatus` (`CategoryStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `category` (`CategoryID`, `CategoryName`, `CategorySeoName`, `CategoryDescription`, `CategoryStatus`, `HigherCategoryID`, `CategoryPhoto`) VALUES
(99,	'Blog',	'Blog',	'Blog full of wonderfull stories!',	4,	NULL,	NULL),
(100,	'Static Text',	'Static Text',	NULL,	4,	NULL,	NULL),
(1001,	'Coffee by Roast',	'Coffee by Roast',	'<p>Select any of our coffee ordered by roast.</p>',	1,	NULL,	NULL),
(1002,	'Coffee by region',	'Coffee by region',	NULL,	1,	NULL,	NULL),
(1003,	'Light',	'Light',	'<span style=\"font-family: sans-serif; font-size: 13px; line-height: 19.1875px; background-color: rgb(249, 249, 249);\">A very light roast level, immediately before first crack. Light brown, toasted grain flavors with sharp acidic tones, almost tea-like in character.</span>',	1,	1001,	NULL),
(1004,	'Medium',	'Medium',	'Medium brown, common for most specialty coffee. Good for tasting the varietal character of a bean.',	1,	1001,	NULL),
(1006,	'Dark',	'Dark',	'Dark brown, shiny with oil, burnt undertones, acidity diminished. At the end of second crack. Roast character is dominant at this level. Little, if any, of the inherent flavors of the coffee remain.',	1,	1001,	NULL),
(1007,	'Africa',	'Africa',	NULL,	1,	1002,	NULL),
(1008,	'Indonesia',	'Indonesia',	NULL,	1,	1002,	NULL),
(1009,	'Central America',	'Central America',	NULL,	1,	1002,	NULL),
(1010,	'South America',	'South America',	NULL,	0,	1002,	NULL),
(1011,	'Tea',	'Tea',	NULL,	1,	NULL,	NULL);

DROP TABLE IF EXISTS `categorystatus`;
CREATE TABLE `categorystatus` (
  `CategoryStatusID` int(11) NOT NULL AUTO_INCREMENT,
  `CategoryStatusName` varchar(190) NOT NULL,
  PRIMARY KEY (`CategoryStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `categorystatus` (`CategoryStatusID`, `CategoryStatusName`) VALUES
(0,	'Draft'),
(1,	'Published'),
(2,	'Featured'),
(4,	'Blog');

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `CommentID` int(11) NOT NULL AUTO_INCREMENT,
  `CommentTitle` varchar(45) DEFAULT NULL,
  `CommentContent` text,
  `DateOfAdded` datetime DEFAULT NULL,
  `Author` varchar(60) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `PreviousCommentID` int(11) DEFAULT '0',
  PRIMARY KEY (`CommentID`),
  KEY `CommentID_idx` (`PreviousCommentID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `FKPreviousComment` FOREIGN KEY (`PreviousCommentID`) REFERENCES `comment` (`CommentID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `CurrencyID` int(11) NOT NULL AUTO_INCREMENT,
  `CurrencyCode` varchar(3) DEFAULT NULL,
  `CurrencyName` varchar(45) DEFAULT NULL,
  `CurrencyRate` float DEFAULT NULL,
  PRIMARY KEY (`CurrencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `currency` (`CurrencyID`, `CurrencyCode`, `CurrencyName`, `CurrencyRate`) VALUES
(1,	'CZK',	'Koruna ?esk?',	NULL),
(2,	'EUR',	'Euro',	NULL);

DROP TABLE IF EXISTS `delivery`;
CREATE TABLE `delivery` (
  `DeliveryID` int(11) NOT NULL AUTO_INCREMENT,
  `DeliveryName` varchar(45) DEFAULT NULL,
  `DeliveryDescription` varchar(45) DEFAULT NULL,
  `DeliveryPrice` float DEFAULT NULL,
  `FreeFromPrice` float DEFAULT NULL,
  `StatusID` int(11) NOT NULL DEFAULT '2',
  `HigherDelivery` int(11) DEFAULT NULL,
  PRIMARY KEY (`DeliveryID`),
  KEY `PriceID_idx` (`DeliveryPrice`),
  KEY `StatusID` (`StatusID`),
  KEY `HigherDelivery` (`HigherDelivery`),
  CONSTRAINT `delivery_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `status` (`StatusID`),
  CONSTRAINT `delivery_ibfk_2` FOREIGN KEY (`HigherDelivery`) REFERENCES `delivery` (`DeliveryID`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `delivery` (`DeliveryID`, `DeliveryName`, `DeliveryDescription`, `DeliveryPrice`, `FreeFromPrice`, `StatusID`, `HigherDelivery`) VALUES
(1,	'Personal pick up',	'Personal in the shop',	0,	NULL,	1,	NULL),
(2,	'Czech postal service',	'Send by transport company',	99,	1000,	1,	NULL),
(3,	'DPD',	'Curier express shipping! :)',	160,	10000,	1,	NULL),
(353,	'Zásilkovna',	'osobní převzetí v síti Zásilkovna.cz',	49,	NULL,	1,	353),
(354,	'cz - Beroun',	'Oční optika M. Ečerová',	49,	NULL,	1,	353),
(355,	'cz - Brno, Jiráskova',	'Marty\'s clean garage',	49,	NULL,	1,	353),
(356,	'cz - Brno, Komín - Závist',	'ShopGSM.cz',	49,	NULL,	1,	353),
(357,	'cz - Brno, Královo Pole',	'MobilMax',	49,	NULL,	1,	353),
(358,	'cz - Brno, Mendlovo náměstí',	'MobilMax',	49,	NULL,	1,	353),
(359,	'cz - Brno, Merhautova',	'Gabriela',	49,	NULL,	1,	353),
(360,	'cz - Brno, Nové Sady',	'Motocyklové díly.cz',	49,	NULL,	1,	353),
(361,	'cz - České Budějovice, Otakarova',	'Tvořilka',	49,	NULL,	1,	353),
(362,	'cz - Frýdek-Místek',	'Dvěděti.cz - dřevěné hračky',	49,	NULL,	1,	353),
(363,	'cz - Havířov, Ostravská',	'Shell',	49,	NULL,	1,	353),
(364,	'cz - Holešov',	'MAVEX, spol. s r.o.',	49,	NULL,	1,	353),
(365,	'cz - Hradec Králové',	'Kancelářský servis HK',	49,	NULL,	1,	353),
(366,	'cz - Chrudim',	'Bytový textil',	49,	NULL,	1,	353),
(367,	'cz - Jihlava',	'Svět hor',	49,	NULL,	1,	353),
(368,	'cz - Karlovy Vary',	'Logistic centre - NEW WAVE CZ, a.s.',	49,	NULL,	1,	353),
(369,	'cz - Kladno',	'OptikDoDomu',	49,	NULL,	1,	353),
(370,	'cz - Kolín',	'Vzorkovna na Zahradní',	49,	NULL,	1,	353),
(371,	'cz - Kroměříž',	'Hlaváč CZ',	49,	NULL,	1,	353),
(372,	'cz - Kutná Hora',	'iBoom s.r.o.',	49,	NULL,	1,	353),
(373,	'cz - Liberec, 5. května',	'nStore.cz s.r.o.',	49,	NULL,	1,	353),
(374,	'cz - Mladá Boleslav',	'Relax solární studio',	49,	NULL,	1,	353),
(375,	'cz - Most, J. Skupy',	'MobilMax - DobírkaMobil',	49,	NULL,	1,	353),
(376,	'cz - Náchod',	'OptikDoDomu',	49,	NULL,	1,	353),
(377,	'cz - Olomouc, centrum',	'Optika Mgr. Eva Bazgerová',	49,	NULL,	1,	353),
(378,	'cz - Olomouc, Nová Ulice',	'JV-OL',	49,	NULL,	1,	353),
(379,	'cz - Ostrava, Mariánské Hory',	'Outlet Rocca Intimo',	49,	NULL,	1,	353),
(380,	'cz - Ostrava, Nádražní',	'Le Boutique Gourmet',	49,	NULL,	1,	353),
(381,	'cz - Ostrava, Poruba',	'Lahůdky z Itálie',	49,	NULL,	1,	353),
(382,	'cz - Pardubice',	'Aneco v.o.s.',	49,	NULL,	1,	353),
(383,	'cz - Písek',	'AKY chovatelské potřeby a krmiva',	49,	NULL,	1,	353),
(384,	'cz - Plzeň, u centra Plaza',	'Tvořilka',	49,	NULL,	1,	353),
(385,	'cz - Praha 1, Klimentská',	'SKETA Shop',	49,	NULL,	1,	353),
(386,	'cz - Praha 1, Národní třída',	'Stáčírna',	49,	NULL,	1,	353),
(387,	'cz - Praha 10, Starostrašnická',	'Dia-Bio-Racio-Bezlepek',	49,	NULL,	1,	353),
(388,	'cz - Praha 14, Černý Most',	'Farní charita',	49,	NULL,	1,	353),
(389,	'cz - Praha 2, Hlavní nádraží',	'Bohemia Wine',	49,	NULL,	1,	353),
(390,	'cz - Praha 3, Vinohrady',	'Stáčírna s.r.o.',	49,	NULL,	1,	353),
(391,	'cz - Praha 3, Želivského',	'Barvy&laky',	49,	NULL,	1,	353),
(392,	'cz - Praha 4, Braník',	'GAW-Net ',	49,	NULL,	1,	353),
(393,	'cz - Praha 4, Pražského Povstání',	'Pilulky24.cz',	49,	NULL,	1,	353),
(394,	'cz - Praha 4, U Vyšehradu',	'Autodoplňky Ascartuning',	49,	NULL,	1,	353),
(395,	'cz - Praha 5, Smíchovské nádraží',	'Zlatá Tečka',	49,	NULL,	1,	353),
(396,	'cz - Praha 6, Evropská',	'Shell',	49,	NULL,	1,	353),
(397,	'cz - Praha 6, Hradčanská',	'VIDEOTECH.CZ',	49,	NULL,	1,	353),
(398,	'cz - Praha 6, Řepy',	'Fotomobil',	49,	NULL,	1,	353),
(399,	'cz - Praha 7, Jateční',	'Direct, spol. s r.o.',	49,	NULL,	1,	353),
(400,	'cz - Praha 8,  Florenc',	'Perfect Print s.r.o.',	49,	NULL,	1,	353),
(401,	'cz - Praha 8, Ládví',	'HESTIA s.r.o.',	49,	NULL,	1,	353),
(402,	'cz - Praha 8, Sokolovská',	'TisknuLevne.cz',	49,	NULL,	1,	353),
(403,	'cz - Praha 9, Hloubětín',	'Sun Way',	49,	NULL,	1,	353),
(404,	'cz - Praha 9, Ocelářská (Depo)',	'Zásilkovna s.r.o.',	49,	NULL,	1,	353),
(405,	'cz - Rakovník',	'OptikDoDomu',	49,	NULL,	1,	353),
(406,	'cz - Rudná',	'Oční optika M. Ečerová',	49,	NULL,	1,	353),
(407,	'cz - Teplice, Masarykova',	'Shell',	49,	NULL,	1,	353),
(408,	'cz - Trutnov',	'OptikDoDomu',	49,	NULL,	1,	353),
(409,	'cz - Třebíč',	'Mgr. Jitka Švaříčková - DEDRA Třebíč',	49,	NULL,	1,	353),
(410,	'cz - Třinec',	'Pochutnej si!',	49,	NULL,	1,	353),
(411,	'cz - Uherské Hradiště',	'Penzion Na Stavidle',	49,	NULL,	1,	353),
(412,	'cz - Uherský Brod',	'CA Pencil Travel',	49,	NULL,	1,	353),
(413,	'cz - Ústí nad Labem, Revoluční',	'Pekárna Chabařovice',	49,	NULL,	1,	353),
(414,	'cz - Vyškov',	'Dárkové zboží - Pěkný-Domov.cz',	49,	NULL,	1,	353),
(415,	'cz - Zlín, T. G. Masaryka',	'Residence Park-in',	49,	NULL,	1,	353),
(416,	'cz - Znojmo',	'Supraton',	49,	NULL,	1,	353),
(417,	'cz - Žatec',	'DĚTSKÝ SVĚT',	49,	NULL,	1,	353),
(418,	'de - Zittau (DE)',	'Triloxx GmbH',	49,	NULL,	1,	353),
(419,	'sk - Banská Bystrica, Švermova',	'CATUS Slovakia',	49,	NULL,	1,	353),
(420,	'sk - Banská Bystrica, Tajovského',	'Lešenia',	49,	NULL,	1,	353),
(421,	'sk - Bratislava, Cyprichová',	'Kníhkupectvo, antikvariát',	49,	NULL,	1,	353),
(422,	'sk - Bratislava, Petržalka',	'Zásilkovna',	49,	NULL,	1,	353),
(423,	'sk - Bratislava, Podunajské Biskupice',	'Naše Elektro - Nel.sk',	49,	NULL,	1,	353),
(424,	'sk - Bratislava, Vajnorská',	'AUTOTEL',	49,	NULL,	1,	353),
(425,	'sk - Dunajská Streda',	'Rempack',	49,	NULL,	1,	353),
(426,	'sk - Galanta',	'Halens',	49,	NULL,	1,	353),
(427,	'sk - Komárno',	'Záložňa VictoryTrade',	49,	NULL,	1,	353),
(428,	'sk - Košice, Toryská',	'Kvetinárstvo ',	49,	NULL,	1,	353),
(429,	'sk - Liptovský Mikuláš',	'Zbrane a strelivo',	49,	NULL,	1,	353),
(430,	'sk - Martin',	'Jadran',	49,	NULL,	1,	353),
(431,	'sk - Nitra, Mlynská',	'Nitra, Mlynská',	49,	NULL,	1,	353),
(432,	'sk - Prešov',	'PC herňa & Internetová čitáreň',	49,	NULL,	1,	353),
(433,	'sk - Ružomberok',	'CK Darka Tour',	49,	NULL,	1,	353),
(434,	'sk - Spišská Nová Ves',	'Diskontná predajna hračiek',	49,	NULL,	1,	353),
(435,	'sk - Trenčín',	'FourBrain s.r.o.',	49,	NULL,	1,	353),
(436,	'sk - Trnava',	'Obchodík \"U chorej vrany\"',	49,	NULL,	1,	353),
(437,	'sk - Žilina, Rosinská',	'RUNO spol. s r.o.',	49,	NULL,	1,	353),
(438,	'Uloženka',	'osobní převzetí v síti Uloženka.cz',	39,	NULL,	3,	438),
(439,	'Pobočka Praha 4',	'5. května 1109/63',	49,	NULL,	3,	438),
(440,	'Pobočka Brno',	'Václavská 237/6, areál ICB vchod č. 9',	49,	NULL,	3,	438),
(441,	'Pobočka Ostrava',	'28.října 1422/299',	49,	NULL,	3,	438),
(442,	'Pobočka Hradec Králové',	'Pražská třída 293',	49,	NULL,	3,	438),
(443,	'Pobočka Praha 9',	'Kolbenova 931/40b',	49,	NULL,	3,	438),
(444,	'Pobočka Brno 2',	'Černopolní 54/245',	49,	NULL,	3,	438),
(445,	'Pobočka Olomouc',	'Wellnerova 1322/3c',	49,	NULL,	3,	438),
(446,	'Pobočka Plzeň',	'Tovární 280/7',	49,	NULL,	3,	438),
(447,	'Pobočka České Budějovice',	'Novohradská 736/36',	49,	NULL,	3,	438),
(448,	'Pobočka Ústí nad Labem',	'Dlouhá 1/12',	49,	NULL,	3,	438),
(449,	'Pobočka SK, Bratislava',	'Chorvátska 1',	49,	NULL,	3,	438),
(450,	'Nejlevnější delivery',	'Nejlevnější delivery',	19,	NULL,	1,	NULL);

DROP TABLE IF EXISTS `documentation`;
CREATE TABLE `documentation` (
  `DocumentID` int(11) NOT NULL AUTO_INCREMENT,
  `DocumentName` varchar(45) DEFAULT NULL,
  `DocumentDescription` varchar(500) DEFAULT NULL,
  `DocumentURL` varchar(100) DEFAULT NULL,
  `ProductID` int(11) NOT NULL,
  PRIMARY KEY (`DocumentID`),
  KEY `ProductID_idx` (`ProductID`),
  CONSTRAINT `FKDocumentProduct` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `mailcontent`;
CREATE TABLE `mailcontent` (
  `MailID` int(11) NOT NULL AUTO_INCREMENT,
  `MailSubject` varchar(200) COLLATE utf8_czech_ci NOT NULL,
  `MailContent` text COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`MailID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `module`;
CREATE TABLE `module` (
  `ModuleID` int(11) NOT NULL AUTO_INCREMENT,
  `ModuleName` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `CompModuleName` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `ModuleDescription` text COLLATE utf8_czech_ci,
  `ModuleType` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `StatusID` int(11) NOT NULL DEFAULT '2',
  PRIMARY KEY (`ModuleID`),
  KEY `StatusID` (`StatusID`),
  CONSTRAINT `module_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `status` (`StatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

INSERT INTO `module` (`ModuleID`, `ModuleName`, `CompModuleName`, `ModuleDescription`, `ModuleType`, `StatusID`) VALUES
(1,	'Zásilkovna',	'zasilkovna',	'Osobní převzetí v síti Zásilkovna.cz',	'shipping',	1),
(2,	'Uloženka',	'ulozenka',	'Osobní odběr v síti Uloženka.cz',	'shipping',	2),
(3,	'Cash On Delivery',	'cod',	'Cash on delivery module',	'payment',	2),
(4,	'Comments',	'comment',	'Enable comments for products.',	'product',	1),
(5,	'Documents',	'document',	'Add documents to your products.',	'product',	1),
(6,	'Heureka',	'heureka',	'Heureka feed',	'order',	1),
(7,	'Gapi',	'gapi',	'jsuajisjaoi\r\n',	'gapi',	1),
(8,	'Bankwire',	'bankwire',	'Bankwire payment',	'payment',	1),
(9,	'XML feed generator',	'xmlfeed',	'Generating XML for product search engines like Google Products, etc.',	'product',	1);

DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `NotesID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) NOT NULL,
  `NotesDate` datetime NOT NULL,
  `NotesName` varchar(150) NOT NULL,
  `NotesDescription` text NOT NULL,
  PRIMARY KEY (`NotesID`),
  KEY `OrderID` (`OrderID`),
  CONSTRAINT `notes_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orderdetails`;
CREATE TABLE `orderdetails` (
  `OrderDetailsID` int(11) NOT NULL AUTO_INCREMENT,
  `OrderID` int(11) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UnitPrice` float DEFAULT NULL,
  PRIMARY KEY (`OrderDetailsID`),
  KEY `OrderID_idx` (`OrderID`),
  KEY `ProductID_idx` (`ProductID`),
  CONSTRAINT `FKOrderDetailsOrder` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKOrderDetailsProduct` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL AUTO_INCREMENT,
  `StatusID` int(11) DEFAULT '1',
  `UsersID` varchar(60) DEFAULT NULL,
  `ProductsPrice` float DEFAULT NULL,
  `DeliveryPaymentPrice` float DEFAULT NULL,
  `TaxPrice` float DEFAULT NULL,
  `PriceWithoutTax` float DEFAULT NULL,
  `TotalPrice` float DEFAULT NULL,
  `DateCreated` datetime DEFAULT NULL,
  `DateOfLastChange` datetime DEFAULT NULL,
  `DateFinished` datetime DEFAULT NULL,
  `DeliveryID` int(11) DEFAULT NULL,
  `PaymentID` int(11) DEFAULT NULL,
  `Note` longtext,
  `IP` varchar(15) DEFAULT NULL,
  `SessionID` int(11) DEFAULT NULL,
  `Read` bit(1) DEFAULT b'0',
  PRIMARY KEY (`OrderID`),
  KEY `StatusID_idx` (`StatusID`),
  KEY `DeliveryID_idx` (`DeliveryID`),
  KEY `PaymentMethodID_idx` (`PaymentID`),
  KEY `UserID` (`UsersID`),
  CONSTRAINT `FKOrderDelivery` FOREIGN KEY (`DeliveryID`) REFERENCES `delivery` (`DeliveryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FKOrderStatus` FOREIGN KEY (`StatusID`) REFERENCES `orderstatus` (`OrderStatusID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`PaymentID`) REFERENCES `payment` (`PaymentID`) ON DELETE SET NULL,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`UsersID`) REFERENCES `users` (`UsersID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `orderstatus`;
CREATE TABLE `orderstatus` (
  `OrderStatusID` int(11) NOT NULL AUTO_INCREMENT,
  `StatusName` varchar(45) DEFAULT NULL,
  `StatusDescription` varchar(255) DEFAULT NULL,
  `StatusProgress` int(11) DEFAULT '0',
  PRIMARY KEY (`OrderStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `orderstatus` (`OrderStatusID`, `StatusName`, `StatusDescription`, `StatusProgress`) VALUES
(0,	'CANCELED',	'order has been canceled',	0),
(1,	'Pending',	'Pending order',	1),
(2,	'Sending',	'sending order',	5),
(3,	'Done',	'done',	10);

DROP TABLE IF EXISTS `parameters`;
CREATE TABLE `parameters` (
  `ParameterID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) DEFAULT NULL,
  `AttribID` int(11) DEFAULT NULL,
  `Val` varchar(255) DEFAULT NULL,
  `UnitID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ParameterID`),
  KEY `ProductID` (`ProductID`),
  KEY `AttribID` (`AttribID`),
  KEY `UnitID` (`UnitID`),
  CONSTRAINT `parameters_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `parameters_ibfk_2` FOREIGN KEY (`AttribID`) REFERENCES `attrib` (`AttribID`),
  CONSTRAINT `parameters_ibfk_3` FOREIGN KEY (`UnitID`) REFERENCES `unit` (`UnitID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `parameters` (`ParameterID`, `ProductID`, `AttribID`, `Val`, `UnitID`) VALUES
(1,	3,	1,	'Light',	1),
(2,	3,	2,	'Syrupy',	1),
(3,	3,	3,	'Bittersweet',	1),
(4,	3,	4,	'Bergamot, floral, jasmine, juicy, intense.',	1),
(5,	13,	1,	'Light',	1),
(6,	13,	2,	'Medium',	1),
(7,	13,	3,	'Clean',	1),
(8,	13,	4,	'Berries, stone fruit, deep floral',	1),
(9,	4,	1,	'Light',	1),
(10,	4,	2,	'medium light',	1),
(11,	4,	3,	'Sweet toned and balanced',	1),
(12,	4,	4,	'Flavors of stone fruit, vanilla and brown sugar',	1),
(13,	14,	1,	'Light',	NULL),
(14,	14,	2,	'Medium',	NULL),
(15,	14,	3,	'Medium',	NULL),
(16,	14,	5,	'Chocolate, Caramel',	NULL),
(17,	15,	1,	'Medium',	NULL),
(18,	15,	2,	'Thick, syrupy, luxurious',	NULL),
(19,	15,	3,	'Sweet',	NULL),
(20,	15,	5,	'Chocolate, citrus, orange, wine-like berry, spice',	NULL),
(21,	16,	1,	'Medium',	NULL),
(22,	16,	2,	'Chocolate Chip Cookie, Medium -light',	NULL),
(23,	16,	3,	'Smack down right in the middle',	NULL),
(24,	16,	5,	'Peanut butter, Floral earth, Hot cocoa with marshmallows, a happy childhood memory',	NULL),
(25,	17,	1,	'Medium',	NULL),
(26,	17,	2,	'Smooth, like melted caramel',	NULL),
(27,	17,	3,	'A well toned Soprano',	NULL),
(28,	17,	5,	'Raspberry, chocolate, sweet red berry candy, blood orange juice',	NULL),
(29,	18,	1,	'Dark',	NULL),
(30,	18,	2,	'Full',	NULL),
(31,	18,	3,	'Low to moderate',	NULL),
(32,	18,	5,	'Smoky, tropical wood, prune, walnut',	NULL),
(33,	19,	1,	'Dark',	NULL),
(34,	19,	2,	'Big',	NULL),
(35,	19,	3,	'Medium to low',	NULL),
(36,	19,	5,	'Smoky, chocolate, cocoa',	NULL),
(37,	20,	1,	'Dark',	NULL),
(38,	20,	2,	'Full, rich, thick',	NULL),
(39,	20,	3,	'Mild and muted',	NULL),
(40,	20,	5,	'Chocolate, earthy smokiness, resinous tobacco',	NULL),
(41,	21,	1,	'Dark',	NULL),
(42,	21,	2,	'Rich',	NULL),
(43,	21,	3,	'Balanced',	NULL),
(44,	21,	5,	'Heavy chocolate',	NULL),
(45,	22,	1,	'Dark',	NULL),
(46,	22,	2,	'Full, rich',	NULL),
(47,	22,	3,	'Balanced',	NULL),
(48,	22,	5,	'Smoky, chocolate',	NULL),
(49,	25,	1,	'Dark',	NULL),
(50,	25,	2,	'Full',	NULL),
(51,	25,	3,	'Low',	NULL),
(52,	25,	5,	'Toasted caramel, slightly smoky',	NULL),
(53,	26,	1,	'Medium',	NULL),
(54,	26,	2,	'Full, creamy',	NULL),
(55,	26,	3,	'Balanced',	NULL),
(56,	26,	5,	'Deep chocolate with caramel overtones',	NULL),
(57,	27,	6,	'10',	2),
(58,	27,	7,	'India',	NULL),
(59,	28,	6,	'125',	2),
(60,	28,	7,	'India',	NULL),
(61,	29,	6,	'100',	2),
(62,	29,	7,	'Sri Lanka',	NULL),
(63,	30,	1,	'Medium Dark',	NULL),
(64,	30,	2,	'Smooth',	NULL),
(65,	30,	3,	'Mild',	NULL),
(66,	30,	5,	'Brandy, chocolate, caramel, cedar, flowers',	NULL),
(67,	33,	1,	'Medium',	NULL),
(68,	33,	2,	'Full',	NULL),
(69,	33,	3,	'Low',	NULL),
(70,	33,	5,	'Fruit, mellow earth tones and almond accents',	NULL),
(71,	36,	1,	'Medium',	NULL),
(72,	36,	2,	'Thick',	NULL),
(73,	36,	3,	'Muted',	NULL),
(74,	36,	5,	'Cocoa, walnut',	NULL),
(75,	37,	1,	'Medium',	NULL),
(76,	37,	2,	'Balanced',	NULL),
(77,	37,	3,	'Medium',	NULL),
(78,	37,	5,	'Deep cocoa, cardamom, candied clementine',	NULL),
(79,	38,	1,	'Medium',	NULL),
(80,	38,	2,	'Balanced, creamy',	NULL),
(81,	38,	3,	'Tartly sweet',	NULL),
(82,	38,	5,	'Cherry-toned chocolate, strawberry, lemon',	NULL);

DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `PaymentName` varchar(45) DEFAULT NULL,
  `PaymentPrice` float DEFAULT '1',
  `StatusID` int(11) NOT NULL DEFAULT '2',
  PRIMARY KEY (`PaymentID`),
  KEY `PriceID` (`PaymentPrice`),
  KEY `StatusID` (`StatusID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `status` (`StatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `payment` (`PaymentID`, `PaymentName`, `PaymentPrice`, `StatusID`) VALUES
(1,	'Cash',	0,	1),
(3,	'Bankwire',	50,	1),
(4,	'Cash on delivery',	0,	3),
(5,	'Cash on delivery',	0,	3),
(6,	'Cash on delivery',	0,	3);

DROP TABLE IF EXISTS `photo`;
CREATE TABLE `photo` (
  `PhotoID` int(11) NOT NULL AUTO_INCREMENT,
  `PhotoName` varchar(45) DEFAULT NULL,
  `PhotoURL` varchar(100) DEFAULT NULL,
  `PhotoAlbumID` int(11) DEFAULT NULL,
  `PhotoAltText` varchar(100) DEFAULT NULL,
  `CoverPhoto` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`PhotoID`),
  KEY `PhotoAlbumID_idx` (`PhotoAlbumID`),
  CONSTRAINT `FKPhotoPhotoAlbum` FOREIGN KEY (`PhotoAlbumID`) REFERENCES `photoalbum` (`PhotoAlbumID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `photo` (`PhotoID`, `PhotoName`, `PhotoURL`, `PhotoAlbumID`, `PhotoAltText`, `CoverPhoto`) VALUES
(56,	'Ethiopia Yirgacheffe Kochere Gr 1',	'Temple-Coffee-Ethiopia-Yirgacheffe-Kochere-Gr-1.3022.lg.jpg',	3,	'Ethiopia Yirgacheffe Kochere Gr 1',	1),
(57,	'Ardi Ethiopia',	'MadCap-Coffee-Ardi-Ethiopia.2038.lg.jpg',	11,	'Ardi Ethiopia',	1),
(58,	'Nokia 3310 ',	'Equator-Coffees-Costa-Rica-La-Perla-Del-Cafe-Red-Honey.2946.lg.jpg',	4,	'Nokia 3310 ',	1),
(59,	'Jackie Oh Organic - Decaf',	'Doma-Coffee-Jackie-Oh-Organic-Decaf.1196.lg.jpg',	12,	'Jackie Oh Organic - Decaf',	1),
(62,	'1000Faces Coffee - Espresso Neruda',	'1000Faces-Coffee--Espresso-Neruda.1923.lg.jpg',	15,	'1000Faces Coffee - Espresso Neruda',	1),
(63,	'Equator Coffees - Fair Trade Organic Alligato',	'Equator-Coffees--Fair-Trade-Organic-Alligator.530.lg.jpg',	16,	'Equator Coffees - Fair Trade Organic Alligator',	1),
(64,	'Atomic Cafe - Black Velvet',	'Atomic-Cafe-Black-Velvet.450.lg.jpg',	17,	'Atomic Cafe - Black Velvet',	1),
(65,	'Johnson Brothers - Black Earth Blend',	'Johnson-Brothers-Black-Earth-Blend.269.lg.jpg',	18,	'Johnson Brothers - Black Earth Blend',	1),
(66,	'PT\'s Coffee - Gizmo Blend',	'PTs-Coffee-Gizmo-Blend.75.lg.jpg',	19,	'PT\'s Coffee - Gizmo Blend',	1),
(67,	'Klatch Coffee - Blue Thunder Blend',	'Klatch-Coffee-Blue-Thunder-Blend.604.lg.jpg',	20,	'Klatch Coffee - Blue Thunder Blend',	1),
(68,	'Novo Coffee - Espresso Del Fuego',	'Novo-Coffee-Espresso-Del-Fuego.409.lg.jpg',	21,	'Novo Coffee - Espresso Del Fuego',	1),
(69,	'Doma Coffee - Bella Luna - Decaf',	'Doma-Coffee-Bella-Luna-Decaf.1179.lg.jpg',	22,	'Doma Coffee - Bella Luna - Decaf',	1),
(70,	'Assam Black Tea',	'pch-assam.jpg',	24,	'Assam Black Tea',	1),
(71,	'DILMAH WHITE LITCHEE NO.1 HAND ROLLLED',	'dilmah.jpg',	25,	'DILMAH WHITE LITCHEE NO.1 HAND ROLLLED',	1),
(72,	'Klatch Coffee - Belle Espresso',	'Klatch-Coffee-Belle-Espresso.59.lg.jpg',	26,	'Klatch Coffee - Belle Espresso',	1),
(73,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	'Equator-Coffees-Ad-Hoc-Chefs-Blend.2335.lg.jpg',	27,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	1),
(74,	'Doma Coffee - The Chronic - Organic',	'Doma-Coffee--The-Chronic-Organic.1184.lg.jpg',	28,	'Doma Coffee - The Chronic - Organic',	1),
(75,	'PT\'s Coffee - Flying Monkey Espresso',	'PTs-Coffee--Flying-Monkey-Espresso.651.lg.jpg',	29,	'PT\'s Coffee - Flying Monkey Espresso',	1),
(77,	'Klatch Coffee',	'Klatch-Coffee--Worlds-Best-Espresso-Coffee.321.lg.jpg',	13,	'Klatch Coffee',	1),
(78,	'Tigerwalk Espresso',	'Equator-Coffees--Tigerwalk-Espresso.1401.lg.jpg',	30,	'Tigerwalk Espresso',	1),
(79,	'1000Faces Coffee - Bell\'s Blend',	'1000Faces-Coffee-Bells-Blend.1765.lg.jpg',	14,	'1000Faces Coffee - Bell\'s Blend',	1),
(95,	'Assam Black Tea',	'pch-assam.jpg',	24,	'Assam Black Tea',	NULL);

DROP TABLE IF EXISTS `photoalbum`;
CREATE TABLE `photoalbum` (
  `PhotoAlbumID` int(11) NOT NULL AUTO_INCREMENT,
  `PhotoAlbumName` varchar(45) DEFAULT NULL,
  `PhotoAlbumDescription` varchar(500) DEFAULT NULL,
  `ProductID` int(11) DEFAULT NULL,
  `BlogID` int(11) DEFAULT NULL,
  `StaticTextID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PhotoAlbumID`),
  KEY `ProductID` (`ProductID`),
  KEY `BlogID` (`BlogID`),
  KEY `StaticTextID` (`StaticTextID`),
  CONSTRAINT `photoalbum_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `photoalbum_ibfk_2` FOREIGN KEY (`BlogID`) REFERENCES `blog` (`BlogID`),
  CONSTRAINT `photoalbum_ibfk_3` FOREIGN KEY (`StaticTextID`) REFERENCES `statictext` (`StaticTextID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `photoalbum` (`PhotoAlbumID`, `PhotoAlbumName`, `PhotoAlbumDescription`, `ProductID`, `BlogID`, `StaticTextID`) VALUES
(3,	'Trojka',	'trojka',	3,	NULL,	NULL),
(4,	'ctyrka',	'ctyrka',	4,	NULL,	NULL),
(11,	'Sony Ericsson Xperia Mini',	'<p style=\"margin: 0px 0px 0.5em; padding: 0px; line-height: 1.5em; word-wrap: break-word; color: #333333; font-family: \'Arial CE\', Arial, \'Helvetica CE\', Helvetica, sans-serif; font-size: small;\"><strong style=\"margin: 0px; padding: 0px;\">Mal&yacute; stylov&yacute; smartphone Sony Ericsson Xperia Mini</strong>&nbsp;se může pochlubit pěkn&yacute;m designem, mal&yacute;mi rozměry i velmi dobrou funkčn&iacute; v&yacute;bavou. Telefonu s operačn&iacute;m syst&eacute;mem Google Android 2.3 Gingerbrea',	13,	NULL,	NULL),
(12,	'Jackie Oh Organic - Decaf',	'',	14,	NULL,	NULL),
(13,	'Klatch Coffee',	'',	15,	NULL,	NULL),
(14,	'1000Faces Coffee - Bell\'s Blend',	'',	16,	NULL,	NULL),
(15,	'1000Faces Coffee - Espresso Neruda',	'',	17,	NULL,	NULL),
(16,	'Equator Coffees - Fair Trade Organic Alligato',	'',	18,	NULL,	NULL),
(17,	'Atomic Cafe - Black Velvet',	'',	19,	NULL,	NULL),
(18,	'Johnson Brothers - Black Earth Blend',	'',	20,	NULL,	NULL),
(19,	'PT\'s Coffee - Gizmo Blend',	'',	21,	NULL,	NULL),
(20,	'Klatch Coffee - Blue Thunder Blend',	'',	22,	NULL,	NULL),
(21,	'Novo Coffee - Espresso Del Fuego',	'',	25,	NULL,	NULL),
(22,	'Doma Coffee - Bella Luna - Decaf',	'',	26,	NULL,	NULL),
(23,	'Assam Mangalam FTGFOP1 CL SPL 10 g',	'',	27,	NULL,	NULL),
(24,	'Assam Black Tea',	'',	28,	NULL,	NULL),
(25,	'DILMAH WHITE LITCHEE NO.1 HAND ROLLLED',	'',	29,	NULL,	NULL),
(26,	'Klatch Coffee - Belle Espresso',	'',	30,	NULL,	NULL),
(27,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	'',	33,	NULL,	NULL),
(28,	'Doma Coffee - The Chronic - Organic',	'',	36,	NULL,	NULL),
(29,	'PT\'s Coffee - Flying Monkey Espresso',	'',	37,	NULL,	NULL),
(30,	'Tigerwalk Espresso',	'',	38,	NULL,	NULL);

DROP TABLE IF EXISTS `price`;
CREATE TABLE `price` (
  `PriceID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) DEFAULT NULL,
  `SellingPrice` float NOT NULL,
  `SALE` float DEFAULT '1',
  `FinalPrice` float NOT NULL,
  `CurrencyID` int(11) DEFAULT '1',
  PRIMARY KEY (`PriceID`),
  KEY `CurrencyID_idx` (`CurrencyID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `FKPriceCurrency` FOREIGN KEY (`CurrencyID`) REFERENCES `currency` (`CurrencyID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `price_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `price` (`PriceID`, `ProductID`, `SellingPrice`, `SALE`, `FinalPrice`, `CurrencyID`) VALUES
(3,	3,	15.99,	0,	15.99,	1),
(4,	4,	15000,	1500,	13500,	1),
(10,	13,	18,	0,	18,	1),
(11,	14,	17,	0,	17,	1),
(12,	15,	20,	0,	20,	1),
(13,	16,	10,	0,	10,	1),
(14,	17,	15,	0,	15,	1),
(15,	18,	13,	0,	13,	1),
(16,	19,	22,	0,	22,	1),
(17,	20,	10,	0,	10,	1),
(18,	21,	19,	0,	19,	1),
(19,	22,	12,	0,	12,	1),
(20,	23,	12,	0,	12,	1),
(21,	24,	25,	2.5,	22.5,	1),
(22,	25,	11,	0,	11,	1),
(23,	26,	18,	0,	18,	1),
(24,	27,	4,	0,	4,	1),
(25,	28,	30,	0,	30,	1),
(26,	29,	20,	0,	20,	1),
(27,	30,	13,	0,	13,	1),
(28,	31,	13,	0,	13,	1),
(29,	32,	30,	0,	30,	1),
(30,	33,	17,	0,	17,	1),
(31,	34,	17,	0,	17,	1),
(32,	35,	32,	0,	32,	1),
(33,	36,	15,	0,	15,	1),
(34,	37,	20,	0,	20,	1),
(35,	38,	12,	0,	12,	1),
(36,	39,	12,	0,	12,	1),
(37,	40,	29,	0,	29,	1);

DROP TABLE IF EXISTS `producer`;
CREATE TABLE `producer` (
  `ProducerID` int(11) NOT NULL AUTO_INCREMENT,
  `ProducerName` varchar(255) NOT NULL,
  PRIMARY KEY (`ProducerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `producer` (`ProducerID`, `ProducerName`) VALUES
(1,	'N/A'),
(2,	'Doma Coffee'),
(3,	'Klatch Coffee'),
(4,	'1000Faces Coffee'),
(5,	'Equator Coffees'),
(6,	'Select Producer'),
(7,	'Atomic Cafe'),
(8,	'Johnson Brothers'),
(9,	'PT\'s Coffee'),
(10,	'Novo Coffee'),
(11,	'Assam'),
(12,	'Dilmah');

DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `ProductID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(255) DEFAULT NULL,
  `ProductSeoName` varchar(255) DEFAULT NULL,
  `ProductVariants` int(11) DEFAULT NULL,
  `ProductVariantName` text,
  `ProducerID` int(11) DEFAULT NULL,
  `ProductNumber` varchar(255) DEFAULT NULL,
  `ProductShort` varchar(500) DEFAULT NULL,
  `ProductDescription` longtext,
  `ProductStatusID` int(11) NOT NULL DEFAULT '1',
  `ProductEAN` varchar(45) DEFAULT NULL,
  `ProductQR` varchar(45) DEFAULT NULL,
  `ProductWarranty` varchar(45) DEFAULT NULL,
  `PiecesAvailable` int(11) DEFAULT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `DateOfAvailable` date NOT NULL DEFAULT '0000-00-00',
  `ProductDateOfAdded` datetime NOT NULL,
  `Video` text,
  PRIMARY KEY (`ProductID`),
  KEY `CategoryID_idx` (`CategoryID`),
  KEY `ProductStatusID` (`ProductStatusID`),
  KEY `ProducerID` (`ProducerID`),
  KEY `ProductVariants` (`ProductVariants`),
  CONSTRAINT `FKProductCategory` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `product_ibfk_3` FOREIGN KEY (`ProductStatusID`) REFERENCES `productstatus` (`ProductStatusID`),
  CONSTRAINT `product_ibfk_4` FOREIGN KEY (`ProducerID`) REFERENCES `producer` (`ProducerID`),
  CONSTRAINT `product_ibfk_6` FOREIGN KEY (`ProductVariants`) REFERENCES `product` (`ProductID`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `product` (`ProductID`, `ProductName`, `ProductSeoName`, `ProductVariants`, `ProductVariantName`, `ProducerID`, `ProductNumber`, `ProductShort`, `ProductDescription`, `ProductStatusID`, `ProductEAN`, `ProductQR`, `ProductWarranty`, `PiecesAvailable`, `CategoryID`, `DateOfAvailable`, `ProductDateOfAdded`, `Video`) VALUES
(3,	'Ethiopia Yirgacheffe Kochere Gr 1',	'Ethiopia Yirgacheffe Kochere Gr 1',	NULL,	NULL,	1,	'',	'This lot of Yirgacheffe, or more specifically, Kochere is an exceptional example of what washed coffees from the region should taste like. This coffee is a non-auction lot coffee selected for us by our friends at BNT Coffee in Ethiopia. This is the first coffee of two which we will be offering this year from BNT.',	'<div style=\"text-align: left;\"><span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">We hope to have more direct, producer specific coffees with BNT in&nbsp;</span><span id=\"dots\" style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">the future, however this coffee is an outstanding example of what is to come. Enjoy! From CoffeeReview.Com Blind Assessment: Rich, zesty, bright. Night-blooming flowers, honey, lime, cinnamon in aroma and cup. Sweetly tart, bittersweet acidity; lively, lightly syrupy mouthfeel. Rather drying in the finish but profoundly flavor-saturated. Notes: Yirgacheffe is a coffee region in southern Ethiopia that produces distinctive coffees from traditional varieties of Arabica long grown in the region. Yirgacheffe coffees like this one processed by the wet or washed method (fruit skin and pulp are removed before drying) typically express great aromatic complexity and intensity with a particular emphasis on citrus and floral notes. Like virtually all Ethiopia coffees, this coffee is produced by villagers on small, garden plots interplanted with food and other subsistence crops. Temple is a quality-focused retail and wholesale specialty roaster active in Sacramento, California since 2005. Committed to sourcing, roasting and brewing the finest coffees, Temple features coffee from distinguished single estates and cooperatives around the world. Who Should Drink It: Those who enjoy the sweet, acidy brightness of a high-grown, light-roasted cup with an intense, original aromatic bonus.</span><br></div>',	3,	'',	'',	'',	98,	1003,	'0000-00-00',	'0000-00-00 00:00:00',	NULL),
(4,	'Costa Rica La Perla Del Cafe Red Honey',	'Costa Rica La Perla Del Cafe Red Honey',	NULL,	NULL,	5,	'',	'This spring we presented a special lot of SL28 variety coffee from Carlos Barrantes’ farm La Perla del Café. This is the second year in a row we are offering coffee from his farm and we are excited to expand our partnership with such a quality-minded coffee producer. ',	'<p><span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">In addition to the tiny plot of coveted SL28 variety coffee, there are larger plantings of Villa Sarchi, a variety</span><span id=\"dots\" style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">of coffee which naturally mutated from the Bourbon variety in Costa Rica over a half century ago. We secured two small lots of Villa Sarchi variety coffee from La Perla, each processed by different method. This lot was processed by the so-called Red Honey method, a variation of the honey or pulped natural process where a specific percentage of fruit mucilage is allowed to dry on the bean. To be classified as Red Honey (as opposed to yellow honey) the majority of fruit mucilage is left clinging to the bean after pulping. Because of the high percentage of mucilage, the beans take on a reddish cast during the drying stage. The flavor of this coffee is distinctly sweet and fruity, contrasting well with the Fully Washed version of Villa Sarchi we are offering from the same farm. We are happy to announce that Equator is the sloe roaster of this coffee! Although Carlos has been growing coffee for quite sometime, he only recently established his own micro mill, which he named La Perla del Café. Previously he used his family mill, La Planada. We asked if he would process a small lot of Red Honey coffee exclusively for Equator. This is the first lot he has processed using this method and we are very pleased with the results.</span><br></p>',	3,	'',	'',	'',	54,	1001,	'0000-00-00',	'0000-00-00 00:00:00',	NULL),
(13,	'Ardi Ethiopia',	'Ardi Ethiopia',	NULL,	NULL,	1,	'11111',	'In Sidamo, Ethiopia it is common to have dry-processed coffee that presents itself with a burst of flavor. But rarely is a particular coffee so sweet, so balanced and yet so clean. The Ardi is dry processed coffee (often referred to as natural processed), meaning the beans are dried with the coffee fruit still intact, allowing the natural flavors of the coffee cherry to soak into the bean.',	'<p><span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">The mill is managed carefully assuring the beans never touch the ground and are turned regularly to achieve even drying. This past year, Ryan had the opportunity to visit the cooperative and see the process first hand. He found the process to be quite meticulous; Ripe cherries are picked, and then dried on raised beds for the next 3 weeks. During the entire 3 weeks of drying, workers sort through the beds every single day, assuring that underipe coffee cherries don\'t make their way into the final product. During this time the coffee is raked constantly for even drying and also covered by tarps in the evening and when threatened by rain to assure the drying cycle is not disturbed. Since 2010 we have purchased the Ardi and it continues to be a huge hit. This year we are proud to be offering an exclusive small selection that was specially prepared just for us at Madcap from the Kercha Cooperative. Perfecting the dry processed coffee is certainly the focus at Kercha and that focus is apparent in the cup. We have found the Ardi from Kercha to offer a burst of flavor and aromatics containing strawberry, honey and milk chocolate.</span><br></p>',	2,	'123456',	'122',	'rok',	11,	1003,	'0000-00-00',	'0000-00-00 00:00:00',	NULL),
(14,	'Jackie Oh Organic - Decaf',	'Jackie Oh Organic - Decaf',	NULL,	NULL,	2,	'11111',	'This Swiss Water processed decaf offers a balance of deep aroma and medium body, with highlights of sweetness and acidity. Works well as both an espresso and drip coffee.',	'This Swiss Water processed decaf offers a balance of deep aroma and medium body, with highlights of sweetness and acidity. Works well as both an espresso and drip coffee.',	2,	'123456',	'122',	'rok',	10,	1003,	'0000-00-00',	'2013-09-12 20:28:20',	NULL),
(15,	'Klatch Coffee',	'Klatch Coffee',	NULL,	NULL,	3,	'11111',	'Awarded the World\'s Best Espresso on the planet, this coffee is the winner of the 2007 World Barista Championship in Tokyo, Japan. With over 40 countries pulling shots, this competition espresso won the top honor.',	'Awarded the World\'s Best Espresso on the planet, this coffee is the winner of the 2007 World Barista Championship in Tokyo, Japan. With over 40 countries pulling shots, this competition espresso won the top honor. Your first taste is chocolate and citrus with orange being the prominent citrus. Your second and final sip will turn syrupy sweet with wine like berry and spice adding to&nbsp;<span id=\"dots\">the mix. Strong enough to cut through the milk but so delicious you\'ll want to drink shot after shot of straight espresso. World\'s Best features three legendary beans, Brazil Yellow Bourbon, Sumatra Lake Tawar, and Ethiopian Natural. Each roasted separately then blended together for peak flavor. When run at 25 to 28 seconds, your first taste is chocolate and citrus with orange being the prominent citrus. Your second and final sip will turn syrupy sweet with wine like berry and spice adding to the mix. Strong enough to cut through milk but delicious as a straight espresso shot. Prepare with 20+ g double, 203 degrees, 1 oz each shot, 26-28 seconds,volume: 1.7 - 2.0 oz.</span>',	3,	'123456',	'122',	'rok',	100,	1004,	'0000-00-00',	'2013-09-12 20:36:44',	NULL),
(16,	'1000Faces Coffee - Bell\'s Blend',	'1000Faces Coffee - Bell\'s Blend',	NULL,	NULL,	4,	'11111',	'Named for our hero, bell hooks,( a writer who only writes in lower case letters) our medium/light roast House blend varies seasonally but is a mainstay on our menu. The bell’s blend is always the marriage of Latin American shade grown coffees from two distinct farms. These two combined roasts often elicit taste notes of fresh spread peanut butter and satisfying sweet chocolates. Light, whimsical, expressive, bright, alive and eye opening. The bell is our new school blend for the expressive coffe',	'Named for our hero, bell hooks,( a writer who only writes in lower case letters) our medium/light roast House blend varies seasonally but is a mainstay on our menu. The bell’s blend is always the marriage of Latin American shade grown coffees from two distinct farms. These two combined roasts often elicit taste notes of fresh spread peanut butter and satisfying sweet chocolates. Light, whimsical, expressive, bright, alive and eye opening. The bell is our new school blend for the expressive coffee aficionado.&nbsp;',	2,	'123456',	'122',	'rok',	1,	1004,	'0000-00-00',	'2013-09-12 20:42:04',	NULL),
(17,	'1000Faces Coffee - Espresso Neruda',	'1000Faces Coffee - Espresso Neruda',	NULL,	NULL,	4,	'11111',	'Espresso Neruda, our newest top shelf espresso blend, is named after poets Jan and Pablo Neruda. Created by marrying two seemingly disparate and faraway lands, this espresso will…',	'Espresso Neruda, our newest top shelf espresso blend, is named after poets Jan and Pablo Neruda. Created by marrying two seemingly disparate and faraway lands, this espresso will inspire you to simultaneously stage a coup, dance the tango of love, and pour forth your soul in a candle lit corner through volumes of scrawling sonnets. Satiny smooth, lusciously fruity and creamy, let us let you fall in love.&nbsp;',	2,	'123456',	'122',	'rok',	0,	1004,	'0000-00-00',	'2013-09-12 20:46:15',	NULL),
(18,	'Equator Coffees - Fair Trade Organic Alligator',	'Equator Coffees - Fair Trade Organic Alligator',	NULL,	NULL,	5,	'11111',	'French Roast is dark brown with lots of oil. Strong, smoky roast flavor dominates; bittersweet chocolate flavor is pronounced. Yields a rich mouth-feel with robust earth tones reminiscent of smoky tropical wood. Fortified by prune and walnut accents. French roasted coffees from Latin America, Indonesia and Africa yield a smoky yet fruity cup. \r\n',	'French Roast is dark brown with lots of oil. Strong, smoky roast flavor dominates; bittersweet chocolate flavor is pronounced. Yields a rich mouth-feel with robust earth tones reminiscent of smoky tropical wood. Fortified by prune and walnut accents. French roasted coffees from Latin America, Indonesia and Africa yield a smoky yet fruity cup.&nbsp;<span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\"></span><span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\"></span><br style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">',	1,	'123456',	'122',	'rok',	11,	1006,	'0000-00-00',	'2013-09-12 20:55:31',	NULL),
(19,	'Atomic Cafe - Black Velvet',	'Atomic Cafe - Black Velvet',	NULL,	NULL,	7,	'11111',	'A dark roasted Papua New Guinea, with its rich, hearty, full-bodied earthiness is complimented by a dark roasted Costa Rican for a super smooth, very rich cup that lingers on the palate. Enjoyable all day long ',	'A dark roasted Papua New Guinea, with its rich, hearty, full-bodied earthiness is complimented by a dark roasted Costa Rican for a super smooth, very rich cup that lingers on the palate. Enjoyable all day long&nbsp;',	2,	'123456',	'122',	'rok',	5,	1006,	'0000-00-00',	'2013-09-12 21:09:17',	NULL),
(20,	'Johnson Brothers - Black Earth Blend',	'Johnson Brothers - Black Earth Blend',	NULL,	NULL,	8,	'11111',	'Named as much for a local community as it is the land that grows the beans. This blend brings us back to the early days of Specialty Coffee; a robust flavor that reminds us of nights around a campfire sharing stories and laughs. Try this coffee and see what it\'s like to hang in our back yard. It\'s Fair Trade Certified and Organic. ',	'Named as much for a local community as it is the land that grows the beans. This blend brings us back to the early days of Specialty Coffee; a robust flavor that reminds us of nights around a campfire sharing stories and laughs. Try this coffee and see what it\'s like to hang in our back yard. It\'s Fair Trade Certified and Organic.&nbsp;',	2,	'123456',	'122',	'rok',	200,	1006,	'0000-00-00',	'2013-09-12 21:14:49',	NULL),
(21,	'PT\'s Coffee - Gizmo Blend',	'PT\'s Coffee - Gizmo Blend',	NULL,	NULL,	9,	'11111',	'This inspired blend is dark roasted and features a rich flavor with heavy chocolate notes and a bold finish that stands up in milk. ',	'This inspired blend is dark roasted and features a rich flavor with heavy chocolate notes and a bold finish that stands up in milk.&nbsp;',	2,	'123456',	'122',	'rok',	20,	1006,	'0000-00-00',	'2013-09-12 21:27:48',	NULL),
(22,	'Klatch Coffee - Blue Thunder Blend',	'Klatch Coffee - Blue Thunder Blend',	NULL,	NULL,	3,	'11111',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong. ',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong.&nbsp;',	1,	'123456',	'122',	'rok',	11,	1007,	'0000-00-00',	'2013-09-12 21:39:35',	NULL),
(23,	'Klatch Coffee - Blue Thunder Blend',	'Klatch Coffee - Blue Thunder Blend',	22,	'Blue Thunder Blend - 2 lbs.',	3,	'11111',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong. ',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong.&nbsp;',	1,	'123456',	'122',	'rok',	1,	1007,	'0000-00-00',	'2013-09-12 21:43:01',	NULL),
(24,	'Klatch Coffee - Blue Thunder Blend',	'Klatch Coffee - Blue Thunder Blend',	22,	'Blue Thunder Blend - 5 lbs.',	3,	'11111',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong. ',	'A strong, rich cup with characteristic smokey, sweet tones. A full bodied cup resulting from a combination of our French Roast cut with a full city roast Sumatra Blue Lintong.&nbsp;',	1,	'123456',	'122',	'rok',	1,	1007,	'0000-00-00',	'2013-09-12 21:43:17',	NULL),
(25,	'Novo Coffee - Espresso Del Fuego',	'Novo Coffee - Espresso Del Fuego',	NULL,	NULL,	10,	'11111',	'One of Novo\'s first espresso blends has been re-introduced! Our darkest roast profile, this is a good choice for those making a transition from dark over-roasted coffees to ones with a little more nuance. I guess we could call it our gateway drug. ',	'One of Novo\'s first espresso blends has been re-introduced! Our darkest roast profile, this is a good choice for those making a transition from dark over-roasted coffees to ones with a little more nuance. I guess we could call it our gateway drug.&nbsp;',	2,	'123456',	'122',	'rok',	40,	1007,	'0000-00-00',	'2013-09-12 22:00:46',	NULL),
(26,	'Doma Coffee - Bella Luna - Decaf',	'Doma Coffee - Bella Luna - Decaf',	NULL,	NULL,	2,	'11111',	'This Swiss Water processed decaf offers all the flavors of our signature blends without the caffeine. It has a full body, creamy with a slight caramel flavor. This blend is excellent both as an espresso or drip coffee. \r\n',	'This Swiss Water processed decaf offers all the flavors of our signature blends without the caffeine. It has a full body, creamy with a slight caramel flavor. This blend is excellent both as an espresso or drip coffee.&nbsp;<span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\"></span><span style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\"></span><br style=\"color: rgb(62, 30, 18); font-family: georgia, arial, verdana, sans-serif; font-size: 16px; background-color: rgb(255, 255, 255);\">',	2,	'123456',	'122',	'rok',	99,	1008,	'0000-00-00',	'2013-09-12 22:05:46',	NULL),
(27,	'Assam Mangalam FTGFOP1 CL SPL 10 g',	'Assam Mangalam FTGFOP1 CL SPL 10 g',	NULL,	NULL,	11,	'11111',	'Tea from one of the finest gardens in Assamu. Black tickets are carefully collected from Panitola clones, which are characterized by a high content of golden tipsů.Ve aroma is…',	'<div>Tea from one of the finest gardens in Assamu. Black tickets are carefully collected from Panitola clones, which are characterized by a high content of golden tipsů.Ve aroma is dominated by ripe plums, the taste is pleasantly sweet tea to cream. Lot OR349/12.</div><div><br></div><div>Preparation: Pour boiling water for tea in a ratio of 1.5 dl to 1 teaspoon if lye tea in the teapot then plus 1 teaspoon of the teapot. Allow 3-5 minutes to infuse. Then strain the. Can be prepared 1 infusion.</div>',	2,	'123456',	'122',	'rok',	9,	1011,	'0000-00-00',	'2013-09-12 22:11:59',	NULL),
(28,	'Assam Black Tea',	'Assam Black Tea',	NULL,	NULL,	11,	'11111',	'Assam Black Leaf Black Tea Assam tea leaves Ingredients: pure black tea from India and Indonesia Instructions for preparation: To prepare the tea, always use fresh water. Do čajovékonvice to 6 cups of tea (about 1 liter) warm by rinsing with hot water vložíme3-4 teaspoon of loose tea and pour fresh boiling water. Alkalis 3-4 minutes. Weight: 125 g',	'Assam Black Leaf Black Tea Assam tea leaves Ingredients: pure black tea from India and Indonesia Instructions for preparation: To prepare the tea, always use fresh water. Do čajovékonvice to 6 cups of tea (about 1 liter) warm by rinsing with hot water vložíme3-4 teaspoon of loose tea and pour fresh boiling water. Alkalis 3-4 minutes. Weight: 125 g',	2,	'123456',	'122',	'rok',	100,	1011,	'0000-00-00',	'2013-09-12 22:17:04',	NULL),
(29,	'DILMAH WHITE LITCHEE NO.1 HAND ROLLLED',	'DILMAH WHITE LITCHEE NO.1 HAND ROLLLED',	NULL,	NULL,	12,	'11111',	'Dilmah teas are packaged on site within a few days after the manual collection of fresh tea leaves from our own tea plantations in order to maintain freshness and flavor. This 100% natural, genuine Ceylon tea has a rich content of beneficial antioxidants to support a healthy lifestyle.\r\n',	'<p style=\"margin: 0px 0px 1.25em;\">Dilmah teas are packaged on site within a few days after the manual collection of fresh tea leaves from our own tea plantations in order to maintain freshness and flavor. This 100% natural, genuine Ceylon tea has a rich content of beneficial antioxidants to support a healthy lifestyle.</p><div>Dilmah is a family company founded on moral principles, can make its customers by offering the best tea in the world and farmers fair compensation. The teas are packed at source and marketed under the brand Dilmah.<br></div>',	1,	'123456',	'122',	'rok',	3,	1011,	'0000-00-00',	'2013-09-12 22:19:52',	NULL),
(30,	'Klatch Coffee - Belle Espresso',	'Klatch Coffee - Belle Espresso',	NULL,	NULL,	3,	'11111',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flowers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. In',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flo<span id=\"dots\">wers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. Intense aroma: brandy, chocolate, caramel. I would add hint of berry and great crema.</span>',	2,	'123456',	'122',	'rok',	17,	1009,	'0000-00-00',	'2013-09-12 22:26:58',	NULL),
(31,	'Klatch Coffee - Belle Espresso',	'Klatch Coffee - Belle Espresso',	30,	'Belle Espresso - 2 lbs.',	3,	'11111',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flowers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. In',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flo<span id=\"dots\">wers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. Intense aroma: brandy, chocolate, caramel. I would add hint of berry and great crema.</span>',	1,	'123456',	'122',	'rok',	1,	1009,	'0000-00-00',	'2013-09-12 22:29:19',	NULL),
(32,	'Klatch Coffee - Belle Espresso',	'Klatch Coffee - Belle Espresso',	30,	'Belle Espresso - 5 lbs.',	3,	'11111',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flowers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. In',	'A high scoring Espresso! Our Belle is the highest rated espresso blend ever with a \"94\" by cupping taste guru Kenneth Davids of coffee review. For this tasting Ken tried 40 espressos and rated over 30. In the small cup medium in body but smooth in mouth feel, crisply pungent yet caramelly sweet, with a tightly knit, understated complexity: Brandy, chocolate, caramel, cedar and flo<span id=\"dots\">wers, hints of which persist in the roundly rich finish. Masters milk with a gentle, brandied chocolate authority. Intense aroma: brandy, chocolate, caramel. I would add hint of berry and great crema.</span>',	1,	'123456',	'122',	'rok',	14,	1009,	'0000-00-00',	'2013-09-12 22:29:36',	NULL),
(33,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	'Equator Coffees - Ad Hoc - Chef\'s Blend',	NULL,	NULL,	5,	'11111',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents. ',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents.&nbsp;',	1,	'123456',	'122',	'rok',	8,	1009,	'0000-00-00',	'2013-09-12 22:30:45',	NULL),
(34,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	'Equator Coffees - Ad Hoc - Chef\'s Blend',	33,	'Ad Hoc - Chef\'s Blend - 2 lbs.',	5,	'11111',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents. ',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents.&nbsp;',	1,	'123456',	'122',	'rok',	11,	1009,	'0000-00-00',	'2013-09-12 22:32:54',	NULL),
(35,	'Equator Coffees - Ad Hoc - Chef\'s Blend',	'Equator Coffees - Ad Hoc - Chef\'s Blend',	33,	'Ad Hoc - Chef\'s Blend - 5 lbs.',	5,	'11111',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents. ',	'Creating a coffee blend for a chef like Thomas Keller is a fascinating process and a once-in-lifetime opportunity. Chef\'s Goal: Design a blend of light roasted coffees that unfold gently in the cup, emphasizing sweetness and body. The result: An overlay of fruit is buttressed by a mellow base of earth-toned coffees with almond accents.&nbsp;',	1,	'123456',	'122',	'rok',	111,	1009,	'0000-00-00',	'2013-09-12 22:33:17',	NULL),
(36,	'Doma Coffee - The Chronic - Organic',	'Doma Coffee - The Chronic - Organic',	NULL,	NULL,	2,	'11111',	'The Chronic is a blend of coffees from our producer partners in Central and South America. It is 100% Certified Organic (yes, certified!), Fair Trade and roasted to perfection right here at DOMA with Bob Marley playing on the turntable. It is a slightly darker roast which, not suprisingly, finishes at a temperature of 420°F on our Loring Smartroast. Hot umber fuel to re-whiten the reddest of eyes, The Chronic warms the palate and the tummy with hints of cocoa and walnut with a concise, smooth fi',	'The Chronic is a blend of coffees from our producer partners in Central and South America. It is 100% Certified Organic (yes, certified!), Fair Trade and roasted to perfection right here at DOMA with Bob Marley playing on the turntable. It is a slightly darker roast which, not suprisingly, finishes at a temperature of 420°F on our Loring Smartroast. Hot umber fuel to re-whiten th<span id=\"dots\">e reddest of eyes, The Chronic warms the palate and the tummy with hints of cocoa and walnut with a concise, smooth finish, with hints of remembering the previous evening. Great as an espresso or in drip preparations.</span>',	2,	'123456',	'122',	'rok',	11,	1010,	'0000-00-00',	'2013-09-12 22:43:36',	NULL),
(37,	'PT\'s Coffee - Flying Monkey Espresso',	'PT\'s Coffee - Flying Monkey Espresso',	NULL,	NULL,	9,	'11111',	'This espresso is extremely balanced, but playful, ranging from a deep cocoa and cardamom body to a candied, clementine sweetness. The components marry together to create a beautiful harmony of flavors while still having enough depth to play nicely with milk. Flying Monkey was conjured out of experimentation and curiosity. When you have numerous exceptional coffees at your fingertips, you cannot help but play with the possibilities. Flying Monkey is a striking blend with a lot of versatility. Muc',	'This espresso is extremely balanced, but playful, ranging from a deep cocoa and cardamom body to a candied, clementine sweetness. The components marry together to create a beautiful harmony of flavors while still having enough depth to play nicely with milk. Flying Monkey was conjured out of experimentation and curiosity. When you have numerous exceptional coffees at your fingertips<span id=\"dots\">, you cannot help but play with the possibilities. Flying Monkey is a striking blend with a lot of versatility. Much like its fictional counterparts, it is incredibly adaptable and can be enjoyed in almost every setting. Whether you are looking for a straight shot or something that will pair well with a milkier beverage, Flying Monkey is sure to please. FOR ESPRESSO: We use a dose of approximately 20 grams with an extraction time of 24-27 seconds for a double shot.</span>',	2,	'123456',	'122',	'rok',	15,	1010,	'0000-00-00',	'2013-09-12 22:50:56',	NULL),
(38,	'Tigerwalk Espresso',	'Tigerwalk Espresso',	NULL,	NULL,	5,	'11111',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	3,	'123456',	'122',	'rok',	9,	1010,	'0000-00-00',	'2013-09-12 22:58:47',	NULL),
(39,	'Tigerwalk Espresso',	'Tigerwalk Espresso',	38,	'Tigerwalk Espresso - 2 lbs.',	5,	'11111',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	1,	'123456',	'122',	'rok',	9,	1010,	'0000-00-00',	'2013-09-12 23:01:09',	NULL),
(40,	'Tigerwalk Espresso',	'Tigerwalk Espresso',	38,	'Tigerwalk Espresso - 5 lbs.',	5,	'11111',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	'Served at Redd, Chef Richard Reddington\'s famed Napa Valley restaurant. A balanced, sweet and creamy espresso that features notes of cherry-toned chocolate, strawberries and a lemon-toned effervescence. In an effort to satisfy the emerging preference for lighter roasted and more fruit forward flavors in espresso, our roasting team collaborated to design this tartly sweet espresso blend.',	1,	'123456',	'122',	'rok',	5,	1010,	'0000-00-00',	'2013-09-12 23:01:22',	NULL);

DROP TABLE IF EXISTS `productstatus`;
CREATE TABLE `productstatus` (
  `ProductStatusID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductStatusName` varchar(100) NOT NULL,
  `ProductStatusDescription` varchar(255) NOT NULL,
  PRIMARY KEY (`ProductStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `productstatus` (`ProductStatusID`, `ProductStatusName`, `ProductStatusDescription`) VALUES
(1,	'Concept',	'This product is in stae: Concept'),
(2,	'Visible',	'This product is visible'),
(3,	'Featured',	'Featured product');

DROP TABLE IF EXISTS `productvariants`;
CREATE TABLE `productvariants` (
  `VariantID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) NOT NULL,
  `VariantName` text COLLATE utf8_czech_ci,
  `AttribID` int(11) NOT NULL,
  `Val` int(11) NOT NULL,
  `UnitID` int(11) NOT NULL,
  PRIMARY KEY (`VariantID`),
  KEY `ProductID` (`ProductID`),
  KEY `AttribID` (`AttribID`),
  KEY `Val` (`Val`),
  KEY `UnitID` (`UnitID`),
  CONSTRAINT `productvariants_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `productvariants_ibfk_2` FOREIGN KEY (`AttribID`) REFERENCES `attrib` (`AttribID`),
  CONSTRAINT `productvariants_ibfk_3` FOREIGN KEY (`Val`) REFERENCES `attrib` (`AttribID`),
  CONSTRAINT `productvariants_ibfk_4` FOREIGN KEY (`UnitID`) REFERENCES `unit` (`UnitID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;


DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `SettingID` int(11) NOT NULL AUTO_INCREMENT,
  `SettingName` varchar(100) NOT NULL,
  `Value` varchar(255) NOT NULL,
  PRIMARY KEY (`SettingID`),
  UNIQUE KEY `Name` (`SettingName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `settings` (`SettingID`, `SettingName`, `Value`) VALUES
(1,	'ShopLayout',	'default'),
(2,	'Description',	'Ecommerce 2.0 that works almost automatically.'),
(3,	'HomepageLayout',	'default'),
(4,	'Logo',	'logo (1).png'),
(5,	'Name',	'Birneshop DEMOtime'),
(6,	'ProductLayout',	'default'),
(7,	'TAX',	'20'),
(8,	'OrderMail',	'luk.danek@gmail.com'),
(9,	'ContactMail',	'jiri.kifa@gmail.com'),
(10,	'ContactPhone',	'+420333444'),
(11,	'CompanyAddress',	'Zdice 18, U hřibitova 34567'),
(12,	'InvoicePrefix',	'i-2013'),
(13,	'ProductMiniLayout',	'fourinline'),
(14,	'GA',	'UA-42741537-1'),
(15,	'ShopURL',	'http://localhost'),
(27,	'zasilkovnaAPI',	'66fbbe30bb36aee4'),
(28,	'zasilkovnaID',	'353'),
(29,	'Salt',	'Salt'),
(30,	'gapiAPI',	'4/BdPpTGmoBcA6YXzCNLQrKDIHfTd6.Qi927urqOpsVOl05ti8ZT3axvvIhgQI'),
(31,	'gapiTOKEN',	'{\"access_token\":\"ya29.AHES6ZRUGTx_HsylhCX4s5f4W-d2Rn2HS3I2c8kvdTi2y1L1Kglrsobd\",\"token_type\":\"Bearer\",\"expires_in\":3600,\"refresh_token\":\"1\\/gWO9VgJWOC1YngESadNHDhAFsO2YioYyGFcc3mTY6Uw\",\"created\":1376821668}'),
(32,	'bankwireID',	'7'),
(33,	'Account',	''),
(34,	'slider',	'unnamed.png'),
(35,	'TopMenu',	'Category'),
(36,	'SideMenu',	'Category'),
(37,	'FooterMenu',	'Info'),
(38,	'Style',	'');

DROP TABLE IF EXISTS `statictext`;
CREATE TABLE `statictext` (
  `StaticTextID` int(11) NOT NULL AUTO_INCREMENT,
  `StaticTextName` varchar(100) COLLATE utf8_czech_ci NOT NULL,
  `StaticTextContent` text COLLATE utf8_czech_ci NOT NULL,
  `StatusID` int(11) NOT NULL DEFAULT '2',
  PRIMARY KEY (`StaticTextID`),
  KEY `StatusID` (`StatusID`),
  CONSTRAINT `statictext_ibfk_1` FOREIGN KEY (`StatusID`) REFERENCES `status` (`StatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

INSERT INTO `statictext` (`StaticTextID`, `StaticTextName`, `StaticTextContent`, `StatusID`) VALUES
(1,	'Terms and condition',	'<p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Bouřkové pásmo spojené se silnými nárazy větru a místy i přívalovými dešti a kroupami po půlnoci přešlo přes střední Čechy a Ústecký kraj do kraje Libereckého.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">\"V okresu Hradec Králové se vyskytují velmi silné bouřky provázené krupobitím.<br>&nbsp;Bouřky postupují směrem k severovýchodu a v následujících hodinách postoupí<br>do okresů Trutnov a Náchod,\" varovali meteorologové v pátek ráno před půl sedmou.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Při bouřkách lidem hrozí&nbsp;zranění ulomenými větvemi a zásah bleskem.&nbsp;Těch bylo na obloze nejvíce hned na počátku, ve čtvrtek mezi 18. a&nbsp;19. hodinou. Tehdy byly bouřky na jihozápadě republiky a<a href=\"http://www.chmi.cz/\" target=\"_blank\" style=\"color: rgb(19, 55, 94);\">Český hydrometeorologický ústav</a>zaznamenal intenzitu až 156 blesků za minutu.</p><div class=\"imagelist imagelist-sp5 not4bbtext\" style=\"zoom: 1; margin: 0px 0px 0.5em; font-size: small; font-family: Arial, Helvetica, sans-serif; background-color: rgb(225, 225, 225);\"><div class=\"cell cell-first\" style=\"float: left; margin-left: 22px; width: 172px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c033e_mapa0023.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c033e_mapa0023.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 22px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c0340_mapa0024.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c0340_mapa0024.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 22px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c0336_mapa0001.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c0336_mapa0001.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"fc0\" style=\"overflow: hidden; clear: both; float: none; line-height: 0; margin: 0px; padding: 0px; font-size: 0px; height: 0px;\"></div></div><div class=\"imagelist imagelist-sp5 not4bbtext\" style=\"zoom: 1; margin: 0px 0px 0.5em; font-size: small; font-family: Arial, Helvetica, sans-serif; background-color: rgb(225, 225, 225);\"><div class=\"cell cell-first\" style=\"float: left; margin-left: 22px; width: 172px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c0336_mapa0002.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c0336_mapa0002.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 22px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c0337_mapa0003.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c0337_mapa0003.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 22px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c0337_mapa0004.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c0337_mapa0004.jpg\" width=\"172\" height=\"129\" alt=\"Přehled srážek v noci na pátek 21. června\" title=\"Přehled srážek v noci na pátek 21. června\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"fc0\" style=\"overflow: hidden; clear: both; float: none; line-height: 0; margin: 0px; padding: 0px; font-size: 0px; height: 0px;\"></div><p style=\"margin: 0px; padding: 0.3em 0px 0px; clear: both; line-height: 1.33; font-size: 12px; color: rgb(102, 102, 102);\">Na mapách z ČHMÚ je vidět postup bouřek v noci na 21. června</p><div class=\"fc0\" style=\"overflow: hidden; clear: both; float: none; line-height: 0; margin: 0px; padding: 0px; font-size: 0px; height: 0px;\"></div></div><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">\"Druhá vlna přišla po půlnoci, trvala několik hodin a intenzita byla kolem 50 blesků za minutu. Kolem sedmé hodiny ráno, kdy byly bouřky&nbsp;na Liberecku, byla intenzita 60 blesků za minutu,\" řekl iDNES.cz mluvčí Českého hydrometeorologického ústavu Petr Dvořák.&nbsp;Za&nbsp;patnáct hodin, počínaje čtvrteční osmnáctou hodinou, zaznamenali meteorologové na území republiky 10 914 blesků.</p><h3 class=\"tit not4bbtext\" id=\"--padaly-kroupy-i-stromy\" style=\"margin: 0px; padding: 0px; font-size: 1em; font-weight: 400; font-family: Arial, Helvetica, sans-serif; line-height: 15px; background-color: rgb(225, 225, 225);\">Padaly kroupy i stromy</h3><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Už v podvečer bouřky silně zasáhly<b>Karlovarský kraj</b>.&nbsp;\"Ze všech okresů Karlovarského kraje máme hlášeny velmi silné bouřky. Evidujeme také nárazy větru a srážkové úhrny kolem 10&nbsp;mm, v ojedinělých případech dokonce 25 mm. Místy jsou srážky doprovázeny kroupami,\" uvedl pro iDNES.cz Josef Hanzlík z ČHMÚ.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Hasiči v Karlovarském kraji celkem vyjížděli k 75 událostem, odstraňovali padlé stromy, odčerpávali vodu i zachraňovali zvířata. Podle mluvčího krajských hasičů Martina Kasala největší problémy způsobily rozlité malé potoky nebo voda, která stekla z kopců.</p><table id=\"--konec-veder\" class=\"complete complete-half-r not4bbtext\" style=\"margin: 0px 0px 0.5em 10px; padding: 0px; font-size: 12px; position: relative; width: 192px; border: 0px; border-collapse: collapse; border-top-left-radius: 6px; border-top-right-radius: 6px; border-bottom-right-radius: 6px; border-bottom-left-radius: 6px; line-height: 15px; background-color: rgb(238, 238, 238); float: right; font-family: Arial, Helvetica, sans-serif;\"><tbody><tr><td style=\"margin: 0px; padding: 10px 10px 3px;\"><h3 style=\"margin: 0px 0px 0.1em; padding: 0px; font-size: 20px; color: rgb(185, 21, 28);\">Konec veder</h3><p class=\"title\" style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 16px; font-weight: 700; color: rgb(70, 70, 70);\">Bouřky přišly po vedrech, které přepisovaly rekordy</p><div><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><b>PONDĚLÍ:&nbsp;</b><a href=\"http://zpravy.idnes.cz/padaji-rekordni-teploty-0wt-/domaci.aspx?c=A130617_163831_domaci_cen\" style=\"color: rgb(19, 55, 94);\">Začalo to třicítkami</a></p><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><b>ÚTERÝ:</b>&nbsp;<a href=\"http://zpravy.idnes.cz/pocasi-vysoke-teploty-teplotni-rekordy-fd2-/domaci.aspx?c=A130618_150258_domaci_mzi\" style=\"color: rgb(19, 55, 94);\">Klementinum má nový rekord</a></p><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><b>STŘEDA:&nbsp;</b><a href=\"http://zpravy.idnes.cz/teplotni-rekordy-klementinum-dkt-/domaci.aspx?c=A130619_165448_domaci_mzi\" style=\"color: rgb(19, 55, 94);\">Bylo 35,5 stupně</a></p><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><b>ČTVRTEK:&nbsp;</b><a href=\"http://zpravy.idnes.cz/teplotni-rekordy-ve-ctvrtek-dg2-/domaci.aspx?c=A130620_165158_domaci_ert\" style=\"color: rgb(19, 55, 94);\">Ve stínu bylo až 38 stupňů</a></p><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><b>PŘEDPOVĚĎ:&nbsp;</b><a href=\"http://zpravy.idnes.cz/predpoved-pocasi-pro-tyden-od-20-cervna-dxz-/domaci.aspx?c=A130620_074906_domaci_jpl\" style=\"color: rgb(19, 55, 94);\">Bude o 20 stupňů méně</a></p></div></td></tr></tbody></table><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">\"V první polovině noci, asi od 18:00 do 22:00, jsme jezdili hlavně ke spadaným stromům, které zablokovaly silnice. Později zase převažovalo odčerpávání z domů a sklepů,\" uvedl Kasal.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Nejhorší situace byla na Kynšpersku. V Lítově voda vyplavila halu firmy i penzion, v Nebanicích přívaly vod nezvládala kanalizace a voda vyhazovala kanálové poklopy.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">\"V Chotíkově a Liboci voda zaplavila návsi, bylo tam až metr vody,\" popsal Kasal. Hasiči tam museli na člunech zachraňovat domácí zvířata. \"Lidé se stihli dostat pryč, ale pro zvířata jsme museli na člunech. Asi polovinu se podařilo zachránit,\" uvedl Kasal.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Ve Stebnici u Lipové na Chebsku potok hrozil odříznutím dětského tábora. Hasiči proto celý tábor s 21 dětmi evakuovali do základní školy v Lipové. Krajem se okolo 4:45 přehnala druhá vlna bouře. Ačkoli ji také doprovázely blesky a silný déšť, větší škody už nenapáchala.&nbsp;</p><table id=\"--fotogalerie\" class=\"complete  not4bbtext\" style=\"margin: 0px 0px 1em; padding: 0px; font-size: 12px; position: relative; width: 560px; border: 0px; border-collapse: collapse; border-top-left-radius: 6px; border-top-right-radius: 6px; border-bottom-right-radius: 6px; border-bottom-left-radius: 6px; line-height: 15px; background-color: rgb(238, 238, 238); font-family: Arial, Helvetica, sans-serif;\"><tbody><tr><td style=\"margin: 0px; padding: 10px 10px 3px;\"><h3 style=\"margin: 0px 0px 0.1em; padding: 0px; font-size: 20px; color: rgb(185, 21, 28);\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert\" style=\"color: rgb(185, 21, 28); text-decoration: none;\">Fotogalerie</a></h3><div><div class=\"imagelist imagelist-sp5 not4bbtext\" style=\"zoom: 1; margin: 0px 0px 0.5em; font-size: small;\"><div class=\"cell cell-first\" style=\"float: left; margin-left: 12px; width: 172px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c02e8_20136DB3B3B4E18D88F4DCC94B5688BAFA2A.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c02e8_20136DB3B3B4E18D88F4DCC94B5688BAFA2A.jpg\" width=\"172\" height=\"129\" alt=\"Blesky v Lysé nad Labem\" title=\"Blesky v Lysé nad Labem\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 12px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c02e6_201326507345ED6283E28E1578036CFF5B21.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c02e6_201326507345ED6283E28E1578036CFF5B21.jpg\" width=\"172\" height=\"129\" alt=\"Blesky nad Olšanským náměstím v Praze\" title=\"Blesky nad Olšanským náměstím v Praze\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"cell\" style=\"float: left; width: 172px; margin-left: 12px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert&amp;foto=SKR4c033b_2013BC7B5356A24971D7B8DDAAA342CEC496.jpg\" style=\"color: rgb(19, 55, 94);\"><img src=\"http://oidnes.cz/13/063/sp5/SKR4c033b_2013BC7B5356A24971D7B8DDAAA342CEC496.jpg\" width=\"172\" height=\"129\" alt=\"Bouřka v Jiřetíně nad Jedlovou\" title=\"Bouřka v Jiřetíně nad Jedlovou\" style=\"border: 0px; vertical-align: middle;\"></a></div><div class=\"fc0\" style=\"overflow: hidden; clear: both; float: none; line-height: 0; margin: 0px; padding: 0px; font-size: 0px; height: 0px;\"></div></div><p style=\"margin: 0px 0px 0.5em; padding: 0px; font-size: 14px;\"><a href=\"http://zpravy.idnes.cz/foto.aspx?r=domaci&amp;c=A130620_185733_domaci_ert\" style=\"color: rgb(19, 55, 94);\">Zobrazit fotogalerii</a></p></div></td></tr></tbody></table><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Silná bouřka přešla také okolím<b>Rokycan v Plzeňském kraji</b>. Místní uvedli, že spolu s deštěm tam zaznamenali také kroupy o průměru až tři centimetry. Region pak hlásí také rozbité skleníky a poničené střechy několika automobilů. Přívaly vody zde naštěstí zatím nezpůsobily žádné bleskové povodně.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Bouřky&nbsp;směřovaly na severovýchod přes Chebsko, Sokolovsko a Karlovarsko. Velmi silné bouřky pak v noci zasáhly také Ústecký&nbsp;nebo Liberecký kraj.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Kolem půlnoci dorazila bouřka do Prahy a&nbsp;pak pokračovala přes Mělnicko, Mladoboleslavsko.<b>Středočeští</b>hasiči vyjížděli ke 40 výjezdům, blesk udeřil do domu na Kladensku a zapálil střechu.</p><h3 class=\"tit not4bbtext\" id=\"--voda-a-kroupy-zastavily-dopravu\" style=\"margin: 0px; padding: 0px; font-size: 1em; font-weight: 400; font-family: Arial, Helvetica, sans-serif; line-height: 15px; background-color: rgb(225, 225, 225);\">Voda a kroupy zastavily dopravu</h3><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Podle webu Českých drah musel být před 20. hodinou zastaven provoz na železnici v úseku mezi Tršnicí a Kynšperkem nad Ohří, kde byla podemletá trať a poškozené trakční vedení. Vlaky byly nahrazeny autobusovou dopravou, opravy by měly trvat asi dva dny.</p><div class=\"catchbox-l catchbox-vn not4bbtext\" style=\"position: relative; width: 192px; font-size: 12px; line-height: 15px; float: left; margin: 0px 15px 0.5em -70px; background-color: rgb(245, 245, 245); font-family: Arial, Helvetica, sans-serif;\"><div class=\"bg1\" style=\"background-image: url(http://gidnes.cz/u/n4/box-edge.png); background-position: initial initial; background-repeat: no-repeat no-repeat;\"><div class=\"bg2\" style=\"background-image: url(http://gidnes.cz/u/n4/box-edge.png); padding: 10px; background-position: -192px 100%; background-repeat: no-repeat no-repeat;\"><h3 style=\"margin: 0px 0px 0.6em; padding: 0px; font-size: 20px; color: rgb(185, 21, 28);\">Posílejte fotky a videa</h3><p style=\"margin: 0px 0px 1em; padding: 0px; font-size: 14px;\">Nafotili jste řádění bouřky?</p><p style=\"margin: 0px 0px 1em; padding: 0px; font-size: 14px;\"><b>Pošlete své záběry do rubriky&nbsp;<a href=\"http://zpravy.idnes.cz/ocima-ctenaru.asp\" style=\"color: rgb(19, 55, 94);\">Očima čtenářů</a>.</b></p><p class=\"f92\" style=\"margin: 0px 0px 1em; padding: 0px; font-size: 11px; color: rgb(102, 102, 102);\">Použité fotografie či videa odměníme honorářem. Podmínky použití fotografií a videozáznamů<a href=\"http://www.idnes.cz/pravidla\" style=\"color: rgb(19, 55, 94);\">najdete zde</a>.</p></div></div></div><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Večer spadly stromy na dvě regionální trati v Plzeňském kraji. Úseky z Kasejovic do Blatné a z Třemešné pod Přimdou do Bělé nad Radbuzou se podařilo po půlnoci zprovoznit.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Stromy padaly i na silnice, kolem půlnoci to bylo zejména na Lounsku, Chomutovsku, Kladensku a Českolipsku, vyplývá z informací policejního dopravního webu.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Na křižovatce u Horšovského Týna na Domažlicku silnici zaplavil proud vody o výšce asi 30 centimetrů, v Odravě na Chebsku musel být uzavřen zaplavený podjezd pod rychlostní silnicí R5. Na Sokolovsku voda zaplavila vozovku u obcí Dolní Nivy a Jindřichovice, u Kaceřova se na silnici sesunul svah.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Některé silnice jsou kvůli popadaným stromům neprůjezdné i ráno.&nbsp;Například na Lounsku silnice&nbsp;239&nbsp;mezi Slavětínem a Perucí nebo silnice 227 u obce Holedec.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Podle Radiožurnálu hasiči na Žatecku a Děčínsku vyjížděli k popadaným stromům, poškozeným střechám a uvolněné krytině. Kvůli silnému dešti musel být evakuován kemp v Lipové u Chebu. Místní potok se rozlil a hrozilo zatopení chatek.</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Vlna bouřek by měla udělat definitivní tečku za extrémními horky, které sužovaly Česko v uplynulých dnech. Na mnoha místech ve čtvrtek padaly i stoleté teplotní rekordy (<a href=\"http://zpravy.idnes.cz/teplotni-rekordy-ve-ctvrtek-dg2-/domaci.aspx?c=A130620_165158_domaci_ert\" style=\"color: rgb(19, 55, 94);\">více o nich čtěte zde</a>).</p><p style=\"margin: 0px; padding: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 12px; line-height: 15px; background-color: rgb(225, 225, 225);\">Zdroj:<a href=\"http://zpravy.idnes.cz/bourky-v-cesku-0pl-/domaci.aspx?c=A130620_185733_domaci_ert\" style=\"color: rgb(19, 55, 94);\">http://zpravy.idnes.cz/bourky-v-cesku-0pl-/domaci.aspx?c=A130620_185733_domaci_ert</a></p>',	1),
(2,	'About us',	'<p style=\"text-align: left; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ut purus feugiat, tincidunt nibh nec, faucibus massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed pulvinar risus quis diam tempor volutpat quis non lacus. Donec ullamcorper pellentesque lacinia. Integer lobortis tortor nec elit adipiscing suscipit. Nulla nec dolor ac lacus facilisis mollis at eu risus. Etiam ac congue mi. Nam nec malesuada lorem, a interdum risus. Aliquam at tellus ac nulla sodales&nbsp;<img src=\"http://localhost/platon/www/images/logo/birne_logo_web.png\" alt=\"Birneshop DEMO\" title=\"Birneshop DEMO\"><span style=\"font-size: 11px; line-height: 14px;\">ultricies eu c</span></p><hr><p style=\"text-align: left; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\"><span style=\"font-size: 11px; line-height: 14px;\">onvallis n</span><span style=\"font-size: 11px; line-height: 14px;\">isi. Quisque et magna bibendum, cursus purus suscipit, pellentesque libero. Proin ac lacinia augue, aliquet dictum metus. Nam non felis lectus. Donec a sapien eu nunc vestibulum varius vitae ac odio. Vestibulum fermentum sem ut dui blandit consequat.</span></p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Fusce placerat nulla tortor, id gravida lectus hendrerit ac. Sed mattis ultrices ornare. Nulla urna turpis, mattis vitae lectus nec, blandit consequat orci. Nullam mi neque, sodales vulputate venenatis rhoncus, rhoncus sit amet dui. Fusce et diam euismod, blandit metus eget, ornare purus. Nunc ut erat a justo consectetur accumsan vel et metus. Donec in porttitor nisl. Maecenas felis dolor, euismod nec gravida nec, hendrerit vel ligula. Ut dictum, diam ac sagittis commodo, quam metus volutpat ante, eget fringilla dolor massa a ligula. Aliquam sit amet euismod dui, vitae egestas elit. Donec scelerisque viverra condimentum. Aliquam felis ligula, tempus quis laoreet non, fringilla eget urna. Nulla at magna laoreet, viverra diam eget, mollis nisi.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse eros felis, tincidunt ac congue at, scelerisque a lectus. Etiam sollicitudin magna ac sem faucibus mollis. Morbi viverra cursus elit nec luctus. Phasellus eget metus eu est tincidunt varius. Aliquam ullamcorper enim malesuada orci consectetur, vel ultricies massa facilisis. Quisque mi odio, blandit sed nisl non, dapibus ornare nibh. Integer ut erat sit amet urna&nbsp;<img src=\"http://localhost/platon/www/images/logo/birne_logo_web.png\" alt=\"Birneshop DEMO\" title=\"Birneshop DEMO\"><span style=\"font-size: 11px; line-height: 14px;\">accumsan porta ac non sapien. Vestibulum tellus eros, fermentum a rutrum non, semper a felis. Praesent venenatis lorem tincidunt, laoreet metus eget, dapibus ligula. Sed convallis sapien vel vestibulum semper. Cras rhoncus elementum sapien, vel porta dolor tristique at. Curabitur gravida id urna sit amet lobortis. Donec quis risus sapien.</span></p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">In mollis mauris ut massa fringilla, pretium tempor lorem imperdiet. Curabitur vel risus nulla. Aenean rutrum justo non laoreet vulputate. Etiam mattis laoreet lacus vitae venenatis. Cras varius pellentesque varius. Suspendisse potenti. Nunc eu erat sit amet lacus consequat faucibus quis in orci. Etiam cursus varius ipsum, vitae adipiscing risus egestas nec. Integer id convallis leo, iaculis bibendum tellus. Nam consectetur nibh gravida placerat bibendum.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse pellentesque ut orci eget porttitor. Curabitur placerat odio et mauris consectetur elementum. Aliquam dictum eros id ultricies iaculis. Donec non orci facilisis, interdum nisi vel, imperdiet justo. Nam imperdiet diam eget quam vehicula, a mattis orci scelerisque. Morbi tincidunt molestie enim non malesuada. Aliquam scelerisque mi non mauris dictum viverra. In tincidunt, ante ac hendrerit scelerisque, odio quam suscipit nulla, sed tempor nisl purus at nisl. Ut blandit eu erat sed facilisis. Sed facilisis id ipsum ac placerat. Vivamus eu arcu tempus, vulputate massa vel, dignissim estLorem ipsum dolor sit amet, consectetur adipiscing elit. In ut purus feugiat, tincidunt nibh nec, faucibus massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed pulvinar risus quis diam tempor volutpat quis non lacus. Donec ullamcorper pellentesque lacinia. Integer lobortis tortor nec elit adipiscing suscipit. Nulla nec dolor ac lacus facilisis mollis at eu risus. Etiam ac congue mi. Nam nec malesuada lorem, a interdum risus. Aliquam at tellus ac nulla sodales ultricies eu convallis nisi. Quisque et magna bibendum, cursus purus suscipit, pellentesque libero. Proin ac lacinia augue, aliquet dictum metus. Nam non felis lectus. Donec a sapien eu nunc vestibulum varius vitae ac odio. Vestibulum fermentum sem ut dui blandit consequat.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Fusce placerat nulla tortor, id gravida lectus hendrerit ac. Sed mattis ultrices ornare. Nulla urna turpis, mattis vitae lectus nec, blandit consequat orci. Nullam mi neque, sodales vulputate venenatis rhoncus, rhoncus sit amet dui. Fusce et diam euismod, blandit metus eget, ornare purus. Nunc ut erat a justo consectetur accumsan vel et metus. Donec in porttitor nisl. Maecenas felis dolor, euismod nec gravida nec, hendrerit vel ligula. Ut dictum, diam ac sagittis commodo, quam metus volutpat ante, eget fringilla dolor massa a ligula. Aliquam sit amet euismod dui, vitae egestas elit. Donec scelerisque viverra condimentum. Aliquam felis ligula, tempus quis laoreet non, fringilla eget urna. Nulla at magna laoreet, viverra diam eget, mollis nisi.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse eros felis, tincidunt ac congue at, scelerisque a lectus. Etiam sollicitudin magna ac sem faucibus mollis. Morbi viverra cursus elit nec luctus. Phasellus eget metus eu est tincidunt varius. Aliquam ullamcorper enim malesuada orci consectetur, vel ultricies massa facilisis. Quisque mi odio, blandit sed nisl non, dapibus ornare nibh. Integer ut erat sit amet urna accumsan porta ac non sapien. Vestibulum tellus eros, fermentum a rutrum non, semper a felis. Praesent venenatis lorem tincidunt, laoreet metus eget, dapibus ligula. Sed convallis sapien vel vestibulum semper. Cras rhoncus elementum sapien, vel porta dolor tristique at. Curabitur gravida id urna sit amet lobortis. Donec quis risus sapien.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">In mollis mauris ut massa fringilla, pretium tempor lorem imperdiet. Curabitur vel risus nulla. Aenean rutrum justo non laoreet vulputate. Etiam mattis laoreet lacus vitae venenatis. Cras varius pellentesque varius. Suspendisse potenti. Nunc eu erat sit amet lacus consequat faucibus quis in orci. Etiam cursus varius ipsum, vitae adipiscing risus egestas nec. Integer id convallis leo, iaculis bibendum tellus. Nam consectetur nibh gravida placerat bibendum.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse pellentesque ut orci eget porttitor. Curabitur placerat odio et mauris consectetur elementum. Aliquam dictum eros id ultricies iaculis. Donec non orci facilisis, interdum nisi vel, imperdiet justo. Nam imperdiet diam eget quam vehicula, a mattis orci scelerisque. Morbi tincidunt molestie enim non malesuada. Aliquam scelerisque mi non mauris dictum viverra. In tincidunt, ante ac hendrerit scelerisque, odio quam suscipit nulla, sed tempor nisl purus at nisl. Ut blandit eu erat sed facilisis. Sed facilisis id ipsum ac placerat. Vivamus eu arcu tempus, vulputate massa vel, dignissim estLorem ipsum dolor sit amet, consectetur adipiscing elit. In ut purus feugiat, tincidunt nibh nec, faucibus massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed pulvinar risus quis diam tempor volutpat quis non lacus. Donec ullamcorper pellentesque lacinia. Integer lobortis tortor nec elit adipiscing suscipit. Nulla nec dolor ac lacus facilisis mollis at eu risus. Etiam ac congue mi. Nam nec malesuada lorem, a interdum risus. Aliquam at tellus ac nulla sodales ultricies eu convallis nisi. Quisque et magna bibendum, cursus purus suscipit, pellentesque libero. Proin ac lacinia augue, aliquet dictum metus. Nam non felis lectus. Donec a sapien eu nunc vestibulum varius vitae ac odio. Vestibulum fermentum sem ut dui blandit consequat.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Fusce placerat nulla tortor, id gravida lectus hendrerit ac. Sed mattis ultrices ornare. Nulla urna turpis, mattis vitae lectus nec, blandit consequat orci. Nullam mi neque, sodales vulputate venenatis rhoncus, rhoncus sit amet dui. Fusce et diam euismod, blandit metus eget, ornare purus. Nunc ut erat a justo consectetur accumsan vel et metus. Donec in porttitor nisl. Maecenas felis dolor, euismod nec gravida nec, hendrerit vel ligula. Ut dictum, diam ac sagittis commodo, quam metus volutpat ante, eget fringilla dolor massa a ligula. Aliquam sit amet euismod dui, vitae egestas elit. Donec scelerisque viverra condimentum. Aliquam felis ligula, tempus quis laoreet non, fringilla eget urna. Nulla at magna laoreet, viverra diam eget, mollis nisi.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse eros felis, tincidunt ac congue at, scelerisque a lectus. Etiam sollicitudin magna ac sem faucibus mollis. Morbi viverra cursus elit nec luctus. Phasellus eget metus eu est tincidunt varius. Aliquam ullamcorper enim malesuada orci consectetur, vel ultricies massa facilisis. Quisque mi odio, blandit sed nisl non, dapibus ornare nibh. Integer ut erat sit amet urna accumsan porta ac non sapien. Vestibulum tellus eros, fermentum a rutrum non, semper a felis. Praesent venenatis lorem tincidunt, laoreet metus eget, dapibus ligula. Sed convallis sapien vel vestibulum semper. Cras rhoncus elementum sapien, vel porta dolor tristique at. Curabitur gravida id urna sit amet lobortis. Donec quis risus sapien.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">In mollis mauris ut massa fringilla, pretium tempor lorem imperdiet. Curabitur vel risus nulla. Aenean rutrum justo non laoreet vulputate. Etiam mattis laoreet lacus vitae venenatis. Cras varius pellentesque varius. Suspendisse potenti. Nunc eu erat sit amet lacus consequat faucibus quis in orci. Etiam cursus varius ipsum, vitae adipiscing risus egestas nec. Integer id convallis leo, iaculis bibendum tellus. Nam consectetur nibh gravida placerat bibendum.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse pellentesque ut orci eget porttitor. Curabitur placerat odio et mauris consectetur elementum. Aliquam dictum eros id ultricies iaculis. Donec non orci facilisis, interdum nisi vel, imperdiet justo. Nam imperdiet diam eget quam vehicula, a mattis orci scelerisque. Morbi tincidunt molestie enim non malesuada. Aliquam scelerisque mi non mauris dictum viverra. In tincidunt, ante ac hendrerit scelerisque, odio quam suscipit nulla, sed tempor nisl purus at nisl. Ut blandit eu erat sed facilisis. Sed facilisis id ipsum ac placerat. Vivamus eu arcu tempus, vulputate massa vel, dignissim estLorem ipsum dolor sit amet, consectetur adipiscing elit. In ut purus feugiat, tincidunt nibh nec, faucibus massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed pulvinar risus quis diam tempor volutpat quis non lacus. Donec ullamcorper pellentesque lacinia. Integer lobortis tortor nec elit adipiscing suscipit. Nulla nec dolor ac lacus facilisis mollis at eu risus. Etiam ac congue mi. Nam nec malesuada lorem, a interdum risus. Aliquam at tellus ac nulla sodales ultricies eu convallis nisi. Quisque et magna bibendum, cursus purus suscipit, pellentesque libero. Proin ac lacinia augue, aliquet dictum metus. Nam non felis lectus. Donec a sapien eu nunc vestibulum varius vitae ac odio. Vestibulum fermentum sem ut dui blandit consequat.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Fusce placerat nulla tortor, id gravida lectus hendrerit ac. Sed mattis ultrices ornare. Nulla urna turpis, mattis vitae lectus nec, blandit consequat orci. Nullam mi neque, sodales vulputate venenatis rhoncus, rhoncus sit amet dui. Fusce et diam euismod, blandit metus eget, ornare purus. Nunc ut erat a justo consectetur accumsan vel et metus. Donec in porttitor nisl. Maecenas felis dolor, euismod nec gravida nec, hendrerit vel ligula. Ut dictum, diam ac sagittis commodo, quam metus volutpat ante, eget fringilla dolor massa a ligula. Aliquam sit amet euismod dui, vitae egestas elit. Donec scelerisque viverra condimentum. Aliquam felis ligula, tempus quis laoreet non, fringilla eget urna. Nulla at magna laoreet, viverra diam eget, mollis nisi.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse eros felis, tincidunt ac congue at, scelerisque a lectus. Etiam sollicitudin magna ac sem faucibus mollis. Morbi viverra cursus elit nec luctus. Phasellus eget metus eu est tincidunt varius. Aliquam ullamcorper enim malesuada orci consectetur, vel ultricies massa facilisis. Quisque mi odio, blandit sed nisl non, dapibus ornare nibh. Integer ut erat sit amet urna accumsan porta ac non sapien. Vestibulum tellus eros, fermentum a rutrum non, semper a felis. Praesent venenatis lorem tincidunt, laoreet metus eget, dapibus ligula. Sed convallis sapien vel vestibulum semper. Cras rhoncus elementum sapien, vel porta dolor tristique at. Curabitur gravida id urna sit amet lobortis. Donec quis risus sapien.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">In mollis mauris ut massa fringilla, pretium tempor lorem imperdiet. Curabitur vel risus nulla. Aenean rutrum justo non laoreet vulputate. Etiam mattis laoreet lacus vitae venenatis. Cras varius pellentesque varius. Suspendisse potenti. Nunc eu erat sit amet lacus consequat faucibus quis in orci. Etiam cursus varius ipsum, vitae adipiscing risus egestas nec. Integer id convallis leo, iaculis bibendum tellus. Nam consectetur nibh gravida placerat bibendum.</p><p style=\"text-align: justify; font-size: 11px; line-height: 14px; margin: 0px 0px 14px; padding: 0px; font-family: Arial, Helvetica, sans;\">Suspendisse pellentesque ut orci eget porttitor. Curabitur placerat odio et mauris consectetur elementum. Aliquam dictum eros id ultricies iaculis. Donec non orci facilisis, interdum nisi vel, imperdiet justo. Nam imperdiet diam eget quam vehicula, a mattis orci scelerisque. Morbi tincidunt molestie enim non malesuada. Aliquam scelerisque mi non mauris dictum viverra. In tincidunt, ante ac hendrerit scelerisque, odio quam suscipit nulla, sed tempor nisl purus at nisl. Ut blandit eu erat sed facilisis. Sed facilisis id ipsum ac placerat. Vivamus eu arcu tempus, vulputate massa vel, dignissim est</p>',	1),
(3,	'or connect with us on social networks',	':)',	2),
(4,	'super text',	'',	2),
(5,	'New text',	'<br>',	2);

DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
  `StatusID` int(11) NOT NULL AUTO_INCREMENT,
  `StatusName` varchar(30) COLLATE utf8_czech_ci NOT NULL,
  PRIMARY KEY (`StatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_czech_ci;

INSERT INTO `status` (`StatusID`, `StatusName`) VALUES
(1,	'Active'),
(2,	'Non-Active'),
(3,	'Archived');

DROP TABLE IF EXISTS `unit`;
CREATE TABLE `unit` (
  `UnitID` int(11) NOT NULL AUTO_INCREMENT,
  `UnitShort` varchar(50) NOT NULL,
  `UnitName` varchar(255) NOT NULL,
  PRIMARY KEY (`UnitID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `unit` (`UnitID`, `UnitShort`, `UnitName`) VALUES
(1,	' ',	' '),
(2,	'g',	'grams'),
(3,	'mAh',	'miliamperhours'),
(4,	'px',	'pixels'),
(5,	'\"',	'inches');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `UsersID` varchar(60) NOT NULL,
  `Password` varchar(60) DEFAULT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `PhoneNumber` int(11) DEFAULT NULL,
  `CompanyName` varchar(45) DEFAULT NULL,
  `TIN` varchar(45) DEFAULT NULL,
  `Permission` varchar(6) NOT NULL DEFAULT 'user',
  PRIMARY KEY (`UsersID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `users` (`UsersID`, `Password`, `Name`, `PhoneNumber`, `CompanyName`, `TIN`, `Permission`) VALUES
('admin@admin.com',	'$2a$07$$$$$$$$$$$$$$$$$$$$$$.Yqgs4IC6X2x/em6hm8RFU1wBrsCvoAi',	'Lukkk',	0,	'0',	'0',	'admin');

DROP TABLE IF EXISTS `video`;
CREATE TABLE `video` (
  `VideoID` int(11) NOT NULL AUTO_INCREMENT,
  `ProductID` int(11) DEFAULT NULL,
  `BlogID` int(11) DEFAULT NULL,
  `StaticTextID` int(11) DEFAULT NULL,
  `VideoName` varchar(255) COLLATE utf16_czech_ci NOT NULL,
  `VideoLink` text COLLATE utf16_czech_ci NOT NULL,
  PRIMARY KEY (`VideoID`),
  KEY `ProductID` (`ProductID`),
  KEY `BlogID` (`BlogID`),
  KEY `StaticTextID` (`StaticTextID`),
  CONSTRAINT `video_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `video_ibfk_2` FOREIGN KEY (`BlogID`) REFERENCES `blog` (`BlogID`),
  CONSTRAINT `video_ibfk_3` FOREIGN KEY (`StaticTextID`) REFERENCES `statictext` (`StaticTextID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 COLLATE=utf16_czech_ci;


-- 2013-09-20 22:42:18
