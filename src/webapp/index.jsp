<%@ page contentType="text/html; charset=utf-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>24-2_DB_107</title>
</head>
<body>
<h1>직원 검색 시스템</h1>
<h2>로그인을 위한 계정 정보 입력</h2>
<form action="main.jsp" method = "post">
  <label for="dbacct">DB 사용자 계정:</label>
  <p><input type="text" name="dbacct"></p><br>
  <label for="dbname">DB 이름:</label>
  <p><input type="text" name="dbname"></p><br>
  <label for="password">비밀번호:</label>
  <p><input type="text" name="password"></p><br>
  <button type="submit">로그인</button>
</form>
<a href="main.jsp">메인 페이지로 이동</a>
</body>
</html>