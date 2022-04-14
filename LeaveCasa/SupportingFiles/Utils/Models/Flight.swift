//
//  Flight.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 28/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//
import ObjectMapper

class Flight: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var segments: [AnyObject]?
        var stops = [FlightAirport]()
        
        segments <- map[WSResponseParams.WS_RESP_PARAM_SEGMENTS]
        sFare <- map[WSResponseParams.WS_RESP_PARAM_FARE_CAP]
        sResultIndex <- map[WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX]
        sAirlineCode <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE]
        sIsPanRequiredAtBook <- map[WSResponseParams.WS_RESP_PARAM_IS_PAN_REQ_AT_BOOK]
        sIsPanRequiredAtTicket <- map[WSResponseParams.WS_RESP_PARAM_IS_PAN_REQ_AT_TICKET]
        sIsPassportRequiredAtBook <- map[WSResponseParams.WS_RESP_PARAM_IS_PASSPORT_REQ_AT_BOOK]
        sIsPassportRequiredAtTicket <- map[WSResponseParams.WS_RESP_PARAM_IS_PASSPORT_REQ_AT_TICKET]
        sIsLCC <- map[WSResponseParams.WS_RESP_PARAM_ISLCC]
        sIsGSTMandatory <- map[WSResponseParams.WS_RESP_PARAM_IS_GST_MANDATORY]
        sGSTAllowed <- map[WSResponseParams.WS_RESP_PARAM_GST_ALLOWED]
        
        var allFlightSegments = [[FlightSegment]] ()
        
        if let segments = segments {
            var segmentsArray = [[String: AnyObject]]()
            
            for result in segments  {
                if let seg = result as? [[String: AnyObject]] {
                    segmentsArray = seg
                    
                }
                
                if let results = Mapper<FlightSegment>().mapArray(JSONArray: segmentsArray) as [FlightSegment]? {
                    allFlightSegments.append(results)
                }
            }
            sSegments = allFlightSegments
            
        }
        
        if let fare = sFare as? FlightFare {
            sPrice = fare.sPublishedFare
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
    
    lazy var sSegments = [[FlightSegment]]()
    lazy var sFare = FlightFare()
    lazy var sResultIndex = String()
    //    lazy var sSource = String()
    //    lazy var sDestination = String()
    //    lazy var sSourceCode = String()
    //    lazy var sDestinationCode = String()
    //    lazy var sStartTime = String()
    //    lazy var sEndTime = String()
    //    lazy var sDuration = Int()
    //    lazy var sAccDuration = Int()
    lazy var sPrice = Double()
    //    lazy var sCurrency = Int()
    //    lazy var sType = [String: AnyObject]()
    //    lazy var sStopsCount = Int()
    //    lazy var sStops = [FlightAirport]()
    //    lazy var sAirlineNo = Int()
    //    lazy var sAirlineName = String()
    //    lazy var sAirlineLogo = String()
    //    lazy var sAdditional = String()
    lazy var sIsPassportRequiredAtBook = Bool()
    lazy var sIsPassportRequiredAtTicket = Bool()
    lazy var sIsPanRequiredAtTicket = Bool()
    lazy var sIsPanRequiredAtBook = Bool()
    lazy var sIsLCC = Bool()
    lazy var sIsGSTMandatory = Bool()
    lazy var sGSTAllowed = Bool()
    lazy var sAirlineCode = String()
    
    
}

class FlightSegment: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        var origin = [String: AnyObject]()
        var destination = [String: AnyObject]()
        
        origin <- map[WSResponseParams.WS_RESP_PARAM_ORIGIN]
        destination <- map[WSResponseParams.WS_RESP_PARAM_DESTINATION]
        
        if let originAirport = origin[WSResponseParams.WS_RESP_PARAM_AIRPORT] as? [String: AnyObject], let airport = Mapper<FlightAirport>().map(JSON: originAirport) {
            sOriginAirport = airport
        }
        
        if let originDepartTime = origin[WSResponseParams.WS_RESP_PARAM_DEP_TIME] as? String {
            sOriginDeptTime = originDepartTime
        }
        
        if let desAirport = destination[WSResponseParams.WS_RESP_PARAM_AIRPORT] as? [String: AnyObject], let airport = Mapper<FlightAirport>().map(JSON: desAirport) {
            sDestinationAirport = airport
        }
        
        if let desArrTime = destination[WSResponseParams.WS_RESP_PARAM_ARR_TIME] as? String {
            sDestinationArrvTime = desArrTime
        }
        
        sAirline <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE]
        sDuration <- map[WSResponseParams.WS_RESP_PARAM_DURATION]
        sAccDuration <- map[WSResponseParams.WS_RESP_PARAM_DURATION_ACCUM]
        sNumberOfSeats <- map[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_SEATS]
        sCabinClass <- map[WSResponseParams.WS_RESP_PARAM_CABIN_CLASS]
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
    
    lazy var sAirline = FlightAirline()
    lazy var sOriginAirport = FlightAirport()
    lazy var sDestinationAirport = FlightAirport()
    lazy var sOriginDeptTime = String()
    lazy var sDestinationArrvTime = String()
    lazy var sDuration = Int()
    lazy var sAccDuration = Int()
    lazy var sNumberOfSeats = Int()
    lazy var sCabinClass = Int()
}

