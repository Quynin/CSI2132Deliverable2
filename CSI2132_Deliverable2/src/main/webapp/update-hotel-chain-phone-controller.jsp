<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumberService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get phone number info from the request
    String phoneNumberID = request.getParameter("phoneNumberID");
    String phoneNumberString = request.getParameter("phoneNumberString");
    String oldPhoneNumber = request.getParameter("oldPhoneNumber");

    HotelChainPhoneNumberService service = new HotelChainPhoneNumberService();

    // create HotelChainPhoneNumber object
    HotelChainPhoneNumber obj = new HotelChainPhoneNumber(phoneNumberID, phoneNumberString);

    Message msg;
    // try to update a hotelChainPhoneNumber
    try {
        String value = service.updatePhoneNumber(obj, oldPhoneNumber);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the phone number was successfully updated
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
    // redirect to employee-hotel-chains page
    response.sendRedirect("employee-hotel-chains.jsp");
%>