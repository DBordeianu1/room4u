UPDATE booking
SET status = 'pending'
WHERE registration_id IN (1, 2);