package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO4 {
    protected static Connection con;

    public DAO4() {
        if (con == null) {
            String dbUrl = System.getProperty("db.url", "jdbc:mysql://localhost:3306/qlcuahang4?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=UTF-8");
            String dbUser = System.getProperty("db.user", "root");
            String dbPass = System.getProperty("db.password", "");

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
            } catch (ClassNotFoundException e) {
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public Connection getConnection() {
        return con;
    }
}
