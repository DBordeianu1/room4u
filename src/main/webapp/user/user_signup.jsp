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
            //add user (customer is hardcodede because page is user exclusive)
            db.addNewUser("CUSTOMER", Integer.parseInt(id), idType, firstName, middleName, lastName, Integer.parseInt(streetNumber), streetName, city, province, postalCode, country, null);

            response.sendRedirect("user_login.jsp");
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

<div class="glass_container">
    <button onclick="window.location.href='../index.jsp'" style="all:unset; cursor:pointer;">
        <svg  style="width:20px; height:20px;" fill="#dbe7ea" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" stroke="#dbe7ea"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g data-name="Layer 2"> <g data-name="arrow-ios-back"> <rect width="24" height="24" transform="rotate(90 12 12)" opacity="0"></rect> <path d="M13.83 19a1 1 0 0 1-.78-.37l-4.83-6a1 1 0 0 1 0-1.27l5-6a1 1 0 0 1 1.54 1.28L10.29 12l4.32 5.36a1 1 0 0 1-.78 1.64z"></path> </g> </g> </g></svg>
    </button>
    <br>
    <br>
    <h2>Sign Up</h2>
    <br>
    <form method="post" action="user_signup.jsp">
        <fieldset>
          <div id="date_filter">
              <label><small>Country:*</small></label>
              <select name="country">
                <option value="canada">Canada</option>
                <option value="us">United States</option>
              </select>
          </div>
          <br>
          <div id="date_filter">
              <label><small>SIN/SSN number:*</small></label>
              <div class="search-bar">
                <input type="number" min="1" max="1000000000" name="user_id" required>
              </div>
            </div>
          <br>
          <div id="date_filter">
                <label><small>First name:*</small></label>
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
                <label><small>Last name:*</small></label>
                <div class="search-bar">
                <input type="text" name="user_lastname" required>
            </div>
          </div>
          <br>
          <div id="date_filter">
                <label><small>Street number:*</small></label>
                <div class="search-bar">
                <input type="number" min="1" max="1000" name="user_streetnumber" required>
            </div>
          </div>
          <br>
          <div id="date_filter">
                <label><small>Street name:*</small></label>
                <div class="search-bar">
                <input type="text" name="user_streetname" required>
            </div>
          </div>
          <br>
          <div id="date_filter">
                <label><small>City:*</small></label>
                <div class="search-bar">
                <input type="text" name="user_city" required>
            </div>
          </div>
          <br>
          <div id="date_filter">
                <label><small>State/Province:*</small></label>
                <div class="search-bar">
                <input type="text" name="user_province" required>
            </div>
          </div>
          <br>
          <div id="date_filter">
                <label><small>Postal code:*</small></label>
                <div class="search-bar">
                <input type="text" name="user_postalcode" required>
            </div>
          </div>
          <br>
        </fieldset>
        <div class="buttons">
            <button type="submit">Sign Up</button>
        </div>
    </form>
</div>
</body>
</html>