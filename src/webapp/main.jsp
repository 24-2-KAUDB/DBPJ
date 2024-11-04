<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>24-2_DB_107</title>
</head>
<body>
<h1>직원 검색 시스템</h1>
<form>
  <h3>검색 범위</h3>
  <select name = "Category" >
    <option value="none" selected>전체</option>
    <option value="department">부서</option>
    <option value="sex">성별</option>
    <option value="salary">연봉</option>
    <option value="bdate">생일</option>
    <option value="supervisor">부하직원</option>
    <option value="supervising">상사</option>
  </select>
  
  <input type = "text" name = "inputText">
  
  <hr>
  <h2>검색 항목</h2>
  <label><input type="checkbox" name="name" value="1" checked> Name</label>
  <label><input type="checkbox" name="ssn" value="1" checked> Ssn</label>
  <label><input type="checkbox" name="bdate" value="1" checked> Bdate</label>
  <label><input type="checkbox" name="address" value="1" checked> Address</label>
  <label><input type="checkbox" name="sex" value="1" checked> Sex</label>
  <label><input type="checkbox" name="salary" value="1" checked> Salary</label>
  <label><input type="checkbox" name="supervisor" value="1" checked> Supervisor</label>
  <label><input type="checkbox" name="department" value="1" checked> Department</label>
  <input type="button" value="검색하기">
</form>
<h3>테이블</h3>
<table>
  <thead>
    <tr>
      <th>선택</th>
      <th>직원 번호</th>
    </tr>
  </thead>
  <tbody>
  <%
    String dbacct = request.getParameter("dbacct");
    String dbname = request.getParameter("dbname");
    String password = request.getParameter("password");
    
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = null;
    
    String url = "jdbc:mysql://localhost:3306/"+dbname;
    conn = DriverManager.getConnection(url, dbacct, password);
    
    String stmt1 = "select * from EMPLOYEE";
    PreparedStatement p = conn.prepareStatement(stmt1);
    ResultSet r = p.executeQuery();
    
    while (r.next()) {
  %>
  <tr>
    
    <td><input type="checkbox"></td>
    <td><%= r.getString("ssn") %></td>
  </tr>
  <%
    }
    r.close();
    p.close();
    conn.close();
  %>
  </tbody>
</table>
<hr>
<div>
  <h1>직원 추가 코드 작성</h1>
</div>
<div>
  <h1>직원 업데이트 코드 작성</h1>
</div>
<div>
  <h1>직원 삭제 코드 작성</h1>
</div>
<hr>
</body>
</html>