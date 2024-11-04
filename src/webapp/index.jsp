<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>24-2_DB_107</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
  <style>
      *{
          font-family: 'AppleSDGothicNeo', sans-serif;
      }
  </style>
</head>
<body>
<form action="main.jsp" method = "post">
  <label for="dbacct">DB 사용가 계정:</label>
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