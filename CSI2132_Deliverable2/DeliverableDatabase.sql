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
    addressOfCentralOffices VARCHAR(50)
);

CREATE TABLE Hotel (
    hotelID SERIAL, PRIMARY KEY(hotelID),
    hotelChainID VARCHAR(50), FOREIGN KEY(hotelChainID) REFERENCES HotelChain(hotelChainID) ON UPDATE CASCADE,
    rating INT check((1 <= rating) and (rating <= 10)),
    hotelAddress VARCHAR(50),
    managerID VARCHAR(20), FOREIGN KEY(managerID) REFERENCES Person(personID)
);

CREATE TABLE HotelRoom (
	roomID SERIAL UNIQUE,
    hotelID non_neg, PRIMARY KEY(hotelID, roomID), FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID) ON UPDATE CASCADE,
    price non_neg_double NOT NULL, 
    amenities VARCHAR(200),
    capacityOfRoom non_neg NOT NULL,
    viewFromRoom VARCHAR(50),
    isExtendable boolean,
    problemsOrDamages VARCHAR(200)
);

CREATE TABLE Booking (
    bookingID SERIAL, PRIMARY KEY(bookingID),
    roomID non_neg, FOREIGN KEY(roomID) REFERENCES HotelRoom(roomID) ON DELETE SET NULL,
    customerID VARCHAR(20), FOREIGN KEY(customerID) REFERENCES Person(personID) ON UPDATE CASCADE ON DELETE SET NULL,
    startDate DATE check(startDate < endDate),
    endDate DATE check(endDate > startDate),
    bookingCost non_neg_double NOT NULL, 
    bookingStatus VARCHAR(20) check (bookingStatus IN ('Booking', 'Renting', 'Archived')) 
);

CREATE TABLE Customer (
    customerID VARCHAR(20), PRIMARY KEY(customerID), FOREIGN KEY(customerID) REFERENCES Person(personID) ON UPDATE CASCADE ON DELETE CASCADE,
    registrationDate DATE NOT NULL
);

CREATE TABLE Employee (
    employeeID VARCHAR(20), PRIMARY KEY(employeeID), FOREIGN KEY(employeeID) REFERENCES Person(personID) ON UPDATE CASCADE ON DELETE CASCADE,
    hotelID non_neg, FOREIGN KEY(hotelID) REFERENCES Hotel(hotelID),
    employeeRole VARCHAR(20)
);

CREATE TABLE HotelEmailAddress (
    emailAddressID non_neg, FOREIGN KEY(emailAddressID) REFERENCES Hotel(hotelID) ON UPDATE CASCADE ON DELETE CASCADE,
    emailAddressString VARCHAR(50),
    PRIMARY KEY(emailAddressID, emailAddressString)
);
CREATE TABLE HotelChainEmailAddress (
    emailAddressID VARCHAR(50), FOREIGN KEY(emailAddressID) REFERENCES HotelChain(hotelChainID) ON UPDATE CASCADE ON DELETE CASCADE,
    emailAddressString VARCHAR(50),
    PRIMARY KEY(emailAddressID, emailAddressString)
);

CREATE TABLE HotelPhoneNumber (
    phoneNumberID non_neg, FOREIGN KEY(phoneNumberID) REFERENCES Hotel(HotelID) ON UPDATE CASCADE ON DELETE CASCADE,
    phoneNumberString VARCHAR(20),
    PRIMARY KEY(phoneNumberID, phoneNumberString)
);
CREATE TABLE HotelChainPhoneNumber (
	phoneNumberID VARCHAR(50), FOREIGN KEY(phoneNumberID) REFERENCES HotelChain(hotelChainID) ON UPDATE CASCADE ON DELETE CASCADE,
	phoneNumberString VARCHAR(50),
	PRIMARY KEY(phoneNumberID, phoneNumberString)
);

--TRIGGER 1:
--Function for trigger to check if attempting to delete hotel chains with existing hotels
CREATE FUNCTION check_hotelChain_has_hotels ()
	RETURNS trigger AS
	$BODY$
	BEGIN
	--Check if there exist hotels of the hotelChain
	IF (SELECT COUNT (hotelID) FROM Hotel WHERE Hotel.hotelChainID = OLD.hotelChainID) > 0 THEN
		RAISE EXCEPTION 'Cannot delete HotelChain with existing Hotels.';
	END IF;
	
RETURN NEW;
END
$BODY$ LANGUAGE plpgsql;
--Trigger for checking HotelChain before delete
CREATE TRIGGER check_hotelChain_before_delete
BEFORE DELETE ON HotelChain
FOR EACH ROW
EXECUTE PROCEDURE check_hotelChain_has_hotels();

