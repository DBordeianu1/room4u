# room4u
## Getting Started

### Setting up the database
**Prerequisites:**
- PostgreSQL installed
- Python installed with `pandas` and `openpyxl` libraries

**Step 1: Configure `src/main/resources/db.properties`**

Fill in your PostgreSQL connection details:
```properties
db.url=jdbc:postgresql://localhost:5432/your_database_name
db.username=your_username
db.password=your_password
```
*Note that the host and port number might be different, check your connection properties directly in pgAdmin.*

**Step 2: Run `excel_to_csv.py`**

You must run it under `sql/`: It generates a CSV for each sheet in `hotelchains.xlsx` under `sql/csv_files/`.

**Step 3: Run `schema.sql` in pgAdmin**

Open your database in pgAdmin, open the query tool, and run `schema.sql` to create all tables.

**Step 4: Import CSVs via pgAdmin**

For each table, **right-click > choose "Import/Export Data..." > click on "Import"**. Select the corresponding CSV from `sql/csv_files/`. Under the "Options" tab at the top, toggle "Header" on, and set "Delimiter" to `,`. Import in the following order:

1. `hotel_chain`
2. `hotel_chain_email`, `hotel_chain_phone`
3. `hotel`
4. `hotel_email`, `hotel_phone`
5. `room`
6. `room_view`, `room_problem`, `room_amenity`
7. `person`
8. `employee`
9. `employee_role`, `customer`
10. `registration`
11. `booking`, `renting`, `registration_special_request`
12. `reg_room`, `makes`
13. `works_at`, `supervises`, `processes`

*If the import was successful, you should see two green success notifications in pgAdmin's message panel for each table.*

**Step 5: Run `reset_sequences.sql` in pgAdmin**

Run `reset_sequences.sql` in the query tool so auto-increment counters continue from the correct value after the initial data load.*

**Step 6: Run `triggers.sql` in pgAdmin**

Run `triggers.sql` in the query tool for the user-defined constraints to be added to the db implementation.*

**Step 7: Run `indexes.sql` in pgAdmin**

Run `indexes.sql` in the query tool for optimized lookup time for frequent queries.*

**Step 8: Run `views.sql` in pgAdmin**

Run `views.sql` in the query tool for predefined queries on common data aggregations.*

The following views were implemented:
> - the number of available rooms per area
> - the aggregated capacity of all the rooms of a specific hotel

**If the script ran successfully, you should see a green success notification in pgAdmin's message panel.*

---
<div align="center">Powered by <b>Group 28</b></div>
<h6 align="center">Marianne and Daniela</h6>
