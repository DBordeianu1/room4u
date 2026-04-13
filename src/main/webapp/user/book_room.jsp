<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

String action = request.getParameter("action"); //for the date filtering
int hotelId = Integer.parseInt(request.getParameter("hotel_id"));
String hotelName = request.getParameter("hotel_name");
int roomNum = Integer.parseInt(request.getParameter("room_number"));
double price = Double.parseDouble(request.getParameter("price"));

if (action == null) {
%>

<!DOCTYPE html>
<html>
<head>
    <title>Book Room</title>
    <link rel="stylesheet" href="../styles.css">
</head>
<body>

<div class="glass_container_big">
    <!--button will only go to user_findroom because booking is a user-only thing-->
    <button onclick="window.location.href='user_findroom.jsp'" style="all:unset; cursor:pointer;">
        <svg  style="width:20px; height:20px;" fill="#dbe7ea" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" stroke="#dbe7ea"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g data-name="Layer 2"> <g data-name="arrow-ios-back"> <rect width="24" height="24" transform="rotate(90 12 12)" opacity="0"></rect> <path d="M13.83 19a1 1 0 0 1-.78-.37l-4.83-6a1 1 0 0 1 0-1.27l5-6a1 1 0 0 1 1.54 1.28L10.29 12l4.32 5.36a1 1 0 0 1-.78 1.64z"></path> </g> </g> </g></svg>
    </button>
    <br>
    <br>
    <h2>Book <%= hotelName %> Room <%= roomNum %></h2>
    <br>
    <form method="post">
        <!--will take values from the prev. page hopefully-->
        <input type="hidden" name="hotel_id" value="<%= hotelId %>">
        <input type="hidden" name="room_number" value="<%= roomNum %>">
        <input type="hidden" name="price" value="<%= price %>">
        <input type="hidden" name="action" value="dates">

        <label><small>Start date:</small></label>
        <input type="datetime-local" name="start" required><br><br>

        <label><small>End date:</small></label>
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
if (e.isBefore(s) || s.isBefore(LocalDateTime.now())) {
%>
<script>
    alert("Invalid start or end date. Please ensure your end date is after your start date, or your start date is not in the past.");
    window.history.back(); //note to marianne: go back and use this for login/add user alerts if you have time
</script>
<%
    return;
}
long hours = ChronoUnit.HOURS.between(s, e);
long nights = hours / 24;
double totalPrice = nights * price;

PreparedStatement check = connection.prepareStatement(
    "SELECT 1 FROM reg_room " +
    "JOIN registration ON reg_room.registration_id = registration.registration_id " +
    "LEFT JOIN booking ON registration.registration_id = booking.registration_id " +
    "LEFT JOIN renting ON registration.registration_id = renting.registration_id " +
    "WHERE reg_room.hotel_id = ? AND reg_room.room_number = ? " +
    "AND (booking.status = 'confirmed' OR renting.registration_id IS NOT NULL) " +
    "AND NOT (registration.end_date <= ? OR registration.start_date >= ?)"
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
    <link rel="stylesheet" href="../styles.css">
</head>
<body>

<div class="glass_container_big">
    <button onclick="window.location.href='user_findroom.jsp'" style="all:unset; cursor:pointer;">
        <svg  style="width:20px; height:20px;" fill="#dbe7ea" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" stroke="#dbe7ea"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g data-name="Layer 2"> <g data-name="arrow-ios-back"> <rect width="24" height="24" transform="rotate(90 12 12)" opacity="0"></rect> <path d="M13.83 19a1 1 0 0 1-.78-.37l-4.83-6a1 1 0 0 1 0-1.27l5-6a1 1 0 0 1 1.54 1.28L10.29 12l4.32 5.36a1 1 0 0 1-.78 1.64z"></path> </g> </g> </g></svg>
    </button>
    <br>
    <br>
    <h2>Confirm Your Booking for <%= hotelName %> Room <%= roomNum %></h2>
    <br>
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
        <br>
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

int customerId = Integer.parseInt((String) session.getAttribute("user_id"));
String idType = (String) session.getAttribute("id_type");

PreparedStatement reg = connection.prepareStatement(
    "INSERT INTO registration(start_date, end_date, is_archived) VALUES (?, ?, false) RETURNING registration_id"
);
reg.setTimestamp(1, Timestamp.valueOf(start.replace("T"," ") + ":00"));
reg.setTimestamp(2, Timestamp.valueOf(end.replace("T"," ") + ":00"));
ResultSet regRs = reg.executeQuery();
regRs.next();
int regId = regRs.getInt(1);

PreparedStatement mk = connection.prepareStatement(
    "INSERT INTO makes(registration_id, id_number, id_type) VALUES (?, ?, ?)"
);
mk.setInt(1, regId);
mk.setInt(2, customerId);
mk.setString(3, idType);
mk.executeUpdate();

PreparedStatement rr = connection.prepareStatement(
    "INSERT INTO reg_room(registration_id, hotel_id, room_number) VALUES (?, ?, ?)"
);
rr.setInt(1, regId);
rr.setInt(2, hotelId);
rr.setInt(3, roomNum);
rr.executeUpdate();

PreparedStatement bk = connection.prepareStatement(
    "INSERT INTO booking(registration_id, status, booking_date) VALUES (?, 'pending', NOW())"
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