--TRIGGER 2:
--Function for trigger to check if attempting to delete hotels with existing hotel rooms
CREATE FUNCTION check_hotel_has_rooms ()
	RETURNS trigger AS
	$BODY$
	BEGIN
	--Check if there exist hotels of the hotelChain
	IF (SELECT COUNT (roomID) FROM HotelRoom WHERE HotelRoom.hotelID = OLD.hotelID) > 0 THEN
		RAISE EXCEPTION 'Cannot delete Hotel with existing Rooms.';
	END IF;
	
RETURN NEW;
END
$BODY$ LANGUAGE plpgsql;
--Trigger for checking Hotel before delete
CREATE TRIGGER check_hotel_before_delete
BEFORE DELETE ON Hotel
FOR EACH ROW
EXECUTE PROCEDURE check_hotel_has_rooms();

/*
--TRIGGER 3
--Function for trigger to check if a booking is attempting to book an currently used room
CREATE FUNCTION check_booking_creates_conflict ()
	RETURNS trigger AS
	$BODY$
	BEGIN
	--If the new Booking would overlap in time with another booking
	IF EXISTS (SELECT * FROM Booking b WHERE b.roomID = NEW.roomID AND b.endDate < NEW.startDate) THEN
		RAISE EXCEPTION 'Booking attempting to be inserted would create a conflict.';
	END IF;
	
RETURN NEW;
END
$BODY$ LANGUAGE plpgsql;
--Trigger for checking Booked hotel rooms before delete
CREATE TRIGGER check_booking_creates_conflict
BEFORE INSERT ON Booking
FOR EACH STATEMENT
EXECUTE PROCEDURE check_booking_creates_conflict();



--DROP TRIGGER check_booking_creates_conflict ON Booking;
DROP FUNCTION check_booking_creates_conflict;

INSERT INTO Booking (roomID, customerID, startDate, endDate, bookingCost, bookingStatus)
VALUES
(251, null, '2023-01-19', '2023-01-26', 99.99, 'Booking');

SELECT * FROM Booking;

--SCRAP ROOM
SELECT 
*/



--VIEWS

--VIEW 1
--VIEW provides the number of available rooms per area/street
CREATE VIEW numberOfHotelRoomsOnSameStreet AS
SELECT REGEXP_SUBSTR(h.hotelAddress, '[A-z]+\s*[A-z]*') AS area, SUM(numberOfRooms) AS numberOfAvailableRooms
	FROM Hotel h,
    LATERAL(
    	SELECT COUNT(*) AS numberOfRooms
		FROM (
			SELECT *
			FROM HotelRoom
			WHERE roomID NOT IN(
				SELECT roomID
				FROM Booking
				WHERE Booking.bookingStatus != 'Archived'
			)
		) hR
		WHERE h.hotelID = hR.hotelID
	)
GROUP BY area;

--VIEW 2
--View provides the total capacity of a hotel's rooms alongside the hotel's ID, hotel chain, and hotel address
CREATE VIEW totalCapacityOfHotels AS
SELECT hotelID, hotelChainID, hotelAddress, SUM(capacityOfRoom) AS hotelCapacity
FROM Hotel NATURAL JOIN HotelRoom
GROUP BY hotelID 
ORDER BY hotelCapacity DESC;


/***
 *	DATA DUMP
 */

INSERT INTO HotelChain
VALUES
('TestHotels', '123 Small Road'),
('AnotherHotelChain', '124 Small Road'),
('GenericHotelChain', '125 Small Road'),
('Fancy Hotels', '1 Rich Drive'),
('ThisHotelChainDoesNotUseEmail', '0 The Road');


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
--ThisHotelChainDoesNotUSeEmail emails
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


INSERT INTO Hotel (hotelChainID, rating, hotelAddress, managerID)
VALUES
--TestHotels hotels
('TestHotels', 1, '1 Locale Drive', null),
('TestHotels', 2, '2 Locale Drive', null),
('TestHotels', 3, '351 Laurier Avenue', null),
('TestHotels', 4, '2 Rideau Street', null),
('TestHotels', 5, '35 Road Road', null),
('TestHotels', 3, '2 London Avenue', null),
('TestHotels', 3, '77 London Avenue', null),
('TestHotels', 1, '44 London Avenue', null),

