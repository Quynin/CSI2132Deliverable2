<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoom" %>
<%@ page import="com.CSI2132Deliverable2.HotelRoomService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    // get room info from the request
    int hotelID = Integer.parseInt(request.getParameter("hotelID"));

    double minPrice = 0;
    if (request.getParameter("minPrice") != "") {
        minPrice = Double.parseDouble(request.getParameter("minPrice"));
    }

    int minCapacity = 1;
    if (request.getParameter("capacity") != "") {
        minCapacity = Integer.parseInt(request.getParameter("capacity"));
    }

    //Get HotelRooms of the Hotel
    HotelRoomService service = new HotelRoomService();
    List<HotelRoom> res = service.getAvailableRoomsOfHotel(hotelID);

    //Return list
    ArrayList<HotelRoom> availableRooms = new ArrayList<HotelRoom>();

    //Filter by all queries
    for (HotelRoom r : res) {

        //If hotel room meets min price filter
        if (minPrice <= r.getPrice()) {

            //If hotel meets min capacity filter
            if (minCapacity <= r.getCapacityOfRoom()) {

                //Then add h to the hotels to return
                availableRooms.add(r);
            }
        }
    }


     // check where to redirect
     try {
         request.getSession().setAttribute("filteredRooms", availableRooms);
         response.sendRedirect("room-select.jsp");
     } catch (Exception e) {
         e.printStackTrace();
     }
%>
