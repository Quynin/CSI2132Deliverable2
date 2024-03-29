package com.CSI2132Deliverable2;

public class NumberOfAvailableHotelRoomsOnStreet {


    /*
     * VARIABLES
     */
    private String area;
    private int numberOfAvailableRooms;

    /*
     * CONSTRUCTORS
     */
    public NumberOfAvailableHotelRoomsOnStreet(String area, int numberOfAvailableRooms) {
       setArea(area);
       setNumberOfAvailableRooms(numberOfAvailableRooms);

    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getArea() {return this.area;}
    public void setArea(String a) {this.area = a;}

    public int getNumberOfAvailableRooms() {return this.numberOfAvailableRooms;}
    public void setNumberOfAvailableRooms(int nOAR) {this.numberOfAvailableRooms = nOAR;}


    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotel= " + this.getArea() + "</li>"
                + "<li>hotel= " + this.getNumberOfAvailableRooms() + "</li>";
    }
}
