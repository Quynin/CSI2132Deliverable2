package com.CSI2132Deliverable2;

import java.util.List;

public class HotelChain {

    /*
    * VARIABLES
     */
    private String hotelChainID;
    private String addressOfCentralOffices;
    private int numberOfHotels;
    private List<HotelChainPhoneNumber> hotelChainPhoneNumberList;
    private List<HotelChainEmailAddress> hotelChainEmailAddressList;

    /*
    * CONSTRUCTORS
     */
    public HotelChain(String hcID, String aOCO, int nOH, List<HotelChainPhoneNumber> hCPNL, List<HotelChainEmailAddress> hCEAL) {
        setHotelChainID(hcID);
        setAddressOfCentralOffices(aOCO);
        setNumberOfHotels(nOH);
        setHotelChainPhoneNumberList(hCPNL);
        setHotelChainEmailAddressList(hCEAL);
    }

    /*
     * ACCESSORS & MODIFIERS
     */
    public String getHotelChainID() {return this.hotelChainID;}
    public void setHotelChainID(String hcID) {this.hotelChainID = hcID;}

    public String getAddressOfCentralOffices() {return this.addressOfCentralOffices;}
    public void setAddressOfCentralOffices(String aOCO) {this.addressOfCentralOffices = aOCO;}

    public int getNumberOfHotels() {return this.numberOfHotels;}
    public void setNumberOfHotels(int nOH) {this.numberOfHotels = nOH;}

    public List<HotelChainPhoneNumber> getHotelChainPhoneNumberList() {return this.hotelChainPhoneNumberList;}
    public void setHotelChainPhoneNumberList(List<HotelChainPhoneNumber> list) {this.hotelChainPhoneNumberList = list;}

    public List<HotelChainEmailAddress> getHotelChainEmailAddressList() {return this.hotelChainEmailAddressList;}
    public void setHotelChainEmailAddressList(List<HotelChainEmailAddress> list) {this.hotelChainEmailAddressList = list;}

    /*
     * METHODS
     */
    public String toString() {
        return "<ul>"
                + "<li>hotelChain= " + this.getHotelChainID() + "</li>"
                + "<li>hotelChain= " + this.getAddressOfCentralOffices() + "</li>"
                + "<li>hotelChain= " + this.getNumberOfHotels() + "</li>"
                + "<li>hotelChain= " + this.getHotelChainPhoneNumberList() + "</li>"
                + "<li>hotelChain= " + this.getHotelChainEmailAddressList() + "</li>";
    }

}
