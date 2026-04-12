<%@ page import="util.DatabaseService" %>

<%
String idType = request.getParameter("idtype");
String idNumber = request.getParameter("id_number");
String country = request.getParameter("country");

if (request.getMethod().equals("POST")) {

    if (idType == null || idType.isEmpty() ||
        idNumber == null || idNumber.isEmpty() ||
        country == null || country.isEmpty()) {
%>
        <script>alert("Please fill out all input fields.");</script>
<%
    } else {

        DatabaseService db = new DatabaseService();
        boolean success = false;

        // convert UI values to backend values
        String type = idType.equals("Employee") ? "employee" : "customer";

        // determine id_type based on country
        String idTypeCode = country.equals("canada") ? "sin" : "ssn";

        if (type.equals("employee")) {
            success = db.removeEmployee(Integer.parseInt(idNumber), idTypeCode);
        } else {
            success = db.removeCustomer(Integer.parseInt(idNumber), idTypeCode);
        }

        if (!success) {
%>
            <script>alert("No matching record found.");</script>
<%
        } else {
%>
            <script>alert("Record successfully removed.");</script>
<%
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
        <button onclick="window.location.href='manager_addemployee.jsp'">Add Employee</button>
        <button onclick="window.location.href='manager_removeemployee.jsp'" class="active">Remove Employee</button>
        <button onclick="window.location.href='manager_addroom'">Add Room</button>
        <button onclick="window.location.href='../logout.jsp'">Sign Out</button>
    </div>
</header>


<div class="glass_container_big">

    <h2>Remove Employee/Customer</h2>
    <br>

    <form method="post" action="manager_remove.jsp">

    <fieldset>
      <div id="date_filter">
          <label><small>ID type:</small></label>
          <select name="idtype">
            <option value="Employee">Employee</option>
            <option value="Customer">Customer</option>
          </select>
      </div>
      <br>

      <div id="date_filter">
          <label><small>Country</small></label>
          <select name="country">
            <option value="canada">Canada</option>
            <option value="us">United States</option>
          </select>
      </div>
      <br>

      <div id="date_filter">
          <label><small>ID number:</small></label>
          <div class="search-bar">
            <input type="text" name="id_number">
          </div>
        </div>
    </fieldset>

    <div class="buttons"><button type="submit">Submit Report</button></div>

    </form>

</div>
</body>
</html>