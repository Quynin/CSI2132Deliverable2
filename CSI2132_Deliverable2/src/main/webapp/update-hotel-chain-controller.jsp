<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.HotelChainService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChain" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddress" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // get hotel info from the request
    String hotelChainID = request.getParameter("hotelChainID");
    String address = request.getParameter("addressOfCentralOffices");
    String oldID = request.getParameter("oldID");
    System.out.println("NEWID:"+hotelChainID +"\nOLDID:" + oldID);

    HotelChainService hs = new HotelChainService();

    // create hotelChain object
    //phoneNumberList and emailAddressList are not used in the HotelService method and can be left null
    HotelChain obj = new HotelChain(hotelChainID, address, -1, null, null);

    Message msg;
    // try to update a hotelChain
    try {
        String value = hs.updateHotelChain(obj, oldID);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the hotelChain was successfully updated
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
    response.sendRedirect("employee-hotel-chains.jsp");
%>