package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class HotelRoomService {

    /*
     * METHODS
     */

    /**
     * Method to get queried HotelRoom from the database
     *
     * @param id the id of the HotelRoom to be found
     * @return queried HotelRoom from database or null if the hotel room was unable to be found
     * @throws Exception when trying to connect to database
     */
    public HotelRoom getHotelRoom(int roomID) throws Exception {

        //SQL query
        String sql = "SELECT * FROM HotelRoom WHERE roomID=?";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        HotelRoom result = null;

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, roomID);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the HotelRoom objects from the result
            while(rs.next()) {
                //Create new HotelRoom object
                result =  new HotelRoom(
                        rs.getInt("roomID"),
                        rs.getInt("hotelID"),
                        rs.getDouble("price"),
                        rs.getString("amenities"),
                        rs.getInt("capacityOfRoom"),
                        rs.getString("viewFromRoom"),
                        rs.getBoolean("isExtendable"),
                        rs.getString("problemsOrDamages")
                );

            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return result;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get all HotelRooms from the database
     *
     * @return list of HotelRooms from database
     * @throws Exception when trying to connect to database
     */
    public List<HotelRoom> getHotelRooms() throws Exception {

        //SQL query
        String sql = "SELECT * FROM HotelRoom";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<HotelRoom> hotelRooms = new ArrayList<HotelRoom>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the HotelRoom objects from the result
            while(rs.next()) {
                //Create new HotelRoom object
                HotelRoom hR =  new HotelRoom(
                        rs.getInt("roomID"),
                        rs.getInt("hotelID"),
                        rs.getDouble("price"),
                        rs.getString("amenities"),
                        rs.getInt("capacityOfRoom"),
                        rs.getString("viewFromRoom"),
                        rs.getBoolean("isExtendable"),
                        rs.getString("problemsOrDamages")
                );
                hotelRooms.add(hR);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return hotelRooms;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get all available (no associated bookings in "Booking" or "Renting")
     * HotelRooms of a Hotel from the database
     *
     * @param hotelID id of the hotel to find available rooms of
     * @return list of HotelRooms from database
     * @throws Exception when trying to connect to database
     */
    public List<HotelRoom> getAvailableRoomsOfHotel(int hotelID) throws Exception {

        //SQL query
        String sql = "SELECT * " +
                "FROM HotelRoom " +
                "WHERE hotelID=? " +
                "AND roomID NOT IN( " +
                "SELECT roomID " +
                "FROM Booking " +
                "WHERE Booking.bookingStatus != 'ARCHIVED' " +
                ");";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<HotelRoom> hotelRooms = new ArrayList<HotelRoom>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, hotelID);

            //Execute query
            ResultSet rs =  st.executeQuery();

            //Create all the HotelRoom objects from the result
            while(rs.next()) {
                //Create new HotelRoom object
                HotelRoom hR =  new HotelRoom(
                        rs.getInt("roomID"),
                        rs.getInt("hotelID"),
                        rs.getDouble("price"),
                        rs.getString("amenities"),
                        rs.getInt("capacityOfRoom"),
                        rs.getString("viewFromRoom"),
                        rs.getBoolean("isExtendable"),
                        rs.getString("problemsOrDamages")
                );
                hotelRooms.add(hR);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return hotelRooms;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a HotelRoom in the database
     *
     * @param HotelRoom HotelRoom to be created
     * @return String returned that states if the HotelRoom was created or not
     * @throws Exception when trying to connect to database
     */
    public String createHotelRoom(HotelRoom hotelRoom) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO HotelRoom (hotelID, price, amenities, capacityOfRoom, viewFromRoom, isExtendable, problemsOrDamages)"
                + " VALUES (?, ?, ?, ?, ?, ?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print HotelRoom to console
        System.out.println(hotelRoom);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setInt(1, hotelRoom.getHotelID());
            st.setDouble(2, hotelRoom.getPrice());
            st.setString(3, hotelRoom.getAmenities());
            st.setInt(4, hotelRoom.getCapacityOfRoom());
            st.setString(5, hotelRoom.getViewFromRoom());
            st.setBoolean(6, hotelRoom.getIsExtendable());
            st.setString(7, hotelRoom.getProblemsOrDamages());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting hotel room: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel room successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a HotelRoom in the database
     *
     * @param HotelRoom HotelRoom to be created
     * @return String returned that states if the HotelRoom was created or not
     * @throws Exception when trying to connect to database
     */
    public String updateHotelRoom(HotelRoom hotelRoom) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE HotelRoom "
                + "SET price=?, amenities=?, capacityOfRoom=?, viewFromRoom=?, isExtendable=?, problemsOrDamages=? "
                + "WHERE roomID=? AND hotelID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + hotelRoom);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setDouble(1, hotelRoom.getPrice());
            st.setString(2, hotelRoom.getAmenities());
            st.setInt(3, hotelRoom.getCapacityOfRoom());
            st.setString(4, hotelRoom.getViewFromRoom());
            st.setBoolean(5, hotelRoom.getIsExtendable());
            st.setString(6, hotelRoom.getProblemsOrDamages());
            st.setInt(7, hotelRoom.getRoomID());
            st.setInt(8, hotelRoom.getHotelID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating hotel room: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel room successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a HotelRoom from the database by its roomID and hotelID
     *
     * @param riD roomID of the HotelRoom to delete from the database
     * @param hID hotelID of the HotelRoom to delete from the database
     * @return String that states if the HotelRoom was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deleteHotelRoom(int rID, int hID) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM HotelRoom WHERE roomID = ? AND hotelID = ?";
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
            st.setInt(1, rID);
            st.setInt(2, hID);

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while deleting hotel room: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Hotel room successfully deleted!";
        }

        //Return message
        return message;
    }
}
