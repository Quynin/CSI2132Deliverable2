package com.CSI2132Deliverable2;

import java.util.ArrayList;
import java.util.List;
import java.sql.*;

public class PersonService {

    /*
     * METHODS
     */

    /**
     * Method to get all Persons from the database
     *
     * @return list of Persons from database
     * @throws Exception when trying to connect to database
     */
    public List<Person> getPersons() throws Exception {

        //SQL query
        String sql = "SELECT * FROM Person";
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //Data structure to return all objects generated from database
        List<Person> persons = new ArrayList<Person>();

        //Try to connect to the database; catch any exceptions
        try (Connection con = db.getConnection()) {

            //Create result set
            Statement st = con.createStatement();
            ResultSet rs =  st.executeQuery(sql);

            //Create all the Person objects from the result
            while(rs.next()) {
                //Create new Person object
                Person p =  new Person(
                        rs.getString("personID"),
                        rs.getString("personIDType"),
                        rs.getString("personFullName"),
                        rs.getString("personAddress")
                );
                persons.add(p);
            }

            //Close the result set
            rs.close();
            //Close the statement
            st.close();
            con.close();
            db.close();

            //Return constructed list
            return persons;

        } catch (Exception e) {
            //Throw the error that occurred
            throw new Exception(e.getMessage());
        }

    }

    /**
     * Method to get create a Person in the database
     *
     * @param Person person to be created
     * @return String returned that states if the Person was created or not
     * @throws Exception when trying to connect to database
     */
    public String createPerson(Person person) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "INSERT INTO Person (personID, personIDType, personFullName, personAddress)"
                + " VALUES (?, ?, ?, ?)";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Person to console
        System.out.println(person);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, person.getID());
            st.setString(2, person.getIDType());
            st.setString(3, person.getFullName());
            st.setString(4, person.getAddress());

            //Execute query
            int output = st.executeUpdate();
            System.out.println("Insert: " + output);

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while inserting person: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Person successfully inserted!";
        }

        //Return message
        return message;
    }

    /**
     * Method to get update a Person in the database
     *
     * @param Person person to be created
     * @return String returned that states if the Person was created or not
     * @throws Exception when trying to connect to database
     */
    public String updatePerson(Person person) throws Exception {

        //SQL query with placeholder of all attributes
        String sql = "UPDATE Person "
                + "SET personIDType=?, personFullName=?, personAddress=? "
                + "WHERE personID=?";
        //Connection to database
        Connection con = null;
        //Database connection object
        ConnectionDB db = new ConnectionDB();
        //String to return
        String message = "";

        //Print Booking to console
        System.out.println("Update: " + person);

        //Try to connect to the database; catch any exceptions
        try {
            con = db.getConnection();

            //Prepare statement
            PreparedStatement st = con.prepareStatement(sql);

            //Fill placeholders ? of statement
            st.setString(1, person.getIDType());
            st.setString(2, person.getFullName());
            st.setString(3, person.getAddress());
            st.setString(4, person.getID());

            //Execute query
            st.executeUpdate();

            //Close the statement
            st.close();
            //Close the connection
            db.close();

        } catch (Exception e) {
            //Update the message if there was an error
            message = "Error while updating person: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Person successfully updated!";
        }

        //Return message
        return message;
    }

    /**
     * Method to delete a Person from the database by its personID
     *
     * @param id personID of the Person to delete from the database
     * @return String that states if the Person was deleted or not
     * @throws Exception when trying to connect to database
     */
    public String deletePerson(String id) throws Exception {

        //SQL query with placeholder id
        String sql = "DELETE FROM Person WHERE personID = ?";
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
            message = "Error while deleting person: " + e.getMessage();
        } finally {
            //Close con if it is still open
            if (con != null) con.close();
            //Update the message if delete was successful
            if (message.equals("")) message = "Person successfully deleted!";
        }

        //Return message
        return message;
    }

}
