package com.CSI2132Deliverable2;

public class TotalCapacityOfHotel {


    /*
     * VARIABLES
     */
    private int hotelID;
    private String hotelChainID;
    private String hotelAddress;
    private int hotelCapacity;

    /*
     * CONSTRUCTORS
     */
    public TotalCapacityOfHotel(int hID, String hcID, String address, int capacity) {
        setHotelID(hID);
        setHotelChainID(hcID);
        setHotelAddress(address);
        setHotelCapacity(capacity);

    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getHotelID() {return this.hotelID;}
    public void setHotelID(int hID) {this.hotelID = hID;}

    public String getHotelChainID() {return this.hotelChainID;}
    public void setHotelChainID(String hcID) {this.hotelChainID = hcID;}

    public String getHotelName() {return this.getHotelChainID() + " on " + this.getHotelAddress();}

    public String getHotelAddress() {return this.hotelAddress;}
    public void setHotelAddress(String address) {this.hotelAddress = address;}

    public int getHotelCapacity() {return this.hotelCapacity;}
    public void setHotelCapacity(int capacity) {this.hotelCapacity = capacity;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotel= " + this.getHotelID() + "</li>"
                + "<li>hotel= " + this.getHotelName() + "</li>"
                + "<li>hotel= " + this.getHotelCapacity() + "</li>";
    }
}
