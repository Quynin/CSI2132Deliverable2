package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;


public class BookingService {

    /*
     * METHODS
     */

    /**
     * Method to get all Bookings from the database
     *
     * @return list of Bookings from database
     * @throws Exception when trying to connect to database
     */
    public List<Booking> getBookings() throws Exception {

        //SQL query
        String sql = "SELECT * FROM Booking";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Booking> bookings = new ArrayList<Booking>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the Booking objects from the result
            while(rs.next()) {
                //Create new Booking object
                Booking b =  new Booking(
                        rs.getInt("bookingID"),
                        rs.getInt("roomID"),
                        rs.getString("customerID"),
                        //If the below methods do not work, try: new java.util.Date(rs.getDate("startDate").getTime())
                        rs.getDate("startDate"),
                        rs.getDate("endDate"),
                        rs.getDouble("cost"),
                        BookingStatus.valueOf(rs.getString("bookingStatus").toUpperCase()),
                        rs.getString("PaymentMethod"),
                        rs.getBoolean("isPaid")
                );
                bookings.add(b);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return bookings;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a Booking in the database
     *
     * @param Booking booking to be created
     * @return String returned that states if the Booking was created or not
     * @throws Exception when trying to connect to database
     */
    public String createBooking(Booking booking) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO Booking (roomID, customerID, startDate, endDate, bookingCost, bookingStatus, paymentMethod, isPaid)"
                        + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println(booking);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, booking.getRoomID());
            st.setString(2, booking.getCustomerID());
            st.setDate(3, new java.sql.Date(booking.getStartDate().getTime()));
            st.setDate(4, new java.sql.Date(booking.getEndDate().getTime()));
            st.setDouble(5, booking.getCost());
            st.setString(6, booking.getBookingStatus().name());
            st.setString(7, booking.getPaymentMethod());
            st.setBoolean(8, booking.getIsPaid());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting booking: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Booking successfully inserted!";
        }
        System.out.println(message);

        //Return message
        return message;
    }

    /**
     * Method to get update a Booking in the database
     *
     * @param Booking booking to be created
     * @return String returned that states if the Booking was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateBooking(Booking booking) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE Booking "
                        + "SET roomID=?, customerID=?, startDate=?, endDate=?, cost=?, bookingStatus=?, paymentMethod=?, isPaid=? "
                        + "WHERE bookingID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + booking);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, booking.getRoomID());
            st.setString(2, booking.getCustomerID());
            st.setDate(3, new java.sql.Date(booking.getStartDate().getTime()));
            st.setDate(4, new java.sql.Date(booking.getEndDate().getTime()));
            st.setDouble(5, booking.getCost());
            st.setString(6, booking.getBookingStatus().name());
            st.setString(7,booking.getPaymentMethod());
            st.setBoolean(8, booking.getIsPaid());
            st.setInt(9, booking.getBookingID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating booking: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Booking successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a Booking from the database by its bookingID
     *
     * @param id bookingID of the Booking to delete from the database
     * @return String that states if the Booking was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteBooking(int id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM Booking WHERE bookingID = ?";
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
            message = "Error while deleting booking: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Booking successfully deleted!";
        }

        //Return message
        return message;
    }

}