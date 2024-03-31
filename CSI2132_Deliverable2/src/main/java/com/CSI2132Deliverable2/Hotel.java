package com.CSI2132Deliverable2;

import java.util.List;

public class Hotel {

    /*
     * VARIABLES
     */
    private int hotelID;
    private String hotelChainID;
    private int rating;
    private String hotelAddress;
    private int numberOfRooms;
    private String managerID;
    private List<HotelPhoneNumber> hotelPhoneNumberList;
    private List<HotelEmailAddress> hotelEmailAddressList;

    /*
     * CONSTRUCTORS
     */
    public Hotel(String hcID, int rating, String address, String mID, List<HotelPhoneNumber> hPNL, List<HotelEmailAddress> hEAL) {
        setHotelChainID(hcID);
        setRating(rating);
        setHotelAddress(address);
        setManagerID(mID);
        setHotelPhoneNumberList(hPNL);
        setHotelEmailAddressList(hEAL);
    }

    public Hotel(int hID, String hcID, int rating, String address, int nOR, String mID, List<HotelPhoneNumber> hPNL, List<HotelEmailAddress> hEAL) {
        setHotelID(hID);
        setHotelChainID(hcID);
        setRating(rating);
        setHotelAddress(address);
        setNumberOfRooms(nOR);
        setManagerID(mID);
        setHotelPhoneNumberList(hPNL);
        setHotelEmailAddressList(hEAL);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getHotelID() {return this.hotelID;}
    public void setHotelID(int hID) {this.hotelID = hID;}

    public String getHotelChainID() {return this.hotelChainID;}
    public void setHotelChainID(String hcID) {this.hotelChainID = hcID;}

    public String getHotelName() {return this.getHotelChainID() + " on " + this.getHotelAddress();}

    public int getRating() {return this.rating;}
    public void setRating(int rating) {this.rating = rating;}

    public String getHotelAddress() {return this.hotelAddress;}
    public void setHotelAddress(String address) {this.hotelAddress = address;}

    public int getNumberOfRooms() {return this.numberOfRooms;}
    public void setNumberOfRooms(int nOR) {this.numberOfRooms = nOR;}

    public String getManagerID() {return this.managerID;}
    public void setManagerID(String mID) {this.managerID = mID;}

    public List<HotelPhoneNumber> getHotelPhoneNumberList() {return this.hotelPhoneNumberList;}
    public void setHotelPhoneNumberList(List<HotelPhoneNumber> list) {this.hotelPhoneNumberList = list;}

    public List<HotelEmailAddress> getHotelEmailAddressList() {return this.hotelEmailAddressList;}
    public void setHotelEmailAddressList(List<HotelEmailAddress> list) {this.hotelEmailAddressList = list;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotel= " + this.getHotelID() + "</li>"
                + "<li>hotel= " + this.getHotelChainID() + "</li>"
                + "<li>hotel= " + this.getHotelName() + "</li>"
                + "<li>hotel= " + this.getRating() + "</li>"
                + "<li>hotel= " + this.getHotelAddress() + "</li>"
                + "<li>hotel= " + this.getNumberOfRooms() + "</li>"
                + "<li>hotel= " + this.getManagerID() + "</li>"
                + "<li>hotel= " + this.getHotelPhoneNumberList() + "</li>"
                + "<li>hotel= " + this.getHotelEmailAddressList() + "</li>";
    }

}
