package cop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    static String host = System.getenv("DB_HOST");
    static String port = System.getenv("DB_PORT");
    static String dbName = System.getenv("DB_NAME");
    static String user = System.getenv("DB_USER");
    static String pass = System.getenv("DB_PASS");

    static String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load JDBC driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("Connecting to DB...");
        return DriverManager.getConnection(url, user, pass);
    }
}
