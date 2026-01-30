/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Adjust URL / user / pass to match your local DB if different
    private static final String URL = "jdbc:mysql://localhost:3306/nothinghill?useSSL=false&serverTimezone=UTC";
    private static final String USER = "mia";
    private static final String PASS = "app";

    static {
        try {
            // load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // fallback older driver
            try { Class.forName("com.mysql.jdbc.Driver"); } catch (ClassNotFoundException ex) {}
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
