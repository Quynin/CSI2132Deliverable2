<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.HotelPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.HotelEmailAddress" %>

<%@ page import="com.CSI2132Deliverable2.Message" %>
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

    //Get messages to display
    String displayError = "";
    if (msgField.contains("Cannot delete Hotel with existing Rooms."))
        displayError += "Cannot delete Hotel with existing Rooms.";
    else if (msgField.contains("Error while updating hotel"))
        displayError += "Not an accepted Manager ID.";

    // empty session messages
    session.setAttribute("messages", new ArrayList<Message>());

    // get all hotels from database
    HotelService hS = new HotelService();
    List<Hotel> hotels = null;
    try {
        hotels = hS.getHotels();
    } catch (Exception e) {
        e.printStackTrace();
    }

    //Get logged-in employee from session
    Employee currentEmployee = (Employee) request.getSession().getAttribute("createdEmployee");
    //Put the employee back in the session for the next page
    //request.getSession().setAttribute("createdEmployee", currentEmployee);

    System.out.println(currentEmployee.getFullName());
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Hotels Page </title>
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
                    <h4 class="modal-title">Edit Hotel</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form">
                        <div style="text-align: center;">
                            <input type="text" name="hotelID" id="hotelID"></br>
                            <input type="text" name="hotelChainID" id="hotelChainID"></br>
                            <input type="text" name="rating" id="rating"></br>
                            <input type="text" name="hotelAddress" id="hotelAddress"></br>
                            <input type="text" name="numberOfRooms" id="numberOfRooms"></br>
                            <input type="text" name="managerID" id="managerID"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>

        </div>
    </div>

    <div id="editModalPhone" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Edit Phone Number</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form">
                        <div style="text-align: center;">
                            <input type="text" name="phoneNumberID" id="phoneNumberID"></br>
                            <input type="text" name="phoneNumberString" id="phoneNumberString"></br>
                            <input type="hidden" name="oldPhoneNumber" id="oldPhoneNumber"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="editModalEmail" class="modal fade" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Edit Email Address</h4>
                    </div>
                    <div class="modal-body">
                        <form id="modal-form">
                            <div style="text-align: center;">
                                <input type="text" name="emailAddressID" id="emailAddressID"></br>
                                <input type="text" name="emailAddressString" id="emailAddressString"></br>
                                <input type="hidden" name="oldEmailAddress" id="oldEmailAddress"></br>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" form="modal-form" class="btn btn-success">Update</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <!-- MAYBE REFORMAT THIS ERROR DISPLAY? -->
    <%= displayError %>

    <div class="container">
        <div class="row" id="row">
            <div class="col-md-12">
                <div class="card" id="card-container">
                    <div class="card-body" id="card">
                        <% if (hotels.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Hotels found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hotel ID</th>
                                    <th>Hotel Chain ID</th>
                                    <th>Rating</th>
                                    <th>Hotel Address</th>
                                    <th>Number of Rooms</th>
                                    <th>Manager ID</th>
                                    <th>Hotel Phone Numbers</th>
                                    <th>Hotel Email Addresses</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (Hotel h : hotels) { %>
                                <tr>
                                    <td><%= h.getHotelID() %></td>
                                    <td><%= h.getHotelChainID() %></td>
                                    <td><%= h.getRating() %></td>
                                    <td><%= h.getHotelAddress() %></td>
                                    <td><%= h.getNumberOfRooms() %></td>
                                    <td><%= h.getManagerID() %></td>
                                    <td>
                                        <ul>
                                        <div style="width:200px">
                                            <% for (HotelPhoneNumber pn : h.getHotelPhoneNumberList()) { %>
                                                <li> <%= pn.getPhoneNumberString() %>
                                                    <a type="button" onclick="setModalFieldsPhone(this)"
                                                       data-toggle="modal"
                                                       data-phonenumberid="pn.getPhoneNumberID()"
                                                       data-phonenumberstring="pn.getPhoneNumberString()"
                                                       data-oldphonenubmer="pn.getPhoneNumberString()"
                                                       data-target="#editModalPhone">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <form method="POST" action="delete-hotel-phone-controller.jsp">
                                                        <input type="hidden" value="<%= pn.getPhoneNumberID() %>" name="id" />
                                                        <input type="hidden" value="<%= pn.getPhoneNumberString() %>" name="string" />
                                                        <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                                    </form>
                                                </li>
                                            <% } %>
                                        </div>
                                        </ul>

                                    </td>
                                    <td>
                                        <ul>
                                            <% for (HotelEmailAddress ea : h.getHotelEmailAddressList()) { %>
                                                <li> <%= ea.getEmailAddressString() %>
                                                    <a type="button" onclick="setModalFieldsEmail(this)"
                                                       data-toggle="modal"
                                                       data-emailaddressid="ea.getEmailAddressID()"
                                                       data-emailaddressstring="ea.getEmailAddressString()"
                                                       data-oldemailaddress="ea.getEmailAddressString()"
                                                       data-target="#editModalEmail">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <form method="POST" action="delete-hotel-email-controller.jsp">
                                                        <input type="hidden" value="<%= pn.getEmailAddressID() %>" name="id" />
                                                        <input type="hidden" value="<%= pn.getEmailAddressString() %>" name="string" />
                                                        <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                                    </form>
                                                </li>
                                            <% } %>
                                        </ul>
                                    </td>

                                    <td>
                                        <a type="button" onclick="setModalFields(this)"
                                           data-toggle="modal"
                                           data-hotelid="<%= h.getHotelID() %>"
                                           data-hotelchainid="<%= h.getHotelChainID() %>"
                                           data-rating="<%= h.getRating() %>"
                                           data-hoteladdress="<%= h.getHotelAddress() %>"
                                           data-numberofrooms="<%= h.getNumberOfRooms() %>"
                                           data-managerid="<%= h.getManagerID() %>"
                                           data-target="#editModal">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </td>
                                    <form method="POST" action="delete-hotel-controller.jsp">
                                        <td>
                                            <input type="hidden" value="<%= h.getHotelID() %>" name="id" />
                                            <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                        </td>
                                    </form>
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

    <script>
        function setModalFields(row) {
            document.getElementById("hotelID").value = row.dataset.hotelid;
            document.getElementById("hotelChainID").value = row.dataset.hotelchainid;
            document.getElementById("rating").value = row.dataset.rating;
            document.getElementById("hotelAddress").value = row.dataset.hoteladdress;
            document.getElementById("numberOfRooms").value = row.dataset.numberofrooms;
            document.getElementById("managerID").value = row.dataset.managerid;

            document.getElementById("modal-form").action = "update-hotel-controller.jsp";
            document.getElementById("modal-form").method = "POST";
        }
    </script>

    <script>
            function setModalFieldsPhone(row) {
                document.getElementById("id").value = row.dataset.id;
                document.getElementById("string").value = row.dataset.string;

                document.getElementById("modal-form").action = "update-hotel-phone-controller.jsp";
                document.getElementById("modal-form").method = "POST";
            }
    </script>

    <script>
            function setModalFieldsEmail(row) {
                document.getElementById("id").value = row.dataset.id;
                document.getElementById("string").value = row.dataset.string;

                document.getElementById("modal-form").action = "update-hotel-email-controller.jsp";
                document.getElementById("modal-form").method = "POST";
            }
    </script>


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