<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    // get the id that was sent
    int roomID = Integer.parseInt(request.getParameter("room-id"));
    int hotelID = Integer.parseInt(request.getParameter("hotel-id"));

    // create a message object
    Message msg;
    // try to delete a hotel room
    try {
        HotelRoomService hotelRoomService = new HotelRoomService();
        // save the message returned from trying to delete an employee
        String value = hotelRoomService.deleteHotelRoom(roomID, hotelID);
        // in case the value contains error/Error then this message is an error
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the employee was successfully deleted
        else msg = new Message("success", value);
    } catch (Exception e) {
        e.printStackTrace();
        msg = new Message("error", "Something went wrong!");
    }

    // append the message in a messages arraylist
    ArrayList<Message> messages = new ArrayList<>();
    messages.add(msg);

    // set session attribute named messages with the messages arraylist
    session.setAttribute("messages", messages);
    // redirect to employees
    response.sendRedirect("employee-hotel-rooms.jsp");
%>