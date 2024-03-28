package com.CSI2132Deliverable2;

import java.sql.*;

public class ConnectionDB {

    /*
     * VARIABLES
     */
	//DB connection information
	private final String ipAddress = "127.0.0.1";
	private final String dbServerPort = "5432";
	private final String dbName = "postgres";
	private final String dbUsername = "postgres";
	private final String dbPassword = "admin";
	 
	//DB connection
	private Connection con = null;

    /*
     * CONSTRUCTORS
     */

    /*
     * ACCESSORS & MODIFIERS
     */

    /*
     * METHODS
     */
	public Connection getConnection() throws Exception {
		try {
			Class.forName("org.postgresql.Driver");
			con = DriverManager.getConnection("jdbc:postgresql://"
					+ ipAddress + ":" + dbServerPort + "/" + dbName,
					dbUsername, dbPassword);
			return con;
		} catch (Exception e){
			throw new Exception("Could not establish connection with the Database Server: "
								+ e.getMessage());
		}
	}
	
	public void close() throws Exception {
		try {
			if (con != null) {
				con.close();
			}
		} catch (SQLException e) {
			throw new SQLException("Could not close connection with the Database Server: "
								+ e.getMessage());
		}
		
	}
}
