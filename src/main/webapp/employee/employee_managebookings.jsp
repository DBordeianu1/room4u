<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

Integer hotelId = (Integer) session.getAttribute("hotel_id");
String action = request.getParameter("action");
String regId = request.getParameter("registration_id");

if ("convert".equals(action) && regId != null) {

    PreparedStatement cancel = connection.prepareStatement(
        "UPDATE booking SET status='cancelled' WHERE registration_id=?"
    );
    cancel.setInt(1, Integer.parseInt(regId));
    cancel.executeUpdate();

    PreparedStatement rent = connection.prepareStatement(
        "INSERT INTO renting(registration_id, paid, renting_date) VALUES (?, true, NOW())"
    );
    rent.setInt(1, Integer.parseInt(regId));
    rent.executeUpdate();
%>
<script>
alert("Booking successfully converted to rental.");
window.location.href = "employee_managebookings.jsp";
</script>
<%
    return;
}

PreparedStatement ps = connection.prepareStatement(
    "SELECT hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
    "room.room_number, room.price, room.capacity, " +
    "registration.registration_id, registration.start_date, registration.end_date, " +
    "makes.id_number, makes.id_type " +
    "FROM booking " +
    "JOIN registration ON registration.registration_id = booking.registration_id " +
    "JOIN makes ON makes.registration_id = registration.registration_id " +
    "JOIN reg_room ON reg_room.registration_id = registration.registration_id " +
    "JOIN room ON room.hotel_id = reg_room.hotel_id AND room.room_number = reg_room.room_number " +
    "JOIN hotel ON hotel.hotel_id = reg_room.hotel_id " +
    "WHERE booking.status ='pending'" + "AND reg_room.hotel_id = ?"
);
ps.setInt(1, hotelId);
ResultSet rs = ps.executeQuery();
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../styles.css">

    <script>
            function showRoomInfo(hotel, room) {
                window.open("room_info.jsp?hotel_id=" + hotel + "&room_number=" + room + "&role=employee",
                    "Room Info",
                    "width=600,height=700");
            }

            function convertRental(regId) {
                if (confirm("Are you sure you want to convert this booking to a rental?")) {
                    window.location.href = "employee_managebookings.jsp?action=convert&registration_id=" + regId;
                }
            }
    </script>

</head>
<body>
<header>
    <div class="nav-links">
        <button onclick="window.location.href='employee_managerentals.jsp'">Manage Rentals</button>
        <button onclick="window.location.href='employee_managebookings.jsp'" class="active">Manage Bookings</button>
        <button onclick="window.location.href='employee_findroom.jsp'">Add Rental</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
     </div>
</header>


<div class="glass_container_big">

  <h2>Current Bookings</h2>
  <br>
  <div class="rooms-grid">

  <%
    while (rs.next()) {
        String hotelName = rs.getString("hotel_name");
        String city = rs.getString("city");
        String province = rs.getString("state_province");
        String country = rs.getString("country");
        int roomNum = rs.getInt("room_number");
        double price = rs.getDouble("price");
        String capacity = rs.getString("capacity");
        int registrationId = rs.getInt("registration_id");
        String idNum = rs.getString("id_number");
        String idType = rs.getString("id_type");
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
        <button onclick="window.location.href='../room_info.jsp?role=employee2&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button onclick="convertRental('<%= registrationId %>')">Convert to Rental</button>
      </div>
    </div>
  <% } %>
  </div>

</div>
</body>
</html>