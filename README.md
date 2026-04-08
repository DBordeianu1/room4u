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

Which generates a CSV for each table under `sql/csv_files/`.

**Step 3: Run `schema.sql` in pgAdmin**

Open your database in pgAdmin, open the query tool, and run `schema.sql` to create all tables.

**Step 4: Import CSVs via pgAdmin**

For each table, **right-click > choose "Import/Export Data..." > click on "Import"**. Select the corresponding CSV from `sql/csv_files/`. Under the "Options" tab at the top, toggle `Header` on and set "Delimiter" to `,`. Import in the following order:

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

*If the script ran successfully, you should see two green success notifications in pgAdmin's message panel each time you do the procedure, i.e. for every table.*

**Step 5: Run `reset_sequences.sql` in pgAdmin**

Run `reset_sequences.sql` in the query tool so auto-increment counters continue from the correct value after the initial data load.

*If the script ran successfully, you should see a green success notification in pgAdmin's message panel.*
