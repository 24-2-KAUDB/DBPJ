<%@ page import="java.util.*, com.example.DatabaseService" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>직원 검색 시스템</title>
</head>
<body>
<h1>직원 검색</h1>

<!-- 검색 폼 -->
<form action="search.jsp" method="get">
    <h3>검색 범위</h3>
    <select name="searchRange" id="searchRange" onchange="updateRangeValueOptions()">
        <option value="all" selected>전체</option>
        <option value="department">부서</option>
        <option value="sex">성별</option>
        <option value="salary">연봉</option>
        <option value="bdate">생일</option>
        <option value="supervisor">부하직원</option>
        <option value="family">가족</option>
    </select>

    <!-- 검색 범위에 따른 동적 선택 목록 -->
    <select name="rangeValue" id="rangeValueSelect" style="display: none;"></select>

    <h3>검색 항목</h3>
    <input type="checkbox" name="fields" value="Fname" checked> Fname
    <input type="checkbox" name="fields" value="Minit"> Minit
    <input type="checkbox" name="fields" value="Lname"> Lname
    <input type="checkbox" name="fields" value="Ssn"> Ssn
    <input type="checkbox" name="fields" value="Bdate"> Bdate
    <input type="checkbox" name="fields" value="Address"> Address
    <input type="checkbox" name="fields" value="Sex"> Sex
    <input type="checkbox" name="fields" value="Salary"> Salary
    <input type="checkbox" name="fields" value="Super_ssn"> Super_ssn
    <input type="checkbox" name="fields" value="Dno"> Dno
    <input type="checkbox" name="fields" value="Dname"> Dname

    <input type="submit" value="검색하기">
</form>

<hr>

<%
    try {
        String searchRange = request.getParameter("searchRange");
        String rangeValue = request.getParameter("rangeValue");
        String[] fields = request.getParameterValues("fields");

        if (fields == null || fields.length == 0) {
            out.println("하나 이상의 검색 항목을 선택하세요.");
            return;
        }

        // 조건 설정
        String condition = "";
        if (searchRange != null && rangeValue != null && !rangeValue.isEmpty()) {
            switch (searchRange) {
                case "department":
                    condition = "Dname = '" + rangeValue + "'";
                    break;
                case "sex":
                    condition = "Sex = '" + rangeValue + "'";
                    break;
                case "salary":
                    condition = "Salary >= " + rangeValue;
                    break;
                case "bdate":
                    condition = "MONTH(Bdate) = " + rangeValue.replace("월", "");
                    break;
                case "supervisor":
                    condition = "Super_ssn = '" + rangeValue + "'";
                    break;
                case "family":
                    condition = "Ssn = '" + rangeValue + "'";
                    break;
                default:
                    condition = "";
                    break;
            }
        }

        DatabaseService dbService = new DatabaseService();
        String username = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        // 검색 결과 가져오기
        List<Map<String, Object>> results = dbService.getemployeeData(fields, condition, null, username, password);

        // 검색 결과 출력
        out.println("<h3>검색 결과</h3>");
        out.println("<p>Condition: " + condition + "</p>");
        out.println("<table border='1'><tr>");

        for (String field : fields) {
            out.println("<th>" + field + "</th>");
        }
        out.println("</tr>");

        for (Map<String, Object> employee : results) {
            out.println("<tr>");
            for (String field : fields) {
                out.println("<td>" + employee.get(field) + "</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<script>
    function updateRangeValueOptions() {
        const searchRange = document.getElementById("searchRange").value;
        const rangeValueSelect = document.getElementById("rangeValueSelect");

        rangeValueSelect.style.display = "none";
        rangeValueSelect.innerHTML = "";

        if (searchRange === "department") {
            rangeValueSelect.style.display = "inline";
            const departments = ["Administration", "Research", "Headquarters"];
            departments.forEach(dept => {
                const option = document.createElement("option");
                option.value = dept;
                option.text = dept;
                rangeValueSelect.appendChild(option);
            });
        } else if (searchRange === "sex") {
            rangeValueSelect.style.display = "inline";
            ["M", "F"].forEach(sex => {
                const option = document.createElement("option");
                option.value = sex;
                option.text = sex;
                rangeValueSelect.appendChild(option);
            });
        } else if (searchRange === "salary") {
            rangeValueSelect.style.display = "inline";
            ["30000", "40000", "50000"].forEach(salary => {
                const option = document.createElement("option");
                option.value = salary;
                option.text = salary;
                rangeValueSelect.appendChild(option);
            });
        } else if (searchRange === "bdate") {
            rangeValueSelect.style.display = "inline";
            for (let month = 1; month <= 12; month++) {
                const option = document.createElement("option");
                option.value = month;
                option.text = month + "월";
                rangeValueSelect.appendChild(option);
            }
        } else if (searchRange === "supervisor") {
            rangeValueSelect.style.display = "inline";
            const supervisors = ["James E Borg", "Jennifer S Wallace", "Ahmad V Jabbar"];
            supervisors.forEach(sup => {
                const option = document.createElement("option");
                option.value = sup;
                option.text = sup;
                rangeValueSelect.appendChild(option);
            });
        } else if (searchRange === "family") {
            rangeValueSelect.style.display = "inline";
            const employees = ["John Doe", "Jane Smith", "Michael Johnson"];
            employees.forEach(emp => {
                const option = document.createElement("option");
                option.value = emp;
                option.text = emp;
                rangeValueSelect.appendChild(option);
            });
        }
    }
</script>
<form action="index.jsp" method="get">
    <button type="submit">홈 화면</button>
</form>
</body>
</html>
