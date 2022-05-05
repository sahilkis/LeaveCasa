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
                    if let token = responseValue[WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN] as? String {
                        self.settings?.accessToken = "\(token)"
                        self.settings?.rememberMe = true
                        
                        completion(true, "")
                    } else {
                        if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            completion(false, responseMessage)
                        }
                        else  {
                            if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_ERRORS] as? [String: AnyObject] {
                                for i in responseMessage.values {
                                    if let error = i as? [AnyObject] {
                                        completion(false, error.first as? String ?? "")
                                        break
                                    }
                                }
                            }
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
    
    // MARK: FORGOT PASSWORD
    class func wsCallForgotPassword(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.forgotPassword, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let responseMessage = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                        completion(true, responseMessage)
                    }
                } else {
                    completion(false, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
            
        })
    }
    
    // MARK: Fetch Customer ID
    class func wsCallFetchCustomerId( completion:@escaping (_ isSuccess: Bool, _ response: String?, _ message: String)->()) {
        AF.request(WebService.customerId, method: .get, parameters: nil, headers: authorizationHeader).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let custID = responseValue[WSResponseParams.WS_RESP_PARAM_ID] as? Int {
                        
                        self.settings?.customerId = "\(custID)"
                        self.settings?.loggedInUserString = Helper.convertToJSONString(jsonObject: responseValue) ?? ""
                        
                        completion(true, "\(custID)", "")
                    }
                    else {
                        completion(false, nil, "Wrong data type")
                    }
                } else {
                    completion(false, nil, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, nil, error.localizedDescription)
            }
        })
    }
    
    // MARK: Upload Profile Image
    class func wsCallUploadImage(media: UIImage, params: [String:String], fileName: String, completion:@escaping (_ isSuccess: Bool, _ response: String?, _ message: String)->()) {
        var headers: HTTPHeaders = authorizationHeader
        
        headers.add(name: "Content-type", value: "multipart/form-data")
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(media.jpegData(
                    compressionQuality: 0.5)!,
                                         withName: fileName,
                                         fileName: "\(fileName).jpg", mimeType: "image/jpg"
                )
                for param in params {
                    let value = param.value.data(using: String.Encoding.utf8)!
                    multipartFormData.append(value, withName: param.key)
                }
            },
            to: WebService.profilePic,
            method: .post ,
            headers: headers
        )
            .responseJSON { response in
                print(response)
                switch response.result {
                case .success(let value):
                    if let responseValue = value as? [String: AnyObject] {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String, message == Strings.SUCCESSFULLY_UPLOAD_PROFILE_PIC {
                        
                        completion(true, "\(message)", "")
                    }
                        
                    } else {
                        completion(false, nil, response.error?.localizedDescription ?? "")
                    }
                case .failure(let error):
                    completion(false, nil, error.localizedDescription)
                }
            }
    }
    
    // MARK: Update Profile
    class func wsCallUpdateProfile(_ reqParams : [String:AnyObject], completion:@escaping (_ isSuccess: Bool, _ response: String?, _ message: String)->()) {
        AF.request(WebService.updateProfile, method: .post, parameters: reqParams, headers: authorizationHeader).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String, message == Strings.SUCCESS_ON_UPDATE_PROFILE  {
                        
                        completion(true, Alert.SUCCESS_ON_UPDATE_PROFILE, "")
                    }
                    else {
                        completion(false, nil, "Wrong data type")
                    }
                } else {
                    completion(false, nil, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, nil, error.localizedDescription)
            }
        })
    }
    
    // MARK: Fetch Trips
    class func wsCallFetchTrips(success:@escaping (_ booking: Booking)->(),failure:@escaping (NSError)->()) { //_ arrHotels: [Hotels], _ arrBuses: [Bus], _ arrFlights: [Flight]
        AF.request(WebService.trips, method: .get, parameters: nil, headers: authorizationHeader).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseArray = value as? [[String: AnyObject]] {
                    print(responseArray)
                    //                    var hotels: [Hotel] = []
                    //                    var buses: [Bus] = []
                    //                    var flights: [Flight] = []
                    for responseValue in responseArray {
                        
                        if let results = Mapper<Booking>().map(JSON: responseValue) as Booking? {
                            //                            hotels = results.sHotelBooking
                            //                            buses = results.sBusBooking
                            //                            flights = results.sFlightBooking
                            success(results)
                        }
                    }
                    
                    //                    success(hotels, buses, flights)
                    
                }  else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: HOTEL
    
    // MARK: SEARCH CITY CODES
    class func wsCallGetCityCodes(_ requestParams: String, success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.citySearch + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [[String: AnyObject]] {
                    success(responseValue, "")
                } else {
                    //                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
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
                    //                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
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
    class func wsCallFetchFlightFareDetails(_ requestParams: [String: AnyObject], success:@escaping (_ fareRules: [String: AnyObject], _ fareQuotes: [String:AnyObject])->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.flightFareDetails, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let fareRulesDict = responseValue[WSResponseParams.WS_RESP_PARAM_FARES_RULES] as? [String:AnyObject], let fareQuotesDict = responseValue[WSResponseParams.WS_RESP_PARAM_FARES_QUOTES] as? [String:AnyObject] {
                        
                        if let fareRules = fareRulesDict[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject], let fareQuotes = fareQuotesDict[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                            
                            success(fareRules, fareQuotes)
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
                        }
                        
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        } else {
                            failure(AppConstants.errSomethingWentWrong)
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
    
    // MARK: FETCH Flight Ticket
    class func wsCallFlightTicketLCC(_ requestParams: [String: AnyObject], success:@escaping (_ response: [String:AnyObject])->(),failure:@escaping (NSError)->()) {
        
        var requstParams = requestParams
        
        requstParams[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = "\(settings?.customerId ?? "")" as AnyObject
        
        AF.request(WebService.flightTicketLCC, method: .post, parameters: requstParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] { //}, let responseValue = value[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:AnyObject] {
                    print(responseValue)
                    if let responseData = responseValue[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:AnyObject], let response = responseData[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                        
                        success(response)
                        
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        } else {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
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
    
    class func wsCallFlightBookNonLCC(_ requestParams: [String: AnyObject], success:@escaping (_ response: [String:AnyObject])->(),failure:@escaping (NSError)->()) {
        
        var requstParams = requestParams
        
        requstParams[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = "\(settings?.customerId ?? "")" as AnyObject
        
        AF.request(WebService.flightBookNonLCC, method: .post, parameters: requstParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let value = value as? [String: AnyObject], let responseValue = value[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:AnyObject] {
                    print(responseValue)
                    if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                        
                        success(response)
                        
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        } else {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                        }
                    }
                } else if let value = value as? [String: AnyObject], let errorMessage = value[WSResponseParams.WS_REPS_PARAM_DATA] as? String {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                } else {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    class func wsCallFlightTicketNonLCC(_ requestParams: [String: AnyObject], success:@escaping (_ response: [String:AnyObject])->(),failure:@escaping (NSError)->()) {
        
        var requstParams = requestParams
        
        requstParams[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = "\(settings?.customerId ?? "")" as AnyObject
        
        AF.request(WebService.flightTicketNonLCC, method: .post, parameters: requstParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let value = value as? [String: AnyObject], let responseValue = value[WSResponseParams.WS_REPS_PARAM_DATA] as? [String:AnyObject] {
                    print(responseValue)
                    if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                        
                        success(response)
                        
                    } else {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message]))
                        } else {
                            failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                        }
                    }
                } else if let value = value as? [String: AnyObject], let errorMessage = value[WSResponseParams.WS_REPS_PARAM_DATA] as? String {
                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
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
    class func wsCallGetBusSourceCityCodes(_ requestParams: String, success:@escaping (_ response: [[String: AnyObject]],_ message:String?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busSourceSearch + requestParams, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    if let results = responseValue[WSResponseParams.WS_RESP_PARAM_SOURCES] as? [[String: AnyObject]] {
                        success(results, "")
                    }
                } else {
                    //                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
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
                    //                    failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: responseData.error?.localizedDescription ?? ""]))
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH Buses
    class func wsCallFetchBuses(_ requestParams: [String: AnyObject], success:@escaping (_ arrData: [Bus], _ markups: Markup?)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busSearch, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String: Any] {
                            var buses = [Bus]()
                            var markups = [Markup] ()
                            
                            if let availableTrips = response[WSResponseParams.WS_RESP_PARAM_AVAILABLE_TRIPS] as? [[String: Any]] {
                                if let busArr = Mapper<Bus>().mapArray(JSONArray: availableTrips) as [Bus]? {
                                    buses = busArr
                                } else {
                                    failure(AppConstants.errSomethingWentWrong)
                                }
                            }
                            if let markups = response[WSResponseParams.WS_RESP_PARAM_MARKUP] as? [String: Any] , let markup = Mapper<Markup>().map(JSON: markups) as Markup? {
                                success(buses, markup)
                            }
                            else {
                                success(buses, nil)
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
    
    // MARK: FETCH Bus Seat Layout
    class func wsCallFetchBusSeatLayout(_ requestParams: [String: AnyObject], success:@escaping (_ arrData: BusLayout)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busSeatLayout, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        
                        if let layouts = responseValue[WSResponseParams.WS_RESP_PARAM_LAYOUT] as? [String: Any] , let layout = Mapper<BusLayout>().map(JSON: layouts) as BusLayout? {
                            success(layout)
                        }
                    } else {
                        failure(AppConstants.errSomethingWentWrong)
                    }
                }
            case .failure(let error):
                failure(NSError.init(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription]))
            }
        })
    }
    
    // MARK: FETCH Bus Ticket Block
    class func wsCallBusTicketBlock(_ requestParams: [String: AnyObject], success:@escaping (_ blockKey: String)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.busTicketBlock, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        if let response = responseValue[WSResponseParams.WS_RESP_PARAM_BLOCK_KEY] as? String {
                            success(response)
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
    
    // MARK: FETCH Bus Final Booking
    class func wsCallBusFinalBooking(_ requestParams: [String: AnyObject], success:@escaping (_ blockKey: [String: AnyObject])->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.finalBooking, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        
                        success(responseValue)
                        
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
    
    class func wsCallCreditWalletBalance(_ requestParams : [String: AnyObject],completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.creditWalletBalance, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                        completion(true, message)
                    }
                    else {
                        completion(false, "Wrong data type")
                    }
                } else {
                    completion(false, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        })
    }
    
    class func wsCallDebitWalletBalance(_ requestParams: [String: AnyObject], completion:@escaping (_ isSuccess: Bool, _ message: String)->()) {
        AF.request(WebService.debitWalletBalance, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String {
                        completion(true, message)
                    }
                    else {
                        completion(false, "Wrong data type")
                    }
                } else {
                    completion(false,  responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false,  error.localizedDescription)
            }
        })
    }
    
    class func wsCallRecheckBooking(_ requestParams: [String: AnyObject], success:@escaping (_ arrHomeData: HotelDetail, _ searchId: String)->(),failure:@escaping (NSError)->()) {
        AF.request(WebService.recheckBooking, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
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
    
    class func wsCallFinalBooking(_ url : String, _ requestParam: [String:AnyObject], completion:@escaping (_ isSuccess: Bool, _ response: [String:AnyObject]?, _ message: String)->()) {
        
        var requestParams = requestParam
        
        requestParams[WSRequestParams.WS_REQS_PARAM_CUSTOMER_ID] = "\(settings?.customerId ?? "")" as AnyObject
        
        AF.request(url, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(responseData) -> Void in
            print(responseData.result)
            switch responseData.result {
            case .success(let value):
                if let responseValue = value as? [String: AnyObject] {
                    print(responseValue)
                    if (responseValue[WSResponseParams.WS_RESP_PARAM_STATUS] as? String == WSResponseParams.WS_REPS_PARAM_SUCCESS) {
                        completion(true, responseValue, "")
                    }
                    else {
                        completion(false, nil, "Wrong data type")
                    }
                } else {
                    completion(false, nil, responseData.error?.localizedDescription ?? "")
                }
            case .failure(let error):
                completion(false, nil, error.localizedDescription)
            }
        })
    }
}
