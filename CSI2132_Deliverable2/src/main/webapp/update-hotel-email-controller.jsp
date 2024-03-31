<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelEmailAddressService" %>
<%@ page import="com.CSI2132Deliverable2.HotelEmailAddress" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get email address info from the request
    System.out.println("EMAIL: " + request.getParameter("emailAddressID"));
    System.out.println("HOTEL?: " + request.getParameter("emailAddressID"));
    int emailAddressID = Integer.parseInt(request.getParameter("emailAddressID"));
    String emailAddressString = request.getParameter("emailAddressString");
    String oldEmailAddress = request.getParameter("oldEmailAddress");

    HotelEmailAddressService service = new HotelEmailAddressService();

    // create HotelEmailAddress object
    HotelEmailAddress obj = new HotelEmailAddress(emailAddressID, emailAddressString);

    Message msg;
    // try to update a hotelEmailAddress
    try {
        String value = service.updateEmailAddress(obj, oldEmailAddress);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the email address  was successfully updated
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