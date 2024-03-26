create domain non_neg INT
constraint non_neg_test
check(value >= 0);

create domain non_neg_double NUMERIC(8, 2)
constraint non_neg_payment
check(value >= 0);

CREATE TABLE Person (
    personID VARCHAR(20), PRIMARY KEY(personID),
    personIDType VARCHAR(20) NOT NULL,
    personFullName VARCHAR(40) NOT NULL,
    personAddress VARCHAR(50)
);

CREATE TABLE HotelChain (
	hotelChainID VARCHAR(50), PRIMARY KEY(hotelChainID),
    addressOfCentralOffices VARCHAR(50),
    numberOfHotels non_neg DEFAULT 0
);

CREATE TABLE Hotel (
    hotelID SERIAL, PRIMARY KEY(hotelID),
    hotelChainID VARCHAR(50), FOREIGN KEY(hotelChainID) REFERENCES HotelChain(hotelChainID),
    rating INT check((1 <= rating) and (rating <= 10)),
    hotelAddress VARCHAR(50),
    numberOfRooms non_neg DEFAULT 0,
    managerID VARCHAR(20), FOREIGN KEY(managerID) REFERENCES Person(personID));

CREATE TABLE HotelRoom (
	roomID SERIAL UNIQUE,
    hotelID non_neg, PRIMARY KEY(hotelID, roomID), FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID),
    price non_neg_double NOT NULL, 
    amenities VARCHAR(200),
    capacityOfRoom non_neg NOT NULL,
    viewFromRoom VARCHAR(50),
    isExtendable boolean,
    problemsOrDamages VARCHAR(200)
);

