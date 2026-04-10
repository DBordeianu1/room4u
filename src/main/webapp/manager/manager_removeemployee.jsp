<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<header>
    <div class="nav-links">
        <button>Add Employee</button>
        <button class="active">Remove Employee/Customer</button>
        <button>Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

    <h2>Remove Employee/Customer</h2>
    <br>
    <fieldset>
      <div id="date_filter">
          <label><small>ID type:</small></label>
          <select name="idtype">
            <option value="Employee">Employee</option>
            <option value="Customer">Customer</option>
          </select>
      </div>
      <br>
      <div id="date_filter">
          <label><small>ID number:</small></label>
          <div class="search-bar">
            <input type="text">
          </div>
        </div>
    </fieldset>

  <div class="buttons"><button>Submit Report</button></div>

</div>
</body>
</html>