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