<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../styles.css">
</head>
<body>
<header>
    <div class="nav-links">
        <button class="active">Add Employee</button>
        <button>Remove Employee</button>
        <button>Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

    <h2>Add Employee</h2>
    <br>
    <fieldset>
      <div id="date_filter">
          <label><small>Employee role:</small></label>
          <select name="employeetype">
            <option value="manager">Manager</option>
            <option value="staff">Hotel Staff</option>
          </select>
      </div>
      <br>
      <div id="date_filter">
          <label><small>ID number:</small></label>
          <div class="search-bar">
            <input type="text">
          </div>
        </div>
      <br>
      <div id="date_filter">
            <label><small>First name:</small></label>
            <div class="search-bar">
              <input type="text">
            </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>Middle name:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>Last name:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>Street number:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>Street name:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>City:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>State/Province:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
            <label><small>Postal code:</small></label>
            <div class="search-bar">
            <input type="text">
        </div>
      </div>
      <br>
      <div id="date_filter">
          <label><small>Country</small></label>
          <select name="country">
            <option value="CAN">Canada</option>
            <option value="USA">United States</option>
          </select>
        </div>
    </fieldset>

  <div class="buttons"><button>Add Employee</button></div>

</div>
</body>
</html>