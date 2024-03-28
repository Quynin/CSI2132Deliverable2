<%@ page import="com.CSI2132Deliverable2.HotelChain, com.CSI2132Deliverable2.HotelChainService, com.CSI2132Deliverable2.Message" %>
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


    //Retrieve all the HotelChain details from database
    ArrayList<HotelChain> hCList = null;
    HotelChainService hCS = new HotelChainService();

    try {
        //Try to retrieve the information and cast it to a list
        hCList = (ArrayList<HotelChain>) hCS.getHotelChains();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">


<head>
    <!-- Meta information -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Home Page of Deliverable </title>

    <!-- Formatting information (and class imports?) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">

    <!--
        //Link information relative to webApp or from external sources
        //INFO GOES HERE
    -->



    	<!-- OTHER INFORMATION -->
    	<input type="hidden" name="message" id="message" value='<%=msgField%>'>
</head>

<body>

    <!--
        //INCLUDE ANY OTHER .jsp FILES HERE

        //OTHER INFORMATION


        //div is a block line element?
    -->
<h2>Hello World! (Body 1)</h2>
</body>

<body> <h1> This is text in format h1 in...</h1> </body>



<body>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

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
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="/assets/js/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>



</body>

</html>