CREATE TABLE Booking (
    bookingID SERIAL, PRIMARY KEY(bookingID),
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

CREATE TABLE HotelEmailAddress (
    emailAddressID non_neg, FOREIGN KEY(emailAddressID) REFERENCES Hotel(hotelID),
    emailAddressString VARCHAR(50),
    PRIMARY KEY(emailAddressID, emailAddressString)
);
CREATE TABLE HotelChainEmailAddress (
    emailAddressID VARCHAR(50), FOREIGN KEY(emailAddressID) REFERENCES HotelChain(hotelChainID),
    emailAddressString VARCHAR(50),
    PRIMARY KEY(emailAddressID, emailAddressString)
);

CREATE TABLE HotelPhoneNumber (
    phoneNumberID non_neg, FOREIGN KEY(phoneNumberID) REFERENCES Hotel(HotelID),
    phoneNumberString VARCHAR(20),
    PRIMARY KEY(phoneNumberID, phoneNumberString)
);
CREATE TABLE HotelChainPhoneNumber (
	phoneNumberID VARCHAR(50), FOREIGN KEY(phoneNumberID) REFERENCES HotelChain(hotelChainID),
	phoneNumberString VARCHAR(50),
	PRIMARY KEY(phoneNumberID, phoneNumberString)
);



INSERT INTO HotelChain
VALUES
('TestHotels', '123 Small Road', 8),
('AnotherHotelChain', '124 Small Road', 9),
('GenericHotelChain', '125 Small Road', 10),
('Fancy Hotels', '1 Rich Drive', 8),
('ThisHotelChainDoesNotUseEmail', '999 Old Street', 8);


INSERT INTO HotelChainEmailAddress
VALUES
--TestHotels emails
('TestHotels', 'centralOffices1@testHotels.com'),
('TestHotels', 'centralOffices2@testHotels.com'),
--AnotherHotelChain emails
('AnotherHotelChain', 'centralOffices@anotherHotelChain.com'),
--GenericHotelChain emails
('GenericHotelChain', 'centralOffices@genericHotelChain.ca'),
--Fancy Hotels emails
('Fancy Hotels', 'centralOffices1@fancyHotels.be'),
('Fancy Hotels', 'centralOffices2@fancyHotels.be'),
('Fancy Hotels', 'legal@fancyHotels.be')
--ThisHotelChainDoesNotUSeEmails emails
--These do not exist
;
INSERT INTO HotelChainPhoneNumber
VALUES
--TestHotels phone numbers
('TestHotels', '123-321-1234'),
('TestHotels', '123-456-7890'),
--AnotherHotelChain phone numbers
('AnotherHotelChain', '432-321-3212'),
--GenericHotelChain phone numbers
('GenericHotelChain', '443-432-4324'),
--Fancy Hotels phone numbers
('Fancy Hotels', '000-000-0001'),
('Fancy Hotels', '000-000-0002'),
('Fancy Hotels', '000-000-0003'),
('Fancy Hotels', '000-000-0004'),
--ThisHotelChainDoesNotUseEmail phone numbers
('ThisHotelChainDoesNotUseEmail', '121-212-1212')
;


INSERT INTO Hotel (hotelChainID, rating, hotelAddress, numberOfRooms, managerID)
VALUES
--TestHotels hotels
('TestHotels', 1, '1 Locale Drive', 6, null),
('TestHotels', 2, '2 Locale Drive', 6, null),
('TestHotels', 3, '351 Laurier Avenue', 6, null),
('TestHotels', 4, '2 Rideau Street', 6, null),
('TestHotels', 5, '35 Road Road', 6, null),
('TestHotels', 3, '2 London Avenue', 6, null),
('TestHotels', 3, '77 London Avenue', 6, null),
('TestHotels', 1, '44 London Avenue', 6, null),

--AnotherHotelChain hotels
('AnotherHotelChain', 5, '3 Princess Street', 5, null),
('AnotherHotelChain', 4, '3 King Street', 5, null),
('AnotherHotelChain', 3, '3 Queen Street', 5, null),
('AnotherHotelChain', 4, '3 Bay Street', 5, null),
('AnotherHotelChain', 5, '3 Bloor Street', 5, null),
('AnotherHotelChain', 4, '3 Bank Street', 5, null),
('AnotherHotelChain', 3, '3 Albert Street', 5, null),
('AnotherHotelChain', 5, '3 King Street', 5, null),
('AnotherHotelChain', 4, '3 Bytown Street', 5, null),

--GenericHotelChain hotels
('GenericHotelChain', 1, '5 Princess Street', 5, null),
('GenericHotelChain', 2, '4 Princess Street', 5, null),
('GenericHotelChain', 3, '6 Dreary Lane', 5, null),
('GenericHotelChain', 1, '8 Road Lane', 5, null),
('GenericHotelChain', 2, '8888 Dreary Lane', 5, null),
('GenericHotelChain', 4, '1234 Rich Drive', 5, null),
('GenericHotelChain', 2, '3433 Rich Drive', 5, null),
('GenericHotelChain', 1, '332 Lancaster Drive', 5, null),
('GenericHotelChain', 3, '23 Blair Street', 5, null),
('GenericHotelChain', 2, '27 Pont du Lyon', 5, null),

--Fancy Hotels hotels
('Fancy Hotels', 5, '42 Pont Rue', 5, null),
('Fancy Hotels', 5, '42 Rich Road', 5, null),
('Fancy Hotels', 5, '42 Snobbery Lane', 5, null),
('Fancy Hotels', 5, '42 Tomcat Crescent', 5, null),
('Fancy Hotels', 5, '42 Caitlyn Crescent', 5, null),
('Fancy Hotels', 5, '42 Pont Rue', 5, null),
('Fancy Hotels', 3, '42 Honte des Riches', 5, null),
('Fancy Hotels', 4, '41 Dilapidated Path', 5, null),

--ThisHotelChainDoesNotUSeEmail hotels
('ThisHotelChainDoesNotUseEmail', 5, '1 WhatRoadIsThis Road', 35, null),
('ThisHotelChainDoesNotUseEmail', 1, '10 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '100 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '1000 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '10000 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '100000 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '1000000 WhatRoadIsThis Road', 5, null),
('ThisHotelChainDoesNotUseEmail', 1, '10000000 WhatRoadIsThis Road', 5, null);

INSERT INTO HotelEmailAddress
VALUES
(001, 'hotel1@testHotels.com'),
(002, 'hotel2@testHotels.com'),
(003, 'hotel3@testHotels.com'),
(004, 'hotel4@testHotels.com'),
(005, 'hotel5@testHotels.com'),
(006, 'hotel6@testHotels.com'),
(007, 'hotel7@testHotels.com'),
(008, 'hotel8@testHotels.com'),

(009, 'hotel1@anotherHotelChain.com'),
(010, 'hotel2@anotherHotelChain.com'),
(011, 'hotel3@anotherHotelChain.com'),
(012, 'hotel4@anotherHotelChain.com'),
(013, 'hotel5@anotherHotelChain.com'),
(014, 'hotel6@anotherHotelChain.com'),
(015, 'hotel7@anotherHotelChain.com'),
(016, 'hotel8@anotherHotelChain.com'),
(017, 'hotel9@anotherHotelChain.com'),

(018, 'hotel1@genericHotelChain.ca'),
(019, 'hotel2@genericHotelChain.ca'),
(020, 'hotel3@genericHotelChain.ca'),
(021, 'hotel4@genericHotelChain.ca'),
(022, 'hotel5@genericHotelChain.ca'),
(023, 'hotel6@genericHotelChain.ca'),
(024, 'hotel7@genericHotelChain.ca'),
(025, 'hotel8@genericHotelChain.ca'),
(026, 'hotel9@genericHotelChain.ca'),
(027, 'hotel10@genericHotelChain.ca'),

(028, 'hotel1@fancyHotels.be'),
(028, 'hotel1Bonus@fancyHotels.be'),
(029, 'hotel2@fancyHotels.be'),
(029, 'hotel2Bonus@fancyHotels.be'),
(030, 'hotel3@fancyHotels.be'),
(030, 'hotel3Bonus@fancyHotels.be'),
(031, 'hotel4@fancyHotels.be'),
(031, 'hotel4Bonus@fancyHotels.be'),
(032, 'hotel5@fancyHotels.be'),
(032, 'hotel5Bonus@fancyHotels.be'),
(033, 'hotel6@fancyHotels.be'),
(033, 'hotel6Bonus@fancyHotels.be'),
(034, 'hotel7@fancyHotels.be'),
(034, 'hotel7Bonus@fancyHotels.be'),
(035, 'hotel8@fancyHotels.be'),
(035, 'hotel8Bonus@fancyHotels.be')
;

INSERT INTO HotelPhoneNumber
VALUES
(001, '098-765-4321'),
(002, '111-222-3333'),
(003, '111-111-1111'),
(004, '222-222-2222'),
(005, '333-333-3333'),
(006, '444-444-4444'),
(007, '555-555-5555'),
(008, '666-666-6666'),

(009, '777-777-7777'),
(010, '888-888-8888'),
(011, '999-999-9999'),
(012, '101-010-1010'),
(013, '332-332-3332'),
(014, '612-632-7434'),
(015, '112-223-3344'),
(016, '112-334-4444'),
(017, '033-223-5555'),

(018, '777-777-6666'),
(019, '777-777-5555'),
(020, '777-777-4444'),
(021, '777-777-3333'),
(022, '777-777-2222'),
(023, '777-777-1111'),
(024, '777-777-0000'),
(025, '777-777-8888'),
(026, '777-777-9999'),
(027, '777-666-3244'),

(028, '000-100-0001'),
(029, '000-100-0002'),
(030, '000-100-0003'),
(031, '000-100-0004'),
(032, '000-100-0005'),
(033, '000-100-0006'),
(034, '000-100-0007'),
(035, '000-100-0008'),

(036, '121-212-1213'),
(037, '121-212-1214'),
(038, '121-212-1215'),
(039, '121-212-1216'),
(040, '121-212-1217'),
(041, '121-212-1218'),
(042, '121-212-1219'),
(043, '121-212-1220')
;

INSERT INTO HotelRoom (hotelID, price, amenities, capacityOfRoom, viewFromRoom, isExtendable, problemsOrDamages)
VALUES
--TestHotels HotelRooms
(1, 99.99, 'Bathroom with shower', 4, 'Harbour', false, ''),
(1, 79.99, 'Bathroom with shower', 3, 'Harbour', false, ''),
(1, 49.99, 'Bathroom with shower', 2, 'Harbour', false, ''),
(1, 119.99, 'Bathroom with shower', 5, 'Harbour', false, ''),
(1, 99.99, 'Bathroom with shower', 4, 'Harbour', true, ''),
(1, 29.99, 'Bathroom with shower', 1, 'Harbour', true, ''),
(2, 159.99, 'Bathroom with shower & bathtub', 4, 'City skyline', false, ''),
(2, 219.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, ''),
(2, 199.99, 'Bathroom with shower & bathtub', 4, 'City skyline', true, ''),
(2, 159.99, 'Bathroom with shower & bathtub', 3, 'City skyline', true, ''),
(2, 119.99, 'Bathroom with shower & bathtub', 2, 'City skyline', true, ''),
(2, 99.99, 'Bathroom with shower & bathtub', 1, 'City skyline', true, ''),
(3, 99.99, 'Bathroom with shower', 4, 'Forest', false, ''),
(3, 79.99, 'Bathroom with shower', 3, 'Forest', false, ''),
(3, 49.99, 'Bathroom with shower', 2, 'Forest', false, ''),
(3, 119.99, 'Bathroom with shower', 5, 'Forest', false, ''),
(3, 99.99, 'Bathroom with shower', 4, 'Forest', true, ''),
(3, 29.99, 'Bathroom with shower', 1, 'Forest', true, ''),
(4, 99.99, 'Bathroom with bathtub', 4, 'Lake', false, ''),
(4, 79.99, 'Bathroom with bathtub', 3, 'Lake', false, ''),
(4, 49.99, 'Bathroom with bathtub', 2, 'Lake', false, ''),
(4, 119.99, 'Bathroom with bathtub', 5, 'Lake', false, ''),
(4, 99.99, 'Bathroom with bathtub', 4, 'Lake', true, ''),
(4, 29.99, 'Bathroom with bathtub', 1, 'Lake', true, ''),
(5, 99.99, 'Bathroom with shower', 4, 'Highway', false, ''),
(5, 79.99, 'Bathroom with shower', 3, 'Highway', false, ''),
(5, 49.99, 'Bathroom with shower', 2, 'Airport', false, ''),
(5, 119.99, 'Bathroom with shower', 5, 'Train tracks', false, ''),
(5, 99.99, 'Bathroom with shower', 4, 'Airport', true, ''),
(5, 29.99, 'Bathroom with shower', 1, 'Highway', true, ''),
(6, 99.99, 'Bathroom with shower', 4, 'A very big tree', false, ''),
(6, 79.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(6, 49.99, 'Bathroom with shower', 2, 'A very big tree', false, ''),
(6, 119.99, 'Bathroom with shower', 5, 'A very big tree', false, ''),
(6, 99.99, 'Bathroom with shower', 4, 'A very big tree', true, ''),
(6, 29.99, 'Bathroom with shower', 1, 'A very big tree', true, ''),
(7, 99.99, 'Bathroom with shower', 4, 'Forest', false, ''),
(7, 79.99, 'Bathroom with shower', 3, 'Forest', false, ''),
(7, 49.99, 'Bathroom with shower', 2, 'Forest', false, ''),
(7, 119.99, 'Bathroom with shower', 5, 'Forest', false, ''),
(7, 99.99, 'Bathroom with shower', 4, 'Forest', true, ''),
(7, 29.99, 'Bathroom with shower', 1, 'Forest', true, ''),
(8, 99.99, 'Bathroom with shower', 4, 'Forest', false, ''),
(8, 79.99, 'Bathroom with shower', 3, 'Forest', false, ''),
(8, 49.99, 'Bathroom with shower', 2, 'Forest', false, ''),
(8, 119.99, 'Bathroom with shower', 5, 'Forest', false, ''),
(8, 99.99, 'Bathroom with shower', 4, 'Forest', true, ''),
(8, 29.99, 'Bathroom with shower', 1, 'Forest', true, ''),

--AnotherHotelChain HotelRooms
(9, 89.99, 'Bathroom with shower', 1, 'Ocean', false, ''),
(9, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(9, 39.99, 'Bathroom with shower', 2, 'Ocean', false, 'Leaking ceiling'),
(9, 109.99, 'Bathroom with shower', 5, 'Highway', false, ''),
(9, 89.99, 'Bathroom with shower', 4, 'Ocean', true, ''),
(10, 89.99, 'Bathroom with shower', 4, 'Ocean', false, ''),
(10, 69.99, 'Bathroom with shower', 3, 'Ocean', false, 'Stained carpet'),
(10, 39.99, 'Bathroom with shower', 2, 'Ocean', false, ''),
(10, 109.99, 'Bathroom with shower', 5, 'Highway', false, ''),
(10, 89.99, 'Bathroom with shower', 1, 'Mountain', true, ''),
(11, 89.99, 'Bathroom with shower', 4, 'Mountain', false, ''),
(11, 69.99, 'Bathroom with shower', 3, 'Mountain', false, ''),
(11, 39.99, 'Bathroom with shower', 2, 'Mountain', false, ''),
(11, 109.99, 'Bathroom with shower', 5, 'Mountain', false, ''),
(11, 89.99, 'Bathroom with shower', 1, 'Mountain', true, ''),
(12, 89.99, 'Bathroom with shower', 4, 'Ocean', false, ''),
(12, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(12, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, 'Broken bedframe'),
(12, 109.99, 'Bathroom with shower & bathtub', 5, 'Highway', false, ''),
(12, 89.99, 'Bathroom with shower & bathtub', 1, 'Ocean', true, ''),
(13, 89.99, 'Bathroom with shower', 4, 'Ocean', false, ''),
(13, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(13, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, 'Broken bedframe'),
(13, 109.99, 'Bathroom with shower & bathtub', 5, 'Mountain', false, 'Window curtains stained'),
(13, 89.99, 'Bathroom with shower & bathtub', 1, 'Ocean', true, ''),
(14, 89.99, 'Bathroom with shower', 4, 'Ocean', false, ''),
(14, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(14, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, ''),
(14, 109.99, 'Bathroom with shower & bathtub', 5, 'Mountain', false, 'Window curtains stained'),
(14, 89.99, 'Bathroom with shower & bathtub', 1, 'Ocean', true, ''),
(15, 19.99, 'Bathroom with shower', 4, 'Ocean', false, 'Mold in shower'),
(15, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(15, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, ''),
(15, 109.99, 'Bathroom with shower & bathtub', 5, 'Mountain', false, 'Window curtains stained'),
(15, 89.99, 'Bathroom with shower & bathtub', 1, 'Ocean', true, ''),
(16, 89.99, 'Bathroom with shower', 4, 'Ocean', false, 'Carpet stolen'),
(16, 69.99, 'Bathroom with shower', 3, 'Ocean', false, ''),
(16, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, ''),
(16, 109.99, 'Bathroom with shower & bathtub', 5, 'Mountain', false, 'Broken air conditioning'),
(16, 89.99, 'Bathroom with shower & bathtub', 1, 'Ocean', true, ''),
(17, 89.99, 'Bathroom with shower', 4, 'Forest', false, 'Balcony is loose'),
(17, 69.99, 'Bathroom with shower', 3, 'Forest', false, ''),
(17, 39.99, 'Bathroom with shower & bathtub', 2, 'Ocean', false, ''),
(17, 109.99, 'Bathroom with shower & bathtub', 5, 'Mountain', false, ''),
(17, 89.99, 'Bathroom with shower & bathtub', 1, '', true, 'No windows'),

--GenericHotelChain HotelRooms
(18, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, 'Springy floorboards'),
(18, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(18, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(18, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, 'Window curtains stained'),
(18, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(19, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, 'Springy floorboards'),
(19, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(19, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(19, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, 'No windows'),
(19, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(20, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, 'Springy floorboards'),
(20, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(20, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(20, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, 'Window curtains stained'),
(20, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(21, 109.99, 'Bathroom', 4, 'Historical buildings', false, ''),
(21, 89.99, 'Bathroom', 3, 'Historical buildings', false, ''),
(21, 59.99, 'Bathroom', 2, 'Historical buildings', false, ''),
(21, 129.99, 'Bathroom', 5, 'City skyline', false, ''),
(21, 109.99, 'Bathroom', 1, 'Historical buildings', true, ''),
(22, 109.99, 'Bathroom with shower', 4, '', false, 'No windows'),
(22, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(22, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(22, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, ''),
(22, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(23, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, 'Springy floorboards'),
(23, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(23, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(23, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, ''),
(23, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(24, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, ''),
(24, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(24, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(24, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, ''),
(24, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(25, 109.99, 'Bathroom with shower', 4, 'A very big tree', false, ''),
(25, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(25, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', false, ''),
(25, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, 'Window curtains stained'),
(25, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(26, 109.99, 'Bathroom with shower', 4, '', false, 'No windows; Door does not lock'),
(26, 89.99, 'Bathroom with shower', 3, 'A very big tree', false, ''),
(26, 59.99, 'Bathroom with shower & bathtub', 2, 'Historical buildings', true, ''),
(26, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', true, ''),
(26, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),
(27, 109.99, 'Bathroom with shower', 4, 'City skyline', false, ''),
(27, 89.99, 'Bathroom with shower', 3, 'Historical buildings', false, ''),
(27, 59.99, 'Bathroom with shower & bathtub', 2, 'City skyline', false, ''),
(27, 129.99, 'Bathroom with shower & bathtub', 5, 'City skyline', false, ''),
(27, 109.99, 'Bathroom with shower & bathtub', 1, 'Historical buildings', true, ''),

--Fancy Hotels HotelRooms
(28, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(28, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(28, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(28, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(28, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(29, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(29, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(29, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(29, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(29, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(30, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(30, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(30, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(30, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(30, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(31, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(31, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(31, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(31, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(31, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(32, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(32, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(32, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(32, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(32, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(33, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(33, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(33, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(33, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(33, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(34, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(34, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(34, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(34, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(34, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),
(35, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 4, 'City skyline', false, ''),
(35, 9089.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 3, 'City skyline', false, ''),
(35, 9059.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 2, 'Historical buildings', false, ''),
(35, 9129.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 5, 'City skyline', false, ''),
(35, 9109.99, 'Bathroom with shower, laundry machine and dryer, air conditioning, TV, microwave, kettle', 1, 'Historical buildings', true, ''),

--ThisHotelChainDoesNotUSeEmail HotelRooms
(36, 0.99, 'Everything', 1, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 2, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 3, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 4, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 5, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 6, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 7, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 8, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 9, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 10, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 11, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 12, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 13, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 14, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 15, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 16, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 17, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 18, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 19, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 20, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 21, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 22, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 23, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 24, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 25, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 26, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 27, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 28, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 29, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 30, 'The Road', true, 'The Road is eager'),
(36, 0.99, 'Everything', 31, 'The Road', false, 'The Road has no damages'),
(36, 0.99, 'Everything', 32, 'The Road', false, 'The Road is perfect'),
(36, 0.99, 'Everything', 33, 'The Road', false, 'The Road wishes you to visit'),
(36, 0.99, 'Everything', 34, 'The Road', false, 'The Road is waiting'),
(36, 0.99, 'Everything', 35, 'The Road', true, 'The Road is eager'),
(37, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(37, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(37, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(37, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(37, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(38, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(38, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(38, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(38, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(38, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(39, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(39, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(39, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(39, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(39, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(40, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(40, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(40, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(40, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(40, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(41, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(41, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(41, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(41, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(41, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(42, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(42, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(42, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(42, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(42, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, ''),
(43, 99.99, 'Bathroom with shower', 4, 'A pleasant forest', false, ''),
(43, 79.99, 'Bathroom with shower', 3, 'A pleasant forest', false, ''),
(43, 49.99, 'Bathroom with shower', 2, 'A pleasant forest', false, ''),
(43, 119.99, 'Bathroom with shower', 5, 'A pleasant forest', false, ''),
(43, 29.99, 'Bathroom with shower', 1, 'A pleasant forest', true, '');



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

SELECT * FROM HotelRoom;