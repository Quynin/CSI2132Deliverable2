package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class CustomerService {

    /*
     * METHODS
     */

    /**
     * Method to get all Customers from the database
     *
     * @return list of Customers from database
     * @throws Exception when trying to connect to database
     */
    public List<Customer> getCustomers() throws Exception {

        //SQL query
        String sql = "SELECT * FROM Person p JOIN Customer c ON p.personID = c.customerID;";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Customer> customers = new ArrayList<Customer>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the Customers objects from the result
            while(rs.next()) {
                //Create new Customer object
                Customer c = new Customer(
                        rs.getString("customerID"), //POSSIBLY REPLACE WITH "personID"?
                        rs.getString("personIDType"),
                        rs.getString("personFullName"),
                        rs.getString("personAddress"),
                        rs.getDate("registrationDate")
                );
                customers.add(c);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return customers;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a Customer in the database
     *
     * @param Customer customer to be created
     * @return String returned that states if the Customer was created or not
     * @throws Exception when trying to connect to database
     */
    public String createCustomer(Customer customer) throws Exception {

        //Create the Person in the database for Customer to build from
        PersonService pS = new PersonService();
        String result = pS.createPerson(customer);
        System.out.println(result);

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO Customer (customerID, registrationDate)"
                + " VALUES (?, NOW() )";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Customer to console
        System.out.println(customer);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, customer.getID());

            //Customer registrationDate is handled by the SQL server as it inputs the Customer
            //st.setDate(2, new java.sql.Date(customer.getRegistrationDate().getTime()));

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting customer: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Customer successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a Customer in the database
     *
     * @param Customer customer to be created
     * @return String returned that states if the Customer was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateCustomer(Customer customer) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE Customer"
                + "SET registrationDate=?"
                + "WHERE customerID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + customer);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setDate(1, new java.sql.Date(customer.getRegistrationDate().getTime()));
            st.setString(2, customer.getID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating customer: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Customer successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a Customer from the database by its customerID
     *
     * @param id customerID of the Customer to delete from the database
     * @return String that states if the Customer was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteCustomer(String id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM Customer WHERE customerID = ?";
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
            message = "Error while deleting customer: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Customer successfully deleted!";
        }

        //Return message
        return message;
    }
}
