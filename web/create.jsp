<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Create Salary</title>
</head>
<body>
  <h2>Create Employee</h2>
  <form action="create.jsp" method="post">
    <label>First Name:</label>
    <input type="text" name="fname" required /><br/>
    <label>Middle Init:</label>
    <input type="text" name="mname" required /><br/>
    <label>Last Name:</label>
    <input type="text" name="lname" required /><br/>
    <label>Ssn:</label>
    <input type="text" name="ssn" required /><br/>
    <label>Birthdate:</label>
    <input type="text" name="bdate" required /><br/>
    <label>Address:</label>
    <input type="text" name="address" required /><br/>
    <label>Sex:</label>
    <select name="sex">
      <option>F</option>
      <option>M</option>
    </select> <br />
    <label>Salary:</label>
    <input type="text" name="salary" required /><br/>
    <label>Super_ssn:</label>
    <input type="text" name="superSsn" required /><br/>
    <label>Dno:</label>
    <input type="text" name="dno" required /><br/>
    <input type="submit" value="정보 추가하기" />
  </form>

  <%
    String fname = request.getParameter("fname");
    String mname = request.getParameter("mname");
    String lname = request.getParameter("lname");
    String ssn = request.getParameter("ssn");
    String bdate = request.getParameter("bdate");
    String address = request.getParameter("address");
    String sex = request.getParameter("sex");
    String salary = request.getParameter("salary");
    String superSsn = request.getParameter("superSsn");
    String dno = request.getParameter("dno");
    
    
    try{
      if(ssn != null && !ssn.isEmpty()){
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "sps2150";//비번 입력
        
        Connection conn = null;
        
        conn = DriverManager.getConnection(url, user, password);
        
        String insert = "INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement p = conn.prepareStatement(insert);
        p.clearParameters();
        p.setString(1, (String) fname);
        p.setString(2, (String) mname);
        p.setString(3, (String) lname);
        p.setString(4, (String) ssn);
        if (bdate != null && !bdate.isEmpty()) {
          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 형식에 맞는 포맷 지정
          java.util.Date parsedDate = sdf.parse(bdate); // String을 java.util.Date로 파싱
          p.setDate(5, new java.sql.Date(parsedDate.getTime())); // java.sql.Date로 변환하여 PreparedStatement에 설정
        }
        p.setString(6, (String) address);
        p.setString(7, (String) sex);
        p.setBigDecimal(8, new java.math.BigDecimal(salary));
        p.setString(9, (String) superSsn);
        p.setInt(10, Integer.parseInt(dno));
        int rowsUpdated = p.executeUpdate();
        
        if (rowsUpdated > 0) {
          response.sendRedirect("text.jsp");
        } else {
          out.println("<script type=\"text/javascript\">");
          out.println("alert('올바르지 않은 형식이 존재합니다.');");
          out.println("</script>");
        }
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
  %>>
</body>
</html>
