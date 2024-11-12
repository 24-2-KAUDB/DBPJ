<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Search Project Work Hours</title>
</head>
<body>
<h2>Search Project Work Hours</h2>
<form action="searchWorkHours.jsp" method="post">
  <label>프로젝트 번호:</label>
  <input type="text" name="pno" required/> <br />
  <input type="submit" value="프로젝트별 근무 시간 검색하기"/>
</form>
<%
  String pno = request.getParameter("pno");

  if(pno != null && !pno.isEmpty()){
    String url = "jdbc:mysql://DESKTOP-Q1IG1AR:3306/mydb";
    String user = "root";
    String password = "epdlxjqpdltmrlch";//비번 입력
    Connection conn = null;

    conn = DriverManager.getConnection(url, user, password);

    String searchWorkHours = "SELECT SUM(Hours)as sum_hours, Pname  FROM WORKS_ON, PROJECT WHERE Pnumber = Pno AND Pno = ? Group By Pname" ;
    PreparedStatement p = conn.prepareStatement(searchWorkHours);
    p.clearParameters();
    p.setString(1, pno);

    ResultSet rs = null;
    rs = p.executeQuery();
    out.println("<table border='1'>");
    out.println("<tr><th>Pno</th><th>Pname</th><th>WorkHours</th></tr>");

    boolean isValid = false;
    while (rs.next()) {
      out.println("<tr>");
      out.println("<td>" + pno + "</td>");
      out.println("<td>" + rs.getString("Pname") + "</td>");
      out.println("<td>" + rs.getDouble("sum_hours") + "</td>");
      out.println("</tr>");
      isValid = true;
    }
    out.println("</table>");
    if(!isValid){
      out.println("<script type=\"text/javascript\">");
      out.println("alert('존재하지 않는 프로젝트입니다.');");
      out.println("</script>");
    }
    try{
      if(conn != null)
        conn.close();
    } catch( SQLException e){
      e.printStackTrace();
    }
  }
%>
<form action="index.jsp" method="get">
  <button type="submit">홈 화면</button>
</form>
</body>
</html>