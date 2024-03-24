package com.CSI2132Deliverable2;

public class EmailAddress {

    /*
     * VARIABLES
     */
    private int emailAddressID;
    private String emailAddressString;

    /*
     * CONSTRUCTORS
     */
    public EmailAddress(int eaID, String eaS) {
        setEmailAddressID(eaID);
        setEmailAddressString(eaS);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getEmailAddressID() {return emailAddressID;}

    public void setEmailAddressID(int eaID) {this.emailAddressID = eaID;}

    public int getEmailAddressString() {return emailAddressString;}
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
