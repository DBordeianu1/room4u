SET search_path = 'public';
----- View 1: the first view is the number of available rooms per area.
-- To be able to test view 1 from deliverable 2's description, you need to insert these values in the db
INSERT INTO registration(start_date,end_date,is_archived) VALUES ('2026-04-01 00:00:00','2026-05-30 00:00:00',false) RETURNING registration_id;
-- double-check the registration_id from the return value of the above query
-- (it should be 17, otherwise insert change registration_id to the value you see in pgAdmin's message panel)
INSERT INTO reg_room(registration_id,hotel_id,room_number) VALUES (17,29,4);

-- we assume that when we wish to look for available rooms based on the time at which the query is run
CREATE VIEW available_rooms_per_area AS
SELECT state_province,country,COUNT(*) AS available_rooms FROM room r INNER JOIN hotel h ON r.hotel_id=h.hotel_id
WHERE NOT EXISTS
          (SELECT hotel_id,room_number FROM registration reg INNER JOIN reg_room rr ON reg.registration_id=rr.registration_id
           WHERE rr.hotel_id=r.hotel_id AND rr.room_number=r.room_number AND reg.start_date<=CURRENT_TIMESTAMP AND reg.end_date>=CURRENT_TIMESTAMP)
GROUP BY country,state_province;

----- View 2: the second view is the aggregated capacity of all the rooms of a specific hotel.
CREATE VIEW hotel_capacity AS
SELECT hotel_id,SUM(
        CASE WHEN capacity='single' THEN 1
             WHEN capacity='double' THEN 2
             WHEN capacity='suite' THEN 4
             WHEN capacity='family' THEN 6
             WHEN (capacity='royal' OR capacity='penthouse') THEN 10
            END
                ) AS total_capacity FROM room GROUP BY hotel_id;