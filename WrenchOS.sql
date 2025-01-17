CREATE TABLE IF NOT EXISTS `wrenchaccounts` (
  `identifier` varchar(50) DEFAULT '',
  `idtoken` varchar(50) DEFAULT '',
  `charid` int(11) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT '',
  `lastname` varchar(50) DEFAULT NULL,
  `cash` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `plrid` int(11) DEFAULT NULL,
  `job` varchar(20) DEFAULT 'CIV',
  `inventory` longtext DEFAULT NULL,
  `rank` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `plate` char(8) NOT NULL DEFAULT '',
  `vin` char(17) NOT NULL,
  `owner` int(10) unsigned DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  `model` varchar(20) NOT NULL,
  `class` tinyint(3) unsigned DEFAULT NULL,
  `data` longtext NOT NULL,
  `trunk` longtext DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `stored` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `plate` (`plate`) USING BTREE,
  UNIQUE KEY `vin` (`vin`) USING BTREE,
  KEY `FK_vehicles_characters` (`owner`) USING BTREE,
  KEY `FK_vehicles_groups` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
