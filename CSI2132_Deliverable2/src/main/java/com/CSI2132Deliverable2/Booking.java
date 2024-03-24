package com.CSI2132Deliverable2;

import java.util.*;//CAN IMPORT THIS BUT NOT java.util.GregorianCalendar?

public class Booking {

    /*
     * VARIABLES
     */
    private int bookingID;
    private int roomID;
    private String customerID;
    private GregorianCalendar startDate;
    private GregorianCalendar endDate;
    private double cost;
    private BookingStatus status;

    /*
     * CONSTRUCTORS
     */
	public Booking(int bID, int rID, String cID, GregorianCalendar sDate, GregorianCalendar eDate, double cost, BookingStatus status) {
		setBookingID(bID);
		setRoomID(rID);
		setCustomerID(cID);
		setStartDate(sDate);
		setEndDate(eDate);
		setCost(cost);
		setBookingStatus(status);
	}

    /*
     * ACCESSORS & MODIFIERS
     */
	public int getBookingID() {return this.bookingID;}
	public void setBookingID(int bID) {this.bookingID = bID;}
	
	public int getRoomID() {return this.roomID;}
	public void setRoomID(int rID) {this.roomID = rID;}
	
	public String getCustomerID() {return this.customerID;}
	public void setCustomerID(String cID) {this.customerID = cID;}
	
	public GregorianCalendar getStartDate() {return this.startDate;}
	public void setStartDate(GregorianCalendar sDate) {this.startDate = sDate;}
	
	public GregorianCalendar getEndDate() {return this.endDate;}
	public void setEndDate(GregorianCalendar eDate) {this.endDate = eDate;}
	
	public double getCost() {return this.cost;}
	public void setCost(double cost) {this.cost = cost;}
	
	public BookingStatus getBookingStatus() {return this.status;}
	public void setBookingStatus(BookingStatus status) {this.status = status;}

    /*
     * METHODS
     */
	public String toString() {
		return "<ul>"
				+ "<li>booking= " + this.getBookingID() + "</li>"
				+ "<li>booking= " + this.getRoomID() + "</li>"
				+ "<li>booking= " + this.getCustomerID() + "</li>"
				+ "<li>booking= " + this.getStartDate().toString() + "</li>"
				+ "<li>booking= " + this.getEndDate().toString() + "</li>"
				+ "<li>booking= " + this.getCost() + "</li>"
				+ "<li>booking= " + this.getBookingStatus().name() + "</li>";
	}

}
