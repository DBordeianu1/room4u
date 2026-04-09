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
-- but that was just the initial data transfer.
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
AFTER DELETE OR INSERT
ON employee
FOR EACH ROW
EXECUTE FUNCTION monitor_hotel_managers();