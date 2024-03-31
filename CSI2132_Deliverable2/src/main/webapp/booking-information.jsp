<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="com.CSI2132Deliverable2.Customer" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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

    //get transferred values
     Customer customer = (Customer) request.getSession().getAttribute("createdCustomer");
     Hotel hotel = (Hotel) request.getSession().getAttribute("chosenHotel");
     HotelRoom hotelRoom = (HotelRoom) request.getSession().getAttribute("selectedRoom");

%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Room Select Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <div class="container" id="row-container" style="padding: 70px 0;">
                    <div class="card" id="card-container-layout">
                        <div class="card-body" id="card">
                             <h4 class="card-title">Fill Booking information</h4>
                             <form id="modal-form" method="POST" action="booking-information-controller.jsp">
                                 <div style="text-align: center;">
                                     <label for="start-date">Choose Start Date:</label>
                                     <input type="date" id="start-date" name="start-date">
                                     </br>
                                     <label for="end-date">Choose End Date:</label>
                                     <input type="date" id="end-date" name="end-date" disabled>
                                     </br>
                                     <p id="price" name="price"> Price: <%= hotelRoom.getPrice()%>$ </p>
                                     </br>
                                     <label for="payment-method">How would you like to pay? (Credit/Debit advance, cash In-Person):</label>
                                     <select name="payment-method" id="payment-method">
                                         <option value="Credit Card">Credit Card</option>
                                         <option value="Debit Card">Debit Card</option>
                                         <option value="In-Person">In Person</option>
                                     </select>
                                     <button class="btn btn-primary" id="show-btn">Confirm</button>
                                 </div>
                             </form>
                        </div>
                    </div>
    </div>


    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="/assets/js/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>

    <script>
        $(document).ready(function() {
         let startDate = document.getElementById('start-date');
          let endDate = document.getElementById('end-date');

          // Enable endDate if startDate is filled, as well as set minimum dates
          let currentDate = new Date();
          let dd = currentDate.getDate();
          let mm = currentDate.getMonth() + 1; // January is [0] so I added 1 to get the right month.
          let yy = currentDate.getFullYear();

          if(dd < 10) {
            dd = "0" + dd.toString();
          };

          if(mm < 10) {
            mm = "0" + mm.toString();
          };

          let today = yy + '-' + mm + '-' + dd;

          startDate.setAttribute("min", today);

          startDate.oninput = () => {
            if (startDate.value.length > 0) {
              endDate.disabled = false;

              let fullSelectedDate = new Date(startDate.value);
              fullSelectedDate.setDate(fullSelectedDate.getDate() + 2);

              let selectedDd = fullSelectedDate.getDate();
              let selectedMm = fullSelectedDate.getMonth() + 1;
              let selectedYy = fullSelectedDate.getFullYear();

              if(selectedDd < 10) {
                selectedDd = "0" + selectedDd.toString();
              };

              if(selectedMm < 10) {
                selectedMm = "0" + selectedMm.toString();
              };

              let nextDay = selectedYy + '-' + selectedMm + '-' + selectedDd;

              endDate.setAttribute("min", nextDay);

            } else {
              endDate.disabled = true;
            }
          };
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