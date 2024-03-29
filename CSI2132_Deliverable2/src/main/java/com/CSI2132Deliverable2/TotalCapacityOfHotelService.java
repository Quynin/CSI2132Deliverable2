package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;


public class TotalCapacityOfHotelService {

    /*
     * METHODS
     */

    /**
     * Method to get all TotalCapacityOfHotel from the database
     *
     * @return list of TotalCapacityOfHotel from database
     * @throws Exception when trying to connect to database
     */
    public List<TotalCapacityOfHotel> getTotalCapacitiesOfHotel() throws Exception {

        //SQL query
        String sql = "SELECT * FROM totalCapacityOfHotels";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<TotalCapacityOfHotel> totalCapacities = new ArrayList<TotalCapacityOfHotel>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the Booking objects from the result
            while(rs.next()) {
                //Create new Booking object
                TotalCapacityOfHotel tCOH =  new TotalCapacityOfHotel(
                        rs.getInt("hotelID"),
                        rs.getString("hotelChainID"),
                        rs.getString("hotelAddress"),
                        rs.getInt("hotelCapacity")
                );
                totalCapacities.add(tCOH);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return totalCapacities;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }
}