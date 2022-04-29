//
//  Booking.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 28/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import ObjectMapper

class Booking: Mappable, CustomStringConvertible {
    
    lazy var sFlightBooking = [FlightBooking]()
    lazy var sBusBooking = [BusBooking]()
    lazy var sHotelBooking = [HotelBooking]()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var object: [AnyObject]?
        
        object <- map[WSResponseParams.WS_RESP_PARAM_FLIGHT_BOOKING]
        
        if let item = object as? [[String: AnyObject]], let booking = Mapper<FlightBooking>().mapArray(JSONArray: item) as [FlightBooking]? {
            sFlightBooking = booking
        }
        object <- map[WSResponseParams.WS_RESP_PARAM_BUS_BOOKING]
        
        if let item = object as? [[String: AnyObject]], let booking = Mapper<BusBooking>().mapArray(JSONArray: item) as [BusBooking]? {
            sBusBooking = booking
        }
        
        object <- map[WSResponseParams.WS_RESP_PARAM_HOTEL_BOOKING]
        
        if let item = object as? [[String: AnyObject]], let booking = Mapper<HotelBooking>().mapArray(JSONArray: item) as [HotelBooking]? {
            sHotelBooking = booking
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class FlightBooking: Mappable, CustomStringConvertible {
    
    lazy var sBookingId = Int()
    lazy var sPNR = String()
    lazy var sStatus = Int()
    lazy var sTicketStatus = Int()
    lazy var sFlight = Flight()
    lazy var sRoute = Route()
    lazy var sPassengers = [FlightPassenger]()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var bookingDetail: AnyObject?
        var bookingDetailDict: [String : AnyObject]?
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_BOOKING_DETAIL]
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            bookingDetailDict = details
        }
        if let detailsDict = bookingDetail as? [String: AnyObject] {
            bookingDetailDict = detailsDict
            
        }
        if let details = bookingDetailDict as? [String: AnyObject], let responseDict = details[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject], let respDict = responseDict[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
            if let flightItinerary = respDict[WSResponseParams.WS_RESP_PARAM_FLIGHT_ITINERARY] as? [String:AnyObject]
            {
                if let results = Mapper<Flight>().map(JSON: flightItinerary) as Flight? {
                    sFlight = results
                }
                if let passenger = flightItinerary[WSRequestParams.WS_REQS_PARAM_PASSENGER.capitalized] as? [[String: AnyObject]] {
                    if let passengers = Mapper<FlightPassenger>().mapArray(JSONArray: passenger) as [FlightPassenger]? {
                        sPassengers = passengers
                    }
                }
            }
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int {
                sBookingId = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_PNR] as? String{
                sPNR = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_STATUS] as? Int{
                sStatus = item
            }
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_TICKET_STATUS] as? Int {
                sTicketStatus = item
            }
        }
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_ROUTE]
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            if let results = Mapper<Route>().map(JSON: details) as Route? {
                sRoute = results
            }
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class Route: Mappable, CustomStringConvertible {
    
    lazy var sTripType = String()
    lazy var sAdult = Int()
    lazy var sChild = Int()
    lazy var sInfants = Int()
    lazy var sDepart = String()
    lazy var sFrom = String()
    lazy var sTo = String()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        sTripType <- map[WSRequestParams.WS_REQS_PARAM_TRIP_TYPE]
        sAdult <- map[WSRequestParams.WS_REQS_PARAM_ADULT]
        sChild <- map[WSRequestParams.WS_REQS_PARAM_CHILD]
        sInfants <- map[WSRequestParams.WS_REQS_PARAM_INFANTS]
        sDepart <- map[WSRequestParams.WS_REQS_PARAM_DEPART]
        sFrom <- map[WSRequestParams.WS_REQS_PARAM_FROM]
        sTo <- map[WSRequestParams.WS_REQS_PARAM_TO]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class BusBooking: Mappable, CustomStringConvertible {
    
    lazy var sBookingId = String()
    lazy var sPNR = String()
    lazy var sStatus = Int()
    lazy var sTicketStatus = Int()
    lazy var sBus = Bus()
    lazy var sRoute = Route()
    lazy var sPassengers = [BusPassenger]()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var bookingDetail: AnyObject?
        var bookingDetailDict: [String : AnyObject]?
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_BOOKING_DETAIL]
        sBookingId <- map[WSResponseParams.WS_RESP_PARAM_BOOKINGID]
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            bookingDetailDict = details
        }
        if let detailsDict = bookingDetail as? [String: AnyObject] {
            bookingDetailDict = detailsDict
            
        }
        if let details = bookingDetailDict as? [String: AnyObject], let respDict = details[WSResponseParams.WS_RESP_PARAM_DETAIL] as? [String:AnyObject] {
            
            if let results = Mapper<Bus>().map(JSON: respDict) as Bus? {
                sBus = results
            }
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_BOOKINGID] as? String {
                sBookingId = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_PNR] as? String{
                sPNR = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_STATUS] as? Int{
                sStatus = item
            }
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_TICKET_STATUS] as? Int {
                sTicketStatus = item
            }
            
            if let passenger = respDict[WSRequestParams.WS_REQS_PARAM_INVENTORY_ITEMS] as? [[String: AnyObject]] {
                if let passengers = Mapper<BusPassenger>().mapArray(JSONArray: passenger) as [BusPassenger]? {
                    sPassengers = passengers
                }
            }
            
            if let passenger = respDict[WSRequestParams.WS_REQS_PARAM_INVENTORY_ITEMS] as? [String: AnyObject] {
                if let passengers = Mapper<BusPassenger>().map(JSON: passenger) as BusPassenger? {
                    sPassengers = [passengers]
                }
            }
        }
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_ROUTE]
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            if let results = Mapper<Route>().map(JSON: details) as Route? {
                sRoute = results
            }
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}



