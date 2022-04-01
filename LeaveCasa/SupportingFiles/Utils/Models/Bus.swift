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
        sBusRoutes <- map[WSResponseParams.WS_RESP_PARAM_BUS_ROUTES]
        sSeats <- map[WSResponseParams.WS_RESP_PARAM_SEATS_AVAILABLE]
        fareDetails <- map[WSResponseParams.WS_RESP_PARAM_FARES_DETAILS]
        sArrivalTime <- map[WSResponseParams.WS_RESP_PARAM_ARRIVAL_TIME]
        sDepartureTime <- map[WSResponseParams.WS_RESP_PARAM_DEPARTURE_TIME]
        sTravels <- map[WSResponseParams.WS_RESP_PARAM_TRAVELS]
        sBusType <- map[WSResponseParams.WS_RESP_PARAM_BUS_TYPE]
        sSleeper <- map[WSResponseParams.WS_RESP_PARAM_SLEEPER]
        sAC <- map[WSResponseParams.WS_RESP_PARAM_AC]
        
        var busBoarding: [[String: AnyObject]]?
        
        busBoarding <- map[WSResponseParams.WS_RESP_PARAM_BOARDING_TIMES]
        
        if let results = Mapper<BusBoarding>().mapArray(JSONArray: busBoarding ?? []) as [BusBoarding]? {
            sBusBoarding = results
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
    
    lazy var sBusRoutes = String()
    lazy var sSeats = String()
    lazy var fareDetails = [[String: AnyObject]]()
    lazy var sArrivalTime = String()
    lazy var sDepartureTime = String()
    lazy var sTravels = String()
    lazy var sBusType = String()
    lazy var sSleeper = String()
    lazy var sAC = String()
    lazy var sBusBoarding = [BusBoarding]()
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
