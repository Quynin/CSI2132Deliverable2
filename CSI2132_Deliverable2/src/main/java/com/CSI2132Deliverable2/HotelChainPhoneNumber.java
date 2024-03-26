package com.CSI2132Deliverable2;

public class HotelChainPhoneNumber {

    /*
     * VARIABLES
     */
    private String phoneNumberID;
    private String phoneNumberString;

    /*
     * CONSTRUCTORS
     */
    public HotelChainPhoneNumber(String pnID, String pnS) {
        setPhoneNumberID(pnID);
        setPhoneNumberString(pnS);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getPhoneNumberID() {return this.phoneNumberID;}
    public void setPhoneNumberID(String pnID) {this.phoneNumberID = pnID;}

    public String getPhoneNumberString() {return this.phoneNumberString;}
    public void setPhoneNumberString(String pnS) {this.phoneNumberString = pnS;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>phoneNumber= " + this.getPhoneNumberID() + "</li>"
                + "<li>phoneNumber= " + this.getPhoneNumberString() + "</li>";
    }

}
