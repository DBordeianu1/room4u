<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

String start = request.getParameter("trip-start");
String end = request.getParameter("trip-end");
String capacity = request.getParameter("capacity");
String minPrice = request.getParameter("min_price");
String maxPrice = request.getParameter("max_price");

Integer hotelId = (Integer) session.getAttribute("hotel_id");

boolean hasFilters = request.getMethod().equalsIgnoreCase("POST");

boolean noFilters = (capacity == null || capacity.isEmpty()) && (minPrice == null || minPrice.isEmpty()) && (maxPrice == null || maxPrice.isEmpty());

ResultSet rs = null;

if (hasFilters) {
    StringBuilder sql = new StringBuilder(
        "SELECT hotel.hotel_id, hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
        "room.room_number, room.price, room.capacity " +
        "FROM hotel " +
        "JOIN room ON hotel.hotel_id = room.hotel_id " +
        "WHERE hotel.hotel_id = ? " +
        "AND (room.hotel_id, room.room_number) NOT IN ( " +
        "    SELECT rr.hotel_id, rr.room_number " +
        "    FROM reg_room rr " +
        "    JOIN registration reg ON rr.registration_id = reg.registration_id " +
        "    LEFT JOIN booking b ON reg.registration_id = b.registration_id " +
        "    LEFT JOIN renting rent ON reg.registration_id = rent.registration_id " +
        "    WHERE b.status = 'confirmed' OR rent.registration_id IS NOT NULL " +
        ") "
    );

    if (!noFilters) {

        if (capacity != null && !capacity.isEmpty())
            sql.append("AND room.capacity = ? ");

        if (minPrice != null && !minPrice.isEmpty())
            sql.append("AND room.price >= ? ");

        if (maxPrice != null && !maxPrice.isEmpty())
            sql.append("AND room.price <= ? ");
    }

    PreparedStatement ps = connection.prepareStatement(sql.toString());

    int index = 1;
    ps.setInt(index++, hotelId);

    if (!noFilters) {

        if (capacity != null && !capacity.isEmpty())
            ps.setString(index++, capacity);

        if (minPrice != null && !minPrice.isEmpty())
            ps.setDouble(index++, Double.parseDouble(minPrice));

        if (maxPrice != null && !maxPrice.isEmpty())
            ps.setDouble(index++, Double.parseDouble(maxPrice));
    }
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
  <form method="post" action="employee_findroom.jsp">
      <fieldset id="filters">

          <div id="id_choices">
                <div id="date_filter">
                  <label><small>Start date:</small></label>
                  <input type="datetime-local" id="start" name="trip-start" min="2026-01-01" max="2050-12-31" />
                </div>
                <div id="date_filter">
                  <label><small>End date:</small></label>
                  <input type="datetime-local" id="end" name="trip-end" min="2026-01-01" max="2050-12-31" />
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
      if (hasFilters && rs != null) {
          while (rs.next()) {

              int hotelId2 = rs.getInt("hotel_id");
              String hotelName = rs.getString("hotel_name");
              String city = rs.getString("city");
              String province = rs.getString("state_province");
              String country = rs.getString("country");
              int roomNum = rs.getInt("room_number");
              double price = rs.getDouble("price");
              String roomCapacity = rs.getString("capacity");
      %>

      <div class="room-card">
        <div class="room-img-placeholder img-holiday"></div>
        <div class="room-body">
          <div class="room_title">
            <span class="room-name"><b><%= hotelName %> <%= roomNum %></b></span>
            <div class="stats">
              <span class="roomstats">$<%= price %><sub>/night</sub></span>
              <span class="roomstats"><%= roomCapacity %></span>
            </div>
          </div>
          <p class="room-location"><%= city %>, <%= province %>, <%= country %></p>
        </div>
        <div class="room_buttons">
          <button onclick="window.location.href='../room_info.jsp?role=employee1&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
          <button onclick="window.location.href='employee_makerental.jsp?hotel_id=<%= hotelId2 %>&room_number=<%= roomNum %>'">Register Rental</button>
        </div>
      </div>

      <%
          }
      }
      %>
  </div>

</div>
</body>
</html>