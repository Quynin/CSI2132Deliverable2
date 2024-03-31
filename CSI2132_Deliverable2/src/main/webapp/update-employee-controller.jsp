<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.util.List" %>
<%
    // get employee info from the request
    String id = request.getParameter("id");
    String idType = request.getParameter("idType");
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    int hotelID = Integer.parseInt(request.getParameter("hotelID"));
    String role = request.getParameter("role");

    EmployeeService employeeService = new EmployeeService();

    // create employee object
    Employee employee = new Employee(id, idType, name, address, hotelID, role);

    Message msg;
    // try to update a employee
    try {
        String value = employeeService.updateEmployee(employee);
        System.out.println("HERE IS EMPLOYEE UPDATE VALUE: " +  value);
        // if the value contains error/Error then this is an error message
        if (value.contains("Error") || value.contains("error")) msg = new Message("error", value);
        // else the employee was successfully updated
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
    // redirect to employees page
    response.sendRedirect("employees.jsp");
%>