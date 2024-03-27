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

    /**
     * Constructor for without rDate
     *
     * @param id String id of the Customer
     * @param idType String type of the ID (e.g: SIN or SSN)
     * @param name String name of the Customer
     * @param address String address of the Customer
     */
    public Customer(String id, String idType, String name, String address) {
        super(id, idType, name, address);
    }

    /**
     * Constructor for with rDate
     *
     * @param id String id of the Customer
     * @param idType String type of the ID (e.g: SIN or SSN)
     * @param name String name of the Customer
     * @param address String address of the Customer
     * @param rDate Date of registration
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
        if (this.getRegistrationDate() == null) { //If no registration date to print
            return super.toString();
        } else { //If there is a registration date to print
            return super.toString()
                    + "<li>customer= " + this.getRegistrationDate().toString() + "</li>";
        }
    }

}
