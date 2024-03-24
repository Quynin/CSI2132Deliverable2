package com.CSI2132Deliverable2;

import java.util.*;//CAN IMPORT THIS BUT NOT java.util.Date?

public class Customer extends Person {

    /*
     * VARIABLES
     */
    private Date registrationDate; //FIND Date LIBRARY

    /*
     * CONSTRUCTORS
     */
    public Customer(String id, String idType, String name, String address, Date rDate) {
        super(id, idType, name, address);
        setRegistrationDate(rDate);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public Date getRegistrationDate() {return this.registrationDate;}
    public void setRegistrationDate(Date rDate) {this.registrationDate = rDate;}

    /*
     * METHODS
     */
    @Override
    public String toString() {
        return super.toString()
                + "<li>customer= " + this.getRegistrationDate().toString() + "</li>";
    }

}
