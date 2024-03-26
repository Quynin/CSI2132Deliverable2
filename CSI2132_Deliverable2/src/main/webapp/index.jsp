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

    <div class="container">
        <div class="row" id="row">
            <div class="col-md-12">
                <div class="card" id="card-container">
                    <div class="card-body" id="card">
                        <% if (hCList.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No HotelChains found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hotel Name</th>
                                    <th>Central Office Address</th>
                                    <th>Number of Hotels</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (HotelChain hC : hCList) { %>
                                <tr>
                                    <td><%= hC.getHotelChainID() %></td>
                                    <td><%= hC.getAddressOfCentralOffices() %></td>
                                    <td><%= hC.getNumberOfHotels() %></td>
                                    <td>
                                        <a type="button" onclick="setModalFields(this)"
                                           data-toggle="modal" data-id="<%= hC.getHotelChainID() %>"
                                           data-name="<%= hC.getAddressOfCentralOffices() %>"
                                           data-email="<%= hC.getNumberOfHotels() %>"
                                           data-target="#editModal">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>




</body>

</html>
