<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>부서별 월급 일괄 수정</title>
  <script>
    function updateSalary(action) {
      const percentage = parseFloat(document.getElementById("percentage").value);
      if (isNaN(percentage)) {
        alert("올바른 비율을 입력하세요.");
        return;
      }
      document.getElementById("action").value = action;
      document.getElementById("salaryForm").submit();
    }

    function resetForm() {
      document.getElementById("percentage").value = "";
      document.getElementById("action").value = "";
      const checkboxes = document.getElementsByName("selectedDepartments");
      checkboxes.forEach(checkbox => checkbox.checked = false);
    }
  </script>
</head>
<body>
<h2>부서별 월급 일괄 수정</h2>

<%
  // 데이터베이스 연결 정보
  String dbUrl = "jdbc:mysql://DESKTOP-Q1IG1AR:3306/mydb"; // 데이터베이스 URL에 맞게 수정
  String username = (String) session.getAttribute("username");
  String password = (String) session.getAttribute("password");

  // 부서 목록 조회
  List<Map<String, Object>> departments = new ArrayList<>();
  try (Connection conn = DriverManager.getConnection(dbUrl, username, password);
       Statement stmt = conn.createStatement();
       ResultSet rs = stmt.executeQuery("SELECT Dnumber, Dname FROM DEPARTMENT")) {

    while (rs.next()) {
      Map<String, Object> dept = new HashMap<>();
      dept.put("Dnumber", rs.getInt("Dnumber"));
      dept.put("Dname", rs.getString("Dname"));
      departments.add(dept);
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
%>

<form id="salaryForm" method="post">
  <fieldset>
    <legend>부서 선택</legend>
    <% for (Map<String, Object> dept : departments) { %>
    <label>
      <input type="checkbox" name="selectedDepartments" value="<%= dept.get("Dnumber") %>">
      <%= dept.get("Dnumber") %> - <%= dept.get("Dname") %>
    </label><br>
    <% } %>
  </fieldset>

  <br><br>

  <label for="percentage">비율 입력 (%):</label>
  <input type="number" id="percentage" name="percentage" step="0.1" required>

  <br><br>

  <input type="hidden" id="action" name="action">

  <button type="button" onclick="updateSalary('increase')">증가</button>
  <button type="button" onclick="updateSalary('decrease')">감소</button>
  <button type="button" onclick="resetForm()">Back</button>
</form>

<%
  // 월급 수정 처리 로직
  String action = request.getParameter("action");
  if (action != null && (action.equals("increase") || action.equals("decrease"))) {
    String[] selectedDepartments = request.getParameterValues("selectedDepartments");
    String percentageStr = request.getParameter("percentage");

    if (selectedDepartments != null && percentageStr != null) {
      double percentage = Double.parseDouble(percentageStr);
      int updatedCount = 0;

      String operator = action.equals("increase") ? "+" : "-";
      String query = "UPDATE EMPLOYEE SET Salary = Salary * (1 " + operator + " ? / 100) WHERE Dno = ?";

      try (Connection conn = DriverManager.getConnection(dbUrl, username, password);
           PreparedStatement pstmt = conn.prepareStatement(query)) {

        for (String dno : selectedDepartments) {
          pstmt.setDouble(1, percentage);
          pstmt.setInt(2, Integer.parseInt(dno));
          int rowsAffected = pstmt.executeUpdate();
          if (rowsAffected > 0) {
            updatedCount++;
          }
        }
      } catch (SQLException e) {
        e.printStackTrace();
      }

      out.println("<p>" + updatedCount + "개 부서의 월급이 수정되었습니다.</p>");
    } else {
      out.println("<p>부서 또는 비율을 선택해 주세요.</p>");
    }
  }
%>
<form action="index.jsp" method="get">
  <button type="submit">홈 화면</button>
</form>
</body>
</html>
