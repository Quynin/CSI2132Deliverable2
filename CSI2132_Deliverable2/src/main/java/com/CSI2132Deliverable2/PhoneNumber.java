package com.CSI2132Deliverable2;

public class PhoneNumber {

    /*
     * VARIABLES
     */
    private int phoneNumberID;
    private String phoneNumberString;

    /*
     * CONSTRUCTORS
     */
    public PhoneNumber(int pnID, String pnS) {
        setPhoneNumberID(pnID);
        setPhoneNumberString(pnS);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getPhoneNumberID() {return this.phoneNumberID;}
    public void setPhoneNumberID(int pnID) {this.phoneNumberID = pnID;}

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
