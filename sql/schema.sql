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
	country varchar(10) NOT NULL CHECK(country='Canada' OR country='US'),
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
	country varchar(10) NOT NULL CHECK(country='Canada' OR country='US'),
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
CREATE TABLE room(
	hotel_id bigserial,
	room_number integer CHECK(room_number BETWEEN 1 AND 1000),
	price numeric(6,2) NOT NULL,
	capacity varchar(10) NOT NULL CHECK(capacity='single' OR capacity='double' OR capacity='suite' OR capacity='family'),
	extendable boolean NOT NULL,
	PRIMARY KEY(hotel_id,room_number),
	FOREIGN KEY(hotel_id) REFERENCES hotel
);
