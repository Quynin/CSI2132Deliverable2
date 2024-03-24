package com.CSI2132Deliverable2;

public class Hotel {

    /*
     * VARIABLES
     */
    private int hotelID;
    private String hotelChainID;
    private int rating;
    private String address;
    private int numberOfRooms;
    private int emailAddressID;
    private int phoneNumberID;
    private String managerID;

    /*
     * CONSTRUCTORS
     */
    public Hotel(int hID, String hcID, int rating, String address, int nOR, int eaID, int pnID, String mID) {
        setHotelID(hID);
        setHotelChainID(hcID);
        setRating(rating);
        setAddress(address);
        setNumberOfRooms(nOR);
        setEmailAddressID(eaID);
        setPhoneNumberID(pnID);
        setManagerID(mID);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getHotelID() {return this.hotelID;}
    public void setHotelID(int hID) {this.hotelID = hID;}

    public String getHotelChainID() {return this.hotelChainID;}
    public void setHotelChainID(String hcID) {this.hotelChainID = hcID;}

    public int getRating() {return this.rating;}
    public void setRating(int rating) {this.rating = rating;}

    public String getAddress() {return this.address;}
    public void setAddress(String address) {this.address = address;}

    public int getNumberOfRooms() {return this.numberOfRooms;}
    public void setNumberOfRooms(int nOR) {this.numberOfRooms = nOR;}

    public int getEmailAddressID() {return this.emailAddressID;}
    public void setEmailAddressID(int eaID) {this.emailAddressID = eaID;}

    public int getPhoneNumberID() {return this.phoneNumberID;}
    public void setPhoneNumberID(int pnID) {this.phoneNumberID = pnID;}

    public String getManagerID() {return this.managerID;}
    public void setManagerID(String mID) {this.managerID = mID;}
    
    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotel= " + this.getHotelID() + "</li>"
                + "<li>hotel= " + this.getHotelChainID() + "</li>"
                + "<li>hotel= " + this.getRating() + "</li>"
                + "<li>hotel= " + this.getAddress() + "</li>"
                + "<li>hotel= " + this.getNumberOfRooms() + "</li>"
                + "<li>hotel= " + this.getEmailAddressID() + "</li>"
                + "<li>hotel= " + this.getPhoneNumberID() + "</li>"
                + "<li>hotel= " + this.getManagerID() + "</li>";
    }

}
