-- Database: sdafdf

-- DROP DATABASE sdafdf;

CREATE DATABASE sdafdf
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Russian_Russia.1251'
       LC_CTYPE = 'Russian_Russia.1251'
       CONNECTION LIMIT = -1;
       
CREATE TABLE Users (
	user_id int,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	middle_name varchar(50),
	INN varchar(60) NOT NULL,
	doc_type varchar(60)NOT NULL,
	doc_number varchar(60)NOT NULL,
	doc_issue varchar(60)NOT NULL,
	doc_expire varchar(60)NOT NULL,
	PRIMARY KEY (user_id)
);

INSERT INTO Users
	VALUES(2001,'Aksakalov' , 'Beksultan', 'Assanovich', '123456789', 'PASSPORT','87878787','06.06.2010','12.12.2050'),
		  (2002,'Aksakalova' , 'Gaukhar', 'Assanovna', '1234567891', 'PASSPORT','87878788','04.08.2008','12.12.2030'),
		  (2003,'Aksakalov' , 'Sundet', 'Assanovich', '1234567890', 'PASSPORT','87878789','02.07.2009','12.12.2040');

CREATE TABLE Roles (
	role_id int,
	description_r varchar(255) NOT NULL,
	PRIMARY KEY (role_id)
);

INSERT INTO Roles
	VALUES(2101,'Train driver'),
		  (2102,'Passenger'),
		  (2103,'Conductor');
	      	
CREATE TABLE User_roles (
	user_role_id int,
	user_id int,
	role_id int,
	PRIMARY KEY (user_role_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (role_id) REFERENCES Roles(role_id) 
);

INSERT INTO User_roles
	VALUES(1,2001,2101),
		  (2,2002,2102),
		  (3,2003,2103);

CREATE TABLE Type_train (
	type_train_id int,
	tp_name varchar(50)NOT NULL,
	tp_description varchar(255)NOT NULL,
	PRIMARY KEY (type_train_id)
);

INSERT INTO Type_train
	VALUES(2611,'Тулпар-Тальго','При производстве всех маятниковых поездов, выпускаемых ТАЛЬГО, особое внимание уделяется безопасности,
	      скорости, комфорту, экономии энергии и уменьшению загрязнения окружающей среды.'),
	      (2612,'Актобе-Шымкент','Поезд едет со скоростью не более 180км час'),
	      (2613,'Шымкент-Алматы','Поезд имеет только один путь');

CREATE TABLE Stations(
	station_id int,
	st_name varchar(50)NOT NULL,
	st_city varchar(50)NOT NULL,
	st_loaction varchar(50)NOT NULL,
	PRIMARY KEY (station_id)
);

INSERT INTO Stations
	VALUES(2311,'Moscow','Aktobe','Aksay microdistrict'),
	      (2312,'Bekzhan','Shymkent','Samal district'),
	      (2313,'Almaty-1','Almaty','Abilaykhana 7street');

CREATE TABLE Routes (
	routes_id int,
	start_station_id int,
	end_station_id int,
	PRIMARY KEY(routes_id),
	FOREIGN KEY(start_station_id) REFERENCES Stations(station_id),
	FOREIGN KEY(end_station_id) REFERENCES Stations(station_id)
);

INSERT INTO Routes
	VALUES(2411,2311,2311),
	      (2412,2312,2312),
	      (2413,2313,2313);

CREATE TABLE Train_company (
	train_company_id int,
	short_name varchar(50)  NOT NULL,
	full_name varchar(255)  NOT NULL,
	PRIMARY KEY(train_company_id)
);

INSERT INTO Train_company
	VALUES(2711,'TOO','"TOO" Astana railway'),
	      (2712,'AO','"AO" Aktobe'),
	      (2713,'IP','"IP" Shymkent');

CREATE TABLE Trains (
	train_id int,
	go_time date NOT NULL,
	arrival_time date NOT NULL,
	routes_id int,
	type_train_id int,
	train_company_id int,
	PRIMARY KEY (train_id),
	FOREIGN KEY (routes_id)REFERENCES Routes(routes_id),
	FOREIGN KEY (type_train_id)REFERENCES Type_train(type_train_id),
	FOREIGN KEY (train_company_id)REFERENCES Train_company(train_company_id)
);

INSERT INTO Trains
	VALUES(2911,'1-Nov-2016','2-Nov-2016',2411,2611,2711),
	      (2912,'2-June-2016','3-June-2016',2412,2612,2712),
	      (2913,'3-October-2016','4-October-2016',2413,2613,2713);

CREATE TABLE Classification_types (
	classif_id int,
	classif_name varchar(255)NOT NULL,
	classif_description varchar(255) NOT NULL,
	PRIMARY KEY (classif_id)
);

INSERT INTO Classification_types
	VALUES (2511,'Compart','Special room in the passenger railway carriage'),
	       (2512,'Reserved seat','One of the types of passenger railway carriage in Russia and other CIS countries'),
	       (2513,'luxury','Double compartments which can be accessories');

CREATE TABLE Places (
	place_id int,
	pl_price int NOT NULL,
	train_id int,
	classif_id int,
	PRIMARY KEY (place_id),
	FOREIGN KEY (train_id) REFERENCES Trains(train_id),
	FOREIGN KEY (classif_id)REFERENCES Classification_types(classif_id)
);

INSERT INTO Places
	VALUES(3111,2500,2911,2511),
	      (3112,3500,2912,2512),
	      (3113,4500,2913,2513);

CREATE TABLE Compare_places (
	compare_palce_id int,
	user_id int,
	place_id int,
	PRIMARY KEY (compare_palce_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (place_id) REFERENCES Places(place_id)
);

INSERT INTO Compare_places
	VALUES(2211,2001,3111),
	      (2212,2002,3112),
	      (2213,2003,3113);

CREATE TABLE Ticket (
	ticket_id int,
	print_time varchar(50),
	place_id int,
	PRIMARY KEY (ticket_id),
	FOREIGN KEY (place_id) REFERENCES Places(place_id)
);

INSERT INTO Ticket
	VALUES(4111,'23:00 10-Nov-2016',3111),
	      (4112,'22:20 11-Jun-2015',3112),
	      (4113,'21:30 12-May-2015',3113);

CREATE TABLE Orders (
	order_id int,
	order_time varchar(255) NOT NULL,
	user_id int,
	ticket_id int,
	PRIMARY KEY(order_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (ticket_id)REFERENCES Ticket(ticket_id)
);

INSERT INTO Orders
	VALUES(5111,'23:00 10-Nov-2016',2001,4111),
	      (5112,'22:20 11-Jun-2015',2002,4112),
	      (5113,'21:30 12-May-2015',2003,4113);

CREATE TABLE Time_table (
	time_id int,
	go_time  date NOT NULL,
	arrival_time date NOT NULL,
	train_id int,
	station_id int,
	PRIMARY KEY (time_id),
	FOREIGN KEY (train_id) REFERENCES Trains(train_id),
	FOREIGN KEY (station_id) REFERENCES Stations(station_id)
);

INSERT INTO Time_table
	VALUES(3011,'1-May-2015','2-May-2015',2911,2311),
	      (3012,'2-May-2015','3-May-2015',2912,2312),
	      (3013,'3-May-2015','4-May-2015',2913,2313);
		  
UPDATE Time_table SET arrival_time='05.12.2016' WHERE time_id=3011;

ALTER TABLE Time_table
	ADD temp varchar(25);
	
	
ALTER TABLE Time_table
	DROP temp;