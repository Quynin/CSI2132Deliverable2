<%@ page import="com.CSI2132Deliverable2.Message" %>
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
%>

<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Home Page of Deliverable </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="pre-login-navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <div class="col-md-4 container" style="text-align: center; padding: 125px 0;">
        <div class="row" id="row" style="text-align: center;">
            <h4 class="card-title">Welcome to Hotel Trevago Bookings!!! Explore the wondrous hotel locations from all around the globe. </h4>
            </div>

            <div class="row" id="row2">
             <a class="btn btn-primary" style='margin-bottom:16px' id="login-btn" href="login.jsp">Login</a>
             <a class="btn btn-primary" id="signup-btn" href="signup.jsp">Customer Signup</a>
        </div>
    </div>

    <!--
    <div class="container" id="row-container">
        <div class="row" id="row">
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
                        <h4 class="card-title">Create Customer</h4>
                        <p class="card-text" id="paragraph">Enter a new customer into the database<br></p>
                        <a class="btn btn-primary" id="show-btn" href="insert-customer.jsp">Create</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card" id="card-container-layout">
                    <div class="card-body" id="card">
                        <h4 class="card-title">View Hotel Chains</h4>
                        <p class="card-text" id="paragraph">Simple Query to database to show all hotelChains<br></p>
                        <a class="btn btn-primary" id="show-btn" href="hotel-chains.jsp">Show</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
    -->



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
