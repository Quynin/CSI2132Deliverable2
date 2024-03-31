<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.EmployeeService" %>
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

    // get all employees from database
    EmployeeService employeeService = new EmployeeService();
    List<Employee> employees = null;
    try {
        employees = employeeService.getEmployees();
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
    <title> Employees Page </title>
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
                    <h4 class="modal-title">Edit Employee</h4>
                </div>
                <div class="modal-body">
                    <form id="modal-form">
                        <div style="text-align: center;">
                            <input type="text" name="id" id="id"></br>
                            <input type="text" name="idType" id="idType"></br>
                            <input type="text" name="name" id="name"></br>
                            <input type="text" name="address" id="address"></br>
                            <input type="text" name="hotelID" id="hotelID"></br>
                            <input type="text" name="role" id="role"></br>
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
                        <% if (employees.size() == 0) { %>
                        <!--
                            Hey, this case really should not happen because the user is
                            already logged in as an Employee. Maybe throw an error here?
                        -->
                        <h1 style="margin-top: 5rem;">No Employees found!</h1>
                        <% } else { %>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>ID Type</th>
                                    <th>Full Name</th>
                                    <th>Address</th>
                                    <th>Hotel ID</th>
                                    <th>Role</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                for (Employee employee : employees) { %>
                                <tr>
                                    <td><%= employee.getID() %></td>
                                    <td><%= employee.getIDType() %></td>
                                    <td><%= employee.getFullName() %></td>
                                    <td><%= employee.getAddress() %></td>
                                    <td><%= employee.getHotelID() %></td>
                                    <td><%= employee.getRole() %></td>

                                    <!-- This condition prevents a manager from updating or deleting themself.-->
                                    <% if (!employee.getID().equals(currentEmployee.getID())) {%>
                                    <td>
                                        <a type="button" onclick="setModalFields(this)"
                                           data-toggle="modal" data-id="<%= employee.getID() %>"
                                           data-idtype="<%= employee.getIDType() %>"
                                           data-name="<%= employee.getFullName() %>"
                                           data-address="<%= employee.getAddress() %>"
                                           data-hotelid="<%= employee.getHotelID() %>"
                                           data-role="<%= employee.getRole() %>"
                                           data-target="#editModal">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </td>
                                    <form method="POST" action="delete-employee-controller.jsp">
                                        <td>
                                            <input type="hidden" value="<%= employee.getID() %>" name="id" />
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
                        <h4 class="card-title">Insert New Employee</h4>
                         <form id="modal-form" method="POST" action="insert-employee-controller.jsp">
                             <div style="text-align: center;">
                                 <input type="text" class="form-control" name="id" id="id" placeholder="Enter ID value">
                                 </br>
                                 <input type="text" class="form-control" name="id-type" id="id-type" placeholder="Enter ID Type">
                                 </br>
                                 <input type="text" class="form-control" name="full-name" id="full-name" placeholder="Enter Full Name">
                                 </br>
                                 <input type="text" class="form-control" name="address" id="address" placeholder="Enter address">
                                 </br>
                                 <input type="text" class="form-control" name="role" id="role" placeholder="Enter employee role">
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
            document.getElementById("id").value = row.dataset.id;
            document.getElementById("idType").value = row.dataset.idtype;
            document.getElementById("name").value = row.dataset.name;
            document.getElementById("address").value = row.dataset.address;
            document.getElementById("hotelID").value = row.dataset.hotelid;
            document.getElementById("role").value = row.dataset.role;

            document.getElementById("modal-form").action = "update-employee-controller.jsp";
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