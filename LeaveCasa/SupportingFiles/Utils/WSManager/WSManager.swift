import Foundation
import Alamofire
import ObjectMapper

class WSManager {
    static var _settings: SettingsManager?
    
    static var settings: SettingsManagerProtocol?
    {
        if let _ = WSManager._settings {
        }
        else {
            WSManager._settings = SettingsManager()
        }

        return WSManager._settings
    }
    
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static var authorizationHeader: HTTPHeaders = ["Authorization": "Bearer \(settings?.accessToken ?? "")"]
    
    // MARK: LOGIN USER
    class func wsCallLogin(_ requestParams: [String: AnyObject], _ rememberMe: Bool, completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.login, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let token = responseValue[WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN] as? String {
                        self.settings?.accessToken = "\(token)"
                        
                        if rememberMe {
                            self.settings?.rememberMe = true
                        } else {
                            self.settings?.rememberMe = false
                        }
                        
                        completion(true, "")
                    }
                    else {
                        completion(false, responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String ?? "")
                    }
                } else {
                    completion(false, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        })
    }
    
    // MARK: SIGNUP USER
    class func wsCallSignup(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.signup, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let token = responseValue[WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN] as? String, let bearer = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_TYPE] as? String {
                        
                        self.settings?.accessToken = "\(token)\(bearer)"
                        self.settings?.rememberMe = true
                        
                        completion(true, "")
                    } else {
                        if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            completion(false, responseMessage)
                        }
                    }
                } else {
                    completion(false, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
            
        })
    }
    
    // MARK: SEARCH CITY CODES
    class func wsCallGetCityCodes(_ requestParams: String, success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.citySearch + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [[String: AnyObject]] {
                    success(responseValue, "")
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH HOTEL
    class func wsCallFetchHotels(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: [Results], _ markups: [Markup], _ logId: Int)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.hotelSearch, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [[String: Any]] {
                            if let markup = responseValue[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [[String: Any]] {
                                if let results = Mapper<Results>().mapArray(JSONArray: response) as [Results]?, let markupArr = Mapper<Markup>().mapArray(JSONArray: markup) as [Markup]? {
                                    success(results, markupArr, responseValue[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0)
                                }
                            }
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH HOTEL DETAIL
    class func wsCallFetchHotelDetail(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: HotelDetail, _ searchId: String)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.hotelDetail, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                            if let hotelCount = response[WSResponseParams.WS_RESP_PARAM_HOTEL] as? [String: Any] {
                                if let hotels = Mapper<HotelDetail>().map(JSON: hotelCount) as HotelDetail? {
                                    success(hotels, response[WSResponseParams.WS_RESP_PARAM_SEARCH_ID] as? String ?? "")
                                } else {
                                    failure(AppConstants.errSomethingWentWrong)
                                }
                            }
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: HOTEL IMAGES
    class func wsCallGetHotelImages(_ requestParams: String, success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.hotelImages + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let results = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: AnyObject] {
                        if let regular = results[WSResponseParams.WS_RESP_PARAM_REGULAR] as? [[String: AnyObject]] {
                            success(regular, "")
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: - FLIGHTS
    
    // MARK: SEARCH CITY AIRPORT CODES
    class func wsCallGetCityAirportCodes(_ requestParams: String, success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.airportCityCode + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let response = value as? [String: AnyObject], let responseValue = response["codes"] as? [[String: AnyObject]] {
                    success(responseValue, "")
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH FLIGHTS
    class func wsCallFetchFlights(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: [[Flight]], _ logId: Int, _ tokenId: String, _ traceId: String)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.flightSearch, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let responseDict = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                        
                        var allFlights = [[Flight]] ()
                        var tokenId = ""
                        var traceId = ""
                        var logId = 0
                        
                        if let results = responseDict[WSResponseParams.WS_RESP_PARAM_RESULTS_CAP] as? [AnyObject] {
                            var flights = [[String: AnyObject]]()
                            
                            for result in results {
                                if let flight = result as? [[String: AnyObject]] {
                                    flights = flight
                                }
                                                    
                            if let results = Mapper<Flight>().mapArray(JSONArray: flights) as [Flight]? {
                                allFlights.append(results)
                            }
                        }
                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int {
                                logId = item
                            }
                            if let item = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_ID] as? String {
                                tokenId = item
                            }
                            if let item = responseDict[WSResponseParams.WS_RESP_PARAM_TRACE_ID] as? String {
                                traceId = item
                            }
                            
                            success(allFlights, logId, tokenId, traceId)
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }

                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH FLIGHTS FARE
    class func wsCallFetchFlightFareDetails(_ requestParams: [String: AnyObject], success:@escaping (_ response:  [String: AnyObject])->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.flightFareDetails, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let responseDict = responseValue[WSResponseParams.WS_RESP_PARAM_FARES_RULES] as? [String:AnyObject] {
                        
                        if let results = responseDict[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                            
                            success(results)
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }

                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    // MARK: - BUS
    // MARK: SEARCH SOURCE CITY CODES
    class func wsCallGetBusSourceCityCodes(success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busSourceSearch, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    if let results = responseValue[WSResponseParams.WS_RESP_PARAM_SOURCES] as? [[String: AnyObject]] {
                        success(results, "")
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: SEARCH DESTINATION CITY CODES
    class func wsCallGetBusDestinationCityCodes(_ requestParams: String, success:@escaping (_ response: [String: AnyObject],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busDestinationSearch + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    if let results = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: AnyObject] {
                        success(results, "")
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH Buses
    class func wsCallFetchBuses(_ requestParams: [String: AnyObject], success:@escaping (_ arrData: [Bus])->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busSearch, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                            if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [[String: Any]] {
                                if let buses = Mapper<Bus>().mapArray(JSONArray: availableTrips) as [Bus]? {
                                    success(buses)
                                } else {
                                    failure(AppConstants.errSomethingWentWrong)
                                }
                            }
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        }
                    }
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: - WALLET
    class func wsCallFetchWalletBalence(completion:@escaping (_ isSuccess: Bool, _ balance: Double, _ message: String)->()) {
        AF.request(WebService.checkWalletBalance, method: .get, parameters: nil, headers: authorizationHeader).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let availableBalance = responseValue[WSResponseParams.WS_RESP_PARAM_AVAILABLE_BALANCE] as? Double {
                        completion(true, availableBalance, "")
                    }
                    else {
                        completion(false, 0.0, "Wrong data type")
                    }
                } else {
                    completion(false, 0.0, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, 0, error.localizedDescription)
            }
        })
    }
}
