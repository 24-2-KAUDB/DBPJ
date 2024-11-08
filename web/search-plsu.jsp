<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
  <title>Search Employee</title>
</head>
<body>
  <h2>Search Employee</h2>
  <form action="search-plsu.jsp" method="post">
    <select>
      <option></option>
      <option></option>
      <option></option>
      <option></option>
    </select>
    <select name="group">
      <option>그룹없음</option>
      <option>성별</option>
      <option>부서</option>
      <option>상급자</option>
    </select>
    <br />
    <input type="submit" value="그룹 검색하기" />
  </form>
<%
    String group = request.getParameter("group");
    String condition = null;
    if("성별".equals(group)){
      condition = "Sex";
    }else if("부서".equals(group)){
      condition = "Dname";
    }else if("상급자".equals(group)){
      condition = "Super_ssn";
    }
    
    try{
      if(group != null && !group.isEmpty()){
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "sps2150";//비번 입력
        
        Connection conn = null;
        
        conn = DriverManager.getConnection(url, user, password);
        
        String searchGroupSalary = "SELECT " + condition + ", AVG(Salary) AS avg_salary " +
                "FROM EMPLOYEE " +
                "LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber " +
                "GROUP BY " + condition;
        PreparedStatement p = conn.prepareStatement(searchGroupSalary);
        p.clearParameters();
        
        ResultSet rs = null;
        rs = p.executeQuery();
        
        out.println("<table border='1'>");
        out.println("<tr><th>" + condition + "</th><th>Average Salary</th></tr>");
        
        while (rs.next()) {
          out.println("<tr>");
          out.println("<td>" + rs.getString(1) + "</td>");
          out.println("<td>" + rs.getDouble("avg_salary") + "</td>");
          out.println("</tr>");
        }
        
        out.println("</table>");
        try{
          if(conn != null)
            conn.close();
        } catch( SQLException e){
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
  <table>
    <tr>
      <th></th>
    </tr>
  </table>

</body>
</html>
