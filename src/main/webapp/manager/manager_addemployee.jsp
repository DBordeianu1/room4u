<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
String id = request.getParameter("user_id");
String country = request.getParameter("country");
String firstName = request.getParameter("user_firstname");
String middleName = request.getParameter("user_middlename");
String lastName = request.getParameter("user_lastname");
String streetNumber = request.getParameter("user_streetnumber");
String streetName = request.getParameter("user_streetname");
String city = request.getParameter("user_city");
String province = request.getParameter("user_province");
String postalCode = request.getParameter("user_postalcode");
String role = request.getParameter("employeetype");
String hotelIdParam = request.getParameter("hotel_id");

Integer hotelId = null;
if (hotelIdParam != null && !hotelIdParam.isEmpty()) {
    hotelId = Integer.parseInt(hotelIdParam);
}

if (request.getMethod().equals("POST")) {
    if (id == null || id.isEmpty() || country == null || country.isEmpty() || firstName == null || firstName.isEmpty() || lastName == null || lastName.isEmpty() || streetNumber == null || streetNumber.isEmpty() || streetName == null || streetName.isEmpty() || city == null || city.isEmpty() || province == null || province.isEmpty() || postalCode == null || postalCode.isEmpty()) {
%>
        <script>alert("Please fill out all input fields.");</script>
<%
    }

    else {

        DatabaseService db = new DatabaseService();
        String idType;
        boolean valid = true;

        if (country.equals("canada")) { //SIN validation
            idType = "sin";
            if (!id.matches("\\d{9}")) {
                valid = false;
            } else {
                int sum = 0;
                for (int i = 0; i < id.length(); i++) {
                    int digit = Character.getNumericValue(id.charAt(i));
                    if (i % 2 == 1) {
                        digit *= 2;
                        if (digit > 9) digit -= 9;
                    }
                    sum += digit;
                }
                if (sum % 10 != 0) valid = false;
            }
        }

        else { //SSN validation
            idType = "ssn";
            if (!id.matches("\\d{9}")) {
                valid = false;
            } else {
                String areacode = id.substring(0, 3);
                String group = id.substring(3, 5);
                String serialnum = id.substring(5, 9);

                if (areacode.equals("000") || areacode.equals("666") || areacode.charAt(0) == '9') valid = false;
                if (group.equals("00")) valid = false;
                if (serialnum.equals("0000")) valid = false;
            }
        }

        if (!valid) {
%>
            <script>alert("Please enter a valid SIN or SSN.");</script>
<%
        }

        else {

            if ("MANAGER".equals(role)) { //this is to check for user-defined constraint number 14
                PreparedStatement checkManagers = conn.prepareStatement(
                    "SELECT COUNT(*) FROM employee WHERE role='MANAGER' AND hotel_id=?"
                );
                checkManagers.setInt(1, hotelId);
                ResultSet managers = checkManagers.executeQuery();
                managers.next();
                int managerCount = managers.getInt(1);

                if (managerCount >= 4) {
        %>
        <script>
        alert("This hotel has reached its maximum of 4 managers. Please delete a manager or add a regular employee.");
        </script>
        <%
                    return;
                }
            }

            db.addNewUser(role, Integer.parseInt(id), idType, firstName, middleName, lastName,
                          Integer.parseInt(streetNumber), streetName, city, province, postalCode,
                          country, hotelId);

            response.sendRedirect("manager_addemployee.jsp");
            return;
        }

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
</head>
<body>
<header>
    <div class="nav-links">
        <button class="active">Add Employee</button>
        <button>Remove Employee</button>
        <button>Sign Out</button>
    </div>
</header>

<div class="glass_container_big">

    <h2>Add Employee</h2>
    <br>

    <form method="post" action="manager_addemployee.jsp">

    <fieldset>
      <div class="nav-links">
        <button onclick="window.location.href='manager_addemployee.jsp'" class="active">Add Employee</button>
        <button onclick="window.location.href='manager_removeemployee.jsp'">Remove Employee</button>
        <button onclick="window.location.href='manager_addroom'">Add Room</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
      </div>
      <br>

      <div id="date_filter">
          <label><small>ID number:</small></label>
          <div class="search-bar">
            <input type="text" name="user_id" required>
          </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>First name:</small></label>
            <div class="search-bar">
              <input type="text" name="user_firstname" required>
            </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Middle name:</small></label>
            <div class="search-bar">
            <input type="text" name="user_middlename" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Last name:</small></label>
            <div class="search-bar">
            <input type="text" name="user_lastname">
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Street number:</small></label>
            <div class="search-bar">
            <input type="text" name="user_streetnumber" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Street name:</small></label>
            <div class="search-bar">
            <input type="text" name="user_streetname" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>City:</small></label>
            <div class="search-bar">
            <input type="text" name="user_city" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>State/Province:</small></label>
            <div class="search-bar">
            <input type="text" name="user_province" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Postal code:</small></label>
            <div class="search-bar">
            <input type="text" name="user_postalcode" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
          <label><small>Country</small></label>
          <select name="country">
            <option value="canada">Canada</option>
            <option value="us">United States</option>
          </select>
      </div>

      <input type="hidden" name="hotel_id" value="1">

    </fieldset>

    <div class="buttons"><button type="submit">Add Employee</button></div>

    </form>

</div>
</body>
</html>