SET search_path = 'public';
-- ddl statements
-- hotel chain related tables
CREATE TABLE hotel_chain(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	name varchar(100) NOT NULL,
	street_number varchar(10) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us'),
	PRIMARY KEY(chain_id)
);

CREATE TABLE hotel_chain_email(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	email_address varchar(100) CHECK (email LIKE '_%@_%._%'),
	email_type varchar(100),
	PRIMARY KEY(chain_id,email_address,email_type),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

CREATE TABLE hotel_chain_phone(
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	phone_number varchar(25),
	phone_type varchar(100)
	PRIMARY KEY(chain_id,phone_number,phone_type),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

-- hotel related tables
CREATE TABLE hotel(
	hotel_id bigserial PRIMARY KEY,
	chain_id numeric(1,0) CHECK(chain_id BETWEEN 1 AND 5),
	name varchar(100) NOT NULL,
	classification numeric(1,0) CHECK classification BETWEEN 1 AND 5),
	street_number varchar(10) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us'),
	FOREIGN KEY(chain_id) REFERENCES hotel_chain
);

CREATE TABLE hotel_email(
	hotel_id bigserial,
	email_address varchar(100) CHECK (email LIKE '_%@_%._%'),
	email_type varchar(100),
	PRIMARY KEY(hotel_id,email_address,email_type),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

CREATE TABLE hotel_phone(
	hotel_id bigserial,
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
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	price numeric(6,2) NOT NULL,
	capacity varchar(10) NOT NULL CHECK(capacity='single' OR capacity='double' OR capacity='suite' OR capacity='family'),
	extendable boolean NOT NULL,
	PRIMARY KEY(hotel_id,room_number),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

CREATE TABLE room_view(
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	view_of_room varchar(10) CHECK(view_of_room='mountain' OR view_of_room='sea' OR view_of_room='none'),
	PRIMARY KEY(hotel_id,room_number,view_of_room)
	FOREIGN KEY(hotel_id) REFERENCES hotel,
	FOREIGN KEY(room_number) REFERENCES room
);

CREATE TABLE room_problem(
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	problem varchar(100),
	PRIMARY KEY(hotel_id,room_number,problem),
	FOREIGN KEY(hotel_id) REFERENCES hotel,
	FOREIGN KEY(room_number) REFERENCES room
);

CREATE TABLE room_amenity(
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	amenity varchar(100),
	PRIMARY KEY(hotel_id,room_number,amenity),
	FOREIGN KEY(hotel_id) REFERENCES hotel,
	FOREIGN KEY(room_number) REFERENCES room	
);

-- registration related tables
CREATE TABLE registration(
	registration_id bigserial PRIMARY KEY,
	start_date timestamp NOT NULL,
	end_date timestamp NOT NULL,
	is_archived boolean NOT NULL
);

CREATE TABLE registration_special_request(
	registration_id bigserial,
	special_request varchar(100),
	PRIMARY KEY(registration_id,special_request),
	FOREIGN KEY(registration_id) REFERENCES registration
);

CREATE TABLE booking(
	registration_id bigserial PRIMARY KEY,
	status varchar(20) NOT NULL,
	booking_date timestamp NOT NULL,
	FOREIGN KEY(registration_id) REFERENCES registration
);

CREATE TABLE renting(
	registration_id bigserial PRIMARY KEY,
	paid boolean NOT NULL,
	renting_date timestamp NOT NULL,
	FOREIGN KEY(registration_id) REFERENCES registration
);

--person related tables
CREATE TABLE person(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	first_name varchar(100) NOT NULL,
	middle_name varchar(100),
	last_name varchar(100) NOT NULL,
	street_number varchar(10) NOT NULL,
	city varchar(20) NOT NULL,
	state_province varchar(50) NOT NULL,
	zip_postal_code varchar(10) NOT NULL,
	country varchar(10) NOT NULL CHECK(country='canada' OR country='us')
	PRIMARY KEY(id_number,id_type)
);

CREATE TABLE employee(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	hotel_id bigserial PRIMARY KEY,
	PRIMARY KEY(id_number,id_type,hotel_id),
	FOREIGN KEY(id_number,id_type) REFERENCES person
);

CREATE TABLE employee_role(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	role varchar(100),
	PRIMARY KEY(id_number,id_type,role),
	FOREIGN KEY(id_number,id_type) REFERENCES person
);

CREATE TABLE customer(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	date_of_registration timestamp,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES person
);

-- "relationships"
-- registration and room
CREATE TABLE reg_room(
	registration_id bigserial PRIMARY KEY,
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	FOREIGN KEY(registration_id) REFERENCES registration,
	FOREIGN KEY(hotel_id) REFERENCES hotel,
	FOREIGN KEY(room_number) REFERENCES room
);

-- registration and customer
-- unlike the current schema diagram, the attributes for customer are not preceded by customer
CREATE TABLE makes(
	registration_id bigserial PRIMARY KEY,
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	FOREIGN KEY(registration_id) REFERENCES registration,
	FOREIGN KEY(id_number,id_type) REFERENCES customer
);

-- employee and hotel
CREATE TABLE works_at(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	hotel_id bigserial,
	PRIMARY KEY(id_number,id_type),
	FOREIGN KEY(id_number,id_type) REFERENCES employee,
	FOREIGN KEY(hotel_id) REFERENCES hotel
);

-- employee with itself
CREATE TABLE supervises(
	employee_id_number bigserial,
	employee_id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	manager_id_number bigserial,
	manager_id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	PRIMARY KEY(employee_id_number,employee_id_type,manager_id_number,manager_id_type),
	FOREIGN KEY(employee_id_number,employee_id_type,manager_id_number,manager_id_type) REFERENCES employee
);

-- employee and renting
CREATE TABLE processes(
	id_number bigserial,
	id_type varchar(3) CHECK (id_type='sin' OR id_type='ssn'),
	registration_id bigserial,
	PRIMARY KEY(id_number,id_type)
	FOREIGN KEY(id_number,id_type) REFERENCES employee
	FOREIGN KEY(registration_id) REFERENCES registration
);