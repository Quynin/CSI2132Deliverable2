package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class EmployeeService {

    /*
     * METHODS
     */

    /**
     * Method to get all Employees from the database
     *
     * @return list of Employees from database
     * @throws Exception when trying to connect to database
     */
    public List<Employee> getEmployees() throws Exception {

        //SQL query
        String sql = "SELECT * FROM Person p JOIN Employee e ON p.personID = e.employeeID;";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Employee> employees = new ArrayList<Employee>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the Employee objects from the result
            while(rs.next()) {
                //Create new Employee object
                Employee e =  new Employee(
                        rs.getString("employeeID"), //POSSIBLY REPLACE WITH "personID"?
                        rs.getString("personIDType"),
                        rs.getString("personFullName"),
                        rs.getString("personAddress"),
                        rs.getInt("hotelID"),
                        rs.getString("employeeRole")
                );
                employees.add(e);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return employees;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create an Employee in the database
     *
     * @param Employee employee to be created
     * @return String returned that states if the Employee was created or not
     * @throws Exception when trying to connect to database
     */
    public String createEmployee(Employee employee) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO Employee (employeeID, hotelID, employeeRole)"
                + " VALUES (?, ?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Employee to console
        System.out.println(employee);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, employee.getID());
            st.setInt(2, employee.getHotelID());
            st.setString(3, employee.getRole());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting employee: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Employee successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update an Employee in the database
     *
     * @param Employee employee to be created
     * @return String returned that states if the Employee was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateEmployee(Employee employee) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE Employee"
                + "SET hotelID=?, employeeRole=?"
                + "WHERE employeeID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + employee);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, employee.getHotelID());
            st.setString(2, employee.getRole());
            st.setString(3, employee.getID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating employee: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Employee successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete an Employee from the database by its employee
     *
     * @param id employeeID of the Employee to delete from the database
     * @return String that states if the Employee was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteEmployee(String id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM Employee WHERE employeeID = ?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholder ? of statement
            st.setString(1, id);

            //Execute query
            st.executeQuery();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while deleting employee: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Employee successfully deleted!";
        }

        //Return message
        return message;
    }
}
