<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

String action = request.getParameter("action_type");
String hotelId = request.getParameter("hotel_id");
String roomNum = request.getParameter("room_number");
String regId = request.getParameter("registration_id");

if ("submit".equals(action)) {

    String choice = request.getParameter("choice");

    if ("report".equals(choice)) {
        String issue = request.getParameter("issue");

        PreparedStatement ps = connection.prepareStatement(
            "INSERT INTO room_problem(hotel_id, room_number, problem) VALUES (?, ?, ?)"
        );
        ps.setInt(1, Integer.parseInt(hotelId));
        ps.setInt(2, Integer.parseInt(roomNum));
        ps.setString(3, issue);
        ps.executeUpdate();

%>
<script>
    alert("Issue reported successfully");
    window.location.href = "user_myrooms.jsp";
</script>
<%
        return;
    }

    if ("cancel".equals(choice)) {

        PreparedStatement checkRent = connection.prepareStatement(
            "SELECT 1 FROM renting WHERE registration_id = ?"
        );
        checkRent.setInt(1, Integer.parseInt(regId));
        ResultSet rsRentCheck = checkRent.executeQuery();

        if (rsRentCheck.next()) {
%>
<script>
    alert("This room is a rental. Rentals cannot be cancelled."); //adding this here so i can re-use this page for rentals
    window.location.href = "user_myrooms.jsp";
</script>
<%
            return;
        }

        PreparedStatement ps = connection.prepareStatement(
            "UPDATE booking SET status='cancelled' WHERE registration_id=?"
        );
        ps.setInt(1, Integer.parseInt(regId));
        ps.executeUpdate();
%>
<script>
    alert("Booking cancelled");
    window.location.href = "user_myrooms.jsp";
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
        <title>Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="../styles.css">

        <script>
                function toggleIssueBox() { //just doing in-line javascript because tbh, we dont use it enough to justify a whole file
                    const choice = document.getElementById("choice").value;
                    if (choice === "report") {
                        document.getElementById("issue_box").style.display = "block";
                    } else {
                        document.getElementById("issue_box").style.display = "none";
                    }
                }
        </script>
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
          <button onclick="window.location.href='user_myrooms.jsp'" style="all:unset; cursor:pointer;"></button>
          <h2>Report an issue or cancel your booking</h2>
          <br>

          <form method="post">
              <!--preload values-->
              <input type="hidden" name="hotel_id" value="<%= hotelId %>">
              <input type="hidden" name="room_number" value="<%= roomNum %>">
              <input type="hidden" name="registration_id" value="<%= regId %>">
              <input type="hidden" name="action_type" value="submit">

          <fieldset>
            <div id="date_filter">
                <label><small>Action:</small></label>
                    <div class="search-bar">
                        <select name="choice" id="choice" onchange="toggleIssueBox()">
                            <option value="report">Report an issue</option>
                            <option value="cancel">Cancel booking</option>
                        </select>
                    </div>
            </div>
            <br>
            <div id="date_filter">
                  <div id="issue_box"> <!--note from marianne: THIS IS SO JANK LOL-->
                      <label><small>Issue:</small></label>
                      <div class="search-bar">
                      <input type="text" name="issue">
                      </div>
                  </div>
            </div>
          </fieldset>
          <div class="buttons"><button type="submit">Submit Report</button></div>
          </form>

        </div>
    </body>
</html>