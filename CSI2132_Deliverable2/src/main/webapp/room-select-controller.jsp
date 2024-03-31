<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // get customer info from the request
    int id = Integer.parseInt(request.getParameter("hotelroomid"));

    HotelRoomService hotelRoomService = new HotelRoomService();
    HotelRoom hotelRoom = hotelRoomService.getHotelRoom(id);

     // check where to redirect
     try {
         request.getSession().setAttribute("selectedRoom", hotelRoom);
         response.sendRedirect("booking-information.jsp");
     } catch (Exception e) {
         e.printStackTrace();
     }
%>