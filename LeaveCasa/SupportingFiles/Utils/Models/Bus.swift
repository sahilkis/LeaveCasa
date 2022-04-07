//
//  Bus.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ObjectMapper

class Bus: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sBusId <- map[WSResponseParams.WS_RESP_PARAM_ID]
        sBusRoutes <- map[WSResponseParams.WS_RESP_PARAM_BUS_ROUTES]
        sSeats <- map[WSResponseParams.WS_RESP_PARAM_SEATS_AVAILABLE]
        fareDetails <- map[WSResponseParams.WS_RESP_PARAM_FARES_DETAILS]
        fareDetailsArray <- map[WSResponseParams.WS_RESP_PARAM_FARES_DETAILS]
        sArrivalTime <- map[WSResponseParams.WS_RESP_PARAM_ARRIVAL_TIME]
        sDepartureTime <- map[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME]
        sTravels <- map[WSResponseParams.WS_RESP_PARAM_TRAVELS]
        sBusType <- map[WSResponseParams.WS_RESP_PARAM_BUS_TYPE]
        sSleeper <- map[WSResponseParams.WS_RESP_PARAM_SLEEPER]
        sAC <- map[WSResponseParams.WS_RESP_PARAM_AC]
        
        var busBoarding: [[String: AnyObject]]?
        
        busBoarding <- map[WSResponseParams.WS_RESP_PARAM_BOARDING_TIMES]
        sBusBoarding <- map[WSResponseParams.WS_RESP_PARAM_BOARDING_TIMES]
        if let results = Mapper<BusBoarding>().mapArray(JSONArray: busBoarding ?? []) as [BusBoarding]? {
            sBusBoardingArr = results
        }
        
        busBoarding <- map[WSResponseParams.WS_RESP_PARAM_DROPPING_TIME]
        sBusDropping <- map[WSResponseParams.WS_RESP_PARAM_DROPPING_TIME]
        if let results = Mapper<BusBoarding>().mapArray(JSONArray: busBoarding ?? []) as [BusBoarding]? {
            sBusDroppingArr = results
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
    
    lazy var sBusId = String()
    lazy var sBusRoutes = String()
    lazy var sSeats = String()
    lazy var fareDetails = [String: AnyObject]()
    lazy var fareDetailsArray = [[String: AnyObject]]()
    lazy var sArrivalTime = String()
    lazy var sDepartureTime = String()
    lazy var sTravels = String()
    lazy var sBusType = String()
    lazy var sSleeper = String()
    lazy var sAC = String()
    lazy var sBusBoarding = BusBoarding()
    lazy var sBusBoardingArr = [BusBoarding]()
    lazy var sBusDropping = BusBoarding()
    lazy var sBusDroppingArr = [BusBoarding]()
}

class BusBoarding: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sAddress <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS]
        sBpId <- map[WSResponseParams.WS_RESP_PARAM_BP_ID]
        sBpName <- map[WSResponseParams.WS_RESP_PARAM_BP_NAME]
        sContactNumber <- map[WSResponseParams.WS_RESP_PARAM_CONTACT_NO]
        sLandmark <- map[WSResponseParams.WS_RESP_PARAM_LANDMARK]
        sLocation <- map[WSResponseParams.WS_RESP_PARAM_LOCATION]
        sTime <- map[WSResponseParams.WS_RESP_PARAM_TIME]
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
    
    lazy var sAddress = String()
    lazy var sBpId = String()
    lazy var sBpName = String()
    lazy var sContactNumber = String()
    lazy var sLandmark = String()
    lazy var sLocation = String()
    lazy var sTime = String()
}

class BusLayout: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sMaxSeatsPerTicket <- map[WSResponseParams.WS_RESP_PARAM_MAX_SEATS]
        sNoSeatLayoutEnabled <- map[WSResponseParams.WS_RESP_PARAM_NO_SEAT_LAYOUT_ENABLED]
        sVaccinatedBus <- map[WSResponseParams.WS_RESP_PARAM_VACCINATED_BUS]
        sVaccinatedStaff <- map[WSResponseParams.WS_RESP_PARAM_VACCINATED_STAFF]
        
        var array = [[String: AnyObject]]()
        array <- map[WSResponseParams.WS_RESP_PARAM_SEATS]
        
        if let results = Mapper<BusSeat>().mapArray(JSONArray: array) as [BusSeat]? {
            sSeats = results
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
    
    lazy var sMaxSeatsPerTicket = String()
    lazy var sNoSeatLayoutEnabled = Bool()
    lazy var sSeats = [BusSeat]()
    lazy var sVaccinatedBus = Bool()
    lazy var sVaccinatedStaff = Bool()
}

class BusSeat: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var mapObject : AnyObject?
        mapObject <- map[WSResponseParams.WS_RESP_PARAM_AVAILABLE]
        if let available = mapObject as? String, available.lowercased().contains("true")
        {
            sAvailable = true
        }
        
        mapObject <- map[WSResponseParams.WS_RESP_PARAM_LADIES_SEAT]
        if let ladiesSeat = mapObject as? String, ladiesSeat.lowercased().contains("true")
        {
            sLadiesSeat = true
        }
        mapObject <- map[WSResponseParams.WS_RESP_PARAM_MALES_SEAT]
        if let maleSeat = mapObject as? String, maleSeat.lowercased().contains("true")
        {
            sMalesSeat = true
        }
        mapObject <- map[WSResponseParams.WS_RESP_PARAM_RESERVED_FOR_SOCIAL_DIS]
        if let reserved = mapObject as? String, reserved.lowercased().contains("true")
        {
            sReservedForSocialDistancing = true
        }
        
        mapObject <- map[WSResponseParams.WS_RESP_PARAM_FARE]
        if let fare = mapObject as? String, let fareValue = Double(fare)
        {
            sFare = fareValue
        }
        
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sRow <- map[WSResponseParams.WS_RESP_PARAM_ROW]
        
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
    
    lazy var sAvailable = Bool()
    lazy var sLadiesSeat = Bool()
    lazy var sMalesSeat = Bool()
    lazy var sFare = Double()
    lazy var sName = String()
    lazy var sReservedForSocialDistancing = Bool()
    lazy var sRow = String()
    lazy var isSelected = Bool()
}


