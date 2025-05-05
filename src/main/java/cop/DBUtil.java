package cop;


import java.sql.Connection;
import java.sql.*;

public class DBUtil {
	String host = System.getenv("DB_HOST");
String port = System.getenv("DB_PORT");
String dbName = System.getenv("DB_NAME");
String user = System.getenv("DB_USER");
String pass = System.getenv("DB_PASS");

String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false";
Connection conn = DriverManager.getConnection(url, user, pass);



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
        return DriverManager.getConnection(url, user, pass);
    }
}

