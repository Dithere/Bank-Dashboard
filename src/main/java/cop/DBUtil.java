package cop;


import java.sql.Connection;
import java.sql.*;

public class DBUtil {
	static String url ="jdbc:mysql://localhost:3306/bank";

    static String username ="root";
    static String password ="Aditya@123";
    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
    	System.out.println("hfufcj");
        return DriverManager.getConnection(url, username, password);
    }
}

