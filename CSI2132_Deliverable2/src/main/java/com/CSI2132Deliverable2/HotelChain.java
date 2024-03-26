package com.CSI2132Deliverable2;

public class HotelChain {

    /*
    * VARIABLES
     */
    private String hotelChainID;
    private String addressOfCentralOffices;
    private int numberOfHotels;

    /*
    * CONSTRUCTORS
     */
    public HotelChain(String hcID, String aOCO, int nOH) {
        setHotelChainID(hcID);
        setAddressOfCentralOffices(aOCO);
        setNumberOfHotels(nOH);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getHotelChainID() {return this.hotelChainID;}
    public void setHotelChainID(String hcID) {this.hotelChainID = hcID;}

    public String getAddressOfCentralOffices() {return this.addressOfCentralOffices;}
    public void setAddressOfCentralOffices(String aOCO) {this.addressOfCentralOffices = aOCO;}

    public int getNumberOfHotels() {return this.numberOfHotels;}
    public void setNumberOfHotels(int nOH) {this.numberOfHotels = nOH;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotelChain= " + this.getHotelChainID() + "</li>"
                + "<li>hotelChain= " + this.getAddressOfCentralOffices() + "</li>"
                + "<li>hotelChain= " + this.getNumberOfHotels() + "</li>";
    }

}
