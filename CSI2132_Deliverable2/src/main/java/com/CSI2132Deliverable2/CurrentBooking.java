package com.CSI2132Deliverable2;

import java.util.*;//CAN IMPORT THIS BUT NOT java.util.Date?

public class CurrentBooking {

    /*
     * VARIABLES
     */
    private String hotelName;
    private int bookingID;
    private int roomID;
    private Date startDate;
    private Date endDate;
    private double cost;
    private BookingStatus bookingStatus;
    private String paymentMethod;
    private boolean isPaid;
    private String roomAmenities;
    private String roomView;
    private String roomProblemsOrDamages;

    /*
     * CONSTRUCTORS
     */
    public CurrentBooking(String hN, int bID, int rID, Date sDate, Date eDate, double cost, BookingStatus status, String method, boolean iP, String amenities, String viewFromRoom, String problemsOrDamages) {
        setHotelName(hN);
        setBookingID(bID);
        setRoomID(rID);
        setStartDate(sDate);
        setEndDate(eDate);
        setCost(cost);
        setBookingStatus(status);
        setPaymentMethod(method);
        setIsPaid(iP);
        setRoomAmenities(amenities);
        setRoomView(viewFromRoom);
        setRoomProblemsOrDamages(problemsOrDamages);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getHotelName() {return this.hotelName;}
    public void setHotelName(String hN) {this.hotelName = hN;}

    public int getBookingID() {return this.bookingID;}
    public void setBookingID(int bID) {this.bookingID = bID;}

    public int getRoomID() {return this.roomID;}
    public void setRoomID(int rID) {this.roomID = rID;}

    public Date getStartDate() {return this.startDate;}
    public void setStartDate(Date sDate) {this.startDate = sDate;}

    public Date getEndDate() {return this.endDate;}
    public void setEndDate(Date eDate) {this.endDate = eDate;}

    public double getCost() {return this.cost;}
    public void setCost(double cost) {this.cost = cost;}

    public BookingStatus getBookingStatus() {return this.bookingStatus;}
    public void setBookingStatus(BookingStatus status) {this.bookingStatus = status;}

    public String getPaymentMethod() {return this.paymentMethod;}
    public void setPaymentMethod(String method) {this.paymentMethod = method;}

    public boolean getIsPaid() {return this.isPaid;}
    public void setIsPaid(boolean iP) {this.isPaid = iP;}

    public String getRoomAmenities() {return this.roomAmenities;}
    public void setRoomAmenities(String rA) {this.roomAmenities = rA;}

    public String getRoomView() {return this.roomView;}
    public void setRoomView(String rV) {this.roomView = rV;}

    public String getRoomProblemsOrDamages() {return this.roomProblemsOrDamages;}
    public void setRoomProblemsOrDamages(String rPOD) {this.roomProblemsOrDamages = rPOD;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>booking= " + this.getHotelName() + "</li>"
                + "<li>booking= " + this.getBookingID() + "</li>"
                + "<li>booking= " + this.getRoomID() + "</li>"
                + "<li>booking= " + this.getStartDate().toString() + "</li>"
                + "<li>booking= " + this.getEndDate().toString() + "</li>"
                + "<li>booking= " + this.getCost() + "</li>"
                + "<li>booking= " + this.getBookingStatus().name() + "</li>"
                + "<li>booking= " + this.getPaymentMethod() + "</li>"
                + "<li>booking= " + this.getIsPaid() + "</li>"
                + "<li>booking= " + this.getRoomAmenities() + "</li>"
                + "<li>booking= " + this.getRoomView() + "</li>"
                + "<li>booking= " + this.getRoomProblemsOrDamages() + "</li>";
    }

}
