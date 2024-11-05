import java.io.IOException;
import java.sql.*;
import java.util.*;

public class Search {
    public static void main(String[] args) throws SQLException, IOException {
        Scanner scanner = new Scanner(System.in);
        Connection conn = null;

        String dbacct, password, dbname;

        // 사용자로부터 데이터베이스 정보 입력
        System.out.println("Enter database account:");
        dbacct = scanner.nextLine();
        System.out.println("Enter password:");
        password = scanner.nextLine();
        System.out.println("Enter database name:");
        dbname = scanner.nextLine();

        // 데이터베이스 연결
        String url = "jdbc:mysql://localhost:3306/" + dbname;
        conn = DriverManager.getConnection(url, dbacct, password);

        // 검색 범위 입력 받기
        System.out.print("검색 범위 선택 (부서, 성별, 연봉, 생일, 전체 중 하나): ");
        String searchRange = scanner.nextLine();

        System.out.print("검색 값 입력: ");
        String inputText = scanner.nextLine();

        // 검색 항목 선택
        System.out.println("검색 항목 선택 (쉼표로 구분하여 입력, 예: Name,Ssn,Bdate,Salary): ");
        String[] searchFields = scanner.nextLine().split(",");

        // 그룹별 평균 급여 선택 여부
        System.out.print("그룹별 평균 급여를 계산하시겠습니까? (예: 성별, 부서 중 하나 / 아니오: none): ");
        String groupBy = scanner.nextLine();

        // SQL 쿼리 구성
        StringBuilder selectClause = new StringBuilder();
        StringBuilder fromClause = new StringBuilder("EMPLOYEE a LEFT OUTER JOIN EMPLOYEE b ON a.Super_ssn = b.Ssn, DEPARTMENT");
        StringBuilder whereClause = new StringBuilder("a.dno = dnumber");

        // 선택된 검색 항목에 따라 SELECT 절 구성
        boolean firstField = true;
        for (String field : searchFields) {
            if (!firstField) selectClause.append(", ");
            firstField = false;

            switch (field.trim()) {
                case "Name":
                    selectClause.append("concat(a.fname, ' ', ifnull(concat(' ', a.minit), ''), ' ', a.lname) as Name");
                    break;
                case "Supervisor":
                    selectClause.append("concat(b.fname, ' ', b.minit, ' ', b.lname) as Supervisor");
                    break;
                case "Department":
                    selectClause.append("dname as Department");
                    break;
                default:
                    selectClause.append("a.").append(field.trim());
                    break;
            }
        }

        // 검색 범위 조건 추가
        String rangeCondition = "";
        switch (searchRange) {
            case "부서":
                whereClause.append(" AND Dname = ?");
                rangeCondition = inputText;
                break;
            case "성별":
                whereClause.append(" AND Sex = ?");
                rangeCondition = inputText;
                break;
            case "연봉":
                whereClause.append(" AND Salary > ?");
                rangeCondition = inputText;
                break;
            case "생일":
                whereClause.append(" AND MONTH(Bdate) = ?");
                rangeCondition = inputText.replace("월", "");
                break;
        }

        // 그룹별 평균 급여 쿼리 구성
        if (!groupBy.equals("none")) {
            selectClause.setLength(0);  // 기존 SELECT 절을 지우고 새로운 SELECT 절 생성
            if (groupBy.equals("성별")) {
                selectClause.append("Sex, AVG(Salary) as AVG_Salary");
                whereClause = new StringBuilder("1=1 GROUP BY Sex");
            } else if (groupBy.equals("부서")) {
                selectClause.append("Dname as Department, AVG(Salary) as AVG_Salary");
                fromClause = new StringBuilder("EMPLOYEE a JOIN DEPARTMENT ON a.Dno = DEPARTMENT.Dnumber");
                whereClause = new StringBuilder("1=1 GROUP BY Dname");
            }
        }

        String query = "SELECT " + selectClause + " FROM " + fromClause + " WHERE " + whereClause + ";";
        System.out.println("Generated Query: " + query);

        // 쿼리 실행 및 결과 출력
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {

            // 검색 범위 조건 설정
            if (!rangeCondition.isEmpty()) {
                pstmt.setString(1, rangeCondition);  // 필요한 경우, 적절한 타입으로 변경 (setInt 등)
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    for (String field : searchFields) {
                        switch (field.trim()) {
                            case "Name":
                                System.out.println("Name: " + rs.getString("Name"));
                                break;
                            case "Ssn":
                                System.out.println("SSN: " + rs.getString("Ssn"));
                                break;
                            case "Bdate":
                                System.out.println("Birth Date: " + rs.getDate("Bdate"));
                                break;
                            case "Address":
                                System.out.println("Address: " + rs.getString("Address"));
                                break;
                            case "Sex":
                                System.out.println("Sex: " + rs.getString("Sex"));
                                break;
                            case "Salary":
                                System.out.println("Salary: " + rs.getDouble("Salary"));
                                break;
                            case "Supervisor":
                                System.out.println("Supervisor: " + rs.getString("Supervisor"));
                                break;
                            case "Department":
                                System.out.println("Department: " + rs.getString("Department"));
                                break;
                            case "AVG_Salary":
                                System.out.println("Average Salary: " + rs.getDouble("AVG_Salary"));
                                break;
                            default:
                                System.out.println(field.trim() + ": " + rs.getString(field.trim()));
                                break;
                        }
                    }
                    System.out.println("------------");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (conn != null) conn.close();
        }
    }
}
