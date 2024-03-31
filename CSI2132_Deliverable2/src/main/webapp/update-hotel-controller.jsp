<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="com.CSI2132Deliverable2.HotelPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.HotelEmailAddress" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get hotel info from the request
    int hotelID = Integer.parseInt(request.getParameter("hotelID"));
    String hotelChainID = request.getParameter("hotelChainID");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String hotelAddress = request.getParameter("hotelAddress");
    int numberOfRooms = Integer.parseInt(request.getParameter("numberOfRooms"));
    String managerID = request.getParameter("managerID");

    HotelService hs = new HotelService();

    //Dummy variables to make constructor accept values
    List<HotelPhoneNumber> null1 = null;
    List<HotelEmailAddress> null2 = null;

    // create hotel object
    //phoneNumberList and emailAddressList are not used in the HotelService method and can be left null
    Hotel h = new Hotel(hotelID, hotelChainID, rating, hotelAddress, numberOfRooms, managerID, null1, null2);

    Message msg;
    // try to update a hotel
    try {
        String value = hs.updateHotel(h);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotel was successfully updated
        else msg = new Message("success", value);
    } catch (Exception e) {
        e.printStackTrace();
        msg = new Message("error", "Something went wrong!");
    }

    // create an arraylist of messages and append the new message
    ArrayList<Message> messages = new ArrayList<>();
    messages.add(msg);

    // set session attribute named messages to messages value
    session.setAttribute("messages", messages);
    // redirect to employee-hotels page
    response.sendRedirect("employee-hotels.jsp");
%>