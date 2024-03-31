package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class HotelChainEmailAddressService {

    /*
     * METHODS
     */

    /**
     * Method to get all EmailAddresses from the database
     *
     * @return list of HotelChainEmailAddresses from database
     * @throws Exception when trying to connect to database
     */
    public List<HotelChainEmailAddress> getEmailAddresses() throws Exception {

        //SQL query
        String sql = "SELECT * FROM HotelChainEmailAddress";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<HotelChainEmailAddress> emailAddresses = new ArrayList<HotelChainEmailAddress>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the EmailAddress objects from the result
            while(rs.next()) {
                //Create new EmailAddress object
                HotelChainEmailAddress eA =  new HotelChainEmailAddress(
                        rs.getString("emailAddressID"),
                        rs.getString("emailAddressString")
                );
                emailAddresses.add(eA);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return emailAddresses;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a EmailAddress in the database
     *
     * @param HotelChainEmailAddress email address to be created
     * @return String returned that states if the EmailAddress was created or not
     * @throws Exception when trying to connect to database
     */
    public String createEmailAddress(HotelChainEmailAddress emailAddress) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO HotelChainEmailAddress (emailAddressID, emailAddressString)"
                + " VALUES (?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print EmailAddress to console
        System.out.println(emailAddress);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, emailAddress.getEmailAddressID());
            st.setString(2, emailAddress.getEmailAddressString());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting email address: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Email address successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a EmailAddress in the database
     *
     * @param HotelChainEmailAddress email address to be created
     * @param oldEmailAddress email address to find HotelChainEmailAddress to update
     * @return String returned that states if the EmailAddress was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateEmailAddress(HotelChainEmailAddress emailAddress, String oldEmailAddress) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE HotelChainEmailAddress "
                + "SET emailAddressString=? "
                + "WHERE emailAddressID=? AND emailAddressString=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("UPDATE: " + emailAddress);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, emailAddress.getEmailAddressString());
            st.setString(2, emailAddress.getEmailAddressID());
            st.setString(3, oldEmailAddress);

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating email address: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Email address successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a HotelChainEmailAddress from the database by its emailAddressString
     *
     * @param  hCEA HotelChainEmailAddress to delete from the database
     * @return String that states if the EmailAddress was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteEmailAddress(HotelChainEmailAddress hCEA) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM HotelChainEmailAddress WHERE emailAddressID=? AND emailAddressString = ?";
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
            st.setString(1, hCEA.getEmailAddressID());
            st.setString(2, hCEA.getEmailAddressString());

            //Execute query
            st.executeQuery();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while deleting email address: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Email address successfully deleted!";
        }

        //Return message
        return message;
    }
}
