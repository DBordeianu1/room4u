SET search_path = 'public';
-- trigger for user-defined constraint #5 (from deliverable 1)
-- where booking canceled>AFTER UPDATE of status>set is_archived=true on registration
CREATE OR REPLACE FUNCTION archive_booking()
RETURNS TRIGGER AS 
$body$
BEGIN
	IF NEW.status='cancelled' AND (OLD.status='pending' OR OLD.status='confirmed') THEN
		UPDATE registration
		SET is_archived=true
		WHERE registration_id=NEW.registration_id;
	END IF;
	RETURN NEW;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER booking_to_archive
AFTER UPDATE OF status
ON booking
FOR EACH ROW
EXECUTE FUNCTION archive_booking();


-- trigger for user-defined constraint #14 (from deliverable 1)
-- where hotels can have no more than 4 managers and no less than 1
-- hotel manager number superior to 4>rollback

-- I'd like to point out that I know that some of the hotels do not have their own managers, 
-- but that was just the initial data insertion (see setting up db section in README).
CREATE OR REPLACE FUNCTION monitor_hotel_managers()
RETURNS TRIGGER AS 
$body$
BEGIN
	IF TG_OP='INSERT' THEN
		IF (SELECT COUNT(*) FROM employee WHERE hotel_id=NEW.hotel_id)>4 THEN
			RAISE EXCEPTION 'Hotel cannot have more than 4 managers';
		END IF;
		RETURN NEW;
	
	ELSE
		IF (SELECT COUNT(*) FROM employee WHERE hotel_id=OLD.hotel_id)=0 THEN
			RAISE EXCEPTION 'Hotel must have at least 1 manager';
		END IF;
		RETURN OLD;
	END IF;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER number_of_managers
AFTER INSERT OR DELETE
ON employee
FOR EACH ROW
EXECUTE FUNCTION monitor_hotel_managers();

-- trigger for user-defined constraint #6 (from deliverable 1)
-- When information about a hotel chain, hotel (or room) or customer gets deleted, the 
-- booking/renting associated should be archived, i.e. the attribute is_archived in 
-- registration is set to true. 
-- if you delete a customer
CREATE OR REPLACE FUNCTION archive_from_customer()
RETURNS TRIGGER AS 
$body$
BEGIN
	IF TG_OP='DELETE' THEN
		UPDATE registration
		SET is_archived=true
		WHERE registration_id 
		IN (SELECT registration_id FROM makes WHERE id_number=OLD.id_number AND id_type=OLD.id_type);
	END IF;
	RETURN OLD;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER to_archive_from_customer
BEFORE DELETE
ON customer
FOR EACH ROW
EXECUTE FUNCTION archive_from_customer();

-- if you delete a room (will cascade, so a particular one for hotel and hotel_chain is not needed)
CREATE OR REPLACE FUNCTION archive_from_room()
RETURNS TRIGGER AS 
$body$
BEGIN
	IF TG_OP='DELETE' THEN
		UPDATE registration
		SET is_archived=true
		WHERE registration_id 
		IN (SELECT registration_id FROM reg_room WHERE hotel_id=OLD.hotel_id AND room_number=OLD.room_number);
	END IF;
	RETURN OLD;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER to_archive_from_room
BEFORE DELETE
ON room
FOR EACH ROW
EXECUTE FUNCTION archive_from_room();