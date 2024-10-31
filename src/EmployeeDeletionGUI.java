import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class EmployeeDeletionGUI extends JFrame {
    private static final String url = "jdbc:mysql://localhost:3306/company?serverTimezone=UTC";
    private static final String user = "root";
    private static final String password = "jyj8120065!!";

    private JTextField fnameField, lnameField, ssnField, bdateField, addressField, sexField, salaryField, superSsnField, dnoField;
    private JTable table;
    private DefaultTableModel model;

    public EmployeeDeletionGUI() {
        setTitle("Employee Deletion System");
        setSize(800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        // 검색 조건 입력 필드
        JPanel inputPanel = new JPanel(new GridLayout(2, 9));
        fnameField = new JTextField(10);
        lnameField = new JTextField(10);
        ssnField = new JTextField(10);
        bdateField = new JTextField(10);
        addressField = new JTextField(10);
        sexField = new JTextField(10);
        salaryField = new JTextField(10);
        superSsnField = new JTextField(10);
        dnoField = new JTextField(10);

        inputPanel.add(new JLabel("First Name"));
        inputPanel.add(fnameField);
        inputPanel.add(new JLabel("Last Name"));
        inputPanel.add(lnameField);
        inputPanel.add(new JLabel("Ssn"));
        inputPanel.add(ssnField);
        inputPanel.add(new JLabel("Bdate"));
        inputPanel.add(bdateField);
        inputPanel.add(new JLabel("Address"));
        inputPanel.add(addressField);
        inputPanel.add(new JLabel("Sex"));
        inputPanel.add(sexField);
        inputPanel.add(new JLabel("Salary"));
        inputPanel.add(salaryField);
        inputPanel.add(new JLabel("Super_ssn"));
        inputPanel.add(superSsnField);
        inputPanel.add(new JLabel("Dno"));
        inputPanel.add(dnoField);

        // 테이블 모델 설정
        model = new DefaultTableModel(new Object[]{"Ssn", "Fname", "Lname", "Bdate", "Address", "Sex", "Salary", "Super_ssn", "Dno"}, 0);
        table = new JTable(model);

        // 스크롤 패널에 테이블 추가
        JScrollPane scrollPane = new JScrollPane(table);

        // 삭제 버튼
        JButton deleteButton = new JButton("Delete Selected Employees");
        deleteButton.addActionListener(new DeleteActionListener());

        // 프레임에 구성 요소 추가
        add(inputPanel, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);
        add(deleteButton, BorderLayout.SOUTH);

        // 초기 데이터 로드
        loadEmployees();
    }

    private void loadEmployees() {
        // 데이터베이스에서 직원 정보를 로드하여 테이블에 표시
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery("SELECT * FROM employee");

            while (rs.next()) {
                model.addRow(new Object[]{rs.getString("Ssn"), rs.getString("Fname"), rs.getString("Lname"),
                        rs.getDate("Bdate"), rs.getString("Address"), rs.getString("Sex"),
                        rs.getDouble("Salary"), rs.getString("Super_ssn"), rs.getInt("Dno")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(this, "Error loading data from the database.", "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private class DeleteActionListener implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            // 입력된 조건을 바탕으로 DELETE 쿼리 실행
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                StringBuilder deleteSQL = new StringBuilder("DELETE FROM employee WHERE 1=1");
                PreparedStatement pstmt = conn.prepareStatement(deleteSQL.toString());

                // 조건 추가
                int parameterIndex = 1;
                if (!fnameField.getText().isEmpty()) {
                    deleteSQL.append(" AND Fname = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, fnameField.getText());
                }
                if (!lnameField.getText().isEmpty()) {
                    deleteSQL.append(" AND Lname = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, lnameField.getText());
                }
                if (!ssnField.getText().isEmpty()) {
                    deleteSQL.append(" AND Ssn = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, ssnField.getText());
                }
                if (!bdateField.getText().isEmpty()) {
                    deleteSQL.append(" AND Bdate = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setDate(parameterIndex++, Date.valueOf(bdateField.getText()));
                }
                if (!addressField.getText().isEmpty()) {
                    deleteSQL.append(" AND Address = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, addressField.getText());
                }
                if (!sexField.getText().isEmpty()) {
                    deleteSQL.append(" AND Sex = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, sexField.getText());
                }
                if (!salaryField.getText().isEmpty()) {
                    deleteSQL.append(" AND Salary = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setDouble(parameterIndex++, Double.parseDouble(salaryField.getText()));
                }
                if (!superSsnField.getText().isEmpty()) {
                    deleteSQL.append(" AND Super_ssn = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setString(parameterIndex++, superSsnField.getText());
                }
                if (!dnoField.getText().isEmpty()) {
                    deleteSQL.append(" AND Dno = ?");
                    pstmt = conn.prepareStatement(deleteSQL.toString());
                    pstmt.setInt(parameterIndex++, Integer.parseInt(dnoField.getText()));
                }

                // DELETE 쿼리 실행
                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    JOptionPane.showMessageDialog(EmployeeDeletionGUI.this, rowsAffected + "개의 직원 정보가 삭제되었습니다.");
                    model.setRowCount(0); // 테이블 비우기
                    loadEmployees(); // 삭제 후 데이터 재로딩
                } else {
                    JOptionPane.showMessageDialog(EmployeeDeletionGUI.this, "조건에 맞는 직원이 없습니다.");
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                JOptionPane.showMessageDialog(EmployeeDeletionGUI.this, "Error deleting data from the database.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new EmployeeDeletionGUI().setVisible(true);
        });
    }
}
