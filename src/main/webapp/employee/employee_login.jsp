<%@ page import="java.sql.*" %>
<%@ page import="util.DatabaseService" %>

<%
String id = request.getParameter("id_number");
String country = request.getParameter("country");
String role = request.getParameter("employeetype");

if (request.getMethod().equals("POST")) {

    if (id == null || id.isEmpty()) {
%>
        <script>alert("Please fill out all input fields.");</script>
<%
    }

    else {

        DatabaseService db = new DatabaseService();
        String idType;

        if (country.equals("canada")) {
            idType = "sin";
        } else {
            idType = "ssn";
        }

        //verification
        if (!db.loginEmployee(Integer.parseInt(id), idType)) {
%>
            <script>alert("No account found. Please sign up first or enter the correct credentials.");</script>
<%
        }

        else {
            session.setAttribute("user_id", id);

            if(role.equals("manager")){
                response.sendRedirect("../manager/manager_addemployee.jsp");
            }
            else{
                response.sendRedirect("employee_managerentals.jsp");
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
    <title>Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../styles.css">
</head>
<body>
<div class="glass_container">
    <button onclick="window.location.href='../index.jsp'" style="all:unset; cursor:pointer;">
        <svg  style="width:20px; height:20px;" fill="#dbe7ea" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" stroke="#dbe7ea"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g data-name="Layer 2"> <g data-name="arrow-ios-back"> <rect width="24" height="24" transform="rotate(90 12 12)" opacity="0"></rect> <path d="M13.83 19a1 1 0 0 1-.78-.37l-4.83-6a1 1 0 0 1 0-1.27l5-6a1 1 0 0 1 1.54 1.28L10.29 12l4.32 5.36a1 1 0 0 1-.78 1.64z"></path> </g> </g> </g></svg>
    </button>
    <br>
    <br>
    <h2>Employee Login</h2>
    <br>
    <form method="post" action="employee_login.jsp">
        <fieldset id="id_type">
          <div id="date_filter">
              <label><small>Employee role:*</small></label>
              <select name="employeetype">
                <option value="manager">Manager</option>
                <option value="staff">Hotel Staff</option>
              </select>
          </div>
          <br>
          <div id="date_filter">
              <label><small>Country of residence:*</small></label>
              <select name="country">
              <option value="canada">Canada</option>
              <option value="us">United States</option>
              </select>
          </div>
          <br>
          <div id="date_filter">
              <label><small>Identification:*</small></label>
              <div class="search-bar">
                <input type="text" name="id_number" placeholder="Enter your Employee ID" required/>
              </div>
          </div>
        </fieldset>

        <div id="login_button">
            <button type="submit">Login</button>
        </div>
    </form>

</div>
</body>
</html>