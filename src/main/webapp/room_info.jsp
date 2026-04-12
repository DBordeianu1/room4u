<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
Connection conn = db.getConnection();

int hotelId = Integer.parseInt(request.getParameter("hotel_id"));
int roomNum = Integer.parseInt(request.getParameter("room_number"));
String role = request.getParameter("role");

//logic for returning to specific pages based on roles
String backPage;

if (role.equals("customer1")) {
    backPage = "user_findrooms.jsp";
}
else if (role.equals("customer2")) {
    backPage = "user_myrooms.jsp";
}
else if (role.equals("employee1")) {
    backPage = "employee_managerentals.jsp";
}
else if (role.equals("employee2")){
    backPage = "employee_managebookings.jsp";
}
else{
    backPage = "employee_findroom.jsp";
}


PreparedStatement ps = conn.prepareStatement(
    "SELECT h.hotel_name, h.classification, h.city, h.state_province, h.country, " +
    "r.price, r.capacity, r.extendable " +
    "FROM hotel h JOIN room r ON h.hotel_id = r.hotel_id " +
    "WHERE r.hotel_id = ? AND r.room_number = ?"
);

ps.setInt(1, hotelId);
ps.setInt(2, roomNum);

ResultSet rs = ps.executeQuery();
rs.next();

//main room info
String hotelName = rs.getString("hotel_name");
int classification = rs.getInt("classification");
String city = rs.getString("city");
String province = rs.getString("state_province");
String country = rs.getString("country");
double price = rs.getDouble("price");
String capacity = rs.getString("capacity");
boolean extendable = rs.getBoolean("extendable");

//amenities
PreparedStatement allAmenities = conn.prepareStatement(
    "SELECT amenity FROM room_amenity WHERE hotel_id=? AND room_number=?"
);
allAmenities.setInt(1, hotelId);
allAmenities.setInt(2, roomNum);
ResultSet rsA = allAmenities.executeQuery();

StringBuilder amenities = new StringBuilder();
while (rsA.next()) {
    if (amenities.length() > 0) amenities.append(", ");
    amenities.append(rsA.getString("amenity"));
}

//views
PreparedStatement roomView = conn.prepareStatement(
    "SELECT view_of_room FROM room_view WHERE hotel_id=? AND room_number=?"
);
roomView.setInt(1, hotelId);
roomView.setInt(2, roomNum);
ResultSet rsV = roomView.executeQuery();

StringBuilder views = new StringBuilder();
while (rsV.next()) {
    if (views.length() > 0) views.append(", ");
    views.append(rsV.getString("view_of_room"));
}

//problems
PreparedStatement allProblems = conn.prepareStatement(
    "SELECT problem FROM room_problem WHERE hotel_id=? AND room_number=?"
);
allProblems.setInt(1, hotelId);
allProblems.setInt(2, roomNum);
ResultSet rsP = allProblems.executeQuery();

StringBuilder problems = new StringBuilder();
while (rsP.next()) {
    if (problems.length() > 0) problems.append(", ");
    problems.append(rsP.getString("problem"));
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Info</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<!--note: there is no header/navbar here so that it can be used for multiple different roles-->

<div class="glass_container_big">
  <button onclick="window.location.href='<%= backPage %>'" style="all:unset; cursor:pointer;"></button>

  <h2>Info for <%= hotelName %> <%= roomNum %></h2>
  <br>
  <p><b>Price per night: </b>$<%= price %></p>
  <p><b>Capacity: </b><%= capacity %></p>
  <p><b>Extendable: </b><%= extendable ? "Yes" : "No" %></p>
  <p><b>Amenities: </b><%= amenities.toString() %></p>
  <p><b>View: </b><%= views.toString() %></p>
  <p><b>Problems: </b><%= problems.toString() %></p>

</div>
</body>
</html>