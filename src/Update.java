import java.io.IOException;
import java.sql.*;
import java.io.*;
import java.util.Scanner;

public class Update {
  public static void main (String args []) throws SQLException, IOException {
    Scanner scanner = new Scanner(System.in);
    Connection conn = null;

    String dbacct, password, dbname, ssn, lname;
    Double salary;

    System.out.println("Enter database account:");
    dbacct = scanner.nextLine();
    System.out.println("Enter password:");
    password = scanner.nextLine();
    System.out.println("Enter database name:");
    dbname = scanner.nextLine();

    String url = "jdbc:mysql://localhost:3306/"+dbname;
    conn = DriverManager.getConnection(url, dbacct, password);

    System.out.println("Enter a Social Security Number: ");
    ssn=scanner.nextLine();

    System.out.print("업데이트할 속성을 입력하세요 (예: Fname, Minit, Lname, Salary 등): ");
    String attribute = scanner.nextLine();

    System.out.print("새 값을 입력하세요: ");
    String newValue = scanner.nextLine();

    String update = "UPDATE EMPLOYEE SET " + attribute + " = ? WHERE Ssn = ?";
    PreparedStatement p = conn.prepareStatement(update);

    p.clearParameters();
    p.setString(1, newValue);
    p.setString(2, ssn);
    int rowsUpdated = p.executeUpdate();

    if (rowsUpdated > 0) {
      System.out.println("직원 정보가 업데이트되었습니다.");
    } else {
      System.out.println("직원 정보를 찾을 수 없습니다.");
    }
    try{
      if(conn != null)
        conn.close();
    } catch( SQLException e){

    }
  }
}