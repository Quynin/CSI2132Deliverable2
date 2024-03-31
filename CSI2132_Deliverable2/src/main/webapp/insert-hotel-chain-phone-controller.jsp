<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumberService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    String id = request.getParameter("phoneNumberIDToInsert");
    String string = request.getParameter("phoneNumberStringToInsert");

    HotelChainPhoneNumberService service = new HotelChainPhoneNumberService();
    // create new phone number object
    HotelChainPhoneNumber obj = new HotelChainPhoneNumber(id, string);

    Message msg;
    // try to create a new phone number
    try {

        String value = service.createPhoneNumber(obj);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the phonenumber was successfully created
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