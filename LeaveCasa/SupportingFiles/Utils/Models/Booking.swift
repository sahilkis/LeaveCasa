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
            if let flightItinerary = respDict["FlightItinerary"] as? [String:AnyObject]
            {
                if let results = Mapper<Flight>().map(JSON: flightItinerary) as Flight? {
                    sFlight = results
                }
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
            
            if let item = respDict["TicketStatus"] as? Int {
                sTicketStatus = item
            }
        }
        
        bookingDetail <- map["route"]
        
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
    
    lazy var sBookingId = Int()
    lazy var sPNR = String()
    lazy var sStatus = Int()
    lazy var sTicketStatus = Int()
    lazy var sBus = Bus()
    lazy var sRoute = Route()
    
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
        if let details = bookingDetailDict as? [String: AnyObject], let respDict = details[WSResponseParams.WS_RESP_PARAM_DETAIL] as? [String:AnyObject] {
            
            if let results = Mapper<Bus>().map(JSON: respDict) as Bus? {
                sBus = results
                
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
            
            if let item = respDict["TicketStatus"] as? Int {
                sTicketStatus = item
            }
        }
        
        bookingDetail <- map["route"]
        
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
            
            if let item = respDict["TicketStatus"] as? Int {
                sTicketStatus = item
            }
        }
        
        bookingDetail <- map["route"]
        
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
