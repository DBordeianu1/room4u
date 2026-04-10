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
        <button>Manage Rentals</button>
        <button  class="active">Manage Bookings</button>
        <button>Add Rental</button>
        <button>Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

  <h2>Current Bookings</h2>
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
        <button>Customer Info</button>
        <button>Remove Booking</button>
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
        <button>Customer Info</button>
        <button>Remove Booking</button>
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
        <button>Customer Info</button>
        <button>Remove Booking</button>
      </div>
    </div>
  </div>

</div>
</body>
</html>