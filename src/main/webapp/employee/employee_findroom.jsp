<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
Connection connection = db.getConnection();

String start = request.getParameter("start");
String end = request.getParameter("end");
String capacity = request.getParameter("capacity");
String minPrice = request.getParameter("min_price");
String maxPrice = request.getParameter("max_price");

boolean doSearch = (start != null && end != null && !start.isEmpty() && !end.isEmpty());

ResultSet rs = null;

if (doSearch) {
    PreparedStatement ps = connection.prepareStatement(
        "SELECT hotel.hotel_id, hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
        "room.room_number, room.price, room.capacity " +
        "FROM room " +
        "JOIN hotel ON hotel.hotel_id = room.hotel_id " +
        "WHERE room.capacity >= ? " +
        "AND room.price >= ? AND room.price <= ? " +
        "AND NOT EXISTS ( " +
        "   SELECT 1 FROM reg_room " +
        "   JOIN registration ON registration.registration_id = reg_room.registration_id " +
        "   LEFT JOIN booking ON booking.registration_id = registration.registration_id " +
        "   LEFT JOIN renting ON renting.registration_id = registration.registration_id " +
        "   WHERE reg_room.hotel_id = room.hotel_id AND reg_room.room_number = room.room_number " +
        "   AND (booking.status = 'confirmed' OR renting.registration_id IS NOT NULL) " +
        "   AND NOT (registration.end_date <= ? OR registration.start_date >= ?) " +
        ")"
    );

    ps.setInt(1, Integer.parseInt(capacity));
    ps.setDouble(2, Double.parseDouble(minPrice));
    ps.setDouble(3, Double.parseDouble(maxPrice));
    ps.setTimestamp(4, Timestamp.valueOf(start + " 00:00:00"));
    ps.setTimestamp(5, Timestamp.valueOf(end + " 00:00:00"));

    rs = ps.executeQuery();
}
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
        <button onclick="window.location.href='employee_managerentals.jsp'">Manage Rentals</button>
        <button onclick="window.location.href='employee_managebookings.jsp'">Manage Bookings</button>
        <button onclick="window.location.href='employee_findroom.jsp'" class="active">Add Rental</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

  <h2>Available Rooms to Rent</h2>
  <br>
  <form method="get">
      <fieldset id="filters">

          <div id="id_choices">
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
                <select name="capacity">
                    <option value="single">Single</option>
                    <option value="double">Double</option>
                    <option value="suite">Suite</option>
                    <option value="family">Family</option>
                    <option value="royal">Royal</option>
                    <option value="penthouse">Penthouse</option>
                </select>
            </div>
            <div id="date_filter">
              <label><small>Min. price</small></label>
              <input type="number" id="min_price" name="min_price" min="0" max="100000" />
            </div>
            <div id="date_filter">
              <label><small>Max. price</small></label>
              <input type="number" id="max_price" name="max_price" min="0" max="100000" />
            </div>
        </div>
        </fieldset>
      <button>Search for room</button>
  </form>
  <br>
  <br>
  <hr>
  <br>
  <br>

  <div class="rooms-grid">

  <%
    if (doSearch && rs != null) {
        while (rs.next()) {
            int hotelId = rs.getInt("hotel_id");
            String hotelName = rs.getString("hotel_name");
            String city = rs.getString("city");
            String province = rs.getString("state_province");
            String country = rs.getString("country");
            int roomNum = rs.getInt("room_number");
            double price = rs.getDouble("price");
            String cap = rs.getString("capacity");
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
        <p class="room-location"><%= city %>, <%= province %>, country</p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=employee1&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button onclick="window.location.href='employee_makerental.jsp?hotel_id=<%= hotelId %>&room_number=<%= roomNum %>&start=<%= start %>&end=<%= end %>'">Register Rental</button>
      </div>
    </div>

  </div>

</div>
</body>
</html>