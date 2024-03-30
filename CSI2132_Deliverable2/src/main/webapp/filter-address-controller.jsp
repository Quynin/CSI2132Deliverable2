<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // get customer info from the request
    String filter = request.getParameter("address");


    HotelService hotelService = new HotelService();
    List<Hotel> availableHotels = hotelService.getAvailableHotels(filter);

    System.out.println("Filter: " + filter);

     // check where to redirect
     try {
         request.getSession().setAttribute("filteredHotels", availableHotels);
         response.sendRedirect("customer-homepage.jsp");
     } catch (Exception e) {
         e.printStackTrace();
     }
%>
