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
        <button class="active">Find a room</button>
        <button>My rooms</button>
        <button>Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

  <h2>Search for a room</h2>
  <br>
  <fieldset id="filters">

      <div id="id_choices">
        <div id="date_filter">
          <label><small>Country</small></label>
          <select name="country">
            <option value="CAN">Canada</option>
            <option value="USA">United States</option>
          </select>
        </div>
        <div id="date_filter">
          <label><small>Start date:</small></label>
          <input type="date" id="start" name="trip-start" min="2026-01-01" max="2050-12-31" />
        </div>
        <div id="date_filter">
          <label><small>End date:</small></label>
          <input type="date" id="end" name="trip-end" min="2026-01-01" max="2050-12-31" />
        </div>
        <div id="date_filter">
          <label><small>Capacity:</small></label>
          <input type="number" id="capacity" name="capacity" min="1" max="100" />
        </div>
        <div id="date_filter">
          <label><small>Star rating</small></label>
          <input type="number" id="category" name="category" min="1" max="5" />
        </div>
    </div>
    <div id="id_choices">

        <div id="date_filter">
          <label><small>Hotel chain name:</small></label>
          <div class="search-bar">
            <input type="text">
          </div>
        </div>
        <div id="date_filter">
          <label><small>Total hotel rooms:</small></label>
          <input type="number" id="hotel_capacity" name="hotel_capacity" min="1" max="100" />
        </div>
        <div id="date_filter">
          <label><small>Min. price per night:</small></label>
          <input type="number" id="min_price" name="min_price" min="0" max="100000" />
        </div>
        <div id="date_filter">
          <label><small>Max. price per night:</small></label>
          <input type="number" id="max_price" name="max_price" min="0" max="100000" />
        </div>
     </div>
    </fieldset>
  <button>Search for room</button>
  <br>
  <br>
  <hr>
  <br>
  <br>

  <div class="rooms-grid">

    <div class="room-card">
      <div class="room-img-placeholder img-holiday"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b>Holiday Inn 104</b></span>
          <div class="stats">
            <span class="roomstats">$250<sub>/night</sub></span>
            <span class="roomstats">👥 4</span>
          </div>
        </div>
        <p class="room-location">Montgomery, Alabama, USA</p>
      </div>
      <div class="room_buttons">
        <button>Rent Room</button>
        <button>Book Room</button>
      </div>
    </div>

    <div class="room-card">
      <div class="room-img-placeholder img-riverview"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b>Riverview 223</b></span>
          <div class="stats">
            <span class="roomstats">$315<sub>/night</sub></span>
            <span class="roomstats">👥 2</span>
          </div>
        </div>
        <p class="room-location">Ottawa, Ontario, CAN</p>
      </div>
      <div class="room_buttons">
        <button>Rent Room</button>
        <button>Book Room</button>
      </div>
    </div>

    <div class="room-card">
      <div class="room-img-placeholder img-whisper"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b>Whisper 002</b></span>
          <div class="stats">
            <span class="roomstats">$550<sub>/night</sub></span>
            <span class="roomstats">👥 3</span>
          </div>
        </div>
        <p class="room-location">Phoenix, Arizona, USA</p>
      </div>
      <div class="room_buttons">
        <button>Rent Room</button>
        <button>Book Room</button>
      </div>
    </div>

  </div>

</div>
</body>
</html>