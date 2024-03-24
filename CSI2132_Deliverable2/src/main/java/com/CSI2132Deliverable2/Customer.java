package com.CSI2132Deliverable2;

import java.util.*;//CAN IMPORT THIS BUT NOT java.util.GregorianCalendar?

public class Customer extends Person {

    /*
     * VARIABLES
     */
    private GregorianCalendar registrationDate; //FIND Date LIBRARY

    /*
     * CONSTRUCTORS
     */
    public Customer(String id, String idType, String name, String address, GregorianCalendar rDate) {
        super(id, idType, name, address);
        setRegistrationDate(rDate);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public GregorianCalendar getRegistrationDate() {return this.registrationDate;}
    public void setRegistrationDate(GregorianCalendar rDate) {this.registrationDate = rDate;}

    /*
     * METHODS
     */
    @Override
    public String toString() {
        return super.toString()
                + "<li>customer= " + this.getRegistrationDate().toString() + "</li>";
    }

}
