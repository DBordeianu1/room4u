<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
DatabaseService db = new DatabaseService();
Connection conn = db.getConnection();

String action = request.getParameter("action"); //for the date filtering
int hotelId = Integer.parseInt(request.getParameter("hotel_id"));
int roomNum = Integer.parseInt(request.getParameter("room_number"));
double price = Double.parseDouble(request.getParameter("price"));

if (action == null) {
%>

<!DOCTYPE html>
<html>
<head>
    <h2>Book Room</h2>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<div class="glass_container_big">
    <!-button will only go to user_findroom because booking is a user-only thing->
    <button onclick="window.location.href='user_findroom.jsp'" style="all:unset; cursor:pointer;"></button>
    <h2>Book <%= hotelId %> <%= roomNum %></h2>

    <form method="post">
        //takes values from the prev. page
        <input type="hidden" name="hotel_id" value="<%= hotelId %>">
        <input type="hidden" name="room_number" value="<%= roomNum %>">
        <input type="hidden" name="price" value="<%= price %>">
        <input type="hidden" name="action" value="dates"> //submits to action to confirm dates are put in

        <label>Start date:</label>
        <input type="datetime-local" name="start" required><br><br>

        <label>End date:</label>
        <input type="datetime-local" name="end" required><br><br>

        <button type="submit">Continue</button>
    </form>
</div>

</body>
</html>

<%
    return;
}

if ("dates".equals(action)) {

String start = request.getParameter("start");
String end = request.getParameter("end");

LocalDateTime s = LocalDateTime.parse(start);
LocalDateTime e = LocalDateTime.parse(end);
long hours = ChronoUnit.HOURS.between(s, e);
long nights = hours / 24;
double totalPrice = nights * price;

PreparedStatement check = conn.prepareStatement(
    "SELECT 1 FROM reg_room rr " +
    "JOIN registration reg ON rr.registration_id = reg.registration_id " +
    "LEFT JOIN booking b ON reg.registration_id = b.registration_id " +
    "LEFT JOIN renting rent ON reg.registration_id = rent.registration_id " +
    "WHERE rr.hotel_id = ? AND rr.room_number = ? " +
    "AND (b.status = 'confirmed' OR rent.registration_id IS NOT NULL) " +
    "AND NOT (reg.end_date <= ? OR reg.start_date >= ?)"
);

check.setInt(1, hotelId);
check.setInt(2, roomNum);
//formatting string for db
check.setTimestamp(3, Timestamp.valueOf(start.replace("T"," ") + ":00"));
check.setTimestamp(4, Timestamp.valueOf(end.replace("T"," ") + ":00"));

ResultSet rsCheck = check.executeQuery();

if (rsCheck.next()) {
%>
<script>
    alert("This room is already booked or rented during the selected dates.");
    window.history.back();
</script>
<%
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Confirm Booking</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

<div class="glass_container_big">
    <h2>Confirm Your Booking</h2>

    <p><b>Room:</b> <%= roomNum %></p>
    <p><b>From:</b> <%= start %></p>
    <p><b>To:</b> <%= end %></p>
    <p><b>Nights:</b> <%= nights %></p>
    <p><b>Price per night:</b> $<%= price %></p>
    <p><b>Total price:</b> $<%= totalPrice %></p>

    <form method="post">
        <input type="hidden" name="hotel_id" value="<%= hotelId %>">
        <input type="hidden" name="room_number" value="<%= roomNum %>">
        <input type="hidden" name="start" value="<%= start %>">
        <input type="hidden" name="end" value="<%= end %>">
        <input type="hidden" name="price" value="<%= price %>">
        <input type="hidden" name="action" value="confirm">

        <button type="submit">Confirm Booking</button>
    </form>
</div>

</body>
</html>

<%
    return;
}

if ("confirm".equals(action)) {

String start = request.getParameter("start");
String end = request.getParameter("end");

int customerId = Integer.parseInt((String) session.getAttribute("id_number"));
String idType = (String) session.getAttribute("id_type");

PreparedStatement reg = conn.prepareStatement(
    "INSERT INTO registration(start_date, end_date, is_archived) VALUES (?, ?, false) RETURNING registration_id"
);
reg.setTimestamp(1, Timestamp.valueOf(start.replace("T"," ") + ":00"));
reg.setTimestamp(2, Timestamp.valueOf(end.replace("T"," ") + ":00"));
ResultSet regRs = reg.executeQuery();
regRs.next();
int regId = regRs.getInt(1);

PreparedStatement mk = conn.prepareStatement(
    "INSERT INTO makes(registration_id, id_number, id_type) VALUES (?, ?, ?)"
);
mk.setInt(1, regId);
mk.setInt(2, customerId);
mk.setString(3, idType);
mk.executeUpdate();

PreparedStatement rr = conn.prepareStatement(
    "INSERT INTO reg_room(registration_id, hotel_id, room_number) VALUES (?, ?, ?)"
);
rr.setInt(1, regId);
rr.setInt(2, hotelId);
rr.setInt(3, roomNum);
rr.executeUpdate();

PreparedStatement bk = conn.prepareStatement(
    "INSERT INTO booking(registration_id, status, booking_date) VALUES (?, 'confirmed', NOW())"
);
bk.setInt(1, regId);
bk.executeUpdate();
%>

<script>
    alert("Booking successful!");
    window.location.href = "user_myrooms.jsp";
</script>

<%
}
%>