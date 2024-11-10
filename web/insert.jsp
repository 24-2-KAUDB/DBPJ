<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.example.DatabaseService" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>직원 추가</title>
</head>
<body>
<h2>새 직원 추가</h2>
<form action="insert.jsp" method="post">
  <label for="fname">이름:</label>
  <input type="text" name="fname" id="fname" required><br><br>

  <label for="minit">중간 이니셜:</label>
  <input type="text" name="minit" id="minit" maxlength="1"><br><br>

  <label for="lname">성:</label>
  <input type="text" name="lname" id="lname" required><br><br>

  <label for="ssn">SSN:</label>
  <input type="text" name="ssn" id="ssn" required><br><br>

  <label for="bdate">생년월일 (YYYY-MM-DD):</label>
  <input type="date" name="bdate" id="bdate" required><br><br>

  <label for="address">주소:</label>
  <input type="text" name="address" id="address" required><br><br>

  <label for="sex">성별:</label>
  <input type="text" name="sex" id="sex" maxlength="1" required><br><br>

  <label for="salary">급여:</label>
  <input type="number" name="salary" id="salary" required><br><br>

  <label for="super_ssn">상사 SSN:</label>
  <input type="text" name="super_ssn" id="super_ssn"><br><br>

  <label for="dno">부서 번호:</label>
  <input type="number" name="dno" id="dno" required><br><br>

  <button type="submit">직원 추가</button>
</form>

<%
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    // 사용자 입력 값을 Map으로 저장
    Map<String, Object> employeeData = new HashMap<>();
    employeeData.put("Fname", request.getParameter("fname"));
    employeeData.put("Minit", request.getParameter("minit"));
    employeeData.put("Lname", request.getParameter("lname"));
    employeeData.put("Ssn", request.getParameter("ssn"));
    employeeData.put("Bdate", Date.valueOf(request.getParameter("bdate"))); // Date 변환
    employeeData.put("Address", request.getParameter("address"));
    employeeData.put("Sex", request.getParameter("sex"));
    employeeData.put("Salary", new BigDecimal(request.getParameter("salary"))); // BigDecimal 변환
    employeeData.put("Super_ssn", request.getParameter("super_ssn"));
    employeeData.put("Dno", Integer.parseInt(request.getParameter("dno")));

    // 세션에서 사용자 이름과 비밀번호를 가져오기
    String username = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    // DatabaseService를 사용하여 직원 정보 추가
    DatabaseService dbService = new DatabaseService();
    boolean isInserted = dbService.insertEmployee(employeeData, username, password);

    if (isInserted) {
      out.println("<p style='color:green;'>직원 정보가 성공적으로 추가되었습니다.</p>");
    } else {
      out.println("<p style='color:red;'>직원 정보를 추가하는 데 실패했습니다.</p>");
    }
  }
%>
<form action="index.jsp" method="get">
  <button type="submit">홈 화면</button>
</form>
</body>
</html>
