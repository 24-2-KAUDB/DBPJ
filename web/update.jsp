<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Salary</title>
</head>
<body>
    <h2>Update Employee Salary</h2>
    <form action="update.jsp" method="post">
        <label>직원 번호:</label>
        <input type="text" name="ssn" required /><br/>
        <label>수정할 속성:</label>
        <input type="text" name="attribute" required /><br/>
        <label>수정할 값:</label>
        <input type="text" name="newValue" required /><br/>
        <input type="submit" value="Update" />
    </form>
    
    <%
        String ssn = request.getParameter("ssn");
        String attribute = request.getParameter("attribute");
        String newValue = request.getParameter("newValue");
        try{
            if(ssn != null && !ssn.isEmpty() && newValue != null && !newValue.isEmpty()){
                String url = "jdbc:mysql://localhost:3306/mydb";
                String user = "root";
                String password = "sps2150";//비번 입력
                
                Connection conn = null;
                
                conn = DriverManager.getConnection(url, user, password);
                
                String update = "UPDATE EMPLOYEE SET " + attribute + " = ? WHERE Ssn = ?";
                
                PreparedStatement p = conn.prepareStatement(update);
                p.clearParameters();
                p.setString(1, newValue);
                p.setString(2, ssn);
                int rowsUpdated = p.executeUpdate();
                
                if (rowsUpdated > 0) {
                    response.sendRedirect("text.jsp");
                } else {
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('직원 정보를 찾을 수 없습니다.');");
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
    %>
</body>
</html>
