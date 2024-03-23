CREATE TABLE HotelChain (
    hotelChainID VARCHAR(50), PRIMARY KEY(hotelChainID),
    addressOfCentralOffices VARCHAR(50),
    numberOfHotels INT,
    emailAddressID INT, --REFERENCES(), --FILL THIS FOREIGN KEY REFERENCE
    phoneNumberID INT  --,REFERENCE() --FILL THIS FOREIGN KEY REFERENCE
);