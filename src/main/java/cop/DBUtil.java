package cop;


import java.sql.Connection;
import java.sql.*;

public class DBUtil {
	static String host = System.getenv("DB_HOST");
static String port = System.getenv("DB_PORT");
static String dbName = System.getenv("DB_NAME");
static String user = System.getenv("DB_USER");
static String pass = System.getenv("DB_PASS");

static String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false";


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

