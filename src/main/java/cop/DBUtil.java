package cop;


import java.sql.Connection;
import java.sql.*;

public class DBUtil {
	static String host = System.getenv("MYSQLHOST");
static String port = System.getenv("MYSQLPORT");
static String dbName = System.getenv("MYSQLDATABASE");
static String user = System.getenv("MYSQLUSER");
static String pass = System.getenv("MYSQLPASSWORD");

// Example URL for Railway (SSL enabled)
static String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=true";


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

