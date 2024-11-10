<%@ page import="java.sql.*" %>
<%@ page import="com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 페이지</title>
</head>
<body>
<h2>로그인</h2>
<form action="login.jsp" method="post">
  <label for="username">사용자 이름:</label>
  <input type="text" name="username" id="username" required><br><br>

  <label for="password">비밀번호:</label>
  <input type="password" name="password" id="password" required><br><br>

  <button type="submit">로그인</button>
</form>

<%
  // 사용자가 폼을 제출했을 때 처리
  String username = request.getParameter("username");
  String password = request.getParameter("password");

  if (username != null && password != null) {
    DatabaseService dbService = new DatabaseService();

    try (Connection conn = dbService.connect(username, password)) {
      if (conn != null) {
        // 로그인 성공 시 세션에 사용자 정보 저장
        session.setAttribute("username", username);
        session.setAttribute("password", password);
        response.sendRedirect("index.jsp"); // 로그인 성공 후 index.jsp로 리디렉션
      }
    } catch (SQLException e) {
      out.println("<p style='color:red;'>로그인 실패. 다시 시도하세요.</p>");
    }
  }
%>
</body>
</html>
