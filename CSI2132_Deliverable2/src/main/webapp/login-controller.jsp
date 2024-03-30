<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
<%@ page import="com.CSI2132Deliverable2.Customer" %>
<%@ page import="com.CSI2132Deliverable2.CustomerService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // get customer info from the request
    String id = request.getParameter("id");


    CustomerService customerService = new CustomerService();
    EmployeeService employeeService = new EmployeeService();
    Customer customer = customerService.getCustomer(id);
    Employee employee = employeeService.getEmployee(id);
     // check where to redirect
     try {
         if(customer != null){
             request.getSession().setAttribute("createdCustomer", customer);
             response.sendRedirect("customer-homepage.jsp");
             }
         else if(employee!= null){

            response.sendRedirect("employee-homepage.jsp");
         }
         else{
            response.sendRedirect("login.jsp");
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Customers Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>
<body>

</body>
</html>