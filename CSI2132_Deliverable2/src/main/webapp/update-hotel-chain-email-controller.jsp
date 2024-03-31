<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddressService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddress" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get email address info from the request
    System.out.println("EMAIL: " + request.getParameter("emailAddressID"));
    System.out.println("HOTELChain?: " + request.getParameter("emailAddressID"));
    String emailAddressID = request.getParameter("emailAddressID");
    String emailAddressString = request.getParameter("emailAddressString");
    String oldEmailAddress = request.getParameter("oldEmailAddress");

    HotelChainEmailAddressService service = new HotelChainEmailAddressService();

    // create HotelChainEmailAddress object
    HotelChainEmailAddress obj = new HotelChainEmailAddress(emailAddressID, emailAddressString);

    Message msg;
    // try to update a hotelChainEmailAddress
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
    // redirect to employee-hotel-chains page
    response.sendRedirect("employee-hotel-chains.jsp");
%>