package com.CSI2132Deliverable2;

public class HotelChain {

    /*
    * VARIABLES
     */
    private String hotelChainID;
    private String addressOfCentralOffices;
    private int numberOfHotels;
    private int emailAddressID;
    private int phoneNumberID;

    /*
    * CONSTRUCTORS
     */
    public HotelChain(String hcID, String aOCO, int nOH, int eaID, int pnID) {
        setHotelChainID(hcID);
        setAddressOfCentralOffices(aOCO);
        setNumberOfHotels(nOH);
        setEmailAddressID(eaID);
        setPhoneNumberID(pnID);
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

    public int getEmailAddressID() {return this.emailAddressID;}
    public void setEmailAddressID(int eaID) {this.emailAddressID = eaID;}

    public int getPhoneNumberID() {return this.phoneNumberID;}
    public void setPhoneNumberID(int pnID) {this.phoneNumberID = pnID;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotelChain= " + this.getHotelChainID() + "</li>"
                + "<li>hotelChain= " + this.getAddressOfCentralOffices() + "</li>"
                + "<li>hotelChain= " + this.getNumberOfHotels() + "</li>"
                + "<li>hotelChain= " + this.getEmailAddressID() + "</li>"
                + "<li>hotelChain= " + this.getPhoneNumberID() + "</li>";
    }

}
