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

    /*
    // get all customers from database
    CustomerService customerService = new CustomerService();
    List<Customer> customers = null;
    try {
        customers = customerService.getCustomers();
    } catch (Exception e) {
        e.printStackTrace();
    }*/
%>

<!DOCTYPE html>
<html lang="en">


<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
    <title> Login Page </title>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
</head>

<body>

    <jsp:include page="navbar.jsp"/>

    <input type="hidden" name="message" id="message" value='<%=msgField%>' >

    <div class="container" id="row-container">
        <div class="row align-items-center" id="row">
            <div class="col">
                <div class="card" id="card-container-layout">
                    <div class="card-body" id="card">
                         <h4 class="card-title">Login Now!!</h4>
                         <form id="modal-form">
                             <div style="text-align: center;">
                                 <input type="text" class="form-control" name="id" placeholder="Enter ID value">
                             </div>
                         </form>
                         </br>
                         <a class="btn btn-primary" id="show-btn" onclick="loginEmpOrCustomer(id)">Submit</a>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <script>
            function loginEmpOrCustomer(id) {
                <%
                    Employee e;
                    EmployeeService eS;
                    Customer c;
                    CustomerService cS;

                    if ((e = eS.getEmployee(id)) != null) {
                        //Do employee redirect
                    } else if ((c = cS.getCustomer(id) != null) {
                        //Do customer redirect
                    } else {
                        //Tell user they have bad credentials?
                        }


                %>
            }
        </script>


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