class HotelBooking: Mappable, CustomStringConvertible {
    
    lazy var sBookingId = Int()
    lazy var sPNR = String()
    lazy var sStatus = Int()
    lazy var sTicketStatus = Int()
    lazy var sHotel = Hotels()
    lazy var sRoute = Route()
    lazy var sPassengers = [HotelPassenger]()
    lazy var sHolder = HotelPassenger()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        var bookingDetail: AnyObject?
        var bookingDetailDict: [String : AnyObject]?
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_BOOKING_DETAIL]
        
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            bookingDetailDict = details
        }
        if let detailsDict = bookingDetail as? [String: AnyObject] {
            bookingDetailDict = detailsDict
            
        }
        if let details = bookingDetailDict as? [String: AnyObject], let responseDict = details[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject], let respDict = responseDict[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
            
            if let results = Mapper<Hotels>().map(JSON:respDict) as Hotels? {
                sHotel = results
            }
            
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_BOOKINGID] as? Int {
                sBookingId = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_PNR] as? String{
                sPNR = item
            }
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_STATUS] as? Int{
                sStatus = item
            }
            
            if let item = respDict[WSResponseParams.WS_RESP_PARAM_TICKET_STATUS] as? Int {
                sTicketStatus = item
            }
            
            
            if let passenger = respDict[WSRequestParams.WS_REQS_PARAM_HOLDER] as? [String: AnyObject] {
                if let passengers = Mapper<HotelPassenger>().map(JSON: passenger) as HotelPassenger? {
                    sHolder = passengers
                }
            }
            
            if let passenger = respDict[WSRequestParams.WS_REQS_PARAM_BOOKING_ITEMS] as? [[String: AnyObject]] {
                
                var hotelPassenger = [HotelPassenger]()
                
                for bookingItem in passenger {
                    
                    if let rooms = bookingItem[WSRequestParams.WS_REQS_PARAM_ROOMS] as? [[String: AnyObject]] {
                        for room in rooms {
                            
                            if let paxes = room[WSRequestParams.WS_REQS_PARAM_PAXES] as? [[String: AnyObject]] {
                                
                                if let passengers = Mapper<HotelPassenger>().mapArray(JSONArray: paxes) as [HotelPassenger]? {
                                    hotelPassenger.append(contentsOf: passengers)
                                }
                            }
                        }
                    }
                }
                sPassengers = hotelPassenger
            }
            
        }
        
        bookingDetail <- map[WSResponseParams.WS_RESP_PARAM_ROUTE]
        
        if let detailsDict = bookingDetail as? String, let details = Helper.convertToDictionary(text: detailsDict) as? [String: AnyObject] {
            if let results = Mapper<Route>().map(JSON: details) as Route? {
                sRoute = results
            }
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class FlightPassenger: Mappable, CustomStringConvertible {
    
    lazy var sAddressLine1 = String()
    lazy var sAddressLine2 = String()
    lazy var sBaggage = [String: AnyObject]()
    lazy var sCity = String()
    lazy var sContactNo = String()
    lazy var sCountryCode = String()
    lazy var sCountryName = String()
    lazy var sDateOfBirth = String()
    lazy var sEmail = String()
    lazy var sFare = [String:AnyObject]()
    lazy var sFirstName = String()
    lazy var sGender = Int()
    lazy var sGSTCompanyAddress = String()
    lazy var sGSTCompanyContactNumber = String()
    lazy var sGSTCompanyEmail = String()
    lazy var sGSTCompanyName = String()
    lazy var sGSTNumber = String()
    lazy var sLastName = String()
    lazy var sNationality = String()
    lazy var sPAN = String()
    lazy var sPassportNo = String()
    lazy var sTitle = String()
    lazy var sTicket = [String: AnyObject]()
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        sAddressLine1 <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS_LINE1]
        sAddressLine2 <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS_LINE2]
        sCity <- map[WSResponseParams.WS_RESP_PARAM_CITY]
        sContactNo <- map[WSResponseParams.WS_RESP_PARAM_CONTACTNO]
        sCountryCode <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP]
        sCountryName <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYNAME_CAP]
        sDateOfBirth <- map[WSRequestParams.WS_REQS_PARAM_DATE_OF_BIRTH]
        sEmail <- map[WSRequestParams.WS_REQS_PARAM_EMAIL.capitalized]
        sFare <- map[WSResponseParams.WS_RESP_PARAM_FARE.capitalized]
        sFirstName <- map[WSResponseParams.WS_RESP_PARAM_FIRSTNAME]
        sGender <- map[WSRequestParams.WS_REQS_PARAM_GENDER.capitalized]
        sGSTCompanyAddress <- map[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_ADDRESS]
        sGSTCompanyContactNumber <- map[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_CONTACT_NO]
        sGSTCompanyEmail <- map[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_EMAIL]
        sGSTCompanyName <- map[WSRequestParams.WS_REQS_PARAM_GST_COMPANY_NAME]
        sGSTNumber <- map[WSRequestParams.WS_REQS_PARAM_GST_NUMBER]
        sLastName <- map[WSResponseParams.WS_RESP_PARAM_LASTNAME]
        sPAN <- map[WSResponseParams.WS_RESP_PARAM_PAN]
        sPassportNo <- map[WSRequestParams.WS_REQS_PARAM_PASSPORT_NO]
        sTitle <- map[WSRequestParams.WS_REQS_PARAM_TITLE.capitalized]
        sTicket <- map[WSResponseParams.WS_RESP_PARAM_TICKET]
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class BusPassenger: Mappable, CustomStringConvertible {
    
    lazy var sAddress = String()
    lazy var sAge = String()
    lazy var sContactNo = String()
    lazy var sEmail = String()
    lazy var sName = String()
    lazy var sGender = Int()
    lazy var sIdNumber = String()
    lazy var sIdType = String()
    lazy var sPrimary = Bool()
    lazy var sSingleLadies = Bool()
    lazy var sTitle = String()
    
    lazy var sFare = String()
    lazy var sLadiesSeat = Bool()
    lazy var sMalesSeat = Bool()
    lazy var sOperatorServiceCharge = String()
    lazy var sSeatName = String()
    lazy var sServiceTax = String()
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        var dict : AnyObject?
        
        sFare <- map[WSResponseParams.WS_RESP_PARAM_FARE]
        sLadiesSeat <- map[WSResponseParams.WS_RESP_PARAM_LADIES_SEAT]
        sMalesSeat <- map[WSResponseParams.WS_RESP_PARAM_MALES_SEAT]
        sOperatorServiceCharge <- map[WSResponseParams.WS_RESP_PARAM_OPER_SERVICE_CHARGE]
        sSeatName <- map[WSRequestParams.WS_REQS_PARAM_SEAT_NAME]
        sServiceTax <- map[WSResponseParams.WS_RESP_PARAM_SERVICE_TAX]
        
        dict <- map[WSResponseParams.WS_RESP_PARAM_LADIES_SEAT]
        if let item = dict as? String, item.lowercased().contains(Strings.TRUE)
        {
            sLadiesSeat = true
        }
        
        dict <- map[WSResponseParams.WS_RESP_PARAM_MALES_SEAT]
        if let item = dict as? String, item.lowercased().contains(Strings.TRUE)
        {
            sMalesSeat = true
        }
        
        dict <- map[WSRequestParams.WS_REQS_PARAM_PASSENGER]
        
        if let passenger = dict as? [String: AnyObject] {
            if let item = passenger[WSResponseParams.WS_RESP_PARAM_ADDRESS] as? String {
                sAddress = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_AGE] as? String {
                sAge = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_EMAIL] as? String {
                sEmail = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_GENDER] as? Int {
                sGender = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_MOBILE] as? String {
                sContactNo = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_NAME] as? String {
                sName = item
            }
            if let item = passenger[WSRequestParams.WS_RESP_PARAM_ID_NUMBER] as? String {
                sIdNumber = item
            }
            if let item = passenger[WSRequestParams.WS_RESP_PARAM_ID_TYPE] as? String {
                sIdType = item
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_PRIMARY] as? String, item.lowercased().contains(Strings.TRUE) {
                sPrimary = true
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_SINGLE_LADIES] as? String, item.lowercased().contains(Strings.TRUE)  {
                sSingleLadies = true
            }
            if let item = passenger[WSRequestParams.WS_REQS_PARAM_TITLE] as? String {
                sTitle = item
            }
        }
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}

class HotelPassenger: Mappable, CustomStringConvertible {
    
    lazy var sContactNo = String()
    lazy var sEmail = String()
    lazy var sName = String()
    lazy var sClientNationality = String()
    lazy var sType = String()
    lazy var sSurname = String()
    lazy var sTitle = String()
    
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        sContactNo <- map[WSResponseParams.WS_RESP_PARAM_PHONE_NUMBER]
        sEmail <- map[WSRequestParams.WS_REQS_PARAM_EMAIL]
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sClientNationality <- map[WSRequestParams.WS_REQS_PARAM_CLIENT_NATIONALITY]
        sType <- map[WSRequestParams.WS_RESP_PARAM_TYPE]
        sSurname <- map[WSRequestParams.WS_REQS_PARAM_SURNAME]
        sTitle <- map[WSRequestParams.WS_REQS_PARAM_TITLE]
        
    }
    
    var description: String {
        get {
            return Mapper().toJSONString(self, prettyPrint: false)!
        }
    }
    
    let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
        // transform value from String? to Int?
        return Int(value!)
    }, toJSON: { (value: Int?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return String(value)
        }
        return nil
    })
    
}
