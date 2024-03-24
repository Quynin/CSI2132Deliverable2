package com.CSI2132Deliverable2;

public class Person {

    /*
     * VARIABLES
     */
    private String ID;
    private String IDType;
    private String fullName; //POSSIBLY SPLIT INTO fName, mName, & lName?
    private String address;

    /*
     * CONSTRUCTORS
     */
    public Person(String id, String idType, String name, String address) {
        setID(id);
        setIDType(idType);
        setFullName(name);
        setAddress(address);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getID() {return this.ID;}
    public void setID(String id) {this.ID = id;}

    public String getIDType() {return this.IDType;}
    public void setIDType(String idType) {this.IDType = idType;}

    public String getFullName() {return this.fullName;}
    public void setFullName(String name) {this.fullName = name;}

    public String getAddress() {return this.address;}
    public void setAddress(String address) {this.address = address;}

    /*
     * METHODS
     */
    @Override
    public String toString() {
        return "<hl>"
                + "<li>person= " + this.getID() + "</li>"
                + "<li>person= " + this.getIDType() + "</li>"
                + "<li>person= " + this.getFullName() + "</li>"
                + "<li>person= " + this.getAddress() + "</li>";
    }

}
