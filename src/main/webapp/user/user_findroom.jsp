<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
Connection connection = db.getConnection();

String country = request.getParameter("country");
String start = request.getParameter("trip-start");
String end = request.getParameter("trip-end");
String capacity = request.getParameter("capacity");
String category = request.getParameter("category");
String chainName = request.getParameter("chain_name");
String hotelCapacity = request.getParameter("hotel_capacity");
String minPrice = request.getParameter("min_price");
String maxPrice = request.getParameter("max_price");

boolean hasFilters = request.getMethod().equals("POST");

boolean noFilters =
    (country == null || country.isEmpty()) &&
    (capacity == null || capacity.isEmpty()) &&
    (category == null || category.isEmpty()) &&
    (chainName == null || chainName.isEmpty()) &&
    (hotelCapacity == null || hotelCapacity.isEmpty()) &&
    (minPrice == null || minPrice.isEmpty()) &&
    (maxPrice == null || maxPrice.isEmpty());

ResultSet rs = null;

if (hasFilters) {

    //will exclude rooms that are already booked
    String sql =
        "SELECT hotel.hotel_name, hotel.city, hotel.state_province, hotel.country, " +
        "room.room_number, room.price, room.capacity " +
        "FROM hotel " +
        "JOIN room ON hotel.hotel_id = room.hotel_id " +
        "JOIN hotel_chain ON hotel.chain_id = hotel_chain.chain_id " +
        "AND room.room_number NOT IN ( " +
        "    SELECT reg_room.room_number " +
        "    FROM reg_room " +
        "    JOIN registration ON reg_room.registration_id = registration.registration_id " +
        "    LEFT JOIN booking ON registration.registration_id = booking.registration_id " +
        "    LEFT JOIN renting ON registration.registration_id = renting.registration_id " +
        "    WHERE (booking.status = 'confirmed' OR renting.registration_id IS NOT NULL) " +
        ") ";

    // only apply filters if user actually entered something
    if (!noFilters) {

        if (country != null && !country.isEmpty())
            sql.append("AND h.country = ? ");

        if (capacity != null && !capacity.isEmpty())
            sql.append("AND r.capacity = ? ");

        if (category != null && !category.isEmpty())
            sql.append("AND h.classification = ? ");

        if (chainName != null && !chainName.isEmpty())
            sql.append("AND LOWER(hc.chain_name) LIKE LOWER(?) ");

        if (hotelCapacity != null && !hotelCapacity.isEmpty())
            sql.append("AND (SELECT COUNT(*) FROM room rr WHERE rr.hotel_id = h.hotel_id) >= ? ");

        if (minPrice != null && !minPrice.isEmpty())
            sql.append("AND r.price >= ? ");

        if (maxPrice != null && !maxPrice.isEmpty())
            sql.append("AND r.price <= ? ");
    }

    PreparedStatement ps = connection.prepareStatement(sql.toString());

    int idx = 1;

    if (!noFilters) {

        if (country != null && !country.isEmpty())
            ps.setString(idx++, country.toLowerCase());

        if (capacity != null && !capacity.isEmpty())
            ps.setString(idx++, capacity);

        if (category != null && !category.isEmpty())
            ps.setInt(idx++, Integer.parseInt(category));

        if (chainName != null && !chainName.isEmpty())
            ps.setString(idx++, "%" + chainName + "%");

        if (hotelCapacity != null && !hotelCapacity.isEmpty())
            ps.setInt(idx++, Integer.parseInt(hotelCapacity));

        if (minPrice != null && !minPrice.isEmpty())
            ps.setDouble(idx++, Double.parseDouble(minPrice));

        if (maxPrice != null && !maxPrice.isEmpty())
            ps.setDouble(idx++, Double.parseDouble(maxPrice));
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
        <button onclick="window.location.href='../user_findroom.jsp'" class="active">Find Room</button>
        <button onclick="window.location.href='../user_myrooms.jsp'">My Rooms</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

  <h2>Search for a room</h2>
  <br>
  <form method="post" action="user_findrooms.jsp">
      <fieldset id="filters">

          <div id="id_choices">
            <div id="date_filter">
              <label><small>Country</small></label>
              <select name="country">
                <option value="canada">Canada</option>
                <option value="us">United States</option>
              </select>
            </div>
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
                <input name="chain_name" type="text">
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
        <button type="submit">Search for room</button>
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
            String hotelName = rs.getString("hotel_name");
            String cityVal = rs.getString("city");
            String stateVal = rs.getString("state_province");
            String countryVal = rs.getString("country");
            int roomNum = rs.getInt("room_number");
            float price = rs.getDouble("price");
            String roomCapacity = rs.getString("capacity");
    %>

    <div class="room-card">
      <div class="room-img-placeholder"></div>
      <div class="room-body">
        <div class="room_title">
          <span class="room-name"><b><%= hotelName %> <%= roomNum %></b></span>
          <div class="stats">
            <span class="roomstats"><%= price %><sub>/night</sub></span>
            <span class="roomstats"><%= roomCapacity %> people</span>
          </div>
        </div>
        <p class="room-location"><%= cityVal %>, <%= stateVal %>, <%= countryVal %></p>
      </div>
      <div class="room_buttons">
        <button onclick="window.location.href='../room_info.jsp?role=customer1&hotel_id=<%= hotelId %>&room_number=<%= roomNum %>'">View Info</button>
        <button onclick="window.location.href='book_room.jsp?hotel_id=<%= hotelId %>&room_number=<%= roomNum %>&price=<%= price %>'">Book Room</button>
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