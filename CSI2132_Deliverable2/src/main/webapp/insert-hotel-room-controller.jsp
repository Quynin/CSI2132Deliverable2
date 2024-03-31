<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    Double price = Double.parseDouble(request.getParameter("price"));
    String amenities = request.getParameter("amenities");
    int capacityOfRoom = Integer.parseInt(request.getParameter("capacity-of-room"));
    String viewFromRoom = request.getParameter("view-from-room");
    boolean isExtendable = Boolean.valueOf(request.getParameter("is-extendable"));
    String problemsOrDamages = request.getParameter("problems-or-damages");


    //Get the employee from the sesseion
    Employee currentEmployee = (Employee) request.getSession().getAttribute("createdEmployee");

    HotelRoomService hotelRoomService = new HotelRoomService();
    // create new hotel room object
    HotelRoom hotelRoom = new HotelRoom(currentEmployee.getHotelID(), price, amenities, capacityOfRoom, viewFromRoom, isExtendable, problemsOrDamages);

    Message msg;
    // try to create a new hotel room
    try {

        String value = hotelRoomService.createHotelRoom(hotelRoom);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the customer was successfully created
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
    response.sendRedirect("employee-hotel-rooms.jsp");
%>