--AnotherHotelChain hotels
('AnotherHotelChain', 5, '3 Princess Street', null),
('AnotherHotelChain', 4, '3 King Street', null),
('AnotherHotelChain', 3, '3 Queen Street', null),
('AnotherHotelChain', 4, '3 Bay Street', null),
('AnotherHotelChain', 5, '3 Bloor Street', null),
('AnotherHotelChain', 4, '3 Bank Street', null),
('AnotherHotelChain', 3, '3 Albert Street', null),
('AnotherHotelChain', 5, '3 King Street', null),
('AnotherHotelChain', 4, '3 Bytown Street', null),

--GenericHotelChain hotels
('GenericHotelChain', 1, '5 Princess Street', null),
('GenericHotelChain', 2, '4 Princess Street', null),
('GenericHotelChain', 3, '6 Dreary Lane', null),
('GenericHotelChain', 1, '8 Road Lane', null),
('GenericHotelChain', 2, '8888 Dreary Lane', null),
('GenericHotelChain', 4, '1234 Rich Drive', null),
('GenericHotelChain', 2, '3433 Rich Drive', null),
('GenericHotelChain', 1, '332 Lancaster Drive', null),
('GenericHotelChain', 3, '23 Blair Street', null),
('GenericHotelChain', 2, '27 Pont du Lyon', null),

--Fancy Hotels hotels
('Fancy Hotels', 5, '42 Pont Rue', null),
('Fancy Hotels', 5, '42 Rich Road', null),
('Fancy Hotels', 5, '42 Snobbery Lane', null),
('Fancy Hotels', 5, '42 Tomcat Crescent', null),
('Fancy Hotels', 5, '42 Caitlyn Crescent', null),
('Fancy Hotels', 5, '42 Pont Rue', null),
('Fancy Hotels', 3, '42 Honte des Riches', null),
('Fancy Hotels', 4, '41 Dilapidated Path', null),

--ThisHotelChainDoesNotUseEmail hotels
('ThisHotelChainDoesNotUseEmail', 5, '1 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '10 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '100 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '1000 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '10000 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '100000 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '1000000 WhatRoadIsThis Road', null),
('ThisHotelChainDoesNotUseEmail', 1, '10000000 WhatRoadIsThis Road', null);

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

