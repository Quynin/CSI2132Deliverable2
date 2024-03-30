package com.CSI2132Deliverable2;

import java.util.*;//CAN IMPORT THIS BUT NOT java.util.Date?

public class Booking {

    /*
     * VARIABLES
     */
    private int bookingID;
    private int roomID;
    private String customerID;
    private Date startDate;
    private Date endDate;
    private double cost;
    private BookingStatus bookingStatus;
	private String paymentMethod;
	private boolean isPaid;

    /*
     * CONSTRUCTORS
     */
	public Booking( int rID, String cID, Date sDate, Date eDate, double cost, BookingStatus status, String method, boolean iP) {
		setRoomID(rID);
		setCustomerID(cID);
		setStartDate(sDate);
		setEndDate(eDate);
		setCost(cost);
		setBookingStatus(status);
		setPaymentMethod(method);
		setIsPaid(iP);
	}

	public Booking(int bID, int rID, String cID, Date sDate, Date eDate, double cost, BookingStatus status, String method, boolean iP) {
		setBookingID(bID);
		setRoomID(rID);
		setCustomerID(cID);
		setStartDate(sDate);
		setEndDate(eDate);
		setCost(cost);
		setBookingStatus(status);
		setPaymentMethod(method);
		setIsPaid(iP);
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
				+ "<li>booking= " + this.getBookingStatus().name() + "</li>"
				+ "<li>booking= " + this.getPaymentMethod() + "</li>"
				+ "<li>booking= " + this.getIsPaid() + "</li>";
	}

}
