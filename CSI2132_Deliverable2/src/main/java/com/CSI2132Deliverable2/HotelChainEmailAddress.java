package com.CSI2132Deliverable2;

public class HotelChainEmailAddress {

    /*
     * VARIABLES
     */
    private String emailAddressID;
    private String emailAddressString;

    /*
     * CONSTRUCTORS
     */
    public HotelChainEmailAddress(String eaID, String eaS) {
        setEmailAddressID(eaID);
        setEmailAddressString(eaS);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getEmailAddressID() {return emailAddressID;}
    public void setEmailAddressID(String eaID) {this.emailAddressID = eaID;}

    public String getEmailAddressString() {return emailAddressString;}
    public void setEmailAddressString(String eaS) {this.emailAddressString = eaS;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>emailAddress= " + this.getEmailAddressID() + "</li>"
                + "<li>emailAddress= " + this.getEmailAddressString() + "</li>";
    }

}
