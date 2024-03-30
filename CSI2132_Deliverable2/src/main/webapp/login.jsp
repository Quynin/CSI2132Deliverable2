<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
<%@ page import="com.CSI2132Deliverable2.Customer" %>
<%@ page import="com.CSI2132Deliverable2.CustomerService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    ArrayList<Message> messages;

    // get any incoming messages from session attribute named messages
    // if nothing exists then messages is an empty arraylist
    if ((ArrayList<Message>) session.getAttribute("messages") == null) messages = new ArrayList<>();
        // else get that value
    else messages = (ArrayList<Message>) session.getAttribute("messages");

    String msgField = "";

    // create the object in the form of a stringified json
    for (Message m : messages) {
        msgField += "{\"type\":\"" + m.type + "\",\"value\":\"" + m.value.replaceAll("['\"]+", "") + "\"},";
    }

    // empty session messages
    session.setAttribute("messages", new ArrayList<Message>());
%>

<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Login Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="pre-login-navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <div class="container" id="row-container">
        <div class="row align-items-center" id="row">
            <div class="col">
                <div class="card" id="card-container-layout">
                    <div class="card-body" id="card">
                         <h4 class="card-title">Login Now!!</h4>
                         <form id="modal-form" method="POST" action="login-controller.jsp">
                             <div style="text-align: center;">
                                 <input type="text" class="form-control" name="id" id="idIn" placeholder="Enter ID value">
                                 </br>
                                 <button class="btn btn-primary" id="show-btn">Submit</button>
                             </div>
                         </form>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="/assets/js/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>

    <script>
            $(document).ready(function() {
                toastr.options = {
                    "closeButton": true,
                    "positionClass": "toast-bottom-right",
                    "preventDuplicates": false
                };
                /* In order to access variables sent to ejs file to script you must Parse them to string */
                /* then to parse them back to JSON */
                let messages = document.getElementById("message").value;
                if (messages !== "") messages = JSON.parse("[" + messages.slice(0, -1) + "]");
                else messages = [];

                messages
                .forEach(({
                  type,
                  value
                }) => {
                    switch (type) {
                        case "error":
                            toastr.error(value)
                            break;
                        case "success":
                            toastr.success(value)
                            break;
                        case "warning":
                            toastr.warning(value)
                            break;
                        default:
                            toastr.info(value)
                            break;
                    }
                });
            })
    </script>


</body>

</html>