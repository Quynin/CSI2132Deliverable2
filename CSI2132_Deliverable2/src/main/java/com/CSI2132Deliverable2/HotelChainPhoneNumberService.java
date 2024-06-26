package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class HotelChainPhoneNumberService {

    /*
     * METHODS
     */

    /**
     * Method to get all PhoneNumbers from the database
     *
     * @return list of PhoneNumbers from database
     * @throws Exception when trying to connect to database
     */
    public List<HotelChainPhoneNumber> getPhoneNumbers() throws Exception {

        //SQL query
        String sql = "SELECT * FROM HotelChainPhoneNumber";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<HotelChainPhoneNumber> phoneNumbers = new ArrayList<HotelChainPhoneNumber>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the PhoneNumber objects from the result
            while(rs.next()) {
                //Create new PhoneNumber object
                HotelChainPhoneNumber pN =  new HotelChainPhoneNumber(
                        rs.getString("phoneNumberID"),
                        rs.getString("phoneNumberString")
                );
                phoneNumbers.add(pN);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return phoneNumbers;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a PhoneNumber in the database
     *
     * @param HotelChainPhoneNumber phone number to be created
     * @return String returned that states if the PhoneNumber was created or not
     * @throws Exception when trying to connect to database
     */
    public String createPhoneNumber(HotelChainPhoneNumber phoneNumber) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO HotelChainPhoneNumber (phoneNumberID, phoneNumberString)"
                + " VALUES (?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print PhoneNumber to console
        System.out.println(phoneNumber);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, phoneNumber.getPhoneNumberID());
            st.setString(2, phoneNumber.getPhoneNumberString());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting phone number: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Phone number successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a PhoneNumber in the database
     *
     * @param HotelChainPhoneNumber phone number to be updated
     * @param oldPhoneNumber old phone number to identify the phone number to update
     * @return String returned that states if the PhoneNumber was updated or not
     * @throws Exception when trying to connect to database
     */
    public String updatePhoneNumber(HotelChainPhoneNumber phoneNumber, String oldPhoneNumber) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE HotelChainPhoneNumber "
                + "SET phoneNumberString=? "
                + "WHERE phoneNumberID=? AND phoneNumberString=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("UPDATE: " + phoneNumber);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, phoneNumber.getPhoneNumberString());
            st.setString(2, phoneNumber.getPhoneNumberID());
            st.setString(3, oldPhoneNumber);

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating phone number: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Phone number successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a HotelChainPhoneNumber from the database by its phoneNumberString
     *
     * @param hCPN HotelChainPhoneNumber to delete from the database
     * @return String that states if the PhoneNumber was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deletePhoneNumber(HotelChainPhoneNumber hCPN) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM HotelChainPhoneNumber WHERE phoneNumberID=? AND phoneNumberString=?";
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
            st.setString(1, hCPN.getPhoneNumberID());
            st.setString(2, hCPN.getPhoneNumberString());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while deleting phone number: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Phone number successfully deleted!";
        }

        //Return message
        return message;
    }

}
