<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="util.DatabaseService" %>

<%
DatabaseService db = new DatabaseService();
DBConnection dbConnect = new DBConnection();
Connection connection = dbConnect.getConnection();

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
String role = request.getParameter("role");
Integer hotelId = (Integer) session.getAttribute("hotel_id");

if (request.getMethod().equals("POST")) {

    if (id == null || id.isEmpty() || firstName == null || firstName.isEmpty() || lastName == null || lastName.isEmpty() || streetNumber == null || streetNumber.isEmpty() || streetName == null || streetName.isEmpty() || city == null || city.isEmpty() || province == null || province.isEmpty() || postalCode == null || postalCode.isEmpty()) {
    %>
        <script>alert("Please fill out all input fields.");</script>
    <%
        return;
    }

    else {
        String idType;
        if (country.equals("canada")) { idType = "sin"; }
        else { idType = "ssn"; }

        if (!(db.validateID(idType, id))) {
        %>
            <script>alert("Please enter a valid SIN or SSN.");</script>
        <%
        }

        else {


            if (db.checkExists(Integer.parseInt(id), idType)) {
                %>
                    <script>
                        alert("A user with this ID already exists.");
                        window.location.href = "manager_addemployee.jsp";
                    </script>
                <%
                return;
            }
            try {
                    if (role.equals("MANAGER")){ //this is also what was breaking the thing on fruther inspection #iamalittlestupid!
                        db.addNewUser(role, Integer.parseInt(id), idType, firstName, middleName, lastName, Integer.parseInt(streetNumber), streetName, city, province, postalCode, country, hotelId);
                    }
                    else{
                        db.addNewUser("EMPLOYEE", Integer.parseInt(id), idType, firstName, middleName, lastName, Integer.parseInt(streetNumber), streetName, city, province, postalCode, country, null);


                    }
                %>
                    <script>
                        alert("User added succesfully!");
                        window.location.href = "manager_addemployee.jsp";
                    </script>
                <%
            } catch (Exception e){  //to catch the db trigger (THIS IS LITERALLY THE ONLY WAY IT WORKS I CANT FIGURE OUT HOW TO MAKE IT WORK BY COUNTING MANAGERS WITH A QUERY
                db.removeEmployee(Integer.parseInt(id), idType); //the trigger fires after the employee is added, so just delete them
                %>
                <script>
                    alert("This hotel has reached the maximum number of managers (4). Please add the user as an employee, or delete a manager.");
                    window.location.href = "manager_addemployee.jsp";
                </script>
                <%
            }
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
            <button onclick="window.location.href='manager_addemployee.jsp'" class="active">Add Employee</button>
            <button onclick="window.location.href='manager_removeemployee.jsp'">Remove Employee</button>
            <button onclick="window.location.href='manager_addroom.jsp'">Add Room</button>
            <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>

<div class="glass_container_big">

    <h2>Add Employee</h2>
    <br>

    <form method="post" action="manager_addemployee.jsp">

    <fieldset>
      <div id="date_filter">
        <label><small>Employee type</small></label>
        <select name="role">
            <option value="MANAGER">Manager</option>
            <option value="EMPLOYEE">Hotel Staff</option>
        </select>
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
            <input type="text" name="user_lastname" required>
        </div>
      </div>
      <br>

      <div id="date_filter">
            <label><small>Street number:</small></label>
            <div class="search-bar">
            <input type="number" name="user_streetnumber" min="1" max="1000" required>
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
    </fieldset>

    <div class="buttons"><button type="submit">Add Employee</button></div>

    </form>

</div>
</body>
</html>