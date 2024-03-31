<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelEmailAddressService" %>
<%@ page import="com.CSI2132Deliverable2.HotelEmailAddress" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    int id = Integer.parseInt(request.getParameter("emailAddressIDToInsert"));
    String string = request.getParameter("emailAddressStringToInsert");

    HotelEmailAddressService service = new HotelEmailAddressService();
    // create new email address object
    HotelEmailAddress obj = new HotelEmailAddress(id, string);

    Message msg;
    // try to create a new email address
    try {

        String value = service.createEmailAddress(obj);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the emailaddress was successfully created
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
    response.sendRedirect("employee-hotels.jsp");
%>