<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
Connection connection = db.getConnection();

String loggedId = (String) session.getAttribute("id_number");
String loggedType = (String) session.getAttribute("id_type");

String hotelId = request.getParameter("hotel_id");
String roomNum = request.getParameter("room_number");
String start = request.getParameter("start");
String end = request.getParameter("end");
String renterId = request.getParameter("renter_id");
String renterType = request.getParameter("renter_type");
String role = request.getParameter("role");

String first = request.getParameter("first");
String middle = request.getParameter("middle");
String last = request.getParameter("last");
String streetNum = request.getParameter("streetnum");
String streetName = request.getParameter("streetname");
String city = request.getParameter("city");
String province = request.getParameter("province");
String postal = request.getParameter("postal");
String country = request.getParameter("country");

double totalPrice = 0;

if (start != null && end != null) {
    Timestamp s = Timestamp.valueOf(start.replace("T"," ") + ":00");
    Timestamp e = Timestamp.valueOf(end.replace("T"," ") + ":00");
    long diff = e.getTime() - s.getTime();
    long nights = diff / (1000 * 60 * 60 * 24);

    PreparedStatement ps = connection.prepareStatement(
        "SELECT price FROM room WHERE hotel_id=? AND room_number=?"
    );
    ps.setInt(1, Integer.parseInt(hotelId));
    ps.setInt(2, Integer.parseInt(roomNum));
    ResultSet rs = ps.executeQuery();
    double base = 0;
    if (rs.next()) base = rs.getDouble("price");

    totalPrice = base * nights;
    if ("employee".equals(role)) totalPrice *= 0.5;
    if ("customer".equals(role)) totalPrice *= 1.15;
}

