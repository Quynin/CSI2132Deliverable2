package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class HotelChainService {

    /*
     * METHODS
     */

    /**
     * Method to get all HotelChains from the database
     *
     * @return list of HotelChains from database
     * @throws Exception when trying to connect to database
     */
    public List<HotelChain> getHotelChains() throws Exception {

        //SQL query
        String sql = "SELECT hC.hotelChainID, hC.addressOfCentralOffices, numberOfHotels\n" +
                "FROM HotelChain hC,\n" +
                "LATERAL(\n" +
                "\tSELECT COUNT(*) AS numberOfHotels\n" +
                "\tFROM Hotel h\n" +
                "\tWHERE hC.hotelChainID = h.hotelChainID);";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<HotelChain> hotelChains = new ArrayList<HotelChain>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the HotelChain objects from the result
            while(rs.next()) {
                //Create new HotelChain object
                HotelChain hC =  new HotelChain(
                        rs.getString("hotelChainID"),
                        rs.getString("addressOfCentralOffices"),
                        rs.getInt("numberOfHotels")
                );
                hotelChains.add(hC);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return hotelChains;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a HotelChain in the database
     *
     * @param HotelChain hotelChain to be created
     * @return String returned that states if the HotelChain was created or not
     * @throws Exception when trying to connect to database
     */
    public String createHotelChain(HotelChain hotelChain) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO HotelChain (hotelChainID, addressOfCentralOffices)"
                + " VALUES (?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print HotelChain to console
        System.out.println(hotelChain);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, hotelChain.getHotelChainID());
            st.setString(2, hotelChain.getAddressOfCentralOffices());


            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting hotel chain: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel chain successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a HotelChain in the database
     *
     * @param HotelChain hotel chain to be created
     * @return String returned that states if the HotelChain was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateHotelChain(HotelChain hotelChain) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE HotelChain "
                + "SET addressOfCentralOffices=? "
                + "WHERE hotelChainID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + hotelChain);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, hotelChain.getAddressOfCentralOffices());
            st.setString(2, hotelChain.getHotelChainID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating hotel chain: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel chain successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a HotelChain from the database by its hotelChainID
     *
     * @param id hotelChainID of the HotelChain to delete from the database
     * @return String that states if the HotelChain was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteHotelChain(String id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM HotelChain WHERE hotelChainID = ?";
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
            message = "Error while deleting hotel chain: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel chain successfully deleted!";
        }

        //Return message
        return message;
    }
}
