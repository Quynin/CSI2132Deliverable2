<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>

<%
    String id = request.getParameter("id");
    String idType = request.getParameter("id-type");
    String name = request.getParameter("full-name");
    String address = request.getParameter("address");
    String role = request.getParameter("role");


    //Get the manager from the sesseion
    Employee manager = (Employee) request.getSession().getAttribute("createdEmployee");

    EmployeeService employeeService = new EmployeeService();
    // create new employee object
    Employee employee = new Employee(id, idType, name, address, manager.getHotelID(), role);

    Message msg;
    // try to create a new employee
    try {

        String value = employeeService.createEmployee(employee);
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
    response.sendRedirect("employee-homepage.jsp");
%>