<%
session.invalidate(); //will clear out the session
response.sendRedirect("index.jsp");
%>