if ("POST".equalsIgnoreCase(request.getMethod())) {

    if (hotelId == null || roomNum == null || start == null || end == null ||
        renterId == null || renterId.isEmpty() || renterType == null || role == null) {
%>
<script>alert("Please fill out all fields.");</script>
<%
    } else {

        Timestamp startTS = Timestamp.valueOf(start.replace("T"," ") + ":00");
        Timestamp endTS = Timestamp.valueOf(end.replace("T"," ") + ":00");

        long diff = endTS.getTime() - startTS.getTime();
        long nights = diff / (1000 * 60 * 60 * 24);

        PreparedStatement psPrice = connection.prepareStatement(
            "SELECT price FROM room WHERE hotel_id=? AND room_number=?"
        );
        psPrice.setInt(1, Integer.parseInt(hotelId));
        psPrice.setInt(2, Integer.parseInt(roomNum));
        ResultSet rsP = psPrice.executeQuery();
        double basePrice = 0;
        if (rsP.next()) basePrice = rsP.getDouble("price");

        double finalPrice = basePrice * nights;

        if ("employee".equals(role)) {
            if (renterId.equals(loggedId) && renterType.equals(loggedType)) {
%>
<script>alert("Employees cannot submit their own rentals.");</script>
<%
                return;
            }
            finalPrice *= 0.5;
        } else {
            if (first == null || first.isEmpty() || last == null || last.isEmpty() ||
                streetNum == null || streetNum.isEmpty() || streetName == null || streetName.isEmpty() ||
                city == null || city.isEmpty() || province == null || province.isEmpty() ||
                postal == null || postal.isEmpty() || country == null || country.isEmpty()) {
%>
<script>alert("Please fill out all customer fields.");</script>
<%
                return;
            }

            boolean valid = true;

            if ("sin".equals(renterType)) {
                if (!renterId.matches("\\d{9}")) valid = false;
                else {
                    int sum = 0;
                    for (int i = 0; i < renterId.length(); i++) {
                        int d = Character.getNumericValue(renterId.charAt(i));
                        if (i % 2 == 1) {
                            d *= 2;
                            if (d > 9) d -= 9;
                        }
                        sum += d;
                    }
                    if (sum % 10 != 0) valid = false;
                }
            } else {
                if (!renterId.matches("\\d{9}")) valid = false;
                else {
                    String a = renterId.substring(0,3);
                    String g = renterId.substring(3,5);
                    String s = renterId.substring(5,9);
                    if (a.equals("000") || a.equals("666") || a.charAt(0)=='9') valid = false;
                    if (g.equals("00")) valid = false;
                    if (s.equals("0000")) valid = false;
                }
            }

            if (!valid) {
%>
<script>alert("Invalid SIN/SSN.");</script>
<%
                return;
            }

            db.addNewUser("CUSTOMER",
                Integer.parseInt(renterId),
                renterType,
                first, middle, last,
                Integer.parseInt(streetNum),
                streetName, city, province, postal, country, null
            );

            finalPrice *= 1.15;
        }

        PreparedStatement reg = connection.prepareStatement(
            "INSERT INTO registration(start_date, end_date, is_archived) VALUES (?, ?, false)",
            Statement.RETURN_GENERATED_KEYS
        );
        reg.setTimestamp(1, startTS);
        reg.setTimestamp(2, endTS);
        reg.executeUpdate();
        ResultSet regKeys = reg.getGeneratedKeys();
        regKeys.next();
        int regId = regKeys.getInt(1);

        PreparedStatement mk = connection.prepareStatement(
            "INSERT INTO makes(registration_id, id_number, id_type) VALUES (?, ?, ?)"
        );
        mk.setInt(1, regId);
        mk.setInt(2, Integer.parseInt(renterId));
        mk.setString(3, renterType);
        mk.executeUpdate();

        PreparedStatement rr = connection.prepareStatement(
            "INSERT INTO reg_room(registration_id, hotel_id, room_number) VALUES (?, ?, ?)"
        );
        rr.setInt(1, regId);
        rr.setInt(2, Integer.parseInt(hotelId));
        rr.setInt(3, Integer.parseInt(roomNum));
        rr.executeUpdate();

        PreparedStatement rent = connection.prepareStatement(
            "INSERT INTO renting(registration_id, rental_date) VALUES (?, NOW())"
        );
        rent.setInt(1, regId);
        rent.executeUpdate();
%>
<script>
alert("Rental created. Final price: $<%= finalPrice %>");
window.location.href = "employee_rentals.jsp";
</script>
<%
        return;
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Rental</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../styles.css">

    <script>
        function toggleCustomer() {
            const role = document.getElementById("role").value;
            document.getElementById("customer_fields").style.display =
                role === "customer" ? "block" : "none";
        }
    </script>
</head>
<body>

<div class="glass_container">

    <button onclick="window.location.href='employee_findroom.jsp'" style="all:unset; cursor:pointer;">
        <svg style="width:20px; height:20px;" fill="#dbe7ea" viewBox="0 0 24 24">
            <path d="M13.83 19a1 1 0 0 1-.78-.37l-4.83-6a1 1 0 0 1 0-1.27l5-6a1 1 0 0 1 1.54 1.28L10.29 12l4.32 5.36a1 1 0 0 1-.78 1.64z"></path>
        </svg>
    </button>

    <br><br>
    <h2>Create Rental</h2>
    <br>

    <form method="post">

        <input type="hidden" name="hotel_id" value="<%= hotelId %>">
        <input type="hidden" name="room_number" value="<%= roomNum %>">

        <fieldset>

            <div id="date_filter">
                <label><small>Start date/time:</small></label>
                <div class="search-bar">
                    <input type="datetime-local" name="start" value="<%= start %>" required>
                </div>
            </div>

            <br>

            <div id="date_filter">
                <label><small>End date/time:</small></label>
                <div class="search-bar">
                    <input type="datetime-local" name="end" value="<%= end %>" required>
                </div>
            </div>

            <br>

            <div id="date_filter">
                <label><small>Renter ID:</small></label>
                <div class="search-bar">
                    <input type="number" name="renter_id" required>
                </div>
            </div>

            <br>

            <div id="date_filter">
                <label><small>ID Type:</small></label>
                <select name="renter_type">
                    <option value="sin">SIN</option>
                    <option value="ssn">SSN</option>
                </select>
            </div>

            <br>

            <div id="date_filter">
                <label><small>Renter Role:</small></label>
                <select name="role" id="role" onchange="toggleCustomer()">
                    <option value="customer">Customer</option>
                    <option value="employee">Employee</option>
                </select>
            </div>

            <br>

            <div id="customer_fields" style="display:block;">

                <div id="date_filter">
                    <label><small>First name:</small></label>
                    <div class="search-bar">
                        <input type="text" name="first">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Middle name:</small></label>
                    <div class="search-bar">
                        <input type="text" name="middle">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Last name:</small></label>
                    <div class="search-bar">
                        <input type="text" name="last">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Street number:</small></label>
                    <div class="search-bar">
                        <input type="number" name="streetnum">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Street name:</small></label>
                    <div class="search-bar">
                        <input type="text" name="streetname">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>City:</small></label>
                    <div class="search-bar">
                        <input type="text" name="city">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Province:</small></label>
                    <div class="search-bar">
                        <input type="text" name="province">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Postal code:</small></label>
                    <div class="search-bar">
                        <input type="text" name="postal">
                    </div>
                </div>

                <br>

                <div id="date_filter">
                    <label><small>Country:</small></label>
                    <select name="country">
                        <option value="canada">Canada</option>
                        <option value="us">United States</option>
                    </select>
                </div>

            </div>

        </fieldset>

        <br>

        <p><b>Final Price: $<%= String.format("%.2f", totalPrice) %></b></p>

        <div class="buttons">
            <button type="submit">Create Rental</button>
        </div>

    </form>
</div>

</body>
</html>