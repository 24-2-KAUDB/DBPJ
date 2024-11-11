<%@ page import="java.util.ArrayList, java.util.Arrays, java.util.List, java.util.Map" %>
<%@ page import="com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Employee Management System</title>
</head>
<body>
<h2>Employee Management System</h2>

<!-- 검색 조건 선택 폼 (체크박스) -->
<form action="delete.jsp" method="post">
    <fieldset>
        <legend>Search Options</legend>
        <label><input type="checkbox" name="attributes" value="Fname"> First Name</label>
        <label><input type="checkbox" name="attributes" value="Minit"> Middle Initial</label>
        <label><input type="checkbox" name="attributes" value="Lname"> Last Name</label>
        <label><input type="checkbox" name="attributes" value="Ssn"> SSN</label>
        <label><input type="checkbox" name="attributes" value="Bdate"> Birth Date</label>
        <label><input type="checkbox" name="attributes" value="Address"> Address</label>
        <label><input type="checkbox" name="attributes" value="Sex"> Sex</label>
        <label><input type="checkbox" name="attributes" value="Salary"> Salary</label>
        <label><input type="checkbox" name="attributes" value="Super_ssn"> Supervisor SSN</label>
        <label><input type="checkbox" name="attributes" value="Dno"> Department Number</label>
    </fieldset>

    <input type="submit" value="Search" />
</form>

<%
    DatabaseService dbService = new DatabaseService();
    String[] attributes = request.getParameterValues("attributes");
    String username = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    // 조회할 필드 리스트 생성
    List<String> queryAttributes = new ArrayList<>();
    if (attributes != null) {
        queryAttributes.addAll(Arrays.asList(attributes));
    }
    // 'SSN'이 선택되지 않더라도 직원 삭제에 사용할 수 있도록 SSN을 항상 쿼리에서 포함
    if (!queryAttributes.contains("Ssn")) {
        queryAttributes.add("Ssn");
    }

    List<Map<String, Object>> employeeList = dbService.getEmployeeData(queryAttributes.toArray(new String[0]), username, password);
%>


<!-- 직원 정보를 표시할 테이블 -->
<form action="delete.jsp" method="post">
    <table border="1">
        <tr>
            <th>Select</th>
            <%
                if (attributes != null) {
                    for (String attr : attributes) {
                        out.print("<th>" + attr + "</th>");
                    }
                }
            %>
        </tr>

        <%
            if (employeeList != null) {
                for (Map<String, Object> employee : employeeList) {
        %><tr>
        <!-- 직원 선택 체크박스 -->
        <td>
            <input type="checkbox" name="selectedEmployees" value="<%= employee.get("Ssn") %>">
        </td>

        <!-- 검색 조건에 맞는 필드만 표시 -->
        <% if (attributes != null) {
            for (String attr : attributes) {
                out.print("<td>" + employee.get(attr) + "</td>");
            }
        } %>

        <!-- 숨겨진 필드로 SSN을 추가해 삭제 시 사용 -->
        <input type="hidden" name="employeeSsn_<%= employee.get("Ssn") %>" value="<%= employee.get("Ssn") %>">
    </tr><%
            }
        }
    %>
    </table>

    <!-- 삭제 버튼 -->
    <input type="hidden" name="action" value="delete" />
    <input type="submit" value="Delete Selected Employees" />
</form>

<%
    // 삭제 처리 로직
    if ("delete".equals(request.getParameter("action"))) {
        String[] selectedSsns = request.getParameterValues("selectedEmployees");

        int deletedCount = 0;
        if (selectedSsns != null) {
            for (String ssn : selectedSsns) {
                if (dbService.deleteEmployee(ssn, username, password)) {
                    deletedCount++;
                }
            }
            out.println("<p>" + deletedCount + " employee(s) deleted successfully.</p>");
        } else {
            out.println("<p>No employees selected for deletion.</p>");
        }
    }
%>
<form action="index.jsp" method="get">
    <button type="submit">홈 화면</button>
</form>

</body>
</html>

