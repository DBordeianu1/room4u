SET search_path = 'public';
DROP TABLE IF EXISTS processes, supervises, works_at, makes, reg_room, 
customer, employee_role, employee, person, renting, booking, 
registration_special_request, registration, room_amenity, room_problem, 
room_view, room, hotel_phone, hotel_email, hotel, hotel_chain_phone, 
hotel_chain_email, hotel_chain;
-- ddl statements
-- hotel chain related tables
-- name was changed to chain_name because recognized as sql keyword
CREATE TABLE hotel_chain(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5) PRIMARY KEY,
	chain_name varchar(100) NOT NULL,
	street_number varchar(10) NOT NULL,
	street_name varchar(50) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us')
);

CREATE TABLE hotel_chain_email(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	email_address varchar(100) CHECK (email_address LIKE '_%@_%._%'),
	email_type varchar(100),
	PRIMARY KEY(chain_id,email_address,email_type),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

CREATE TABLE hotel_chain_phone(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	phone_number varchar(25),
	phone_type varchar(100),
	PRIMARY KEY(chain_id,phone_number,phone_type),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

-- hotel related tables
-- name was changed to hotel_name because recognized as sql keyword
CREATE TABLE hotel(
	hotel_id bigserial PRIMARY KEY,
	chain_id numeric(1,0) NOT NULL CHECK(chain_id BETWEEN 1 AND 5),
	hotel_name varchar(100) NOT NULL,
	classification numeric(1,0) NOT NULL CHECK(classification BETWEEN 1 AND 5),
	street_number varchar(10) NOT NULL,
	street_name varchar(50) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us'),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

CREATE TABLE hotel_email(
	hotel_id bigint,
	email_address varchar(100) CHECK (email_address LIKE '_%@_%._%'),
	email_type varchar(100),
	PRIMARY KEY(hotel_id,email_address,email_type),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

CREATE TABLE hotel_phone(
	hotel_id bigint,
	phone_number varchar(25),
	phone_type varchar(100),
	PRIMARY KEY(hotel_id,phone_number,phone_type),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

-- room related tables although they depend on hotel

-- although room_number is called number in the relational schema diagram,
-- this change was required to minimize confusion
-- same thing applies for view which becomes view_of_room
CREATE TABLE room(
	hotel_id bigint,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	price numeric(6,2) NOT NULL,
	capacity varchar(10) NOT NULL CHECK(capacity='single' OR capacity='double' OR capacity='suite' OR capacity='family' OR capacity='royal' OR capacity='presidential'),
	extendable boolean NOT NULL,
	PRIMARY KEY(hotel_id,room_number),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

CREATE TABLE room_view(
	hotel_id bigint,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	view_of_room varchar(10) CHECK(view_of_room='mountain' OR view_of_room='sea' OR view_of_room='none'),
	PRIMARY KEY(hotel_id,room_number,view_of_room),
	FOREIGN KEY(hotel_id,room_number) REFERENCES room(hotel_id,room_number)
);

CREATE TABLE room_problem(
	hotel_id bigint,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	problem varchar(100),
	PRIMARY KEY(hotel_id,room_number,problem),
	FOREIGN KEY(hotel_id,room_number) REFERENCES room(hotel_id,room_number)
);

CREATE TABLE room_amenity(
	hotel_id bigint,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	amenity varchar(100),
	PRIMARY KEY(hotel_id,room_number,amenity),
	FOREIGN KEY(hotel_id,room_number) REFERENCES room(hotel_id,room_number)	
);

-- registration related tables
CREATE TABLE registration(
	registration_id bigserial PRIMARY KEY,
	start_date timestamp NOT NULL,
	end_date timestamp NOT NULL,
	is_archived boolean NOT NULL,
	CHECK(start_date<end_date)
);

CREATE TABLE registration_special_request(
	registration_id bigint,
	special_request varchar(100),
	PRIMARY KEY(registration_id,special_request),
	FOREIGN KEY(registration_id) REFERENCES registration
);

CREATE TABLE booking(
	registration_id bigint PRIMARY KEY,
	status varchar(20) NOT NULL CHECK(status='pending' OR status='cancelled' OR status='confirmed'),
	booking_date timestamp NOT NULL,
	FOREIGN KEY(registration_id) REFERENCES registration
);

CREATE TABLE renting(
	registration_id bigint PRIMARY KEY,
	paid boolean NOT NULL,
	renting_date timestamp NOT NULL,
	FOREIGN KEY(registration_id) REFERENCES registration
);

--person related tables
CREATE TABLE person(
	id_number numeric(9,0) CHECK(id_number>0),
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	first_name varchar(100) NOT NULL,
	middle_name varchar(100),
	last_name varchar(100) NOT NULL,
	street_number varchar(10) NOT NULL,
	street_name varchar(50) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us'),
	PRIMARY KEY(id_number,id_type)
);

CREATE TABLE employee(
	id_number bigint,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	hotel_id bigint,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES person,
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

-- role was changed to employee_role as it is perceived as a keyword in sql
CREATE TABLE employee_role(
	id_number bigint,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	employee_role varchar(100),
	PRIMARY KEY(id_number,id_type,employee_role),
	FOREIGN KEY(id_number,id_type) REFERENCES employee
);

CREATE TABLE customer(
	id_number bigint,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	date_of_registration timestamp NOT NULL,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES person
);

-- "relationships"
-- registration and room
CREATE TABLE reg_room(
	registration_id bigint PRIMARY KEY,
	hotel_id bigint NOT NULL,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000) NOT NULL,
	FOREIGN KEY(registration_id) REFERENCES registration,
	FOREIGN KEY(hotel_id,room_number) REFERENCES room(hotel_id,room_number)
);

-- registration and customer
-- unlike the current schema diagram, the attributes for customer are not preceded by customer
CREATE TABLE makes(
	registration_id bigint PRIMARY KEY,
	id_number bigint NOT NULL,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	FOREIGN KEY(registration_id) REFERENCES registration NOT NULL,
	FOREIGN KEY(id_number,id_type) REFERENCES customer
);

-- employee and hotel
CREATE TABLE works_at(
	id_number bigint,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	hotel_id bigint NOT NULL,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES employee,
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

-- employee with itself
CREATE TABLE supervises(
	employee_id_number bigint,
	employee_id_type varchar(3) CHECK (employee_id_type='sin' OR employee_id_type='ssn'),
	manager_id_number bigint,
	manager_id_type varchar(3) CHECK (manager_id_type='sin' OR manager_id_type='ssn'),
	PRIMARY KEY(employee_id_number,employee_id_type),
	FOREIGN KEY(employee_id_number,employee_id_type) REFERENCES employee(id_number,id_type),
	FOREIGN KEY(manager_id_number,manager_id_type) REFERENCES employee(id_number,id_type)
);

-- employee and renting
CREATE TABLE processes(
	id_number bigint,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	registration_id bigint NOT NULL,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES employee,
	FOREIGN KEY(registration_id) REFERENCES registration
);