import ObjectMapper

class User: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        
        sId <- map[WSResponseParams.WS_RESP_PARAM_ID]
        sName <- map[WSRequestParams.WS_REQS_PARAM_NAME]
        sAddress <- map[WSResponseParams.WS_RESP_PARAM_ADDRESS]
        sCity <- map[WSResponseParams.WS_RESP_PARAM_CITY.lowercased()]
        sCountry <- map[WSResponseParams.WS_RESP_PARAM_COUNTRY]
        sDob <- map[WSResponseParams.WS_RESP_PARAM_DOB]
        sEmail <- map[WSRequestParams.WS_REQS_PARAM_EMAIL]
        sGender <- map[WSRequestParams.WS_REQS_PARAM_GENDER]
        sPhone <- map[WSRequestParams.WS_REQS_PARAM_MOBILE]
        sApiToken <- map[WSResponseParams.WS_RESP_PARAM_API_TOKEN]
        sProfilePic <- map[WSResponseParams.WS_RESP_PARAM_PROFILE_PIC]
        sProfilePath <- map[WSResponseParams.WS_RESP_PARAM_PATH]

        var obj : AnyObject?
        
        obj <- map[WSRequestParams.WS_REQS_PARAM_MOBILE]
        
        if let obj = obj as? Int {
            sPhone = "\(obj)"
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
    
    lazy var sId = Int()
    lazy var sName = String()
    lazy var sAddress = String()
    lazy var sCity = String()
    lazy var sCountry = String()
    lazy var sDob = String()
    lazy var sEmail = String()
    lazy var sGender = String()
    lazy var sPhone = String()
    lazy var sApiToken = String()
    lazy var sProfilePic = String()
    lazy var sProfilePath = String()
}