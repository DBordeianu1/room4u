<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="glass_container">
    <h2>Employee Login</h2>
    <br>
    <fieldset id="id_type">
      <div id="date_filter">
          <label><small>Employee role:*</small></label>
          <select name="employeetype">
            <option value="manager">Manager</option>
            <option value="staff">Hotel Staff</option>
          </select>
      </div>
      <br>
      <div id="date_filter">
          <label><small>Identification:*</small></label>
          <div class="search-bar">
            <input type="text" placeholder="👤 Enter your Employee ID" />
          </div>
      </div>
    </fieldset>


    <div id="login_button">
        <button>Login</button>
    </div>
</div>
</body>
</html>