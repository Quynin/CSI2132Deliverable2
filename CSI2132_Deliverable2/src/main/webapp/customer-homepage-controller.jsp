<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@page import="com.CSI2132Deliverable2.Hotel" %>
<%@page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // get customer info from the request
    int id = Integer.parseInt(request.getParameter("hotelid"));
    System.out.println(request.getParameter("hotelid"));

    HotelService hotelService = new HotelService();
    Hotel hotel = hotelService.getHotel(id);

     // check where to redirect
     try {
         request.getSession().setAttribute("sendHotelToRoomPage", hotel);
         response.sendRedirect("room-select.jsp");
     } catch (Exception e) {
         e.printStackTrace();
     }
%>