<%@ page import="java.util.List" %>
<%@ page import="com.example.DatabaseService" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>직원 보고서 출력</title>
</head>
<body>
<h1>직원 보고서</h1>
<%
  String[] attributes = request.getParameterValues("attributes");
  DatabaseService dbService = new DatabaseService();
  List<Map<String, Object>> employeeList = dbService.getEmployeeData(attributes);

  if (attributes != null && employeeList != null) {
%>
<table border="1">
  <tr>
    <% for (String attr : attributes) { %>
    <th><%= "Dno".equals(attr) ? "Dname" : attr %></th>
    <% } %>
  </tr>
  <% for (Map<String, Object> employee : employeeList) { %>
  <tr>
    <% for (String attr : attributes) { %>
    <td><%= "Dno".equals(attr) ? employee.get("Dname") : employee.get(attr) %></td>
    <% } %>
  </tr>
  <% } %>
</table>
<%
  } else {
    out.println("출력할 속성을 선택하지 않았거나 데이터가 없습니다.");
  }
%>
</body>
</html>
