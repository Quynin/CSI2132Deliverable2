<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainService" %>
<%@ page import="com.CSI2132Deliverable2.HotelChain" %>
<%@ page import="com.CSI2132Deliverable2.Employee" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainPhoneNumber" %>
<%@ page import="com.CSI2132Deliverable2.HotelChainEmailAddress" %>

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
    if (msgField.contains("Cannot delete HotelChain with existing Hotels."))
        displayError += "Cannot delete HotelChain with existing Hotels.";
    /*
    else if (msgField.contains("violates check constraint hotel_rating_check"))
        displayError += "Not an accepted rating. Accepted ratings are 1, 2, 3, 4, and 5.";
    else if (msgField.contains("violates foreign key constraint hotel_managerid_fkey"))
            displayError += "Not an accepted Manager ID.";
    */


    // empty session messages
    session.setAttribute("messages", new ArrayList<Message>());

    // get all hotel chains from database
    HotelChainService hS = new HotelChainService();
    List<HotelChain> hotelChains = null;
    try {
        hotelChains = hS.getHotelChains();
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
    <title> Hotel Chains Page </title>
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
                    <h4 class="modal-title">Edit Hotel Chain</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form-hotel-chain">
                        <div style="text-align: center;">
                            <input type="text" name="hotelChainID" id="hotelChainID"></br>
                            <input type="text" name="addressOfCentralOffices" id="addressOfCentralOffices"></br>
                            <input type="text" name="numberOfHotels" id="numberOfHotels" readonly></br>
                            <input type="hidden" name="oldID" id="oldID"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form-hotel-chain" class="btn btn-success">Update</button>
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
                    <form id="modal-form-phone">
                        <div style="text-align: center;">
                            <input type="hidden" name="phoneNumberID" id="phoneNumberID"></br>
                            <input type="text" name="phoneNumberString" id="phoneNumberString"></br>
                            <input type="hidden" name="oldPhoneNumber" id="oldPhoneNumber"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form-phone" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="editModalPhoneInsert" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Add Phone Number</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form-phone-insert">
                        <div style="text-align: center;">
                            <input type="hidden" name="phoneNumberIDToInsert" id="phoneNumberIDToInsert"></br>
                            <input type="text" name="phoneNumberStringToInsert" id="phoneNumberStringToInsert"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form-phone-insert" class="btn btn-success">Add</button>
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
                    <form id="modal-form-email">
                        <div style="text-align: center;">
                            <input type="hidden" name="emailAddressID" id="emailAddressID"></br>
                            <input type="text" name="emailAddressString" id="emailAddressString"></br>
                            <input type="hidden" name="oldEmailAddress" id="oldEmailAddress"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form-email" class="btn btn-success">Update</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="editModalEmailInsert" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Add Email Address</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form-email-insert">
                        <div style="text-align: center;">
                            <input type="hidden" name="emailAddressIDToInsert" id="emailAddressIDToInsert"></br>
                            <input type="text" name="emailAddressStringToInsert" id="emailAddressStringToInsert"></br>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="submit" form="modal-form-email-insert" class="btn btn-success">Add</button>
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
                        <% if (hotelChains.size() == 0) { %>
                        <h1 style="margin-top: 5rem;">No Hotel Chains found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Hotel Chain</th>
                                    <th>Address of Central Office</th>
                                    <th>Number of Hotels</th>
                                    <th>Hotel Chain Phone Numbers</th>
                                    <th>Hotel Chain Email Addresses</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (HotelChain h : hotelChains) { %>
                                <tr>
                                    <td><%= h.getHotelChainID() %></td>
                                    <td><%= h.getAddressOfCentralOffices() %></td>
                                    <td><%= h.getNumberOfHotels() %></td>
                                    <td>
                                        <ul>
                                        <div style="width:200px">
                                            <% for (HotelChainPhoneNumber pn : h.getHotelChainPhoneNumberList()) { %>
                                                <li> <%= pn.getPhoneNumberString() %>
                                                    <a type="button" onclick="setModalFieldsPhone(this)"
                                                       data-toggle="modal"
                                                       data-phonenumberid="<%= pn.getPhoneNumberID() %>"
                                                       data-phonenumberstring="<%= pn.getPhoneNumberString() %>"
                                                       data-oldphonenumber="<%= pn.getPhoneNumberString() %>"
                                                       data-target="#editModalPhone">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <form method="POST" action="delete-hotel-chain-phone-controller.jsp">
                                                        <input type="hidden" value="<%= pn.getPhoneNumberID() %>" name="phoneNumberID" />
                                                        <input type="hidden" value="<%= pn.getPhoneNumberString() %>" name="phoneNumberString" />
                                                        <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                                    </form>
                                                </li>
                                            <% } %>
                                        </div>
                                            <a type="button" onclick="setModalFieldsPhoneInsert(this)"
                                               data-toggle="modal"
                                               data-phonenumberid="<%= h.getHotelChainID() %>"
                                               data-phonenumberstring="<%= new String() %>"
                                               data-target="#editModalPhoneInsert">
                                                <i class="fa fa-plus"></i>
                                            </a>
                                        </ul>

                                    </td>
                                    <td>
                                        <ul>
                                            <% for (HotelChainEmailAddress ea : h.getHotelChainEmailAddressList()) { %>
                                                <li> <%= ea.getEmailAddressString() %>
                                                    <a type="button" onclick="setModalFieldsEmail(this)"
                                                       data-toggle="modal"
                                                       data-emailaddressid="<%= ea.getEmailAddressID() %>"
                                                       data-emailaddressstring="<%= ea.getEmailAddressString() %>"
                                                       data-oldemailaddress="<%= ea.getEmailAddressString() %>"
                                                       data-target="#editModalEmail">
                                                        <i class="fa fa-edit"></i>
                                                    </a>
                                                    <form method="POST" action="delete-hotel-chain-email-controller.jsp">
                                                        <input type="hidden" value="<%= ea.getEmailAddressID() %>" name="emailAddressID" />
                                                        <input type="hidden" value="<%= ea.getEmailAddressString() %>" name="emailAddressString" />
                                                        <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                                    </form>
                                                </li>
                                            <% } %>
                                            <a type="button" onclick="setModalFieldsEmailInsert(this)"
                                               data-toggle="modal"
                                               data-emailaddressid="<%= h.getHotelChainID() %>"
                                               data-emailaddressstring="<%= new String() %>"
                                               data-target="#editModalEmailInsert">
                                                <i class="fa fa-plus"></i>
                                            </a>
                                        </ul>
                                    </td>

                                    <td>
                                        <a type="button" onclick="setModalFields(this)"
                                           data-toggle="modal"
                                           data-hotelchainid="<%= h.getHotelChainID() %>"
                                           data-hotelchainaddress="<%= h.getAddressOfCentralOffices() %>"
                                           data-numberofhotels="<%= h.getNumberOfHotels() %>"
                                           data-oldid="<%= h.getHotelChainID() %>"
                                           data-target="#editModal">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </td>
                                    <form method="POST" action="delete-hotel-chain-controller.jsp">
                                        <td>
                                            <input type="hidden" value="<%= h.getHotelChainID() %>" name="id" />
                                            <button style="all: unset; cursor: pointer;" type="submit"><i class="fa fa-trash"></i></button>
                                        </td>
                                    </form>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        <h4 class="card-title">Insert New Hotel Chain</h4>
                         <form id="modal-form" method="POST" action="insert-hotel-chain-controller.jsp">
                             <div style="text-align: center;">
                                 <input type="text" class="form-control" name="hotel-chain-id" id="hotel-chain-id" placeholder="Enter Hotel Chain">
                                 </br>
                                 <input type="text" class="form-control" name="addressOfCentralOffices" id="addressOfCentralOffices" placeholder="Enter Address of Central Offices">
                                 </br>
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
            document.getElementById("hotelChainID").value = row.dataset.hotelchainid;
            document.getElementById("addressOfCentralOffices").value = row.dataset.hotelchainaddress;
            document.getElementById("numberOfHotels").value = row.dataset.numberofhotels;
            document.getElementById("oldID").value = row.dataset.oldid;

            document.getElementById("modal-form-hotel-chain").action = "update-hotel-chain-controller.jsp";
            document.getElementById("modal-form-hotel-chain").method = "POST";
        }
    </script>

    <script>
            function setModalFieldsPhone(row) {
                document.getElementById("phoneNumberID").value = row.dataset.phonenumberid;
                document.getElementById("phoneNumberString").value = row.dataset.phonenumberstring;
                document.getElementById("oldPhoneNumber").value = row.dataset.oldphonenumber;

                document.getElementById("modal-form-phone").action = "update-hotel-chain-phone-controller.jsp";
                document.getElementById("modal-form-phone").method = "POST";
            }
    </script>

    <script>
            function setModalFieldsPhoneInsert(row) {
                document.getElementById("phoneNumberIDToInsert").value = row.dataset.phonenumberid;
                document.getElementById("phoneNumberStringToInsert").value = row.dataset.phonenumberstring;

                document.getElementById("modal-form-phone-insert").action = "insert-hotel-chain-phone-controller.jsp";
                document.getElementById("modal-form-phone-insert").method = "POST";
            }
    </script>

    <script>
            function setModalFieldsEmail(row) {
                document.getElementById("emailAddressID").value = row.dataset.emailaddressid;
                document.getElementById("emailAddressString").value = row.dataset.emailaddressstring;
                document.getElementById("oldEmailAddress").value = row.dataset.oldemailaddress;

                document.getElementById("modal-form-email").action = "update-hotel-chain-email-controller.jsp";
                document.getElementById("modal-form-email").method = "POST";
            }
    </script>

    <script>
            function setModalFieldsEmailInsert(row) {
                document.getElementById("emailAddressIDToInsert").value = row.dataset.emailaddressid;
                document.getElementById("emailAddressStringToInsert").value = row.dataset.emailaddressstring;

                document.getElementById("modal-form-email-insert").action = "insert-hotel-chain-email-controller.jsp";
                document.getElementById("modal-form-email-insert").method = "POST";
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