
<%@ page import="com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Salary</title>
</head>
<body>
    <h2>Update Employee Salary</h2>
    <form action="update.jsp" method="post">
        <label>SSN:</label>
        <input type="text" name="ssn" required /><br/>
        <label>New Salary:</label>
        <input type="text" name="salary" required /><br/>
        <input type="submit" value="Update" />
    </form>
    <%
        String ssn = request.getParameter("ssn");
        String salary = request.getParameter("salary");
        if (ssn != null && salary != null) {
            DatabaseService dbService = new DatabaseService();
            boolean updated = dbService.updateEmployeeSalary(ssn, salary);
            if (updated) {
                out.println("<p>Salary updated successfully.</p>");
            } else {
                out.println("<p>Error updating salary. Ensure the SSN and salary are correct.</p>");
            }
        }
    %>
</body>
</html>
