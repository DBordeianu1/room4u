<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

Integer hotelId = (Integer) session.getAttribute("hotel_id");
String roomNum = request.getParameter("room_number");
String price = request.getParameter("price");
String capacity = request.getParameter("capacity");
String extendable = request.getParameter("extendable");
String view = request.getParameter("view");

if ("POST".equalsIgnoreCase(request.getMethod())) {

    if (roomNum == null || roomNum.isEmpty() || price == null || price.isEmpty() || capacity == null || capacity.isEmpty() || extendable == null || view == null) {
%>
<script>alert("Please fill out all fields.");</script>
<%
    } else {

        PreparedStatement check = connection.prepareStatement(
            "SELECT 1 FROM room WHERE hotel_id=? AND room_number=?"
        );
        check.setInt(1, hotelId);
        check.setInt(2, Integer.parseInt(roomNum));
        ResultSet rs = check.executeQuery();

        if (rs.next()) {
%>
<script>alert("A room with this number already exists in this hotel.");</script>
<%
        } else {

            PreparedStatement insertRoom = connection.prepareStatement(
                "INSERT INTO room(hotel_id, room_number, price, capacity, extendable) VALUES (?, ?, ?, ?, ?)"
            );
            insertRoom.setInt(1, hotelId);
            insertRoom.setInt(2, Integer.parseInt(roomNum));
            insertRoom.setDouble(3, Double.parseDouble(price));
            insertRoom.setString(4, capacity);
            insertRoom.setBoolean(5, "yes".equals(extendable));
            insertRoom.executeUpdate();

            PreparedStatement insertView = connection.prepareStatement(
                "INSERT INTO room_view(hotel_id, room_number, view_of_room) VALUES (?, ?, ?)"
            );
            insertView.setInt(1, hotelId);
            insertView.setInt(2, Integer.parseInt(roomNum));
            insertView.setString(3, view);
            insertView.executeUpdate();
%>
<script>
alert("Room successfully added.");
window.location.href = "manager_addroom.jsp";
</script>
<%
            return;
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Room</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../styles.css">
</head>

<body>
<header>
    <div class="nav-links">
        <button onclick="window.location.href='manager_addemployee.jsp'">Add Employee</button>
        <button onclick="window.location.href='manager_removeemployee.jsp'">Remove Employee</button>
        <button onclick="window.location.href='manager_addroom.jsp'" class="active">Add Room</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>

<div class="glass_container_big">
    <h2>Add Room</h2><br>
    <form method="post" action="manager_addroom.jsp">

        <fieldset>
            <div id="date_filter">
                <label><small>Room Number:</small></label>
                <div class="search-bar">
                    <input type="number" name="room_number" min="1" max="1000" required>
                </div>
            </div>

            <br>

            <div id="date_filter">
                <label><small>Price (per night):</small></label>
                <div class="search-bar">
                    <input type="number" step="0.01" name="price" required>
                </div>
            </div>

            <br>

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

            <br>

            <div id="date_filter">
                <label><small>Extendable:</small></label>
                <select name="extendable">
                    <option value="yes">Yes</option>
                    <option value="no">No</option>
                </select>
            </div>

            <br>

            <div id="date_filter">
                <label><small>View:</small></label>
                <select name="view">
                    <option value="mountain">Mountain</option>
                    <option value="sea">Sea</option>
                    <option value="none">None</option>
                </select>
            </div>

        </fieldset>

        <div class="buttons">
            <button type="submit">Add Room</button>
        </div>

    </form>

</div>

</body>
</html>