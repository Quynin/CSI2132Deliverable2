<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@page import="com.CSI2132Deliverable2.CurrentBooking" %>
<%@page import="com.CSI2132Deliverable2.CurrentBookingService" %>
<%@page import="com.CSI2132Deliverable2.HotelService" %>
<%@page import="com.CSI2132Deliverable2.Hotel" %>
<%@page import="com.CSI2132Deliverable2.Customer" %>

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

    Customer customer = (Customer) request.getSession().getAttribute("createdCustomer");


    // get all current bookings from database
    CurrentBookingService currentBookingService = new CurrentBookingService();
    List<CurrentBooking> currentBookings = null;
    try {
        currentBookings = currentBookingService.getCurrentBookings(customer.getID());
    } catch (Exception e) {
        e.printStackTrace();
    }

    //get all available hotels from the database
    HotelService hotelService = new HotelService();
    List<Hotel> availableHotels = null;
    try {
        //default situation. no address filter: all hotel with available rooms
        System.out.println("something");
        if(request.getSession().getAttribute("filteredHotels") != null){
            availableHotels = (List<Hotel>) request.getSession().getAttribute("filteredHotels");
        }
        else{
            availableHotels = hotelService.getAvailableHotels("");
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
    <title> Customer Homepage </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <form class="modal-content" method="POST" action="filter-address-controller.jsp">
        <div class="modal-header">
            <h4 class="modal-title">Filter Address</h4>
        </div>
        <div class="modal-body">
            <form id="modal-form">
                <div style="text-align: center;">
                    <input type="text" name="street-address" id="address"></br>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="submit" form="modal-form" class="btn btn-success" >Update</button>
        </div>
    </div>



    <div class="container">
        <div class="row" id="row">
            <div class="col-md-12">
                <div class="card" id="card-container">
                    <div class="card-body" id="card2">
                        <% if (availableHotels.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Available Hotels found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hotel ID</th>
                                    <th>Hotel Chain ID</th>
                                    <th>Hotel Name</th>
                                    <th>Rating</th>
                                    <th>Hotel Address</th>
                                    <th>Number Of Rooms</th>
                                    <th>Manager ID</th>
                                    <th>Choose Hotel</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (Hotel hotel : availableHotels) { %>
                                <tr>
                                    <td><%= hotel.getHotelID() %></td>
                                    <td><%= hotel.getHotelChainID() %></td>
                                    <td><%= hotel.getHotelName() %></td>
                                    <td><%= hotel.getRating() %></td>
                                    <td><%= hotel.getHotelAddress() %></td>
                                    <td><%= hotel.getNumberOfRooms() %></td>
                                    <td><%= hotel.getManagerID() %></td>
                                    <form method="POST" action="room-select.jsp">
                                        <td>
                                             <input type="hidden" value="<%= hotel.getHotelID() %>" name="id" />
                                             <button style="all: unset; cursor: pointer;" type="submit">Select Hotel</button>
                                        </td>
                                    </form>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>
                    <div class="card-body" id="card">
                        <% if (currentBookings.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Current Bookings found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hotel Name</th>
                                    <th>Booking ID</th>
                                    <th>Room ID</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Cost</th>
                                    <th>Booking Status</th>
                                    <th>Payment Method</th>
                                    <th>Is Paid</th>
                                    <th>Room Amenities</th>
                                    <th>Room View</th>
                                    <th>Room Problem or Damages?</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (CurrentBooking currentBooking : currentBookings) { %>
                                <tr>
                                    <td><%= currentBooking.getHotelName() %></td>
                                    <td><%= currentBooking.getBookingID() %></td>
                                    <td><%= currentBooking.getRoomID() %></td>
                                    <td><%= currentBooking.getStartDate() %></td>
                                    <td><%= currentBooking.getEndDate() %></td>
                                    <td><%= currentBooking.getCost() %></td>
                                    <td><%= currentBooking.getBookingStatus() %></td>
                                    <td><%= currentBooking.getPaymentMethod() %></td>
                                    <td><%= currentBooking.getIsPaid() %></td>
                                    <td><%= currentBooking.getRoomAmenities() %></td>
                                    <td><%= currentBooking.getRoomView() %></td>
                                    <td><%= currentBooking.getRoomProblemsOrDamages() %></td>
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
