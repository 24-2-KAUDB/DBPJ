<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메인 화면</title>
</head>
<body>
<h1>환영합니다! 직원 목록</h1>

<%
  class DatabaseService {
    private Connection connect() throws SQLException {
      String url = "jdbc:mysql://localhost:3306/mydb";
      String user = "root";
      String password = "sps2150";
      return DriverManager.getConnection(url, user, password);
    }
    
    public List<Map<String, Object>> getAllEmployeeData() {
      List<Map<String, Object>> employeeList = new ArrayList<>();
      String query = "SELECT EMPLOYEE.*, DEPARTMENT.Dname FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber";
      
      try (Connection conn = connect();
           Statement stmt = conn.createStatement();
           ResultSet rs = stmt.executeQuery(query)) {
        
        while (rs.next()) {
          Map<String, Object> employee = new HashMap<>();
          employee.put("Fname", rs.getString("Fname"));
          employee.put("Minit", rs.getString("Minit"));
          employee.put("Lname", rs.getString("Lname"));
          employee.put("Ssn", rs.getString("Ssn"));
          employee.put("Bdate", rs.getDate("Bdate"));
          employee.put("Address", rs.getString("Address"));
          employee.put("Sex", rs.getString("Sex"));
          employee.put("Salary", rs.getBigDecimal("Salary"));
          employee.put("Super_ssn", rs.getString("Super_ssn"));
          employee.put("Dno", rs.getInt("Dno"));
          employee.put("Dname", rs.getString("Dname"));
          employeeList.add(employee);
        }
      } catch (SQLException e) {
        e.printStackTrace();
      }
      
      return employeeList;
    }
  }
  
  // DatabaseService 객체 생성
  DatabaseService dbService = new DatabaseService();
  
  // 데이터베이스에서 모든 직원 데이터를 가져오기
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