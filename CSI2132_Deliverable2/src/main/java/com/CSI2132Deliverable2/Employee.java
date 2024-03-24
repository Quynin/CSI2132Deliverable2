package com.CSI2132Deliverable2;

public class Employee extends Person {

    /*
     * VARIABLES
     */
    private int hotelID;
    private String role;

    /*
     * CONSTRUCTORS
     */
    public Employee(String id, String idType, String name, String address, int hID, String role) {
        super(id, idType, name, address);
        setHotelID(hID);
        setRole(role);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getHotelID() {return this.hotelID;}
    public void setHotelID(int hID) {this.hotelID = hID;}

    public String getRole() {return this.role;}
    public void setRole(String role) {this.role = role;}

    /*
     * METHODS
     */
    @Override
    public String toString() {
        return super.toString()
              + "<li>employee= " + this.getHotelID() + "</li>"
              + "<li>employee= " + this.getRole() + "</li>";
    }


}
