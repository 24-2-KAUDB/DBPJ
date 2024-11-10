package com.example;

import java.math.BigDecimal;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class DatabaseService {
    public Connection connect(String user, String password) throws SQLException {
        String url = "jdbc:mysql://DESKTOP-Q1IG1AR:3306/mydb";
        return DriverManager.getConnection(url, user, password);
    }

    public List<Map<String, Object>> getAllEmployeeData(String user, String password) {
        List<Map<String, Object>> employeeList = new ArrayList<>();
        String query = "SELECT EMPLOYEE.*, DEPARTMENT.Dname FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber";

        try (Connection conn = connect(user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Map<String, Object> employee = new HashMap<>();
                employee.put("Fname", rs.getString("Fname"));
                employee.put("Minit", rs.getString("Minit"));
                employee.put("Lname", rs.getString("Lname"));
                employee.put("Ssn", rs.getString("Ssn"));
                employee.put("Bdate", rs.getDate("Bdate"));
                employee.put("Address", rs.getString("Address"));
                employee.put("Sex", rs.getString("Sex"));
                employee.put("Salary", rs.getBigDecimal("Salary"));
                employee.put("Super_ssn", rs.getString("Super_ssn"));
                employee.put("Dno", rs.getInt("Dno"));
                employee.put("Dname", rs.getString("Dname"));
                employee.put("updated_date", rs.getString("updated_date"));
                employeeList.add(employee);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employeeList;
    }

    // 예시로 직원 데이터를 가져오는 메서드
    public List<Map<String, Object>> getEmployeeData(String[] attributes, String user, String password) {
        List<Map<String, Object>> employeeList = new ArrayList<>();
        if (attributes == null || attributes.length == 0) {
            return employeeList;
        }

        StringBuilder query = new StringBuilder("SELECT ");
        for (String attr : attributes) {
            if ("Dname".equals(attr)) {
                query.append("DEPARTMENT.Dname AS Dname, ");
            } else {
                query.append("EMPLOYEE.").append(attr).append(", ");
            }
        }
        query.setLength(query.length() - 2); // 마지막 쉼표 제거
        query.append(" FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber");

        try (Connection conn = connect(user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query.toString())) {

            while (rs.next()) {
                Map<String, Object> employee = new HashMap<>();
                for (String attr : attributes) {
                    if ("Dname".equals(attr)) {
                        employee.put("Dname", rs.getObject("Dname"));
                    } else {
                        employee.put(attr, rs.getObject(attr));
                    }
                }
                employeeList.add(employee);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employeeList;
    }

    // 직원 정보 삽입 메서드
    public boolean insertEmployee(Map<String, Object> employeeData, String user, String password) {
        String query = "INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = connect(user, password);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, (String) employeeData.get("Fname"));
            pstmt.setString(2, (String) employeeData.get("Minit"));
            pstmt.setString(3, (String) employeeData.get("Lname"));
            pstmt.setString(4, (String) employeeData.get("Ssn"));
            pstmt.setDate(5, (Date) employeeData.get("Bdate"));
            pstmt.setString(6, (String) employeeData.get("Address"));
            pstmt.setString(7, (String) employeeData.get("Sex"));
            pstmt.setBigDecimal(8, (BigDecimal) employeeData.get("Salary"));
            pstmt.setString(9, (String) employeeData.get("Super_ssn"));
            pstmt.setInt(10, (Integer) employeeData.get("Dno"));

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 직원 정보 삭제 메서드
    public boolean deleteEmployee(String ssn, String user, String password) {
        String query = "DELETE FROM employee WHERE Ssn = ?";
        try (Connection conn = connect(user, password);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, ssn);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // 일반 검색 메서드 (검색 범위와 검색 항목을 사용)
    public List<Map<String, Object>> searchEmployees(String[] attributes, String condition, String username, String password) throws SQLException {
        List<Map<String, Object>> employeeList = new ArrayList<>();
        if (attributes == null || attributes.length == 0) {
            return employeeList;
        }

        // SELECT 절 구성
        StringBuilder query = new StringBuilder("SELECT ");
        for (String attr : attributes) {
            if ("Dname".equals(attr)) {
                query.append("DEPARTMENT.Dname AS Dname, ");
            } else if ("Supervisor".equals(attr)) {
                query.append("CONCAT(b.Fname, ' ', IFNULL(b.Minit, ''), ' ', b.Lname) AS Supervisor, ");
            } else {
                query.append("EMPLOYEE.").append(attr).append(", ");
            }
        }
        query.setLength(query.length() - 2); // 마지막 쉼표 제거
        query.append(" FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber");

        // 상급자 조인 추가 (필요한 경우)
        query.append(" LEFT JOIN EMPLOYEE b ON EMPLOYEE.Super_ssn = b.Ssn");

        // WHERE 절 구성
        if (condition != null && !condition.isEmpty()) {
            query.append(" WHERE ").append(condition);
        }

        System.out.println("Generated Query (Search): " + query); // 디버깅용 쿼리 출력

        try (Connection conn = connect(username, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query.toString())) {

            while (rs.next()) {
                Map<String, Object> employee = new HashMap<>();
                for (String attr : attributes) {
                    if ("Dname".equals(attr)) {
                        employee.put("Dname", rs.getObject("Dname"));
                    } else if ("Supervisor".equals(attr)) {
                        employee.put("Supervisor", rs.getObject("Supervisor"));
                    } else {
                        employee.put(attr, rs.getObject(attr));
                    }
                }
                employeeList.add(employee);
            }
        }
        return employeeList;
    }

    // 그룹별 평균 급여 메서드 (그룹 기준에 따라 평균 급여를 계산)
    public List<Map<String, Object>> getAverageSalaryByGroup(String groupBy, String username, String password) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT ");

        if ("sex".equals(groupBy)) {
            query.append("EMPLOYEE.Sex AS Sex, ");
        } else if ("department".equals(groupBy)) {
            query.append("DEPARTMENT.Dname AS Dname, ");
        } else if ("supervisor".equals(groupBy)) {
            query.append("CONCAT(b.Fname, ' ', IFNULL(b.Minit, ''), ' ', b.Lname) AS Supervisor, ");
        }
        query.append("AVG(EMPLOYEE.Salary) AS avg_salary ");
        query.append("FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber ");

        // 상급자 조인 추가 (필요한 경우)
        if ("supervisor".equals(groupBy)) {
            query.append("LEFT JOIN EMPLOYEE b ON EMPLOYEE.Super_ssn = b.Ssn ");
        }

        // GROUP BY 절 구성
        if ("sex".equals(groupBy)) {
            query.append("GROUP BY EMPLOYEE.Sex");
        } else if ("department".equals(groupBy)) {
            query.append("GROUP BY DEPARTMENT.Dname");
        } else if ("supervisor".equals(groupBy)) {
            query.append("GROUP BY Supervisor");
        }

        System.out.println("Generated Query (Group Average): " + query); // 디버깅용 쿼리 출력

        try (Connection conn = connect(username, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query.toString())) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                if ("sex".equals(groupBy)) {
                    row.put("Sex", rs.getObject("Sex"));
                } else if ("department".equals(groupBy)) {
                    row.put("Dname", rs.getObject("Dname"));
                } else if ("supervisor".equals(groupBy)) {
                    row.put("Supervisor", rs.getObject("Supervisor"));
                }
                row.put("avg_salary", rs.getObject("avg_salary"));
                result.add(row);
            }
        }
        return result;
    }
}
