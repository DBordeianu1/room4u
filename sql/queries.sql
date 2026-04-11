SET search_path = 'public';
------ Query 1: Has nested query (from clause) and aggregation
-- Find all amenities of room 5 in hotel 44, 
-- and calculate its final price given that every amenity it has, 
-- it's price increases by 10% of the original price.
SELECT ROUND(price+(price*0.10*COUNT(amenity)),2) AS final_price FROM room_amenity NATURAL JOIN 
(SELECT hotel_id,room_number,price FROM room WHERE (hotel_id=44 AND room_number=5)) 
GROUP BY room_number,price;

------ Query 2: Has aggregation 
-- Find the province in Canada with the most employees.
SELECT state_province,COUNT(*) AS employee_count FROM (person NATURAL JOIN employee) 
WHERE country='canada' GROUP BY state_province ORDER BY employee_count DESC LIMIT 1;

------ Query 3
-- Find all hotels that have no rooms with problems.
SELECT hotel_id FROM hotel h WHERE NOT EXISTS 
(SELECT * FROM room_problem AS rp WHERE h.hotel_id=rp.hotel_id) ORDER BY hotel_id;

------ Query 4
-- Find all email addresses of hotels or hotel chains that are dedicated to customer service.
(SELECT email_address FROM hotel_chain_email WHERE email_type='Customer Service') UNION
(SELECT email_address FROM hotel_email WHERE email_type='Customer Service');