class FlightAirline: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sAirlineName <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_NAME]
        sAirlineCode <- map[WSResponseParams.WS_RESP_PARAM_AIRLINE_CODE]
        sFlightNumber <- map[WSResponseParams.WS_RESP_PARAM_FLIGHT_NO]
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
    
    lazy var sAirlineCode = String()
    lazy var sAirlineName = String()
    lazy var sFlightNumber = String()
}


class FlightAirport: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sAirportName <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_NAME]
        sAirportCode <- map[WSResponseParams.WS_RESP_PARAM_AIRPORT_CODE]
        sCityCode <- map[WSResponseParams.WS_RESP_PARAM_CITYCODE_CAP]
        sCityName <- map[WSResponseParams.WS_RESP_PARAM_CITYNAME_CAP]
        sCountryName <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYNAME_CAP]
        sCountryCode <- map[WSResponseParams.WS_RESP_PARAM_COUNTRYCODE_CAP]
        sTerminal <- map[WSResponseParams.WS_RESP_PARAM_TERMINAL]
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
    
    lazy var sAirportCode = String()
    lazy var sAirportName = String()
    lazy var sCityCode = String()
    lazy var sCityName = String()
    lazy var sCountryCode = String()
    lazy var sCountryName = String()
    lazy var sTerminal = String()
}
class FlightFare: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        sCurrency <- map[WSResponseParams.WS_RESP_PARAM_CURRENCY]
        sBaseFare <- map[WSResponseParams.WS_RESP_PARAM_BASE_FARE]
        sTax <- map[WSResponseParams.WS_RESP_PARAM_TAX]
        sPublishedFare <- map[WSResponseParams.WS_RESP_PUBLISHED_FARE]
        sYQTax <- map[WSResponseParams.WS_RESP_PARAM_YQTAX]
        sAdditionalTxnFeePub <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB]
        sAdditionalTxnFeeOfrd <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD]
        sServiceFee <- map[WSResponseParams.WS_RESP_PARAM_SERVICE_FEE]
        sDiscount <- map[WSResponseParams.WS_RESP_PARAM_DISCOUNT]
        sOtherCharges <- map[WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES]
        sOfferedFare <- map[WSResponseParams.WS_RESP_PARAM_OFFERED_FARE]
        sTdsOnPLB <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_PLB]
        sTdsOnCommission <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_COMMISSION]
        sTdsOnIncentive <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_INCENTIVE]
        
        var anyObject : AnyObject?
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_BASE_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sBaseFare = value
        }
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TAX]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTax = value
        }
        anyObject <- map[WSResponseParams.WS_RESP_PUBLISHED_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sPublishedFare = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_YQTAX]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sYQTax = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_PUB]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sAdditionalTxnFeePub = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_ADDITIONAL_TXN_FEE_RD]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sAdditionalTxnFeeOfrd = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_DISCOUNT]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sDiscount = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_OTHER_CHARGES]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sOtherCharges = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_OFFERED_FARE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sOfferedFare = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_INCENTIVE]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnIncentive = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_COMMISSION]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnCommission = value
        }
        
        anyObject <- map[WSResponseParams.WS_RESP_PARAM_TDS_ON_PLB]
        if let item = anyObject as? String, !item.isEmpty, let value = Double(item) {
            sTdsOnPLB = value
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
    
    lazy var sCurrency = String()
    lazy var sBaseFare = Double()
    lazy var sTax = Double()
    lazy var sPublishedFare = Double()
    lazy var sYQTax = Double()
    lazy var sAdditionalTxnFeePub = Double()
    lazy var sAdditionalTxnFeeOfrd = Double()
    lazy var sOtherCharges = Double()
    lazy var sDiscount = Double()
    lazy var sOfferedFare = Double()
    lazy var sTdsOnCommission = Double()
    lazy var sTdsOnPLB = Double()
    lazy var sTdsOnIncentive = Double()
    lazy var sServiceFee = Double()
    
    
}
