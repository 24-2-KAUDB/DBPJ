<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
  <title>Delete Employee</title>
</head>
<body>
  <h2>Delete Employee</h2>
  <form action="delete.jsp" method="post">
    <label>SSN to Delete:</label>
    <input type="text" name="ssn" required />
    <input type="submit" value="Delete" />
  </form>
  <%
    try{
      String ssn = request.getParameter("ssn");
      if(ssn != null && !ssn.isEmpty()) {
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "sps2150";//비번 입력
        
        Connection conn = null;
        
        conn = DriverManager.getConnection(url, user, password);
        
        String delete = "DELETE FROM EMPLOYEE WHERE Ssn = ?";
        
        PreparedStatement p = conn.prepareStatement(delete);
        p.clearParameters();
        p.setString(1, ssn);
        int rowsDeleted = p.executeUpdate();
        
        if (rowsDeleted > 0) {
          out.println("<script type=\"text/javascript\">");
          out.println("alert('직원 삭제 성공.');");
          out.println("</script>");
          response.sendRedirect("text.jsp");
        } else {
          out.println("<script type=\"text/javascript\">");
          out.println("alert('직원 정보를 찾을 수 없습니다.');");
          out.println("</script>");
        }
        try {
          if (conn != null)
            conn.close();
        } catch (SQLException e) {
          e.printStackTrace();
        }
      }
    } catch (SQLException e){
      response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
      out.println("<script type=\"text/javascript\">");
      out.println("alert('서버 오류가 발생했습니다: " + e.getMessage().replace("'", "\\'") + "');");
      out.println("</script>");
    }
  %>
</body>
</html>