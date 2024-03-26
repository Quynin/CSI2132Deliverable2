create domain non_neg INT
constraint non_neg_test
check(value >= 0);

create domain non_neg_double NUMERIC(8, 2)
constraint non_neg_payment
check(value >= 0);

CREATE TABLE EmailAddress (
    emailAddressID non_neg, PRIMARY KEY(emailAddressID),
    emailAddressString VARCHAR(50) NOT NULL
);

CREATE TABLE PhoneNumber (
    phoneNumberID non_neg, PRIMARY KEY(phoneNumberID),
    phoneNumberString VARCHAR(20) NOT NULL
);

CREATE TABLE Person (
    personID VARCHAR(20), PRIMARY KEY(personID),
    personIDType VARCHAR(20) NOT NULL,
    personFullName VARCHAR(40) NOT NULL,
    personAddress VARCHAR(50)
);

CREATE TABLE HotelChain (
    hotelChainID VARCHAR(50), PRIMARY KEY(hotelChainID),
    addressOfCentralOffices VARCHAR(50),
    numberOfHotels non_neg DEFAULT 0,
    emailAddressID non_neg, FOREIGN KEY(emailAddressID) REFERENCES EmailAddress(emailAddressID),
    phoneNumberID non_neg, FOREIGN KEY(phoneNumberID) REFERENCES PhoneNumber(phoneNumberID)
);

CREATE TABLE Hotel (
    hotelID non_neg, PRIMARY KEY(hotelID),
    hotelChainID VARCHAR(50), FOREIGN KEY(hotelChainID) REFERENCES HotelChain(hotelChainID),
    rating INT check((1 <= rating) and (rating <= 10)),
    hotelAddress VARCHAR(50),
    numberOfRooms non_neg DEFAULT 0,
    emailAddressID non_neg, FOREIGN KEY(emailAddressID) REFERENCES EmailAddress(emailAddressID),
    phoneNumberID non_neg, FOREIGN KEY(phoneNumberID) REFERENCES PhoneNumber(phoneNumberID),
    managerID VARCHAR(20), FOREIGN KEY(managerID) REFERENCES Person(personID));

CREATE TABLE HotelRoom (
	roomID non_neg UNIQUE,
    hotelID non_neg, PRIMARY KEY(hotelID, roomID), FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID),
    price non_neg_double NOT NULL, 
    amenities VARCHAR(200),
    capacityOfRoom non_neg NOT NULL,
    viewFromRoom VARCHAR(50),
    isExtendable boolean,
    problemsOrDamages VARCHAR(200)
);

CREATE TABLE Booking (
    bookingID non_neg, PRIMARY KEY(bookingID),
    roomID non_neg, FOREIGN KEY(roomID) REFERENCES HotelRoom(roomID),
    customerID VARCHAR(20), FOREIGN KEY(customerID) REFERENCES Person(personID),
    startDate DATE check(startDate < endDate),
    endDate DATE check(endDate > startDate),
    bookingCost non_neg_double NOT NULL, 
    bookingStatus VARCHAR(20) check (bookingStatus IN ('Booking', 'Renting', 'Archived')) 
);

CREATE TABLE Customer (
    customerID VARCHAR(20), PRIMARY KEY(customerID), FOREIGN KEY(customerID) REFERENCES Person(personID),
    registrationDate DATE NOT NULL
);

CREATE TABLE Employee (
    employeeID VARCHAR(20), PRIMARY KEY(employeeID), FOREIGN KEY(employeeID) REFERENCES Person(personID),
    hotelID non_neg, FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID),
    employeeRole VARCHAR(20)
);

/*
INSERT INTO EmailAddress
VALUES
(001, 'quinn.slavish@gmail.com');

INSERT INTO PhoneNumber
VALUES
(001, '613-276-8648');

INSERT INTO HotelChain
VALUES
('TestHotels', 'Street 123', 5, 001, 001);

SELECT * FROM HotelChain;

INSERT INTO PERSON
VALUES
('123987654','SIN', 'First Lastname', '456 Street'),
('1234', 'SSN', 'Lastfirst Name', '457 Street');
SELECT * FROM Person;

INSERT INTO Customer
VALUES
('123987654', '2024-3-25');

INSERT INTO Employee
VALUES
('1234', null, 'FIRED');

SELECT * FROM Customer;

SELECT * FROM Person p JOIN Customer c ON p.personID = c.customerID;
SELECT * FROM Person p JOIN Employee e ON p.personID = e.employeeID;
*/