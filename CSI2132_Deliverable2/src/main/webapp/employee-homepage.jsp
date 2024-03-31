<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>

<%@ page import="java.util.ArrayList" %>

<%@ page contentType="text/html; cha=UTF-8" language="java" %>

<%
    ArrayList<Message> messages;

    //Get any incoming messages from session attribute named messages
    //If nothing exists, then messages is empty
    if ((ArrayList<Message>) session.getAttribute("messages") == null)
        messages = new ArrayList<>();
    else //Else get the messages
        messages = (ArrayList<Message>) session.getAttribute("messages");

    String msgField = "";

    //Create the object in the form of a stringified json
    for (Message m : messages) {
        msgField += "{\"type\":\"" + m.type + "\",\"value\":\"" + m.value.replaceAll("['\"]+", "") + "\"},";
    }

    //Empty the sessions messages
    session.setAttribute("messages", new ArrayList<Message>());


    //Get the employee from the sesseion
    Employee employee = (Employee) request.getSession().getAttribute("createdEmployee");

%>

<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Employee Homepage </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >


    <div class="col-md-4">
        <div class="row" id="row" style="text-align: center;">
        <h4 class="card-title">Welcome, <%= employee.getFullName() %> </h4>
        </div>
    </div>

    <div class="container" id="row-container">
            <div class="row" id="row">

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Hotel Rooms</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all Hotel Rooms<br></p>
                            <a class="btn btn-primary" id="show-btn" href="employee-hotel-rooms.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Bookings</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all customer Bookings<br></p>
                            <a class="btn btn-primary" id="show-btn" href="employee-bookings.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <!--
                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">Create Customer</h4>
                            <p class="card-text" id="paragraph">Enter a new customer into the database<br></p>
                            <a class="btn btn-primary" id="show-btn" href="insert-customer.jsp">Create</a>
                        </div>
                    </div>
                </div>
                -->

                <% if (employee.getRole().replace(" ", "").equals("Manager")) {%>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Customers</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all customers</p>
                            <a class="btn btn-primary" id="show-btn" href="customers.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Employees</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all employees</p>
                            <a class="btn btn-primary" id="show-btn" href="employees.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Hotels</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all Hotels<br></p>
                            <a class="btn btn-primary" id="show-btn" href="employee-hotels.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">View Hotel Chains</h4>
                            <p class="card-text" id="paragraph">Simple Query to database to show all Hotel Chains<br></p>
                            <a class="btn btn-primary" id="show-btn" href="employee-hotel-chains.jsp">Show</a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                            <h4 class="card-title">Add Employees</h4>
                            <p class="card-text" id="paragraph">Insert new employees to database<br></p>
                            <a class="btn btn-primary" id="show-btn" href="insert-employee.jsp">Show</a>
                        </div>
                    </div>
                </div>
                <% } %>

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
