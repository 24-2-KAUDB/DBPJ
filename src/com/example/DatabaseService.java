package com.example;

import java.math.BigDecimal;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class DatabaseService {
    private Connection connect() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/mydb";
        String user = "root";
        String password = "";
        return DriverManager.getConnection(url, user, password);
    }

    public List<Map<String, Object>> getAllEmployeeData() {
        List<Map<String, Object>> employeeList = new ArrayList<>();
        String query = "SELECT EMPLOYEE.*, DEPARTMENT.Dname FROM EMPLOYEE LEFT JOIN DEPARTMENT ON EMPLOYEE.Dno = DEPARTMENT.Dnumber";

        try (Connection conn = connect();
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
                employeeList.add(employee);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return employeeList;
    }

    // 예시로 직원 데이터를 가져오는 메서드
    public List<Map<String, Object>> getEmployeeData(String[] attributes) {
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

        try (Connection conn = connect();
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
    public boolean insertEmployee(Map<String, Object> employeeData) {
        String query = "INSERT INTO employee (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = connect();
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
    public boolean deleteEmployee(String ssn) {
        String query = "DELETE FROM employee WHERE Ssn = ?";
        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, ssn);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
