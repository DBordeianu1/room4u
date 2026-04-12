<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
Connection conn = db.getConnection();

int customerId = Integer.parseInt((String) session.getAttribute("id_number"));
String idType = (String) session.getAttribute("id_type");

//renting
PreparedStatement rentPS = conn.prepareStatement(
    "SELECT h.hotel_name, h.city, h.state_province, h.country, " +
    "r.room_number, r.price, r.capacity " +
    "FROM renting rent " +
    "JOIN registration reg ON rent.registration_id = reg.registration_id " +
    "JOIN makes m ON m.registration_id = reg.registration_id " +
    "JOIN reg_room rr ON rr.registration_id = reg.registration_id " +
    "JOIN room r ON r.hotel_id = rr.hotel_id AND r.room_number = rr.room_number " +
    "JOIN hotel h ON h.hotel_id = r.hotel_id " +
    "WHERE m.id_number = ? AND m.id_type = ?"
);
rentPS.setInt(1, customerId);
rentPS.setString(2, idType);
ResultSet rsRent = rentPS.executeQuery();

//bookings
PreparedStatement bookPS = conn.prepareStatement(
    "SELECT h.hotel_name, h.city, h.state_province, h.country, " +
    "r.room_number, r.price, r.capacity " +
    "FROM booking b " +
    "JOIN registration reg ON b.registration_id = reg.registration_id " +
    "JOIN makes m ON m.registration_id = reg.registration_id " +
    "JOIN reg_room rr ON rr.registration_id = reg.registration_id " +
    "JOIN room r ON r.hotel_id = rr.hotel_id AND r.room_number = rr.room_number " +
    "JOIN hotel h ON h.hotel_id = r.hotel_id " +
    "WHERE m.id_number = ? AND m.id_type = ? AND b.status = 'confirmed'"
);
bookPS.setInt(1, customerId);
bookPS.setString(2, idType);
ResultSet rsBook = bookPS.executeQuery(); //from now on im going to be using rs/ps in resultsets/preparedstatements because i keep getting confused
%>


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
        <button onclick="window.location.href='../user_findroom.jsp'">Find Room</button>
        <button onclick="window.location.href='../user_myrooms.jsp'" class="active">My Rooms</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

  <h2>Rooms you're renting</h2>
  <br>
  <div class="rooms-grid">

  <%
    while (rsRent.next()) {
        String hotelName = rsRent.getString("hotel_name");
        String city = rsRent.getString("city");
        String province = rsRent.getString("state_province");
        String country = rsRent.getString("country");
        int roomNum = rsRent.getInt("room_number");
        double price = rsRent.getDouble("price");
        String capacity = rsRent.getString("capacity");
    %>


    <div class="room-card">
      <div class="room-img-placeholder img-holiday"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b><%= hotelName %> <%= roomNum %></b></span>
          <div class="stats">
            <span class="roomstats">$<%= price %><sub>/night</sub></span>
            <span class="roomstats"><%= capacity %> people</span>
          </div>
        </div>
        <p class="room-location"><%= city %>, <%= province %>, <%= country %></p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=customer2&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button>Report an issue</button>
      </div>
    </div>
  </div>
  <br>
  <br>
  <hr>
  <br>
  <h2>Rooms you're booking</h2>
  <br>
  <div class="rooms-grid">

    <%
      while (rsBook.next()) {
          String hotelName = rsBook.getString("hotel_name");
          String city = rsBook.getString("city");
          String province = rsBook.getString("state_province");
          String country = rsBook.getString("country");
          int roomNum = rsBook.getInt("room_number");
          double price = rsBook.getDouble("price");
          String capacity = rsBook.getString("capacity");
      %>

    <div class="room-card">
      <div class="room-img-placeholder img-holiday"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b><%= hotelName %> <%= roomNum %></b></span>
          <div class="stats">
            <span class="roomstats">$<%= price %><sub>/night</sub></span>
            <span class="roomstats"><%= capacity %> people</span>
          </div>
        </div>
        <p class="room-location"><%= city %>, <%= province %>, <%= country %></p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=customer2&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button onclick="window.location.href='../user_reportissue.jsp?hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">Report or Cancel</button>
      </div>
    </div>

  </div>

</div>
</body>
</html>