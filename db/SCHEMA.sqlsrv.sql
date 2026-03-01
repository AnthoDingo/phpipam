# Dump of table instructions
# ------------------------------------------------------------
DROP TABLE IF EXISTS "instructions";

CREATE TABLE "instructions" (
  "id" int NOT NULL,
  "instructions" varchar(max), /* __no_html_escape__ */
   PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "instructions" ("id", "instructions")
VALUES
	(1,'You can write instructions under admin menu!');


# Dump of table customers
# ------------------------------------------------------------
DROP TABLE IF EXISTS "customers";

CREATE TABLE "customers" (
  "id" int  NOT NULL IDENTITY(1,1),
  "title" varchar(128) NOT NULL DEFAULT '',
  "address" varchar(255) DEFAULT NULL,
  "postcode" VARCHAR(32) NULL DEFAULT NULL,
  "city" varchar(255) DEFAULT NULL,
  "state" varchar(255) DEFAULT NULL,
  "lat" varchar(31) DEFAULT NULL,
  "long" varchar(31) DEFAULT NULL,
  "contact_person" varchar(max) DEFAULT NULL,
  "contact_phone" varchar(32) DEFAULT NULL,
  "contact_mail" varchar(254) DEFAULT NULL,
  "note" varchar(max) DEFAULT NULL,
  "status" varchar(255) DEFAULT 'Active',
  PRIMARY KEY ("id"),
  UNIQUE ("title")
);


# Dump of table ipaddresses
# ------------------------------------------------------------
DROP TABLE IF EXISTS "ipaddresses";

CREATE TABLE "ipaddresses" (
  "id" int NOT NULL IDENTITY(1,1),
  "subnetId" int    NULL  DEFAULT NULL,
  "ip_addr" varchar(100) NOT NULL,
  "is_gateway" bit NOT NULL DEFAULT '0',
  "description" varchar(64) DEFAULT NULL,
  "hostname" varchar(255) DEFAULT NULL,
  "mac" varchar(20) DEFAULT NULL,
  "owner" varchar(128) DEFAULT NULL,
  "state"  int  NULL  DEFAULT '2',
  "switch" int    NULL  DEFAULT NULL,
  "location" int    NULL  DEFAULT NULL,
  "port" varchar(32) DEFAULT NULL,
  "note" varchar(max),
  "lastSeen" DATETIME  NULL  DEFAULT '1970-01-01 00:00:01',
  "excludePing" bit NOT NULL DEFAULT '0',
  "PTRignore" bit NOT NULL DEFAULT '0',
  "PTR" int    NULL  DEFAULT '0',
  "firewallAddressObject" VARCHAR(100) NULL DEFAULT NULL,
  "editDate" TIMESTAMP  NULL  ,
  "customer_id" int  NULL default NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("ip_addr","subnetId"),
  /* INDEX "subnetId" */,
  /* INDEX "location" */,
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_ip" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
/* insert default values */
INSERT INTO "ipaddresses" ("id", "subnetId", "ip_addr", "description", "hostname", "state")
VALUES
	(1,3,'168427779','Server1','server1.cust1.local',2),
	(2,3,'168427780','Server2','server2.cust1.local',2),
	(3,3,'168427781','Server3','server3.cust1.local',3),
	(4,3,'168427782','Server4','server4.cust1.local',3),
	(5,3,'168428021','Gateway',NULL,2),
	(6,4,'168428286','Gateway',NULL,2),
	(7,4,'168428042','Server1','ser1.client2.local',2),
	(8,6,'172037636','DHCP range',NULL,4),
	(9,6,'172037637','DHCP range',NULL,4),
	(10,6,'172037638','DHCP range',NULL,4);


# Dump of table logs
# ------------------------------------------------------------
DROP TABLE IF EXISTS "logs";

CREATE TABLE "logs" (
  "id" int NOT NULL IDENTITY(1,1),
  "severity" int DEFAULT NULL,
  "date" varchar(32) DEFAULT NULL,
  "username" varchar(255) DEFAULT NULL,
  "ipaddr" varchar(64) DEFAULT NULL,
  "command" varchar(max) DEFAULT NULL,
  "details" varchar(max) DEFAULT NULL,
  PRIMARY KEY ("id")
);


# Dump of table requests
# ------------------------------------------------------------
DROP TABLE IF EXISTS "requests";

CREATE TABLE "requests" (
  "id" int  NOT NULL IDENTITY(1,1),
  "subnetId" int    NULL  DEFAULT NULL,
  "ip_addr" varchar(100) DEFAULT NULL,
  "description" varchar(64) DEFAULT NULL,
  "mac" varchar(20) DEFAULT NULL,
  "hostname" varchar(255) DEFAULT NULL,
  "state" INT  NULL  DEFAULT '2',
  "owner" varchar(128) DEFAULT NULL,
  "requester" varchar(128) DEFAULT NULL,
  "comment" varchar(max),
  "processed" bit DEFAULT NULL,
  "accepted" bit DEFAULT NULL,
  "adminComment" varchar(max),
  PRIMARY KEY ("id")
);


# Dump of table sections
# ------------------------------------------------------------
DROP TABLE IF EXISTS "sections";

CREATE TABLE "sections" (
  "id" int NOT NULL IDENTITY(1,1),
  "name" varchar(128) NOT NULL DEFAULT '',
  "description" varchar(max),
  "masterSection" int  NULL  DEFAULT '0',
  "permissions" varchar(1024) DEFAULT NULL, /* __no_html_escape__ */
  "strictMode" bit  NOT NULL  DEFAULT '1',
  "subnetOrdering" VARCHAR(16)  NULL  DEFAULT NULL,
  "order" int  NULL  DEFAULT NULL,
  "editDate" TIMESTAMP  NULL  ,
  "showSubnet" bit NOT NULL DEFAULT '1',
  "showVLAN" bit  NOT NULL  DEFAULT '0',
  "showVRF" bit  NOT NULL  DEFAULT '0',
  "showSupernetOnly" bit  NOT NULL  DEFAULT '0',
  "DNS" VARCHAR(128)  NULL  DEFAULT NULL,
  PRIMARY KEY ("name"),
  UNIQUE ("id")
);
/* insert default values */
INSERT INTO "sections" ("id", "name", "description", "permissions")
VALUES
	(1,'Customers','Section for customers','{\"3\":\"1\",\"2\":\"2\"}'),
	(2,'IPv6','Section for IPv6 addresses','{\"3\":\"1\",\"2\":\"2\"}');


# Dump of table settings
# ------------------------------------------------------------
DROP TABLE IF EXISTS "settings";

CREATE TABLE "settings" (
  "id" int  NOT NULL IDENTITY(1,1),
  "siteTitle" varchar(64) DEFAULT NULL,
  "siteAdminName" varchar(64) DEFAULT NULL,
  "siteAdminMail" varchar(254) DEFAULT NULL,
  "siteDomain" varchar(32) DEFAULT NULL,
  "siteURL" varchar(64) DEFAULT NULL,
  "siteLoginText" varchar(128) DEFAULT NULL,
  "domainAuth" tinyint DEFAULT NULL,
  "enableIPrequests" tinyint DEFAULT NULL,
  "enableVRF" tinyint DEFAULT '1',
  "enableDNSresolving" tinyint DEFAULT NULL,
  "enableFirewallZones" TINYint NOT NULL DEFAULT '0',
  "firewallZoneSettings" VARCHAR(1024) NOT NULL DEFAULT '{"zoneLength":3,"ipType":{"0":"v4","1":"v6"},"separator":"_","indicator":{"0":"own","1":"customer"},"zoneGenerator":"2","zoneGeneratorType":{"0":"decimal","1":"hex","2":"varchar(max)"},"deviceType":"3","padding":"on","strictMode":"on","pattern":{"0":"patternFQDN"}}', /* __no_html_escape__ */
  "enablePowerDNS" TINYint  NULL  DEFAULT '0',
  "powerDNS" varchar(max)  NULL, /* __no_html_escape__ */
  "enableDHCP" TINYint  NULL  DEFAULT '0',
  "DHCP" VARCHAR(256) NULL default '{"type":"kea","settings":{"file":"\/etc\/kea\/kea.conf"}}', /* __no_html_escape__ */
  "enableMulticast" TINYint  NULL  DEFAULT '0',
  "enableNAT" TINYint  NULL  DEFAULT '1',
  "enableSNMP" TINYint  NULL  DEFAULT '0',
  "enableThreshold" TINYint  NULL  DEFAULT '1',
  "enableRACK" TINYint  NULL  DEFAULT '1',
  "enableLocations" TINYint  NULL  DEFAULT '1',
  "enablePSTN" TINYint  NULL  DEFAULT '0',
  "enableChangelog" TINYint  NOT NULL  DEFAULT '1',
  "enableCustomers" TINYint  NOT NULL  DEFAULT '1',
  "enableVaults" TINYint  NOT NULL  DEFAULT '1',
  "link_field" VARCHAR(32)  NULL  DEFAULT '0',
  "version" varchar(5) DEFAULT NULL,
  "dbversion" int NOT NULL DEFAULT '0',
  "dbverified" bit  NOT NULL  DEFAULT '0',
  "donate" tinyint DEFAULT '0',
  "IPfilter" varchar(128) DEFAULT NULL,
  "IPrequired" VARCHAR(128)  NULL  DEFAULT NULL,
  "vlanDuplicate" int DEFAULT '0',
  "vlanMax" int  NULL  DEFAULT '4096',
  "subnetOrdering" varchar(16) DEFAULT 'subnet,asc',
  "visualLimit" int NOT NULL DEFAULT '0',
  "theme" VARCHAR(32)  NOT NULL  DEFAULT 'dark',
  "autoSuggestNetwork" TINYint  NOT NULL  DEFAULT '0',
  "pingStatus" VARCHAR(32)  NOT NULL  DEFAULT '1800;3600',
  "defaultLang" int  NULL  DEFAULT NULL,
  "editDate" TIMESTAMP  NULL  ,
  "vcheckDate" DATETIME  NULL  DEFAULT NULL ,
  "api" BINARY  NOT NULL  DEFAULT '0',
  "scanPingPath" VARCHAR(64)  NULL  DEFAULT '/bin/ping',
  "scanFPingPath" VARCHAR(64)  NULL  DEFAULT '/bin/fping',
  "scanPingType" varchar(255) NOT NULL DEFAULT 'ping',
  "scanMaxThreads" int  NULL  DEFAULT '128',
  "prettyLinks" varchar(255) NOT NULL DEFAULT 'No',
  "hiddenCustomFields" varchar(max) NULL,
  "inactivityTimeout" int  NOT NULL  DEFAULT '3600',
  "updateTags" TINYint  NULL  DEFAULT '0',
  "enforceUnique" TINYint  NULL  DEFAULT '1',
  "authmigrated" TINYINT  NOT NULL  DEFAULT '0',
  "maintaneanceMode" TINYint  NULL  DEFAULT '0',
  "decodeMAC" TINYint  NULL  DEFAULT '1',
  "tempShare" TINYint  NULL  DEFAULT '0',
  "tempAccess" varchar(max)  NULL, /* __no_html_escape__ */
  "log" varchar(255) NOT NULL DEFAULT 'Database',
  "subnetView" TINYINT  NOT NULL  DEFAULT '0',
  "enableCircuits" TINYint  NULL  DEFAULT '1',
  "enableRouting" TINYint  NULL  DEFAULT '0',
  "permissionPropagate" TINYint  NULL  DEFAULT '1',
  "passwordPolicy" VARCHAR(1024)  NULL  DEFAULT '{\"minLength\":8,\"maxLength\":0,\"minNumbers\":0,\"minLetters\":0,\"minLowerCase\":0,\"minUpperCase\":0,\"minSymbols\":0,\"maxSymbols\":0,\"allowedSymbols\":\"#,_,-,!,[,],=,~\"}', /* __no_html_escape__ */
  "2fa_provider" varchar(255) NULL DEFAULT 'none',
  "2fa_name" VARCHAR(32)  NULL  DEFAULT 'phpipam',
  "2fa_length" int  NULL  DEFAULT '26',
  "2fa_userchange" bit  NOT NULL  DEFAULT '1',
  "passkeys" TINYint  NULL  DEFAULT '1',
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "settings" ("id", "siteTitle", "siteAdminName", "siteAdminMail", "siteDomain", "siteURL", "domainAuth", "enableIPrequests", "enableVRF", "enableDNSresolving", "version", "donate", "IPfilter", "vlanDuplicate", "subnetOrdering", "visualLimit")
VALUES
	(1, 'phpipam IP address management', 'Sysadmin', 'admin@domain.local', 'domain.local', 'http://yourpublicurl.com', 0, 0, 0, 0, '1.4', 0, 'mac;owner;state;switch;note;firewallAddressObject', 1, 'subnet,asc', 24);


# Dump of table settingsMail
# ------------------------------------------------------------
DROP TABLE IF EXISTS "settingsMail";

CREATE TABLE "settingsMail" (
  "id" int  NOT NULL IDENTITY(1,1),
  "mtype" varchar(255) NOT NULL DEFAULT 'localhost',
  "msecure" varchar(255)  NOT NULL  DEFAULT 'none',
  "mauth" varchar(255) NOT NULL DEFAULT 'no',
  "mserver" varchar(128) DEFAULT NULL,
  "mport" int DEFAULT '25',
  "muser" varchar(254) DEFAULT NULL,
  "mpass" varchar(128) DEFAULT NULL, /* __no_html_escape__ */
  "mAdminName" varchar(128) DEFAULT NULL,
  "mAdminMail" varchar(254) DEFAULT NULL,
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "settingsMail" ("id", "mtype")
VALUES
	(1, 'localhost');


# Dump of table subnets
# ------------------------------------------------------------
DROP TABLE IF EXISTS "subnets";

CREATE TABLE "subnets" (
  "id" int NOT NULL IDENTITY(1,1),
  "subnet" VARCHAR(255) NULL  DEFAULT NULL,
  "mask" VARCHAR(3) NULL DEFAULT NULL,
  "sectionId" int    NULL  DEFAULT NULL,
  "description" varchar(max),
  "linked_subnet" int    NULL  DEFAULT NULL,
  "firewallAddressObject" VARCHAR(100) NULL DEFAULT NULL,
  "vrfId" int    NULL  DEFAULT NULL,
  "masterSubnetId" int    NOT NULL default 0,
  "allowRequests" bit NOT NULL DEFAULT '0',
  "vlanId" int    NULL  DEFAULT NULL,
  "showName" bit NOT NULL DEFAULT '0',
  "device" INT    NULL  DEFAULT '0',
  "permissions" varchar(1024) DEFAULT NULL, /* __no_html_escape__ */
  "pingSubnet" bit NOT NULL DEFAULT '0',
  "discoverSubnet" bit NOT NULL DEFAULT '0',
  "resolveDNS" bit NOT NULL DEFAULT '0',
  "DNSrecursive" bit NOT NULL DEFAULT '0',
  "DNSrecords" bit NOT NULL DEFAULT '0',
  "nameserverId" int NULL DEFAULT '0',
  "scanAgent" int  DEFAULT NULL,
  "customer_id" int  NULL default NULL,
  "isFolder" bit NOT NULL DEFAULT '0',
  "isFull" bit NOT NULL DEFAULT '0',
  "isPool" bit NOT NULL DEFAULT '0',
  "state" int  NULL  DEFAULT '2',
  "threshold" int  NULL  DEFAULT 0,
  "location" int    NULL  DEFAULT NULL,
  "editDate" TIMESTAMP  NULL  ,
  "lastScan" TIMESTAMP  NULL,
  "lastDiscovery" TIMESTAMP  NULL,
  PRIMARY KEY ("id"),
  /* INDEX "masterSubnetId" */,
  /* INDEX "location" */,
  /* INDEX "sectionId" */,
  /* INDEX "vrfId" */,
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_subnets" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
/* insert default values */
INSERT INTO "subnets" ("id", "subnet", "mask", "sectionId", "description", "vrfId", "masterSubnetId", "allowRequests", "vlanId", "showName", "permissions", "isFolder")
VALUES
	(1,'336395549904799703390415618052362076160','64',2,'Private subnet 1',0,'0',1,1,1,'{\"3\":\"1\",\"2\":\"2\"}',0),
	(2,'168427520','16','1','Business customers',0,'0',1,0,1,'{\"3\":\"1\",\"2\":\"2\"}',0),
	(3,'168427776','24','1','Customer 1',0,'2',1,0,1,'{\"3\":\"1\",\"2\":\"2\"}',0),
	(4,'168428032','24','1','Customer 2',0,'2',1,0,1,'{\"3\":\"1\",\"2\":\"2\"}',0),
	(5, '0', '', 1, 'My folder', 0, 0, 0, 0, 0, '{\"3\":\"1\",\"2\":\"2\"}', 1),
	(6, '172037632', '24', 1, 'DHCP range', 0, 5, 0, 0, 1, '{\"3\":\"1\",\"2\":\"2\"}', 0);


# Dump of table devices
# ------------------------------------------------------------
DROP TABLE IF EXISTS "devices";

CREATE TABLE "devices" (
  "id" int  NOT NULL IDENTITY(1,1),
  "hostname" varchar(255) DEFAULT NULL,
  "ip_addr" varchar(100) DEFAULT NULL,
  "type" int DEFAULT '0',
  "description" varchar(256) DEFAULT NULL,
  "sections" varchar(1024) DEFAULT NULL, /* __no_html_escape__ */
  "snmp_community" varchar(100) DEFAULT NULL,
  "snmp_version" varchar(255) DEFAULT '0',
  "snmp_port" mediumint  DEFAULT '161',
  "snmp_timeout" mediumint  DEFAULT '1000',
  "snmp_queries" varchar(128) DEFAULT NULL,
  "snmp_v3_sec_level" varchar(255) DEFAULT 'none',
  "snmp_v3_auth_protocol" varchar(255) DEFAULT 'none',
  "snmp_v3_auth_pass" varchar(64) DEFAULT NULL, /* __no_html_escape__ */
  "snmp_v3_priv_protocol" varchar(255) DEFAULT 'none',
  "snmp_v3_priv_pass" varchar(64) DEFAULT NULL, /* __no_html_escape__ */
  "snmp_v3_ctx_name" varchar(64) DEFAULT NULL,
  "snmp_v3_ctx_engine_id" varchar(64) DEFAULT NULL,
  "rack" int  DEFAULT NULL,
  "rack_start" int  DEFAULT NULL,
  "rack_size" int  DEFAULT NULL,
  "location" int  DEFAULT NULL,
  "editDate" timestamp NULL DEFAULT NULL ,
  PRIMARY KEY ("id"),
  /* INDEX "hostname" */,
  /* INDEX "location" */
);


# Dump of table userGroups
# ------------------------------------------------------------
DROP TABLE IF EXISTS "userGroups";

CREATE TABLE "userGroups" (
  "g_id" int  NOT NULL IDENTITY(1,1),
  "g_name" varchar(32) DEFAULT NULL,
  "g_desc" varchar(1024) DEFAULT NULL,
  "editDate" TIMESTAMP  NULL  ,
  PRIMARY KEY ("g_id")
);
/* insert default values */
INSERT INTO "userGroups" ("g_id", "g_name", "g_desc")
VALUES
	(2,'Operators','default Operator group'),
	(3,'Guests','default Guest group (viewers)');


# Dump of table users
# ------------------------------------------------------------
DROP TABLE IF EXISTS "users";

CREATE TABLE "users" (
  "id" int NOT NULL IDENTITY(1,1),
  "username" varchar(255) NOT NULL DEFAULT '',
  "authMethod" int  NULL  DEFAULT 1,
  "passkey_only" TINYint  NOT NULL  DEFAULT '0',
  "password" CHAR(128) DEFAULT NULL,
  "groups" varchar(1024) DEFAULT NULL, /* __no_html_escape__ */
  "role" varchar(max),
  "real_name" varchar(128) DEFAULT NULL,
  "email" varchar(254) DEFAULT NULL,
  "domainUser" bit DEFAULT '0',
  "widgets" VARCHAR(1024)  NULL  DEFAULT 'statistics;favourite_subnets;changelog;top10_hosts_v4',
  "lang" int   NULL  DEFAULT '9',
  "favourite_subnets" VARCHAR(1024)  NULL  DEFAULT NULL,
  "disabled" varchar(255)  NOT NULL  DEFAULT 'No',
  "mailNotify" varchar(255)  NOT NULL  DEFAULT 'No',
  "mailChangelog" varchar(255)  NOT NULL  DEFAULT 'No',
  "passChange" varchar(255)  NOT NULL  DEFAULT 'No',
  "editDate" TIMESTAMP  NULL  ,
  "lastLogin" TIMESTAMP  NULL,
  "lastActivity" TIMESTAMP  NULL,
  "compressOverride" varchar(255) NOT NULL DEFAULT 'default',
  "hideFreeRange" tinyint DEFAULT '0',
  "menuType" varchar(255)  NOT NULL  DEFAULT 'Dynamic',
  "menuCompact" TINYINT  NULL  DEFAULT '1',
  "2fa" bit  NOT NULL  DEFAULT '0',
  "2fa_secret" VARCHAR(32)  NULL  DEFAULT NULL,
  "theme" VARCHAR(32)  NULL  DEFAULT '',
  "token" VARCHAR(24)  NULL  DEFAULT NULL,
  "token_valid_until" DATETIME  NULL,
  "module_permissions" varchar(255) DEFAULT '{"vlan":"1","l2dom":"1","vrf":"1","pdns":"1","circuits":"1","racks":"1","nat":"1","pstn":"1","customers":"1","locations":"1","devices":"1","routing":"1","vaults":"1"}', /* __no_html_escape__ */
  "compress_actions" TINYint  NULL  DEFAULT '1',
  PRIMARY KEY ("username"),
  UNIQUE ("id")
);
/* insert default values */
INSERT INTO "users" ("id", "username", "password", "groups", "role", "real_name", "email", "domainUser","widgets", "passChange")
VALUES
	(1,'Admin',0x243624726F756E64733D33303030244A51454536644C394E70766A6546733424524B3558336F6132382E557A742F6835564166647273766C56652E3748675155594B4D58544A5573756438646D5766507A5A51506252626B38784A6E314B797974342E64576D346E4A4959684156326D624F5A33672E,X'','Administrator','phpIPAM Admin','admin@domain.local',0x30,'statistics;favourite_subnets;changelog;access_logs;error_logs;top10_hosts_v4', 'Yes');


# Dump of table lang
# ------------------------------------------------------------
DROP TABLE IF EXISTS "lang";

CREATE TABLE "lang" (
  "l_id" int  NOT NULL IDENTITY(1,1),
  "l_code" varchar(12) NOT NULL DEFAULT '',
  "l_name" varchar(32) DEFAULT NULL,
  PRIMARY KEY ("l_id")
);
/* insert default values */
INSERT INTO "lang" ("l_id", "l_code", "l_name")
VALUES
   (1, 'en_GB.UTF-8', 'English'),
   (2, 'sl_SI.UTF-8', 'Slovenščina'),
   (3, 'fr_FR.UTF-8', 'Français'),
   (4, 'nl_NL.UTF-8', 'Nederlands'),
   (5, 'de_DE.UTF-8', 'Deutsch'),
   (6, 'pt_BR.UTF-8', 'Brazil'),
   (7, 'es_ES.UTF-8', 'Español'),
   (8, 'cs_CZ.UTF-8', 'Czech'),
   (9, 'en_US.UTF-8', 'English (US)'),
  (10, 'ru_RU.UTF-8', 'Russian'),
  (11, 'zh_CN.UTF-8', 'Chinese'),
  (12, 'ja_JP.UTF-8', 'Japanese'),
  (13, 'zh_TW.UTF-8', 'Chinese traditional (繁體中文)'),
  (14, 'it_IT.UTF-8', 'Italian');


# Dump of table vlans
# ------------------------------------------------------------
DROP TABLE IF EXISTS "vlans";

CREATE TABLE "vlans" (
  "vlanId" int NOT NULL IDENTITY(1,1),
  "domainId" INT  NOT NULL  DEFAULT '1',
  "name" varchar(255) NOT NULL,
  "number" int DEFAULT NULL,
  "description" varchar(max),
  "editDate" TIMESTAMP  NULL  ,
  "customer_id" int  NULL default NULL,
  PRIMARY KEY ("vlanId"),
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_vlans" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
/* insert default values */
INSERT INTO "vlans" ("vlanId", "name", "number", "description")
VALUES
	(1,'IPv6 private 1',2001,'IPv6 private 1 subnets'),
	(2,'Servers DMZ',4001,'DMZ public');


# Dump of table vlanDomains
# ------------------------------------------------------------
DROP TABLE IF EXISTS "vlanDomains";

CREATE TABLE "vlanDomains" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(64) DEFAULT NULL,
  "description" varchar(max),
  "permissions" varchar(128) DEFAULT NULL, /* __no_html_escape__ */
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "vlanDomains" ("id", "name", "description", "permissions")
VALUES
	(1, 'default', 'default L2 domain', NULL);


# Dump of table vrf
# ------------------------------------------------------------
DROP TABLE IF EXISTS "vrf";

CREATE TABLE "vrf" (
  "vrfId" int  NOT NULL IDENTITY(1,1),
  "name" varchar(32) NOT NULL DEFAULT '',
  "rd" varchar(32) DEFAULT NULL,
  "description" varchar(256) DEFAULT NULL,
  "sections" VARCHAR(128)  NULL  DEFAULT NULL, /* __no_html_escape__ */
  "editDate" TIMESTAMP  NULL  ,
  "customer_id" int  DEFAULT NULL,
  PRIMARY KEY ("vrfId"),
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_vrf" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

# Dump of table nameservers
# ------------------------------------------------------------
DROP TABLE IF EXISTS "nameservers";

CREATE TABLE "nameservers" (
  "id" int NOT NULL IDENTITY(1,1),
  "name" varchar(255) NOT NULL,
  "namesrv1" varchar(255) DEFAULT NULL,
  "description" varchar(max),
  "permissions" varchar(128) DEFAULT NULL, /* __no_html_escape__ */
  "editDate" TIMESTAMP  NULL  ,
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "nameservers" ("name", "namesrv1", "description", "permissions")
VALUES
	('Google NS', '8.8.8.8;8.8.4.4', 'Google public nameservers', '1;2');



# Dump of table api
# ------------------------------------------------------------
DROP TABLE IF EXISTS "api";

CREATE TABLE "api" (
  "id" int  NOT NULL IDENTITY(1,1),
  "app_id" varchar(32) NOT NULL DEFAULT '',
  "app_code" varchar(32) NULL DEFAULT '',
  "app_permissions" int DEFAULT '1',
  "app_comment" varchar(max)  NULL,
  "app_security"varchar(255)  NOT NULL  DEFAULT 'ssl_token',
  "app_lock" int  NOT NULL  DEFAULT '0',
  "app_lock_wait" int  NOT NULL  DEFAULT '30',
  "app_nest_custom_fields" TINYint  NULL  DEFAULT '0',
  "app_show_links" TINYint  NULL  DEFAULT '0',
  "app_last_access" datetime DEFAULT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("app_id")
);


# Dump of table changelog
# ------------------------------------------------------------
DROP TABLE IF EXISTS "changelog";

CREATE TABLE "changelog" (
  "cid" int  NOT NULL IDENTITY(1,1),
  "ctype" varchar(255) NOT NULL DEFAULT '',
  "coid" int  NOT NULL,
  "cuser" int  NOT NULL,
  "caction" varchar(255) NOT NULL DEFAULT 'edit',
  "cresult" varchar(255) NOT NULL DEFAULT 'success',
  "cdate" datetime NOT NULL,
  "cdiff" varchar(max) DEFAULT NULL,
  PRIMARY KEY ("cid"),
  /* INDEX "coid" */,
  /* INDEX "ctype" */
);


# Dump of table widgets
# ------------------------------------------------------------
DROP TABLE IF EXISTS "widgets";

CREATE TABLE "widgets" (
  "wid" int  NOT NULL IDENTITY(1,1),
  "wtitle" varchar(64) NOT NULL DEFAULT '',
  "wdescription" varchar(1024) DEFAULT NULL,
  "wfile" varchar(64) NOT NULL DEFAULT '',
  "wparams" varchar(1024) DEFAULT NULL,
  "whref" varchar(255) NOT NULL DEFAULT 'no',
  "wsize" varchar(255) NOT NULL DEFAULT '6',
  "wadminonly" varchar(255) NOT NULL DEFAULT 'no',
  "wactive" varchar(255) NOT NULL DEFAULT 'no',
  PRIMARY KEY ("wid")
);
/* insert default values */
INSERT INTO "widgets" ("wid", "wtitle", "wdescription", "wfile", "wparams", "whref", "wsize", "wadminonly", "wactive")
VALUES
	( 1,'Statistics', 'Shows some statistics on number of hosts, subnets', 'statistics', 'height=x', 'no', '4', 'no', 'yes'),
	( 2,'Favourite subnets', 'Shows favourite subnets', 'favourite_subnets', 'height=x&max=x', 'yes', '8', 'no', 'yes'),
	( 3,'Top IPv4 subnets by number of hosts', 'Shows graph of top IPv4 subnets by number of hosts', 'top10_hosts_v4', 'height=x&max=x', 'yes', '6', 'no', 'yes'),
	( 4,'Top IPv6 subnets by number of hosts', 'Shows graph of top IPv6 subnets by number of hosts', 'top10_hosts_v6', 'height=x&max=x', 'yes', '6', 'no', 'yes'),
	( 5,'Top IPv4 subnets by usage percentage', 'Shows graph of top IPv4 subnets by usage percentage', 'top10_percentage', 'height=x&max=x', 'yes', '6', 'no', 'yes'),
	( 6,'Most recent change log entries', 'Shows list of most recent change log entries', 'changelog', 'height=x&max=x', 'yes', '12', 'no', 'yes'),
	( 7,'Active IP addresses requests', 'Shows list of active IP address request', 'requests', 'height=x&max=x', 'yes', '6', 'yes', 'yes'),
	( 8,'Most recent informational logs', 'Shows list of most recent informational logs', 'access_logs', 'height=x&max=x', 'yes', '6', 'yes', 'yes'),
	( 9,'Most recent warning / error logs', 'Shows list of most recent warning and error logs', 'error_logs', 'height=x&max=x', 'yes', '6', 'yes', 'yes'),
	(10,'Tools menu', 'Shows quick access to tools menu', 'tools', NULL, 'yes', '6', 'no', 'yes'),
	(11,'IP Calculator', 'Shows IP calculator as widget', 'ipcalc', NULL, 'yes', '6', 'no', 'yes'),
	(12,'IP Request', 'IP Request widget', 'iprequest', NULL, 'no', '6', 'no', 'yes'),
	(13,'Threshold', 'Shows threshold usage for most consumed subnets', 'threshold', 'height=x&max=x', 'yes', '6', 'no', 'yes'),
	(14,'Inactive hosts', 'Shows list of inactive hosts for defined period', 'inactive-hosts', 'height=x&days=30', 'yes', '6', 'yes', 'yes'),
	(15,'Locations', 'Shows map of locations', 'locations', 'height=x', 'yes', '6', 'no', 'yes'),
	(16,'Bandwidth calculator', 'Calculate bandwidth', 'bw_calculator', NULL, 'no', '6', 'no', 'yes'),
	(17,'Customers', 'Shows customer list', 'customers', 'height=x', 'yes', '6', 'no', 'yes'),
	(18,'User Instructions', 'Shows user instructions', 'instructions', NULL, 'yes', '6', 'no', 'yes'),
	(19,'MAC lookup', 'Shows MAC address vendor', 'mac-lookup', NULL, 'yes', '6', 'no', 'yes'),
	(20,'Recent Logins', 'Shows most recent user logins', 'recent_logins', 'max=5&height=x', 'no', '4', 'yes', 'yes');



# Dump of table deviceTypes
# ------------------------------------------------------------
DROP TABLE IF EXISTS "deviceTypes";

CREATE TABLE "deviceTypes" (
  "tid" int  NOT NULL IDENTITY(1,1),
  "tname" varchar(128) DEFAULT NULL,
  "tdescription" varchar(128) DEFAULT NULL,
  PRIMARY KEY ("tid")
);
/* insert default values */
INSERT INTO "deviceTypes" ("tid", "tname", "tdescription")
VALUES
	(1, 'Switch', 'Switch'),
	(2, 'Router', 'Router'),
	(3, 'Firewall', 'Firewall'),
	(4, 'Hub', 'Hub'),
	(5, 'Wireless', 'Wireless'),
	(6, 'Database', 'Database'),
	(7, 'Workstation', 'Workstation'),
	(8, 'Laptop', 'Laptop'),
	(9, 'Other', 'Other');


# Dump of table loginAttempts
# ------------------------------------------------------------
DROP TABLE IF EXISTS "loginAttempts";

CREATE TABLE "loginAttempts" (
  "id" int  NOT NULL IDENTITY(1,1),
  "datetime" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  "ip" varchar(128) NOT NULL DEFAULT '',
  "count" int NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("ip")
);


# Dump of table usersAuthMethod
# ------------------------------------------------------------
DROP TABLE IF EXISTS "usersAuthMethod";

CREATE TABLE "usersAuthMethod" (
  "id" int  NOT NULL IDENTITY(1,1),
  "type" varchar(255) NOT NULL DEFAULT 'local',
  "params" varchar(max) DEFAULT NULL, /* __no_html_escape__ */
  "protected" varchar(255) NOT NULL DEFAULT 'Yes',
  "description" varchar(max),
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "usersAuthMethod" ("id", "type", "params", "protected", "description")
VALUES
	(1, 'local', NULL, 'Yes', 'Local database'),
	(2, 'http', NULL, 'Yes', 'Apache authentication');


# Dump of table ipTags
# ------------------------------------------------------------
DROP TABLE IF EXISTS "ipTags";

CREATE TABLE "ipTags" (
  "id" int  NOT NULL IDENTITY(1,1),
  "type" varchar(32) DEFAULT NULL,
  "showtag" tinyint DEFAULT '1',
  "bgcolor" varchar(7) DEFAULT '#000',
  "fgcolor" varchar(7) DEFAULT '#fff',
  "compress" varchar(255)  NOT NULL  DEFAULT 'No',
  "locked" varchar(255) NOT NULL DEFAULT 'No',
  "updateTag" TINYint  NULL  DEFAULT '0',
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "ipTags" ("id", "type", "showtag", "bgcolor", "fgcolor", "compress", "locked", "updateTag")
VALUES
	(1, 'Offline', 1, '#f59c99', '#ffffff', 'No', 'Yes', 1),
	(2, 'Used', 0, '#a9c9a4', '#ffffff', 'No', 'Yes', 1),
	(3, 'Reserved', 1, '#9ac0cd', '#ffffff', 'No', 'Yes', 1),
	(4, 'DHCP', 1, '#c9c9c9', '#ffffff', 'Yes', 'Yes', 1);


# Dump of table firewallZones
# ------------------------------------------------------------
DROP TABLE IF EXISTS "firewallZones";

CREATE TABLE "firewallZones" (
  "id" int NOT NULL IDENTITY(1,1),
  "generator" tinyint NOT NULL,
  "length" int DEFAULT NULL,
  "padding" tinyint DEFAULT NULL,
  "zone" varchar(31) NOT NULL,
  "indicator" varchar(8) NOT NULL,
  "description" varchar(max),
  "permissions" varchar(1024) DEFAULT NULL, /* __no_html_escape__ */
  "editDate" timestamp NULL DEFAULT NULL ,
  PRIMARY KEY ("id")
);


# Dump of table firewallZoneMapping
# ------------------------------------------------------------
DROP TABLE IF EXISTS "firewallZoneMapping";

CREATE TABLE "firewallZoneMapping" (
  "id" int NOT NULL IDENTITY(1,1),
  "zoneId" int  NOT NULL,
  "alias" varchar(255) DEFAULT NULL,
  "deviceId" int  DEFAULT NULL,
  "interface" varchar(255) DEFAULT NULL,
  "editDate" timestamp NULL DEFAULT NULL ,
  PRIMARY KEY ("id"),
  /* INDEX "deviceId" */,
  CONSTRAINT "devId" FOREIGN KEY ("deviceId") REFERENCES "devices" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
);


# Dump of table firewallZoneMapping
# ------------------------------------------------------------
DROP TABLE IF EXISTS "firewallZoneSubnet";

CREATE TABLE "firewallZoneSubnet" (
  "zoneId" INT NOT NULL,
  "subnetId" int NOT NULL,
  PRIMARY KEY ("zoneId","subnetId"),
  INDEX "fk_zoneId_idx" ("zoneId" ASC),
  INDEX "fk_subnetId_idx" ("subnetId" ASC),
  CONSTRAINT "fk_zoneId"
    FOREIGN KEY ("zoneId")
    REFERENCES "firewallZones" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_subnetId"
    FOREIGN KEY ("subnetId")
    REFERENCES "subnets" ("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);


# Dump of table scanAgents
# ------------------------------------------------------------
DROP TABLE IF EXISTS "scanAgents";

CREATE TABLE "scanAgents" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(128) DEFAULT NULL,
  "description" varchar(max),
  "type" varchar(255) NOT NULL DEFAULT '',
  "code" varchar(32) DEFAULT NULL,
  "last_access" datetime DEFAULT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("code")
);
/* insert default values */
INSERT INTO "scanAgents" ("id", "name", "description", "type")
VALUES
	(1, 'localhost', 'Scanning from local machine', 'direct');


# Dump of table nat
# ------------------------------------------------------------
DROP TABLE IF EXISTS "nat";

CREATE TABLE "nat" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(64) DEFAULT NULL,
  "type" varchar(255) DEFAULT 'source',
  "src" varchar(max) DEFAULT NULL, /* __no_html_escape__ */
  "dst" varchar(max) DEFAULT NULL, /* __no_html_escape__ */
  "src_port" int DEFAULT NULL,
  "dst_port" int DEFAULT NULL,
  "device" int  DEFAULT NULL,
  "description" varchar(max) DEFAULT NULL,
  "policy" varchar(255) NOT NULL DEFAULT 'No',
  "policy_dst" varchar(255) DEFAULT NULL,
  PRIMARY KEY ("id")
);

# Dump of table racks
# ------------------------------------------------------------
DROP TABLE IF EXISTS "racks";

CREATE TABLE "racks" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(64) NOT NULL DEFAULT '',
  "size" int DEFAULT NULL,
  "location" int    NULL  DEFAULT NULL,
  "row" int  NOT NULL  DEFAULT '1',
  "hasBack" TINYint  NOT NULL  DEFAULT '0',
  "topDown" tinyint NOT NULL DEFAULT '0',
  "description" varchar(max),
  "customer_id" int  NULL default NULL,
  PRIMARY KEY ("id"),
  /* INDEX "location" */,
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_racks" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

# Dump of table rackContents
# ------------------------------------------------------------
DROP TABLE IF EXISTS "rackContents";

CREATE TABLE "rackContents" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(100) DEFAULT NULL,
  "rack" int  DEFAULT NULL,
  "rack_start" int  DEFAULT NULL,
  "rack_size" int  DEFAULT NULL,
  PRIMARY KEY ("id"),
  /* INDEX "rack" */
);


# Dump of table locations
# ------------------------------------------------------------
DROP TABLE IF EXISTS "locations";

CREATE TABLE "locations" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(128) NOT NULL DEFAULT '',
  "description" varchar(max),
  "address" VARCHAR(128)  NULL  DEFAULT NULL,
  "lat" varchar(31) DEFAULT NULL,
  "long" varchar(31) DEFAULT NULL,
  PRIMARY KEY ("id")
);



# Dump of table pstnPrefixes
# ------------------------------------------------------------
DROP TABLE IF EXISTS "pstnPrefixes";

CREATE TABLE "pstnPrefixes" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(128) DEFAULT NULL,
  "prefix" varchar(32) DEFAULT NULL,
  "start" varchar(32) DEFAULT NULL,
  "stop" varchar(32) DEFAULT NULL,
  "master" int DEFAULT '0',
  "deviceId" int  DEFAULT NULL,
  "description" varchar(max),
  PRIMARY KEY ("id")
);



# Dump of table pstnNumbers
# ------------------------------------------------------------
DROP TABLE IF EXISTS "pstnNumbers";

CREATE TABLE "pstnNumbers" (
  "id" int  NOT NULL IDENTITY(1,1),
  "prefix" int  DEFAULT NULL,
  "number" varchar(32) DEFAULT NULL,
  "name" varchar(128) DEFAULT NULL,
  "owner" varchar(128) DEFAULT NULL,
  "state" int  DEFAULT NULL,
  "deviceId" int  DEFAULT NULL,
  "description" varchar(max),
  PRIMARY KEY ("id")
);



# Dump of table circuitProviders
# ------------------------------------------------------------
DROP TABLE IF EXISTS "circuitProviders";

CREATE TABLE "circuitProviders" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(256) DEFAULT NULL,
  "description" varchar(max),
  "contact" varchar(128) DEFAULT '',
  PRIMARY KEY ("id")
);



# Dump of table circuits
# ------------------------------------------------------------
DROP TABLE IF EXISTS "circuits";

CREATE TABLE "circuits" (
  "id" int  NOT NULL IDENTITY(1,1),
  "cid" varchar(128) DEFAULT NULL,
  "provider" int  NOT NULL,
  "type" int  DEFAULT NULL,
  "capacity" varchar(128) DEFAULT NULL,
  "status" varchar(255) NOT NULL DEFAULT 'Active',
  "device1" int  DEFAULT NULL,
  "location1" int  DEFAULT NULL,
  "device2" int  DEFAULT NULL,
  "location2" int  DEFAULT NULL,
  "comment" varchar(max),
  "parent" int  NOT NULL DEFAULT '0',
  "customer_id" int  DEFAULT NULL,
  "differentiator" varchar(100) DEFAULT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("cid","differentiator"),
  /* INDEX "location1" */,
  /* INDEX "location2" */,
  /* INDEX "customer_id" */,
  CONSTRAINT "customer_circuits" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

# Dump of table circuitsLogical
# ------------------------------------------------------------
DROP TABLE IF EXISTS "circuitsLogical";

CREATE TABLE "circuitsLogical" (
  "id" int  NOT NULL IDENTITY(1,1),
  "logical_cid" varchar(128) NOT NULL,
  "purpose" varchar(64) DEFAULT NULL,
  "comments" varchar(max),
  "member_count" int  NOT NULL DEFAULT '0',
  PRIMARY KEY ("id"),
  UNIQUE ("logical_cid")
);


# Dump of table circuitsLogicalMapping
# ------------------------------------------------------------
DROP TABLE IF EXISTS "circuitsLogicalMapping";

CREATE TABLE "circuitsLogicalMapping" (
  "logicalCircuit_id" int  NOT NULL,
  "circuit_id" int  NOT NULL,
  "order" int  DEFAULT NULL,
  PRIMARY KEY ("logicalCircuit_id", "circuit_id")
);


# Dump of table circuitTypes
# ------------------------------------------------------------
DROP TABLE IF EXISTS "circuitTypes";

CREATE TABLE "circuitTypes" (
  "id" int  NOT NULL IDENTITY(1,1),
  "ctname" varchar(64) NOT NULL,
  "ctcolor" varchar(7) DEFAULT '#000000',
  "ctpattern" varchar(255) DEFAULT 'Solid',
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "circuitTypes" ("ctname") VALUES ('Default');


# Dump of table php_sessions
# ------------------------------------------------------------
DROP TABLE IF EXISTS "php_sessions";

CREATE TABLE "php_sessions" (
  "id" varchar(128) NOT NULL DEFAULT '',
  "access" int  DEFAULT NULL,
  "data" varchar(max) NOT NULL, /* __no_html_escape__ */
  "remote_ip" varchar(100) DEFAULT NULL,
  PRIMARY KEY ("id")
);


# Dump of table routing_bgp
# ------------------------------------------------------------
DROP TABLE IF EXISTS "routing_bgp";

CREATE TABLE "routing_bgp" (
  "id" int  NOT NULL IDENTITY(1,1),
  "local_as" int  NOT NULL,
  "local_address" varchar(100) NOT NULL DEFAULT '',
  "peer_name" varchar(255) NOT NULL DEFAULT '',
  "peer_as" int  NOT NULL,
  "peer_address" varchar(100) NOT NULL DEFAULT '',
  "bgp_type" varchar(255) NOT NULL DEFAULT 'external',
  "vrf_id" int  DEFAULT NULL,
  "circuit_id" int  DEFAULT NULL,
  "customer_id" int  DEFAULT NULL,
  "description" varchar(max) DEFAULT NULL,
  PRIMARY KEY ("id"),
  /* INDEX "vrf_id" */,
  /* INDEX "circuit_id" */,
  /* INDEX "customer_id" */,
  CONSTRAINT "circuit_id" FOREIGN KEY ("circuit_id") REFERENCES "circuits" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "cust_id" FOREIGN KEY ("customer_id") REFERENCES "customers" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "vrf_id" FOREIGN KEY ("vrf_id") REFERENCES "vrf" ("vrfId") ON DELETE SET NULL ON UPDATE CASCADE
);


# Dump of table routing_subnets
# ------------------------------------------------------------
DROP TABLE IF EXISTS "routing_subnets";

CREATE TABLE "routing_subnets" (
  "id" int  NOT NULL IDENTITY(1,1),
  "type" varchar(255) NOT NULL DEFAULT 'bgp',
  "direction" varchar(255) NOT NULL DEFAULT 'advertised',
  "object_id" int  NOT NULL,
  "subnet_id" int NOT NULL,
  PRIMARY KEY ("id"),
  UNIQUE ("type","object_id","subnet_id"),
  /* INDEX "object_id" */,
  /* INDEX "subnet_id" */,
  CONSTRAINT "bgp_id" FOREIGN KEY ("object_id") REFERENCES "routing_bgp" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "subnet_id" FOREIGN KEY ("subnet_id") REFERENCES "subnets" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);


# Dump of table vaults
# ------------------------------------------------------------
DROP TABLE IF EXISTS "vaults";

CREATE TABLE "vaults" (
  "id" int  NOT NULL IDENTITY(1,1),
  "name" varchar(64) NOT NULL DEFAULT '',
  "type" varchar(255) NOT NULL DEFAULT 'passwords',
  "description" varchar(max),
  "test" char(128) NOT NULL DEFAULT '', /* __no_html_escape__ */
  PRIMARY KEY ("id")
);


# Dump of table vaultItems
# ------------------------------------------------------------
DROP TABLE IF EXISTS "vaultItems";

CREATE TABLE "vaultItems" (
  "id" int  NOT NULL IDENTITY(1,1),
  "vaultId" int  NOT NULL,
  "type" varchar(255) NOT NULL DEFAULT 'password',
  "type_certificate" varchar(255) NOT NULL DEFAULT 'public',
  "values" varchar(max), /* __no_html_escape__ */
  PRIMARY KEY ("id"),
  /* INDEX "vaultId" */,
  CONSTRAINT "vaultItems_ibfk_1" FOREIGN KEY ("vaultId") REFERENCES "vaults" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);


# Dump of table passkeys
# ------------------------------------------------------------
DROP TABLE IF EXISTS "passkeys";

-- passkey table
CREATE TABLE "passkeys" (
  "id" int  NOT NULL IDENTITY(1,1),
  "user_id" int NOT NULL,
  "credentialId" varchar(max) NOT NULL,
  "keyId" varchar(max) NOT NULL,
  "credential" varchar(max) NOT NULL, /* __no_html_escape__ */
  "comment" varchar(max),
  "created" timestamp NULL DEFAULT NULL,
  "used" timestamp NULL DEFAULT NULL,
  PRIMARY KEY ("id"),
  /* INDEX "user_id" */,
  CONSTRAINT "user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);


# Dump of table nominatim
# ------------------------------------------------------------
DROP TABLE IF EXISTS "nominatim";

CREATE TABLE "nominatim" (
  "id" int  NOT NULL IDENTITY(1,1),
  "url" varchar(255) NOT NULL,
  PRIMARY KEY ("id")
);
/* insert default values */
INSERT INTO "nominatim" ("id", "url") VALUES (1, 'https://nominatim.openstreetmap.org/search');


# Dump of table nominatim_cache
# ------------------------------------------------------------
DROP TABLE IF EXISTS "nominatim_cache";

CREATE TABLE "nominatim_cache" (
  "sha256" binary(32) NOT NULL, /* __no_html_escape__ */
  "date" timestamp NOT NULL DEFAULT current_timestamp(),
  "query" varchar(max) NOT NULL, /* __no_html_escape__ */
  "lat_lng" varchar(max) NOT NULL,
  PRIMARY KEY ("sha256")
);


# Dump of table -- for autofix comment, leave as it is
# ------------------------------------------------------------

UPDATE "settings" SET "version" = "1.74";
UPDATE "settings" SET "dbversion" = 43;
