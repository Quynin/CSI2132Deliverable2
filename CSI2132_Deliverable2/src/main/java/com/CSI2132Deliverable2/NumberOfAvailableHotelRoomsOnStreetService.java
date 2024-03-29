package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;


public class NumberOfAvailableHotelRoomsOnStreetService {

    /*
     * METHODS
     */

    /**
     * Method to get all NumberOfAvailableHotelRoomOnStreet from the database
     *
     * @return list of NumberOfAvailableHotelRoomOnStreet from database
     * @throws Exception when trying to connect to database
     */
    public List<NumberOfAvailableHotelRoomsOnStreet> getNumberOfAvailableHotelRoomOnStreet() throws Exception {

        //SQL query
        String sql = "SELECT * FROM numberOfAvailableHotelRoomsOnSameStreet";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<NumberOfAvailableHotelRoomsOnStreet> availableHotelRoomsOnStreets = new ArrayList<NumberOfAvailableHotelRoomsOnStreet>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the Booking objects from the result
            while(rs.next()) {
                //Create new Booking object
                NumberOfAvailableHotelRoomsOnStreet nOAHROS =  new NumberOfAvailableHotelRoomsOnStreet(
                        rs.getString("area"),
                        rs.getInt("numberOfAvailableRooms")
                );
                availableHotelRoomsOnStreets.add(nOAHROS);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return availableHotelRoomsOnStreets;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }
}