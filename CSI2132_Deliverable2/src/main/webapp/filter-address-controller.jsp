<%@ page import="com.CSI2132Deliverable2.Message" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.CSI2132Deliverable2.Hotel" %>
<%@ page import="com.CSI2132Deliverable2.HotelService" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

    // get customer info from the request
    String addressFilter = request.getParameter("address");
    String hotelChainFilter = request.getParameter("hotelChainName");

    int minRating = 1;
    if (request.getParameter("rating") != "") {
        minRating = Integer.parseInt(request.getParameter("rating"));
    }

    int minNumOfAvailableRooms = 1;
    if (request.getParameter("numberOfRooms") != "") {
        minNumOfAvailableRooms = Integer.parseInt(request.getParameter("numberOfRooms"));
    }


    //Get hotels filtered by address
    HotelService hotelService = new HotelService();
    List<Hotel> res = hotelService.getAvailableHotels(addressFilter);

    //Return list
    ArrayList<Hotel> availableHotels = new ArrayList<Hotel>();

    //Filter by all queries
    for (Hotel h : res) {
        //If hotel meets hotel chain filter
        if (hotelChainFilter == null || hotelChainFilter.isEmpty() || h.getHotelChainID().toLowerCase().contains(hotelChainFilter.toLowerCase())) {

            //If hotel meets min rating filter
            if (minRating <= h.getRating()) {

                //If hotel meets minNumOfAvailableRooms filter
                if (minNumOfAvailableRooms <= h.getNumberOfRooms()) {
                    //Then add h to the hotels to return
                    availableHotels.add(h);
                }
            }
        }
    }


     // check where to redirect
     try {
         request.getSession().setAttribute("filteredHotels", availableHotels);
         response.sendRedirect("customer-homepage.jsp");
     } catch (Exception e) {
         e.printStackTrace();
     }
%>
