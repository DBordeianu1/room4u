------ testing queries for trigger of user-defined constraint #5 (from deliverable 1, see triggers.sql)
-- should notice a change
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=1;
UPDATE booking SET STATUS='cancelled' WHERE registration_id=1;
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=1;

-- should notice a change
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=5;
UPDATE booking SET STATUS='cancelled' WHERE registration_id=5;
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=5;

-- no change here
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=3;
UPDATE booking SET STATUS='cancelled' WHERE registration_id=3;
SELECT r.registration_id,r.is_archived,b.status FROM registration r JOIN booking b ON r.registration_id=b.registration_id WHERE r.registration_id=3;



------ testing queries for trigger of user-defined constraint #14 (from deliverable 1, see triggers.sql)
-- this insert should succeed
INSERT INTO person(id_number,id_type,first_name,middle_name,last_name,street_number,street_name,city,state_province,zip_postal_code,country)
VALUES (555987213,'sin','Blake','Lily','Calm',5,'Lively Rd.','Toronto','Ontario','W2S3D4','canada');
INSERT INTO employee (id_number,id_type,hotel_id) VALUES (555987213,'sin',44);

-- this insert should succeed
INSERT INTO person(id_number,id_type,first_name,last_name,street_number,street_name,city,state_province,zip_postal_code,country)
VALUES (777987213,'ssn','George','Washington',100,'Colorado Rd.','Washington','District of Columbia','55567','us');
INSERT INTO employee (id_number,id_type,hotel_id) VALUES (777987213,'ssn',44);

-- this insert should fail
INSERT INTO person(id_number,id_type,first_name,last_name,street_number,street_name,city,state_province,zip_postal_code,country)
VALUES (888987213,'ssn','Harry','Potter',4,'Privet Drive','Orlando','Florida','34349','us');
INSERT INTO employee (id_number,id_type,hotel_id) VALUES (888987213,'ssn',44);

-- this delete should fail
-- DELETE FROM person WHERE id_number=223761213 AND id_type='ssn';
DELETE FROM employee WHERE id_number=223761213 AND id_type='ssn';



------ testing queries for trigger of user-defined constraint #6 (from deliverable 1, see triggers.sql)
-- customer deletion
-- before
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (1,7);
-- trigger fires here
DELETE FROM customer WHERE id_number=123456789 AND id_type='ssn';
-- after
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (1,7);

-- room deletion
-- before
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (3,6);
-- trigger fires here
DELETE FROM room WHERE hotel_id=23 AND room_number=1;
-- after
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (3,6);

-- hotel deletion
-- before
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (1,2);
-- trigger fires here
DELETE FROM hotel WHERE hotel_id=44;
-- after
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (1,2);

-- hotel chain deletion
-- before
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (3,4,5,6);
-- trigger fires here
DELETE FROM hotel_chain WHERE chain_id=3;
-- after
SELECT registration_id,is_archived FROM registration WHERE registration_id IN (3,4,5,6);