<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddressService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumberService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChain" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddress" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>


<%
    ArrayList<Message> messages;

    // get any incoming messages from session attribute named messages
    // if nothing exists then messages is an empty arraylist
    if ((ArrayList<Message>) session.getAttribute("messages") == null) messages = new ArrayList<>();
        // else get that value
    else messages = (ArrayList<Message>) session.getAttribute("messages");

    String msgField = "";

    // create the object in the form of a stringified json
    for (Message m : messages) {
        msgField += "{\"type\":\"" + m.type + "\",\"value\":\"" + m.value.replaceAll("['\"]+", "") + "\"},";
    }

    // empty session messages
    session.setAttribute("messages", new ArrayList<Message>());

    // get all hotel chains from database
    HotelChainService hotelChainService = new HotelChainService();
    List<HotelChain> hotelChains = null;
    try {
        hotelChains = hotelChainService.getHotelChains();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

