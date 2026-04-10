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
    <h2>Customer Login</h2>
    <br>
    <fieldset id="id_type">
      <div id="date_filter">
          <label><small>Country of residence:*</small></label>
          <select name="country">
            <option value="CAN">Canada</option>
            <option value="USA">United States</option>
          </select>
        </div>
      <br>
      <div id="date_filter">
          <label><small>Identification:*</small></label>
          <div class="search-bar">
            <input type="text" placeholder="👤 Enter your SIN/SSN" />
          </div>
        </div>
    </fieldset>


    <div id="login_button">
        <button>Login</button>
    </div>
</div>
</body>
</html>