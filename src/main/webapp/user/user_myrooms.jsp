<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

int customerId = Integer.parseInt((String) session.getAttribute("user_id"));
String idType = (String) session.getAttribute("id_type");

//renting
PreparedStatement rentPS = connection.prepareStatement(
    "SELECT registration.registration_id, " +
    "hotel.hotel_id, hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
    "room.room_number, room.price, room.capacity " +
    "FROM renting " +
    "JOIN registration ON renting.registration_id = registration.registration_id " +
    "JOIN makes ON makes.registration_id = registration.registration_id " +
    "JOIN reg_room ON reg_room.registration_id = registration.registration_id " +
    "JOIN room ON room.hotel_id = reg_room.hotel_id AND room.room_number = reg_room.room_number " +
    "JOIN hotel ON hotel.hotel_id = room.hotel_id " +
    "WHERE makes.id_number = ? AND makes.id_type = ?"
);
rentPS.setInt(1, customerId);
rentPS.setString(2, idType);
ResultSet rsRent = rentPS.executeQuery();

//bookings
PreparedStatement bookPS = connection.prepareStatement(
    "SELECT registration.registration_id, " +
    "hotel.hotel_id, hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
    "room.room_number, room.price, room.capacity " +
    "FROM booking " +
    "JOIN registration ON booking.registration_id = registration.registration_id " +
    "JOIN makes ON makes.registration_id = registration.registration_id " +
    "JOIN reg_room ON reg_room.registration_id = registration.registration_id " +
    "JOIN room ON room.hotel_id = reg_room.hotel_id AND room.room_number = reg_room.room_number " +
    "JOIN hotel ON hotel.hotel_id = room.hotel_id " +
    "WHERE makes.id_number = ? AND makes.id_type = ? AND booking.status = 'pending'"
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
        <button onclick="window.location.href='user_findroom.jsp'">Find Room</button>
        <button onclick="window.location.href='user_myrooms.jsp'" class="active">My Rooms</button>
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
        int hotelId = rsRent.getInt("hotel_id");
        int regId = rsRent.getInt("registration_id");
    %>


    <div class="room-card">
      <div class="room-img-placeholder img-holiday"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b><%= hotelName %> <%= roomNum %></b></span>
          <div class="stats">
            <span class="roomstats">$<%= price %><sub>/night</sub></span>
            <span class="roomstats"><%= capacity %></span>
          </div>
        </div>
        <p class="room-location"><%= city %>, <%= province %>, <%= country %></p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=customer2&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button onclick="window.location.href='user_reportissue.jsp?registration_id=<%= regId %>&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">Report or Cancel</button>
      </div>
    </div>
  <% } %>
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
          String hotelName2 = rsBook.getString("hotel_name");
          String city2 = rsBook.getString("city");
          String province2 = rsBook.getString("state_province");
          String country2 = rsBook.getString("country");
          int roomNum2 = rsBook.getInt("room_number");
          double price2 = rsBook.getDouble("price");
          String capacity2 = rsBook.getString("capacity");
          int hotelId2 = rsBook.getInt("hotel_id");
          int regId2 = rsBook.getInt("registration_id");
      %>

    <div class="room-card">
      <div class="room-img-placeholder img-holiday"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b><%= hotelName2 %> <%= roomNum2 %></b></span>
          <div class="stats">
            <span class="roomstats">$<%= price2 %><sub>/night</sub></span>
            <span class="roomstats"><%= capacity2 %></span>
          </div>
        </div>
        <p class="room-location"><%= city2 %>, <%= province2 %>, <%= country2 %></p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=customer2&hotel_id=<%= hotelId2 %>&room_number=<%= roomNum2 %>'">View Info</button>
        <button onclick="window.location.href='user_reportissue.jsp?registration_id=<%= regId2 %>&hotel_id=<%= hotelId2 %>&room_number=<%= roomNum2 %>'">Report or Cancel</button>
      </div>
    </div>
  <% } %>
  </div>

</div>
</body>
</html>