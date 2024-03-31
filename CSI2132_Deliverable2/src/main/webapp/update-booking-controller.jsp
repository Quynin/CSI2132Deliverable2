<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.BookingService" %>
<%@ page import="com.CSI2132Deliverable2.Booking" %>
<%@ page import="com.CSI2132Deliverable2.BookingStatus" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.List" %>
<%
    // get booking info from the request
    int bID = Integer.parseInt(request.getParameter("bID"));
    int rID = Integer.parseInt(request.getParameter("rID"));
    String cID = request.getParameter("cID");
    // Get dates
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    Date startDate = formatter.parse(request.getParameter("startDate"));
    Date endDate = formatter.parse(request.getParameter("endDate"));

    double bookingCost = Double.parseDouble(request.getParameter("cost"));

    BookingStatus status = null;
    if (request.getParameter("bookingStatus").toLowerCase().equals("booking")) {
        status = BookingStatus.RENTING;
    } else {
        status = BookingStatus.ARCHIVED;
    }

    String paymentMethod = request.getParameter("paymentMethod");
    boolean isPaid = Boolean.parseBoolean(request.getParameter("isPaid"));


    BookingService service = new BookingService();

    // create booking object
    Booking obj = new Booking(bID, rID, cID, startDate, endDate, bookingCost, status, paymentMethod, isPaid);
    Message msg;
    // try to update a customer
    try {
        String value = service.updateBooking(obj);
        System.out.println(value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the booking was successfully updated
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
    // redirect to bookings page
    response.sendRedirect("employee-bookings.jsp");
%>