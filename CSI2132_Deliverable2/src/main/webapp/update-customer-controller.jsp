<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.CustomerService" %>
<%@ page import="com.CSI2132Deliverable2.Customer" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.List" %>
<%
    // get customer info from the request
    String id = request.getParameter("id");
    String idType = request.getParameter("idType");

    String name = request.getParameter("name");
    String address = request.getParameter("address");

    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

    Date registrationDate;


    System.out.println(request.getParameter("registrationDate"));
    registrationDate = formatter.parse(request.getParameter("registrationDate"));


    CustomerService customerService = new CustomerService();

    // create customer object
    Customer customer = new Customer(id, idType, name, address, registrationDate);
    Message msg;
    // try to update a customer
    try {
        String value = customerService.updateCustomer(customer);
        System.out.println(value);
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
    // redirect to customers page
    response.sendRedirect("customers.jsp");
%>