<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelEmailAddressService" %>
<%@ page import="com.CSI2132Deliverable2.HotelEmailAddress" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get email address info from the request
    int emailAddressID = Integer.parseInt(request.getParameter("emailAddressID"));
    String emailAddressString = request.getParameter("emailAddressString");

    HotelEmailAddressService service = new HotelEmailAddressService();

    // create HotelEmailAddress object
    HotelEmailAddress obj = new HotelEmailAddress(emailAddressID, emailAddressString);

    Message msg;
    // try to delete a hotelEmailAddress
    try {
        String value = service.deleteEmailAddress(obj);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the email address was successfully deleted
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