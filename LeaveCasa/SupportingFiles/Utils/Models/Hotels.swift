import ObjectMapper

class Results: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        hotels <- map[WSResponseParams.WS_RESP_PARAM_HOTELS]
        numberOfHotels <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_HOTELS]
        sNoOfRooms <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ROOMS]
        sNoOfAdults <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_ADULT]
        sNoOfChildren <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_CHILDREN]
        sNoOfNights <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_NIGHT]
        searchId <- map[WSResponseParams.WS_RESP_PARAM_SEARCH_ID]
        totalRequests <- map[WSResponseParams.WS_RESP_PARAM_TOTAL_NUM_OF_REQUEST]
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
    
    lazy var hotels = [Hotels]()
    lazy var numberOfHotels = Int()
    lazy var sNoOfRooms = Int()
    lazy var sNoOfAdults = Int()
    lazy var sNoOfChildren = Int()
    lazy var sNoOfNights = Int()
    lazy var searchId = String()
    lazy var totalRequests = String()
}

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
        iMinRateObj <- map[WSResponseParams.WS_RESP_PARAM_MIN_RATE]
        iMinRate <- map[WSResponseParams.WS_RESP_PARAM_MIN_RATE]
        
        if let imagesUrl = sImages[WSResponseParams.WS_RESP_PARAM_URL] as? String {
            sImageUrl = imagesUrl
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
    lazy var sImages = [String: AnyObject]()
    lazy var sImageUrl = String()
    lazy var iMinRateObj = [String: AnyObject]()
    lazy var iMinRate = HotelRate()
    lazy var iCategory = Int()
}
