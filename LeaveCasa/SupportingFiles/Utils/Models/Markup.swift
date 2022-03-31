//
//  Markup.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 21/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import ObjectMapper

class Markup: Mappable, CustomStringConvertible {
    
    required init?(map: Map) {}
    
    public init(){
        
    }
    
    func mapping(map: Map) {
        amount <- map[WSResponseParams.WS_RESP_PARAM_AMOUNT]
        amountBy <- map[WSResponseParams.WS_RESP_PARAM_AMOUNT_BY]
        starRating <- map[WSResponseParams.WS_RESP_PARAM_STAR_RATTING]
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
    
    lazy var amount = Double()
    lazy var amountBy = String()
    lazy var starRating = Int()
}
