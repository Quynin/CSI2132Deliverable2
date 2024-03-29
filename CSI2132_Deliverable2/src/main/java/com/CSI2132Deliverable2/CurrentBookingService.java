package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;


public class CurrentBookingService {

    /*
     * METHODS
     */

    /**
     * Method to get all CurrentBookings of a customer from the database
     *
     * @param id String id of the customer
     * @return list of CurrentBookings of a customer from database
     * @throws Exception when trying to connect to database
     */
    public List<CurrentBooking> getCurrentBookings(String id) throws Exception {

        //SQL query
        String sql = "SELECT "
                    + "h.hotelChainID, h.hotelAddress, bR.bookingID, bR.roomID, bR.startDate, bR.endDate, bR.bookingCost, bR.bookingStatus, bR.paymentMethod, bR.isPaid, bR.amenities, bR.viewFromRoom, bR.problemsOrDamages "
                    + "FROM (SELECT b.bookingID, b.roomID, b.customerID, b.startDate, b.endDate, b.bookingCost, b.bookingStatus, b.paymentMethod, b.isPaid, hR.hotelID, hR.amenities, hR.viewFromRoom, hR.problemsOrDamages "
                    + "FROM Booking b JOIN HotelRoom hR ON b.roomID = hR.roomID "
                    + "WHERE customerID =? "
                    + ") AS bR "
                    + "JOIN Hotel h ON bR.hotelID = h.hotelID;";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<CurrentBooking> currentBookings = new ArrayList<CurrentBooking>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, id);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the Booking objects from the result
            while(rs.next()) {
                //Create new Booking object
                CurrentBooking cB =  new CurrentBooking(
                        rs.getString("hotelChainID") + " on " + rs.getString("hotelAddress"),
                        rs.getInt("bookingID"),
                        rs.getInt("roomID"),
                        //If the below methods do not work, try: new java.util.Date(rs.getDate("startDate").getTime())
                        rs.getDate("startDate"),
                        rs.getDate("endDate"),
                        rs.getDouble("cost"),
                        BookingStatus.valueOf(rs.getString("bookingStatus")),
                        rs.getString("PaymentMethod"),
                        rs.getBoolean("isPaid"),
                        rs.getString("amenities"),
                        rs.getString("viewFromRoom"),
                        rs.getString("problemsOrDamages")
                );
                currentBookings.add(cB);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return currentBookings;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }
}