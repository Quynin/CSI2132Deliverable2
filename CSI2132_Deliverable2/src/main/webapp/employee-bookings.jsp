<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.BookingService" %>
<%@ page import="com.CSI2132Deliverable2.Booking" %>
<%@ page import="com.CSI2132Deliverable2.BookingStatus" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
<%@ page import="java.util.ArrayList" %>


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

    // get all bookings from database
    BookingService service = new BookingService();
    List<Booking> bookings = null;
    try {
        bookings = service.getBookings();
    } catch (Exception e) {
        e.printStackTrace();
    }

    //Get logged-in employee from session
    Employee currentEmployee = (Employee) request.getSession().getAttribute("createdEmployee");
    System.out.println(currentEmployee.getFullName());

    //Get hotel of logged-in employee
    HotelService hService = new HotelService();
    Hotel h = hService.getHotel(currentEmployee.getHotelID());

    //Get available rooms of current hotel
    HotelRoomService hRService = new HotelRoomService();
    List<HotelRoom> roomList = hRService.getAvailableRoomsOfHotel(h.getHotelID());
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Bookings Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <div id="editModal" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Booking</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form">
                        <div style="text-align: center;">
                            <input type="text" name="id" id="id" readonly></br>
                            <input type="text" name="idType" id="idType" readonly></br>
                            <input type="text" name="name" id="name"></br>
                            <input type="text" name="address" id="address"></br>
                            <input type="text" name="hotelID" id="hotelID"></br>
                            <input type="text" name="role" id="role"></br>
                        </div>
                    </form>
                </div>
            </div>

        </div>
    </div>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >
    <div class="container">
        <div class="row" id="row">
            <div class="col-md-12">
                <div class="card" id="card-container">
                    <div class="card-body" id="card">
                        <% if (bookings.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Bookings found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Room ID</th>
                                    <th>Customer ID</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Cost</th>
                                    <th>Booking Status</th>
                                    <th>Payment Method</th>
                                    <th>Paid?</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (Booking b : bookings) { %>
                                <tr>
                                    <td><%= b.getBookingID() %></td>
                                    <td><%= b.getRoomID() %></td>
                                    <td><%= b.getCustomerID() %></td>
                                    <td><%= b.getStartDate() %></td>
                                    <td><%= b.getEndDate() %></td>
                                    <td><%= b.getCost() %></td>
                                    <td><%= b.getBookingStatus() %></td>
                                    <td><%= b.getPaymentMethod() %></td>
                                    <td><%= b.getIsPaid() %> </td>

                                    <% if (b.getBookingStatus() != BookingStatus.ARCHIVED) { %>
                                    <td>
                                        <form method="POST" action="update-booking-controller.jsp">
                                            <td>
                                                <input type="hidden" value="<%= b.getBookingID() %>" name="bID"/>
                                                <input type="hidden" value="<%= b.getRoomID() %>" name="rID"/>
                                                <input type="hidden" value="<%= b.getCustomerID() %>" name="cID"/>
                                                <input type="hidden" value="<%= b.getStartDate() %>" name="startDate"/>
                                                <input type="hidden" value="<%= b.getEndDate() %>" name="endDate"/>
                                                <input type="hidden" value="<%= b.getCost() %>" name="cost"/>
                                                <input type="hidden" value="<%= b.getBookingStatus() %>" name="bookingStatus"/>
                                                <input type="hidden" value="<%= b.getPaymentMethod() %>" name="paymentMethod"/>
                                                <input type="hidden" value="<%= b.getIsPaid() %>" name="isPaid"/>
                                                <%if (b.getBookingStatus() == BookingStatus.BOOKING) { %>
                                                    <button style="all: unset; cursor: pointer;" type="submit">Check-in (Set to RENTING)</button>
                                                <% } else if (b.getBookingStatus() == BookingStatus.RENTING) { %>
                                                    <button style="all: unset; cursor: pointer;" type="submit">Check-out (Set to ARCHIVE)</button>
                                                <% } %>
                                            </td>
                                        </form>
                                    </td>
                                    <form method="POST" action="delete-booking-controller.jsp">
                                        <td>
                                            <input type="hidden" value="<%= b.getBookingID() %>" name="id" />
                                            <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                        </td>
                                    </form>
                                    <% } %>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        <% if (roomList.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Available rooms at <%= h.getHotelName() %>!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Room ID</th>
                                    <th>Price</th>
                                    <th>Amenities</th>
                                    <th>Capacity of Room</th>
                                    <th>View from Room</th>
                                    <th>Is Extendable</th>
                                    <th>Problems or Damages</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (HotelRoom r : roomList) { %>
                                <tr>
                                    <td><%= r.getRoomID() %></td>
                                    <td><%= r.getPrice() %></td>
                                    <td><%= r.getAmenities() %></td>
                                    <td><%= r.getCapacityOfRoom() %></td>
                                    <td><%= r.getViewFromRoom() %></td>
                                    <td><%= r.getIsExtendable() %></td>
                                    <td><%= r.getProblemsOrDamages() %></td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <h4 class="card-title">Insert Customer Booking</h4>
                         <form id="modal-form" method="POST" action="insert-booking-controller.jsp">
                             <div style="text-align: center;">
                                 <label for="startDate">RoomID:</label>
                                 <input type="text" class="form-control" name="rID" id="rID" placeholder="Enter Room ID"/>
                                 </br>
                                 <label for="startDate">CustomerID:</label>
                                 <input type="text" class="form-control" name="cID" id="cID" placeholder="Enter Customer ID"/>
                                 </br>
                                 <label for="startDate">Choose Start Date:</label>
                                 <input type="date" id="startDate" name="startDate"/>
                                 </br>
                                 <label for="endDate">Choose End Date:</label>
                                 <input type="date" id="endDate" name="endDate"/>
                                 </br>
                                 <label for="startDate">Cost:</label>
                                 <input type="text" id="cost" name="cost"/>
                                 </br>
                                 <label for="payment-method">Which payment method does the customer use:</label>
                                  <select name="paymentMethod" id="paymentMethod">
                                      <option value="Credit Card">Credit Card</option>
                                      <option value="Debit Card">Debit Card</option>
                                      <option value="In-Person">Cash</option>
                                  </select>
                                 <button class="btn btn-primary" id="show-btn">Create Booking</button>
                                 <br>
                             </div>
                         </form>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

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