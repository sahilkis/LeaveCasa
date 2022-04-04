//
//  HotelDetail.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 21/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ObjectMapper

class HotelDetail: Mappable, CustomStringConvertible {
    
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
        iCategory <- map[WSResponseParams.WS_RESP_PARAM_CATEGORY]
        sImages <- map[WSResponseParams.WS_RESP_PARAM_IMAGES]
        sRate <- map[WSResponseParams.WS_RESP_PARAM_RATE]
        
        if let imagesUrl = sImages[WSResponseParams.WS_RESP_PARAM_URL] as? String {
            sImageUrl = imagesUrl
        }
        var ratesArray = [[String: AnyObject]]()
        ratesArray <- map[WSResponseParams.WS_RESP_PARAM_RATES]
        
        if let results = Mapper<HotelRate>().mapArray(JSONArray: ratesArray) as [HotelRate]? {
            rates = results
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
    
    lazy var sName = String()
    lazy var sAddress = String()
    lazy var sCityCode = String()
    lazy var sCountry = String()
    lazy var sDescription = String()
    lazy var sFacilities = String()
    lazy var sHotelCode = String()
    lazy var sRate = HotelRate()
    lazy var rates = [HotelRate]()
    lazy var iCategory = Int()
    lazy var sImages = [String: AnyObject]()
    lazy var sImageUrl = String()
}


class HotelRate: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        aAllotment <- map[WSResponseParams.WS_RESP_PARAM_ALLOTMENT]
        sAvailabiltyStatus <- map[WSResponseParams.WS_RESP_PARAM_AVAILABLITY_STATUS]
        sGroupCode <- map[WSResponseParams.WS_RESP_PARAM_GROUP_CODE]
        sRateKey <- map[WSResponseParams.WS_RESP_PARAM_RATE_KEY]
        sRateType <- map[WSResponseParams.WS_RESP_PARAM_RATE_TYPE]
        sNonRefundable <- map[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE]
        sRoomCode <- map[WSResponseParams.WS_RESP_PARAM_ROOM_CODE]
        sPrice <- map[WSResponseParams.WS_RESP_PARAM_PRICE]
        
        sSupportsCancellation <- map[WSResponseParams.WS_RESP_PARAM_SUPPORTS_CANCELLATION]
        
        
        var roomsArray = [[String: AnyObject]]()
        roomsArray <- map[WSRequestParams.WS_REQS_PARAM_ROOMS]
        
        if let results = Mapper<HotelRoom>().mapArray(JSONArray: roomsArray) as [HotelRoom]? {
            sRooms = results
        }
        
        sBoardingDetails <- map[WSResponseParams.WS_RESP_PARAM_BOARDING_DETAIL]
        sCancellationPolicy <- map[WSResponseParams.WS_RESP_PARAM_CANCELLATION_POLICY]
        sPaymentTypes <- map[WSResponseParams.WS_RESP_PARAM_PAYMENT_TYPE]
        sOtherInclusions <- map[WSResponseParams.WS_RESP_PARAM_OTHER_INCLUSIONS]
        sPriceDetails <- map[WSResponseParams.WS_RESP_PARAM_PRICE_DETAILS]
        
        if let net = sPriceDetails[WSResponseParams.WS_RESP_PARAM_NET] as? [[String: AnyObject]] {
            for i in net {
                if let name = i[WSRequestParams.WS_REQS_PARAM_NAME] as? String, let amount = i[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double, name.lowercased().contains("total") {
                    sNetPrice = amount
                }
            }
        }
        if let gst = sPriceDetails[WSResponseParams.WS_RESP_PARAM_GST] as? [[String: AnyObject]] {
            for i in gst {
                if let name = i[WSRequestParams.WS_REQS_PARAM_NAME] as? String, let amount = i[WSResponseParams.WS_RESP_PARAM_AMOUNT] as? Double, name.lowercased().contains("total") {
                    sGSTPrice = amount
                }
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
    
    lazy var aAllotment = String()
    lazy var sAvailabiltyStatus = String()
    lazy var sBoardingDetails = [String]()
    lazy var sGroupCode = String()
    lazy var sNonRefundable = Bool()
    lazy var sPrice = Double()
    lazy var sPriceDetails = [String:AnyObject]()
    lazy var sNetPrice = Double()
    lazy var sGSTPrice = Double()
    lazy var sPaymentTypes = [String]()
    lazy var sOtherInclusions = [String]()
    lazy var sRateKey = String()
    lazy var sRateType = String()
    lazy var sRooms = [HotelRoom]()
    lazy var sRoomCode = String()
    lazy var sSupportsCancellation = Bool()
    lazy var sCancellationPolicy = [String: AnyObject]()
}



class HotelRoom: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sChildrenAges <- map[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES]
        sNoOfRooms <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ROOMS]
        sNoOfAdults <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ADULT]
        sNoOfChildren <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_CHILDREN]
        sDescription <- map[WSResponseParams.WS_RESP_PARAM_DESCRIPTION]
        sRoomType <- map[WSResponseParams.WS_RESP_PARAM_ROOM_TYPE]
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
    
    lazy var sChildrenAges = [String]()
    lazy var sNoOfRooms = Int()
    lazy var sNoOfAdults = Int()
    lazy var sNoOfChildren = Int()
    lazy var sDescription = String()
    lazy var sRoomType = String()
    
    
}
