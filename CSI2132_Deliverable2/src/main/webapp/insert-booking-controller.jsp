<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.CustomerService" %>
<%@ page import="com.CSI2132Deliverable2.Customer" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.BookingService" %>
<%@ page import="com.CSI2132Deliverable2.Booking" %>
<%@ page import="com.CSI2132Deliverable2.BookingStatus" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.List" %>
<%

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    Date startDate, endDate;

    startDate = formatter.parse(request.getParameter("startDate"));
    endDate = formatter.parse(request.getParameter("endDate"));
    String paymentMethod = request.getParameter("paymentMethod");


    //get saved attributes
    int rID = Integer.parseInt(request.getParameter("rID"));
    String cID = request.getParameter("cID");
    //HotelRoom hotelRoom = (HotelRoom) request.getSession().getAttribute("selectedRoom");

    double cost = Double.parseDouble(request.getParameter("cost"));

    boolean isPaid = true;

    BookingStatus bookingStatus = BookingStatus.RENTING;
    BookingService bookingService = new BookingService();

    // create booking object
    Booking booking = new Booking(rID, cID, startDate, endDate, cost, bookingStatus, paymentMethod, isPaid);

    Message msg;
    // try to create a new booking
    try {

        String value = bookingService.createBooking(booking);
        System.out.println(value);

        //if the value contains duplicate key then this is an error message
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the customer was successfully created
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
    //request.getSession().setAttribute("createdBooking", booking);
    response.sendRedirect("employee-bookings.jsp");
%>