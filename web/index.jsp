<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메인 화면</title>
</head>
<body>
<h1>환영합니다! 직원 목록</h1>

<%
    DatabaseService dbService = new DatabaseService();
    List<Map<String, Object>> employees = dbService.getAllEmployeeData();
%>

<table border="1">
    <tr>
        <th>Fname</th>
        <th>Minit</th>
        <th>Lname</th>
        <th>Ssn</th>
        <th>Bdate</th>
        <th>Address</th>
        <th>Sex</th>
        <th>Salary</th>
        <th>Super_ssn</th>
        <th>Dno</th>
        <th>Dname</th>
    </tr>
    <%
        for (Map<String, Object> employee : employees) {
    %>
    <tr>
        <td><%= employee.get("Fname") %></td>
        <td><%= employee.get("Minit") %></td>
        <td><%= employee.get("Lname") %></td>
        <td><%= employee.get("Ssn") %></td>
        <td><%= employee.get("Bdate") %></td>
        <td><%= employee.get("Address") %></td>
        <td><%= employee.get("Sex") %></td>
        <td><%= employee.get("Salary") %></td>
        <td><%= employee.get("Super_ssn") %></td>
        <td><%= employee.get("Dno") %></td>
        <td><%= employee.get("Dname") %></td>
    </tr>
    <%
        }
    %>
</table>

<p>원하는 기능을 선택하세요:</p>
<form action="update.jsp" method="get">
    <button type="submit">정보 업데이트</button>
</form>
<form action="delete.jsp" method="get">
    <button type="submit">정보 삭제</button>
</form>
<form action="employeeReport.jsp" method="get">
    <button type="submit">직원 보고서 보기</button>
</form>

</body>
</html>
