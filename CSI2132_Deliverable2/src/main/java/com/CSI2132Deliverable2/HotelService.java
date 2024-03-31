package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class HotelService {

    /*
     * METHODS
     */

    /**
     * Method to get queried Hotel from the database
     *
     * @param id the id of the Hotel to be found
     * @return queried Hotel from database or null if the hotel was unable to be found
     * @throws Exception when trying to connect to database
     */
    public Hotel getHotel(int id) throws Exception {

        //SQL query for Hotels
        String sql = "SELECT h.hotelID, h.hotelChainID, h.rating, h.hotelAddress, numberOfRooms, h.managerID" +
                "                FROM Hotel h," +
                "                LATERAL(" +
                "                SELECT COUNT(*) AS numberOfRooms" +
                "                FROM HotelRoom hR" +
                "                WHERE h.hotelID = hR.hotelID)" +
                "                WHERE h.hotelID = ?;";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        Hotel result = null;


        //List of PhoneNumbers
        HotelPhoneNumberService hPNService = new HotelPhoneNumberService();
        List<HotelPhoneNumber> phoneNumbers = hPNService.getPhoneNumbers();

        //List of EmailAddresses
        HotelEmailAddressService hEAService = new HotelEmailAddressService();
        List<HotelEmailAddress> emailAddress = hEAService.getEmailAddresses();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, id);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the Hotel objects from the result
            while(rs.next()) {

                int hotelID = rs.getInt("hotelID");

                //Create list of PhoneNumbers for Hotel
                List<HotelPhoneNumber> filteredPhoneNumbers = new ArrayList<HotelPhoneNumber>();
                for (HotelPhoneNumber hPN : phoneNumbers) {
                    if (hPN.getPhoneNumberID() == hotelID) {
                        filteredPhoneNumbers.add(hPN);
                    }
                }

                //Create list of emailAddresses for Hotel
                List<HotelEmailAddress> filteredEmailAddresses = new ArrayList<HotelEmailAddress>();
                for (HotelEmailAddress hEA : emailAddress) {
                    if (hEA.getEmailAddressID() == hotelID) {
                        filteredEmailAddresses.add(hEA);
                    }
                }

                //Create new Hotel object
                result = new Hotel(
                        hotelID,
                        rs.getString("hotelChainID"),
                        rs.getInt("rating"),
                        rs.getString("hotelAddress"),
                        rs.getInt("numberOfRooms"),
                        rs.getString("managerID"),
                        filteredPhoneNumbers,
                        filteredEmailAddresses
                );
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return hotel
            return result;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get all Hotels from the database
     *
     * @return list of Hotels from database
     * @throws Exception when trying to connect to database
     */
    public List<Hotel> getHotels() throws Exception {

        //SQL query for Hotels
        String sql = "SELECT h.hotelID, h.hotelChainID, h.rating, h.hotelAddress, numberOfRooms, h.managerID" +
                "                FROM Hotel h," +
                "                LATERAL(" +
                "                SELECT COUNT(*) AS numberOfRooms" +
                "                FROM HotelRoom hR" +
                "                WHERE h.hotelID = hR.hotelID);";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Hotel> hotels = new ArrayList<Hotel>();


        //List of PhoneNumbers
        HotelPhoneNumberService hPNService = new HotelPhoneNumberService();
        List<HotelPhoneNumber> phoneNumbers = hPNService.getPhoneNumbers();

        //List of EmailAddresses
        HotelEmailAddressService hEAService = new HotelEmailAddressService();
        List<HotelEmailAddress> emailAddress = hEAService.getEmailAddresses();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the Hotel objects from the result
            while(rs.next()) {

                int hotelID = rs.getInt("hotelID");

                //Create list of PhoneNumbers for Hotel
                List<HotelPhoneNumber> filteredPhoneNumbers = new ArrayList<HotelPhoneNumber>();
                for (HotelPhoneNumber hPN : phoneNumbers) {
                    if (hPN.getPhoneNumberID() == hotelID) {
                        filteredPhoneNumbers.add(hPN);
                    }
                }

                //Create list of emailAddresses for Hotel
                List<HotelEmailAddress> filteredEmailAddresses = new ArrayList<HotelEmailAddress>();
                for (HotelEmailAddress hEA : emailAddress) {
                    if (hEA.getEmailAddressID() == hotelID) {
                        filteredEmailAddresses.add(hEA);
                    }
                }

                //Create new Hotel object
                Hotel h =  new Hotel(
                        hotelID,
                        rs.getString("hotelChainID"),
                        rs.getInt("rating"),
                        rs.getString("hotelAddress"),
                        rs.getInt("numberOfRooms"),
                        rs.getString("managerID"),
                        filteredPhoneNumbers,
                        filteredEmailAddresses
                );
                hotels.add(h);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return hotels;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get all Hotels with available rooms from the database
     *
     * @param addressFilter string of possible filter
     * @return list of Hotels from database
     * @throws Exception when trying to connect to database
     */
    public List<Hotel> getAvailableHotels(String addressFilter) throws Exception {

        //SQL query
        String sql = "SELECT * FROM hotelsWithAvailableRooms WHERE REGEXP_LIKE( UPPER( REGEXP_SUBSTR( hotelAddress , '[A-z|\\s]+' ) ) , UPPER( ? ) );";


        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Hotel> hotels = new ArrayList<Hotel>();

        //List of PhoneNumbers
        HotelPhoneNumberService hPNService = new HotelPhoneNumberService();
        List<HotelPhoneNumber> phoneNumbers = hPNService.getPhoneNumbers();

        //List of EmailAddresses
        HotelEmailAddressService hEAService = new HotelEmailAddressService();
        List<HotelEmailAddress> emailAddress = hEAService.getEmailAddresses();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, addressFilter);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the Hotel objects from the result
            while(rs.next()) {

                int hotelID = rs.getInt("hotelID");

                //Create list of PhoneNumbers for Hotel
                List<HotelPhoneNumber> filteredPhoneNumbers = new ArrayList<HotelPhoneNumber>();
                for (HotelPhoneNumber hPN : phoneNumbers) {
                    if (hPN.getPhoneNumberID() == hotelID) {
                        filteredPhoneNumbers.add(hPN);
                    }
                }

                //Create list of emailAddresses for Hotel
                List<HotelEmailAddress> filteredEmailAddresses = new ArrayList<HotelEmailAddress>();
                for (HotelEmailAddress hEA : emailAddress) {
                    if (hEA.getEmailAddressID() == hotelID) {
                        filteredEmailAddresses.add(hEA);
                    }
                }

                //Create new Hotel object
                Hotel h =  new Hotel(
                        hotelID,
                        rs.getString("hotelChainID"),
                        rs.getInt("rating"),
                        rs.getString("hotelAddress"),
                        rs.getInt("numberOfAvailableRooms"),
                        rs.getString("managerID"),
                        filteredPhoneNumbers,
                        filteredEmailAddresses
                );
                hotels.add(h);
            }



            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return hotels;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }


    /**
     * Method to get create a Hotel in the database
     *
     * @param Hotel hotel to be created
     * @return String returned that states if the Hotel was created or not
     * @throws Exception when trying to connect to database
     */
    public String createHotel(Hotel hotel) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO Hotel (hotelID, hotelChainID, rating, hotelAddress, managerID)"
                + " VALUES (?, ?, ?, ?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Hotel to console
        System.out.println(hotel);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, hotel.getHotelID());
            st.setString(2, hotel.getHotelChainID());
            st.setInt(3, hotel.getRating());
            st.setString(4, hotel.getHotelAddress());
            st.setString(5, hotel.getManagerID());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting hotel: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a Hotel in the database
     *
     * @param Hotel hotel to be created
     * @return String returned that states if the Hotel was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateHotel(Hotel hotel) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE Hotel "
                + "SET hotelChainID=?, rating=?, hotelAddress=?, managerID=? "
                + "WHERE hotelID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + hotel);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, hotel.getHotelChainID());
            st.setInt(2, hotel.getRating());
            st.setString(3, hotel.getHotelAddress());
            st.setString(4, hotel.getManagerID());
            st.setInt(5, hotel.getHotelID());


            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating hotel: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a Hotel from the database by its hotelID
     *
     * @param id hotelID of the Hotel to delete from the database
     * @return String that states if the Hotel was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteHotel(int id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM Hotel WHERE hotelID = ?";
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
            st.setInt(1, id);

            //Execute query
            st.executeQuery();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while deleting hotel: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel successfully deleted!";
        }

        //Return message
        return message;
    }

}
