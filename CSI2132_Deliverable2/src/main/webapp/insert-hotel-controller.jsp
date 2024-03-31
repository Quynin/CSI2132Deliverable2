<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    String id = request.getParameter("hotel-chain-id");
    int rating = Integer.parseInt(request.getParameter("rating"));
    String address = request.getParameter("address");


    //Get the manager from the sesseion
    //Employee manager = (Employee) request.getSession().getAttribute("createdEmployee");

    HotelService service = new HotelService();
    // create new employee object
    Hotel obj = new Hotel(id, rating, address, null, null, null);

    Message msg;
    // try to create a new hotel
    try {

        String value = service.createHotel(obj);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotel was successfully created
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
    response.sendRedirect("employee-hotels.jsp");
%>