--ThisHotelChainDoesNotUseEmail HotelRooms
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
('111-111-111', 'SIN', 'Lucinda Hudson', '1 Life Street'),
('111-111-112', 'SIN', 'Nicole Wheeler', '2 Life Street'),
('111-111-113', 'SIN', 'Tristan Hawkins', '3 Life Street'),
('111-111-114', 'SIN', 'Kamil Dorsey', '4 Life Street'),
('111-111-115', 'SIN', 'Idris Richard', '5 Life Street'),
('111-111-116', 'SIN', 'Doris Simpson', '6 Life Street'),
('111-111-117', 'SIN', 'Mariam Orozco', '7 Life Street'),
('111-111-118', 'SIN', 'Marissa Dunlap', '8 Life Street'),
('111-111-119', 'SIN', 'Yaseen Brewer', '9 Life Street'),
('111-111-120', 'SIN', 'Celine Chan', '10 Life Street'),
('111-111-121', 'SIN', 'Pearl Galvan', '11 Life Street'),
('111-111-122', 'SIN', 'Flynn York', '12 Life Street'),
('111-111-123', 'SIN', 'Kyron Yates', '13 Life Street'),
('111-111-124', 'SIN', 'Mollie Henderson', '14 Life Street'),
('111-111-125', 'SIN', 'Alfie Knowles', '15 Life Street'),
('111-111-126', 'SIN', 'Kyle Holder', '16 Life Street'),
('111-111-127', 'SIN', 'Bernard Pearson', '17 Life Street'),
('111-111-128', 'SIN', 'Gwen Ortiz', '18 Life Street'),
('111-111-129', 'SIN', 'Layla Pope', '19 Life Street'),
('111-111-130', 'SIN', 'Kabir Berger', '20 Life Street'),
('111-111-131', 'SIN', 'Olivia Pratt', '21 Life Street'),
('111-111-132', 'SIN', 'Saskia Waller', '22 Life Street'),
('111-111-133', 'SIN', 'Lena Valenzuela', '23 Life Street'),
('111-111-134', 'SIN', 'Amelie Cummings', '24 Life Street'),
('111-111-135', 'SIN', 'Lester Sanford', '25 Life Street'),
('111-111-136', 'SIN', 'Neave Santiago', '26 Life Street'),
('111-111-137', 'SIN', 'Ernest Ballard', '27 Life Street'),
('111-111-138', 'SIN', 'Gianluca OSullivan', '28 Life Street'),
('111-111-139', 'SIN', 'Callum Frazier', '29 Life Street'),
('111-111-140', 'SIN', 'Willard Mcintosh', '30 Life Street'),
('111-111-141', 'SIN', 'Susan Farley', '31 Life Street'),
('111-111-142', 'SIN', 'Kristina Solomon', '32 Life Street'),
('111-111-143', 'SIN', 'Rhys Potter', '33 Life Street'),
('111-111-144', 'SIN', 'Jake Sheppard', '34 Life Street'),
('111-111-145', 'SIN', 'Kareem Chandler', '35 Life Street'),
('111-111-146', 'SIN', 'Yunus Dawson', '36 Life Street'),
('111-111-147', 'SIN', 'Bryony Mcmahon', '37 Life Street'),
('111-111-148', 'SIN', 'Aliya Flynn', '38 Life Street'),
('111-111-149', 'SIN', 'Jacqueline Daniels', '39 Life Street'),
('111-111-150', 'SIN', 'Paula Bailey', '40 Life Street'),
('111-111-151', 'SIN', 'Chelsea Anthony', '41 Life Street'),
('111-111-152', 'SIN', 'Blaine Mclaughlin', '42 Life Street'),
('111-111-153', 'SIN', 'Rocco Guerra', '43 Life Street'),
('111-111-154', 'SIN', 'Alia Schneider', '44 Life Street'),
('111-111-155', 'SIN', 'Miranda Turner', '45 Life Street'),
('111-111-156', 'SIN', 'Luisa Dixon', '46 Life Street'),
('111-111-157', 'SIN', 'Karim Bray', '47 Life Street'),
('111-111-158', 'SIN', 'Ronan Fowler', '48 Life Street'),
('111-111-159', 'SIN', 'Maryam Moody', '49 Life Street'),
('111-111-160', 'SIN', 'Elizabeth Mcintyre', '50 Life Street'),
('111-111-161', 'SIN', 'Faris Lynch', '51 Life Street'),
('111-111-162', 'SIN', 'Jeremiah Proctor', '52 Life Street'),
('111-111-163', 'SIN', 'Trey Washington', '53 Life Street'),
('111-111-164', 'SIN', 'Nina Daugherty', '54 Life Street'),
('111-111-165', 'SIN', 'Oscar Bass', '55 Life Street'),
('111-111-166', 'SIN', 'Archie Reyes', '56 Life Street'),
('111-111-167', 'SIN', 'Cassandra Black', '57 Life Street'),
('111-111-168', 'SIN', 'Saba Haney', '58 Life Street'),
('111-111-169', 'SIN', 'Evangeline Combs', '59 Life Street'),
('111-111-170', 'SIN', 'Haaris Jackson', '60 Life Street'),
('111-111-171', 'SIN', 'Glenn Marquez', '61 Life Street'),
('111-111-172', 'SIN', 'Jean Santana', '62 Life Street'),
('111-111-173', 'SIN', 'James Richards', '63 Life Street'),
('111-111-174', 'SIN', 'Ricky Wilson', '64 Life Street'),
('111-111-175', 'SIN', 'Autumn Santos', '65 Life Street'),
('111-111-176', 'SIN', 'Tony Blair', '66 Life Street'),
('111-111-177', 'SIN', 'Cai Delgado', '67 Life Street'),
('111-111-178', 'SIN', 'Lewis Patton', '68 Life Street'),
('111-111-179', 'SIN', 'Millicent Hess', '69 Life Street'),
('111-111-180', 'SIN', 'Aimee Leach', '70 Life Street'),
('111-111-181', 'SIN', 'Kacie Kane', '71 Life Street'),
('111-111-182', 'SIN', 'Lucy Nicholson', '72 Life Street'),
('111-111-183', 'SIN', 'Chanel Sutton', '73 Life Street'),
('111-111-184', 'SIN', 'Tyrell Kirby', '74 Life Street'),
('111-111-185', 'SIN', 'Carmen Mcgowan', '75 Life Street'),
('111-111-186', 'SIN', 'Hannah Mcknight', '76 Life Street'),
('111-111-187', 'SIN', 'Ajay Boyer', '77 Life Street'),
('111-111-188', 'SIN', 'Hollie Donnelly', '78 Life Street'),
('111-111-189', 'SIN', 'Harriet Sharpe', '79 Life Street'),
('111-111-190', 'SIN', 'Howard Bright', '80 Life Street'),
('111-111-191', 'SIN', 'Kobe Bernard', '81 Life Street'),
('111-111-192', 'SIN', 'Penelope Fitzpatrick', '82 Life Street'),
('111-111-193', 'SIN', 'Nia Herrera', '83 Life Street'),
('111-111-194', 'SIN', 'Cohen Li', '84 Life Street'),
('111-111-195', 'SIN', 'Declan Shah', '85 Life Street'),
('111-111-196', 'SIN', 'Kain Chen', '86 Life Street'),
('111-111-197', 'SIN', 'Allan Heath', '87 Life Street'),
('111-111-198', 'SIN', 'Arman Carson', '88 Life Street'),
('111-111-199', 'SIN', 'Daisie Stokes', '89 Life Street')
;

