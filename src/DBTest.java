import java.sql.*;
import java.io.*;
import java.util.Scanner;

public class DBTest {
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

    String stmt1 = "select Lname, Salary from EMPLOYEE where Ssn=?";
    PreparedStatement p=conn.prepareStatement(stmt1);

    System.out.println("Enter a Social Security Number: ");
    ssn=scanner.nextLine();

    p.clearParameters();
    p.setString(1, ssn);
    ResultSet r=p.executeQuery();

    while(r.next()){
      lname=r.getString(1);
      salary=r.getDouble(2);
      System.out.println(lname+" "+salary);
    }
    try{
      if(conn != null)
        conn.close();
    } catch( SQLException e){

    }
  }
}
