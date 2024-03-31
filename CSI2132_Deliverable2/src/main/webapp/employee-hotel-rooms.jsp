<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
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

    // empty session messages
    session.setAttribute("messages", new ArrayList<Message>());

    // get all hotel rooms from database
    HotelRoomService hotelRoomService = new HotelRoomService();
    List<HotelRoom> hotelRooms = null;
    try {
        hotelRooms = hotelRoomService.getHotelRooms();
    } catch (Exception e) {
        e.printStackTrace();
    }

    //Get logged-in employee from session
    Employee currentEmployee = (Employee) request.getSession().getAttribute("createdEmployee");
    System.out.println(currentEmployee.getFullName());
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Employees hotel rooms Page </title>
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
                    <h4 class="modal-title">Edit Hotel Room</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form">
                        <div style="text-align: center;">
                            <input type="text" name="room-id" id="room-id" readonly></br>
                            <input type="text" name="hotel-id" id="hotel-id" readonly></br>
                            <input type="text" name="price" id="price"></br>
                            <input type="text" name="amenities" id="amenities"></br>
                            <input type="text" name="capacity-of-room" id="capacity-of-room"></br>
                            <input type="text" name="view-from-room" id="view-from-room"></br>
                            <label for="is-extendable">Room is extendable:</label>
                            <select name="is-extendable" id="is-extendable">
                                <option value="true">true</option>
                                <option value="false">false</option>
                            </select></br>
                            <input type="text" name="problems-or-damages" id="problems-or-damages"></br>
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
    <div class="container">
        <div class="row" id="row">
            <div class="col-md-12">
                <div class="card" id="card-container">
                    <div class="card-body" id="card">
                        <% if (hotelRooms.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Hotel Rooms found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Room ID</th>
                                    <th>Hotel ID</th>
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
                                for (HotelRoom hotelRoom : hotelRooms) { %>
                                <tr>
                                    <td><%= hotelRoom.getRoomID() %></td>
                                    <td><%= hotelRoom.getHotelID() %></td>
                                    <td><%= hotelRoom.getPrice() %></td>
                                    <td style="width:100px"><%= hotelRoom.getAmenities() %></td>
                                    <td><%= hotelRoom.getCapacityOfRoom() %></td>
                                    <td><%= hotelRoom.getViewFromRoom() %></td>
                                    <td><%= hotelRoom.getIsExtendable() %></td>
                                    <td><%= hotelRoom.getProblemsOrDamages() %></td>
                                    <td>
                                        <a type="button" onclick="setModalFields(this)"
                                           data-toggle="modal" data-roomid="<%= hotelRoom.getRoomID() %>"
                                           data-hotelid="<%= hotelRoom.getHotelID()%>"
                                           data-price="<%= hotelRoom.getPrice()%>"
                                           data-amenities="<%= hotelRoom.getAmenities() %>"
                                           data-capacityofroom="<%= hotelRoom.getCapacityOfRoom() %>"
                                           data-viewfromroom="<%= hotelRoom.getViewFromRoom() %>"
                                           data-isextendable="<%= hotelRoom.getIsExtendable() %>"
                                           data-problemsordamages="<%= hotelRoom.getProblemsOrDamages() %>"
                                           data-target="#editModal">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </td>
                                    <form method="POST" action="delete-hotel-room-controller.jsp">
                                        <td>
                                            <input type="hidden" value="<%= hotelRoom.getRoomID() %>" name="room-id" />
                                            <input type="hidden" value="<%= hotelRoom.getHotelID() %>" name="hotel-id" />
                                            <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                        </td>
                                    </form>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        <h4 class="card-title">Insert New Hotel Room</h4>
                         <form id="modal-form2" method="POST" action="insert-hotel-room-controller.jsp">
                             <div style="text-align: center;">
                                 <input type="text" class="form-control" name="price" id="price" placeholder="Enter room price">
                                 </br>
                                 <input type="text" class="form-control" name="amenities" id="amenities" placeholder="Enter room amenities">
                                 </br>
                                 <input type="text" class="form-control" name="capacity-of-room" id="capacity-of-room" placeholder="Enter room capacity">
                                 </br>
                                 <input type="text" class="form-control" name="view-from-room" id="view-from-room" placeholder="Describe view from room">
                                 </br>
                                 <label for="is-extendable">Room is extendable:</label>
                                 <select name="is-extendable" id="is-extendable" class="form-control">
                                     <option value="true">true</option>
                                     <option value="false">false</option>
                                 </select>
                                 </br>
                                 <input type="text" class="form-control" name="problems-or-damages" id="problems-or-damages" placeholder="Describe problems or damages in the room"></br>
                                 <button class="btn btn-primary" id="show-btn">Submit</button>
                             </div>
                         </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function setModalFields(row) {
            document.getElementById("room-id").value = row.dataset.roomid;
            document.getElementById("hotel-id").value = row.dataset.hotelid;
            document.getElementById("price").value = row.dataset.price;
            document.getElementById("amenities").value = row.dataset.amenities;
            document.getElementById("capacity-of-room").value = row.dataset.capacityofroom;
            document.getElementById("view-from-room").value = row.dataset.viewfromroom;
            document.getElementById("is-extendable").value = row.dataset.isextendable;
            document.getElementById("problems-or-damages").value = row.dataset.problemsordamages;

            document.getElementById("modal-form").action = "update-hotel-room-controller.jsp";
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