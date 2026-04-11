package util;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DBConnection {
    private static Connection connection=null;

    public static Connection getConnection() throws SQLException {
        if (connection == null) {
            try {
                Properties props = new Properties();
                InputStream input = DBConnection.class.getClassLoader()
                        .getResourceAsStream("db.properties");
                props.load(input);
                String url = props.getProperty("db.url");
                String user = props.getProperty("db.username");
                String password = props.getProperty("db.password");

                Class.forName("org.postgresql.Driver");
                connection = DriverManager.getConnection(url, user, password);
            } catch (Exception e) {
                throw new SQLException("Failed to load database properties: " + e.getMessage());
            }
        }
        return connection;
    }
}
