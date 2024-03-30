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
            request.getSession().setAttribute("createdEmployee", employee);
            response.sendRedirect("employee-homepage.jsp");
         }
         else{
            response.sendRedirect("login.jsp");
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
%>