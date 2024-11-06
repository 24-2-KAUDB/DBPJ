<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>직원 보고서 선택</title>
</head>
<body>
<h1>직원 보고서 선택</h1>
<form action="displayReport.jsp" method="post">
    <p>출력할 속성을 선택하세요:</p>
    <input type="checkbox" name="attributes" value="Fname"> 이름<br>
    <input type="checkbox" name="attributes" value="Minit"> 중간 이름<br>
    <input type="checkbox" name="attributes" value="Lname"> 성<br>
    <input type="checkbox" name="attributes" value="Ssn"> 주민번호<br>
    <input type="checkbox" name="attributes" value="Bdate"> 생년월일<br>
    <input type="checkbox" name="attributes" value="Address"> 주소<br>
    <input type="checkbox" name="attributes" value="Sex"> 성별<br>
    <input type="checkbox" name="attributes" value="Salary"> 급여<br>
    <input type="checkbox" name="attributes" value="Dname"> 부서명<br> <!-- Dno 대신 Dname -->
    <br>
    <button type="submit">출력</button>
</form>
</body>
</html>
