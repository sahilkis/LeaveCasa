//
//  Hotels.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ObjectMapper

class Hotels: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sAddress <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS]
        sCityCode <- map[WSResponseParams.WS_RESP_PARAM_CITY_CODE]
        sCountry <- map[WSResponseParams.WS_RESP_PARAM_COUNTRY]
        sDescription <- map[WSResponseParams.WS_RESP_PARAM_DESCRIPTION]
        sFacilities <- map[WSResponseParams.WS_RESP_PARAM_FACILITIES]
        sHotelCode <- map[WSResponseParams.WS_RESP_PARAM_HOTEL_CODE]
        sImages <- map[WSResponseParams.WS_RESP_PARAM_IMAGES]
        iCategory <- map[WSResponseParams.WS_RESP_PARAM_CATEGORY]
        iMinRate <- map[WSResponseParams.WS_RESP_PARAM_MIN_RATE]
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
    
    lazy var sName = String()
    lazy var sAddress = String()
    lazy var sCityCode = String()
    lazy var sCountry = String()
    lazy var sDescription = String()
    lazy var sFacilities = String()
    lazy var sHotelCode = String()
    lazy var sImages = [String: AnyObject]()
    lazy var iMinRate = [String: AnyObject]()
    lazy var iCategory = Int()
}
