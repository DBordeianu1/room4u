----- Index 1: Searching for a room by capacity (low-cardinality)
-- Justification:
-- The search in the webapp allows for rooms to be found according to their capacity,
-- which in our db implementation, can take these values: single, double, family, royal, penthouse
-- Since these values are evenly distributed across the room table, a partial index would not be appropriate.
-- A single-column index is therefore the right choice: no particular value is rare.
-- This index is especially useful when querying the db this way:
--       SELECT * FROM room WHERE capacity='[insert specified capacity]'
-- It replaces a sequential scan O(n) with a B-Tree lookup: O(log n) for less common values
-- For common ones, it may fall back to a sequential scan nevertheless
CREATE INDEX IF NOT EXISTS room_capacity_index ON room(capacity);

----- Index 2: Searching for a room by its location (high-cardinality)
-- Justification:
-- The search in the webapp allows for rooms to be found according to their location
-- More specifically, given our db schema, this impacts more directly the hotel table
-- state_province has a high cardinality (many distinct values, few rows per value), 
-- making the single-column index highly effective. A partial-column index would not be appropriate here
-- as no single location dominates the data.
-- This index is especially useful when querying the db this way:
--       SELECT * FROM hotel WHERE state_province='[insert specified location]'
-- It replaces a sequential scan O(n) with a B-Tree lookup: O(log n)
CREATE INDEX IF NOT EXISTS room_location_index ON hotel(state_province);

----- Index 3: Searching for a room given it's base price (medium-high-cardinality)
-- Justification:
-- The search in the webapp allows for rooms to be found according to their base price
-- price has a relatively high cardinality (many distinct values, few rows per value), 
-- making the single-column index highly effective. A partial-column index would not be appropriate here
-- as no single price dominates the data.
-- This index is especially useful when querying the db this way:
--       SELECT * FROM room WHERE price=X
--       SELECT * FROM room WHERE price>=X AND price<=Y
-- It replaces a sequential scan O(n) with a B-Tree lookup: O(log n)
CREATE INDEX IF NOT EXISTS room_base_price_index ON room(price);

----- Index 4: Search for a room given its start/end date (high-cardinality)
-- Justification:
-- The search in the webapp allows for rooms to be found according to their availability 
-- A multi-column index is appropriate here as a room's availibility is determined by both the end and start dates of a registration
-- That is why this index is used more specifically on the registration table
-- This index is especially useful when querying the db this way:
--       SELECT * FROM registration WHERE start_date<=Y AND end_date>=X
--       (where X=requested start date and Y=requested end date)
-- It replaces a sequential scan O(n) with a B-Tree lookup: O(log n)
CREATE INDEX IF NOT EXISTS registration_dates_index ON registration(start_date,end_date); 
