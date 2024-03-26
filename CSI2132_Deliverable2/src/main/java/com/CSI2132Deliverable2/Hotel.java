package com.CSI2132Deliverable2;

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

    /*
     * CONSTRUCTORS
     */
    public Hotel(int hID, String hcID, int rating, String address, int nOR, String mID) {
        setHotelID(hID);
        setHotelChainID(hcID);
        setRating(rating);
        setHotelAddress(address);
        setNumberOfRooms(nOR);
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

    public String getHotelAddress() {return this.hotelAddress;}
    public void setHotelAddress(String address) {this.hotelAddress = address;}

    public int getNumberOfRooms() {return this.numberOfRooms;}
    public void setNumberOfRooms(int nOR) {this.numberOfRooms = nOR;}

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
                + "<li>hotel= " + this.getHotelAddress() + "</li>"
                + "<li>hotel= " + this.getNumberOfRooms() + "</li>"
                + "<li>hotel= " + this.getManagerID() + "</li>";
    }

}
