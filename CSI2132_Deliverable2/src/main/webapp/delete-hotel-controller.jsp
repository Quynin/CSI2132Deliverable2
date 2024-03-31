<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    // get the id that was sent
    int id = Integer.parseInt(request.getParameter("id"));

    // create a message object
    Message msg;
    // try to delete an hotel
    try {
        HotelService hs = new HotelService();
        // save the message returned from trying to delete an hotel
        String value = hs.deleteHotel(id);
        // in case the value contains error/Error then this message is an error
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotel was successfully deleted
        else msg = new Message("success", value);
    } catch (Exception e) {
        e.printStackTrace();
        msg = new Message("error", "Something went wrong!" + e.getMessage());
    }

    // append the message in a messages arraylist
    ArrayList<Message> messages = new ArrayList<>();
    messages.add(msg);

    // set session attribute named messages with the messages arraylist
    session.setAttribute("messages", messages);
    // redirect to employee-hotels
    response.sendRedirect("employee-hotels.jsp");
%>