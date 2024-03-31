<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelChainService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChain" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    String id = request.getParameter("hotel-chain-id");
    String address = request.getParameter("addressOfCentralOffices");


    //Get the manager from the session
    //Employee manager = (Employee) request.getSession().getAttribute("createdEmployee");

    HotelChainService service = new HotelChainService();
    // create new employee object
    HotelChain obj = new HotelChain(id, address, -1, null, null);

    Message msg;
    // try to create a new hotel
    try {

        String value = service.createHotelChain(obj);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotel chain was successfully created
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
    response.sendRedirect("employee-hotel-chains.jsp");
%>