package com.CSI2132Deliverable2;

public class HotelRoom {

    /*
     * VARIABLES
     */
    private int hotelID;
    private int roomID;
    private double price;
    private String amenities;
    private int capacityOfRoom;
    private String viewFromRoom;
    private boolean isExtendable;
    private String problemsOrDamages;

    /*
     * CONSTRUCTORS
     */
    public HotelRoom(int hID, int rID, double price, String amenities, int cOR, String vFR, boolean iE, String pOD) {
        setHotelID(hID);
        setRoomID(rID);
        setPrice(price);
        setAmenties(amenities);
        setCapacityOfRoom(cOR);
        setViewFromRoom(vFR);
        setIsExtendable(iE);
        setProblemsOrDamages(pOD);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public int getHotelID() {return this.hotelID;}
    public void setHotelID(int hID) {this.hotelID = hID;}

    public int getRoomID() {return this.roomID;}
    public void setRoomID(int rID) {this.roomID = rID;}

    public double getPrice() {return this.price;}
    public void setPrice(double price) {this.price = price;}

    public String getAmenities() {return this.amenities;}
    public void setAmenties(String amenities) {this.amenities = amenities;}

    public int getCapacityOfRoom() {return this.capacityOfRoom;}
    public void setCapacityOfRoom(int cOR) {this.capacityOfRoom = cOR;}

    public String getViewFromRoom() {return this.viewFromRoom;}
    public void setViewFromRoom(String vFR) {this.viewFromRoom = vFR;}

    public boolean getIsExtendable() {return this.isExtendable;}
    public void setIsExtendable(boolean iE) {this.isExtendable = iE;}

    public String getProblemsOrDamages() {return this.problemsOrDamages;}
    public void setProblemsOrDamages(String pOD) {this.problemsOrDamages = pOD;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotelRoom= " + this.getHotelID() + "</li>"
                + "<li>hotelRoom= " + this.getRoomID() + "</li>"
                + "<li>hotelRoom= " + this.getPrice() + "</li>"
                + "<li>hotelRoom= " + this.getAmenities() + "</li>"
                + "<li>hotelRoom= " + this.getCapacityOfRoom() + "</li>"
                + "<li>hotelRoom= " + this.getViewFromRoom() + "</li>"
                + "<li>hotelRoom= " + this.getIsExtendable() + "</li>"
                + "<li>hotelRoom= " + this.getProblemsOrDamages() + "</li>";
    }

}
