<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get hotel room info from the request
    int roomid = Integer.parseInt(request.getParameter("room-id"));
    int hotelid = Integer.parseInt(request.getParameter("hotel-id"));
    Double price = Double.parseDouble(request.getParameter("price"));
    String amenities = request.getParameter("amenities");
    int capacityOfRoom = Integer.parseInt(request.getParameter("capacity-of-room"));
    String viewFromRoom = request.getParameter("view-from-room");
    boolean isExtendable = Boolean.valueOf(request.getParameter("is-extendable"));
    String problemsOrDamages = request.getParameter("problems-or-damages");

    HotelRoomService hotelRoomService = new HotelRoomService();

    // create hotel room object
    HotelRoom hotelRoom = new HotelRoom(roomid, hotelid, price, amenities, capacityOfRoom, viewFromRoom, isExtendable, problemsOrDamages);

    Message msg;
    // try to update a hotel room
    try {
        String value = hotelRoomService.updateHotelRoom(hotelRoom);
        System.out.println("HERE IS EMPLOYEE UPDATE VALUE: " +  value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotel room was successfully updated
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
    response.sendRedirect("employee-hotel-rooms.jsp");
%>