INSERT INTO Employee
VALUES
('111-111-111', 1, ' Manager'),
('111-111-112', 2, ' Manager'),
('111-111-113', 3, ' Manager'),
('111-111-114', 4, ' Manager'),
('111-111-115', 5, ' Manager'),
('111-111-116', 6, ' Manager'),
('111-111-117', 7, ' Manager'),
('111-111-118', 8, ' Manager'),
('111-111-119', 9, ' Manager'),
('111-111-120', 10, ' Manager'),
('111-111-121', 11, ' Manager'),
('111-111-122', 12, ' Manager'),
('111-111-123', 13, ' Manager'),
('111-111-124', 14, ' Manager'),
('111-111-125', 15, ' Manager'),
('111-111-126', 16, ' Manager'),
('111-111-127', 17, ' Manager'),
('111-111-128', 18, ' Manager'),
('111-111-129', 19, ' Manager'),
('111-111-130', 20, ' Manager'),
('111-111-131', 21, ' Manager'),
('111-111-132', 22, ' Manager'),
('111-111-133', 23, ' Manager'),
('111-111-134', 24, ' Manager'),
('111-111-135', 25, ' Manager'),
('111-111-136', 26, ' Manager'),
('111-111-137', 27, ' Manager'),
('111-111-138', 28, ' Manager'),
('111-111-139', 29, ' Manager'),
('111-111-140', 30, ' Manager'),
('111-111-141', 31, ' Manager'),
('111-111-142', 32, ' Manager'),
('111-111-143', 33, ' Manager'),
('111-111-144', 34, ' Manager'),
('111-111-145', 35, ' Manager'),
('111-111-146', 36, ' Manager'),
('111-111-147', 37, ' Manager'),
('111-111-148', 38, ' Manager'),
('111-111-149', 39, ' Manager'),
('111-111-150', 40, ' Manager'),
('111-111-151', 41, ' Manager'),
('111-111-152', 42, ' Manager'),
('111-111-153', 43, ' Manager'),
('111-111-154', 1, ' Clerk'),
('111-111-155', 2, ' Clerk'),
('111-111-156', 3, ' Clerk'),
('111-111-157', 4, ' Clerk'),
('111-111-158', 5, ' Clerk'),
('111-111-159', 6, ' Clerk'),
('111-111-160', 7, ' Clerk'),
('111-111-161', 8, ' Clerk'),
('111-111-162', 9, ' Clerk'),
('111-111-163', 10, ' Clerk'),
('111-111-164', 11, ' Clerk'),
('111-111-165', 12, ' Clerk'),
('111-111-166', 13, ' Clerk'),
('111-111-167', 14, ' Clerk'),
('111-111-168', 15, ' Clerk'),
('111-111-169', 16, ' Clerk'),
('111-111-170', 17, ' Clerk'),
('111-111-171', 18, ' Clerk'),
('111-111-172', 19, ' Clerk'),
('111-111-173', 20, ' Clerk'),
('111-111-174', 21, ' Clerk'),
('111-111-175', 22, ' Clerk'),
('111-111-176', 23, ' Clerk'),
('111-111-177', 24, ' Clerk'),
('111-111-178', 25, ' Clerk'),
('111-111-179', 26, ' Clerk'),
('111-111-180', 27, ' Clerk'),
('111-111-181', 28, ' Clerk'),
('111-111-182', 29, ' Clerk'),
('111-111-183', 30, ' Clerk'),
('111-111-184', 31, ' Clerk'),
('111-111-185', 32, ' Clerk'),
('111-111-186', 33, ' Clerk'),
('111-111-187', 34, ' Clerk'),
('111-111-188', 35, ' Clerk'),
('111-111-189', 36, ' Clerk'),
('111-111-190', 37, ' Clerk'),
('111-111-191', 38, ' Clerk'),
('111-111-192', 39, ' Clerk'),
('111-111-193', 40, ' Clerk'),
('111-111-194', 41, ' Clerk'),
('111-111-195', 42, ' Clerk'),
('111-111-196', 43, ' Clerk')
;


