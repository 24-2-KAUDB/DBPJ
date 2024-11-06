
<%@ page import="com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Employee</title>
</head>
<body>
    <h2>Delete Employee</h2>
    <form action="delete.jsp" method="post">
        <label>SSN to Delete:</label>
        <input type="text" name="ssn" required />
        <input type="submit" value="Delete" />
    </form>
    <%
        String ssn = request.getParameter("ssn");
        if (ssn != null) {
            DatabaseService dbService = new DatabaseService();
            boolean deleted = dbService.deleteEmployee(ssn);
            if (deleted) {
                out.println("<p>Employee deleted successfully.</p>");
            } else {
                out.println("<p>Error deleting employee. Ensure the SSN is correct.</p>");
            }
        }
    %>
</body>
</html>
