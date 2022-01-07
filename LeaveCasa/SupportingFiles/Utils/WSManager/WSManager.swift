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
    
    // MARK: LOGIN USER
    class func wsCallLogin(_ requestParams: [String: AnyObject], _ rememberMe: Bool, completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.login, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let token = responseValue[WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN] as? String, let bearer = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_TYPE] as? String {
                        self.settings?.accessToken = "\(token)\(bearer)"
                        
                        if rememberMe {
                            self.settings?.rememberMe = true
                        } else {
                            self.settings?.rememberMe = false
                        }
                        
                        completion(true, "")
                    }
                    else {
                        completion(false, "")
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
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? Int == WSResponseParams.WS_RESP_PARAM_TRUE) {
                        if let token = responseValue[WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN] as? String, let bearer = responseValue[WSResponseParams.WS_RESP_PARAM_TOKEN_TYPE] as? String {
                            
                            self.settings?.accessToken = "\(token)\(bearer)"
                            self.settings?.rememberMe = true
                            
                            completion(true, "")
                        }
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
    class func wsCallFetchHotels(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: [Results], _ markups: [Markup],_ numberOfHotels: Int, _ logId: Int)->(),failure:@escaping (NSError)->()) {
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
                                    success(results, markupArr, responseValue[WSResponseParams.WS_RESP_PARAM_NUMBER_OF_HOTELS] as? Int ?? 0, responseValue[WSResponseParams.WS_RESP_PARAM_LOGID] as? Int ?? 0)
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
    class func wsCallFetchHotelDetail(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: HotelDetail)->(),failure:@escaping (NSError)->()) {
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
                                    success(hotels)
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
}
