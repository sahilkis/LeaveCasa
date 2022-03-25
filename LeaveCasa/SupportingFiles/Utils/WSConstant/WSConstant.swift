//
//  WSConstant.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 08/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

struct WebService {
    static let baseUrl                               = "https://leavecasa.com/api"
    static let termsAndConditions                    = ""
    static let login                                 = "\(baseUrl)/login"
    static let signup                                = "\(baseUrl)/register"
    static let citySearch                            = "\(baseUrl)/hotel-city-search/"
    static let hotelSearch                           = "\(baseUrl)/advance-search/hotel"
    static let hotelDetail                           = "\(baseUrl)/hotel_detail"
    static let hotelImages                           = "\(baseUrl)/hotel_images/"
    static let hotelCancellationPolicy               = "\(baseUrl)/hotel-cancellation-policy"
    // MARK: FLIGHT
    // MARK: BUS
    static let busSourceSearch                       = "\(baseUrl)/bus/cities"
    static let busDestinationSearch                  = "\(baseUrl)/bus/destination/"
    static let busSearch                             = "\(baseUrl)/bus/search"
}

struct WSRequestParams {
    static let WS_REQS_PARAM_ADULTS                  = "adults"
    static let WS_REQS_PARAM_BUS_FROM                = "bus_from"
    static let WS_REQS_PARAM_BUS_TO                  = "bus_to"
    static let WS_REQS_PARAM_CHECKIN                 = "checkin"
    static let WS_REQS_PARAM_CHECKOUT                = "checkout"
    static let WS_REQS_PARAM_CHILDREN                = "children"
    static let WS_REQS_PARAM_CHILDREN_AGES           = "children_ages"
    static let WS_REQS_PARAM_CLIENT_NATIONALITY      = "client_nationality"
    static let WS_REQS_PARAM_CURRENT_REQUEST         = "current_request"
    static let WS_REQS_PARAM_CUTOFF_TIME             = "cutoff_tim"
    static let WS_REQS_PARAM_DESTINATION_CODE        = "destination_code"
    static let WS_REQS_PARAM_EMAIL                   = "email"
    static let WS_REQS_PARAM_HOTEL_CATEGORY          = "hotel_category"
    static let WS_REQS_PARAM_HOTEL_INFO              = "hotel_info"
    static let WS_REQS_PARAM_JOURNEY_DATE            = "journey_date"
    static let WS_REQS_PARAM_MOBILE                  = "mobile"
    static let WS_REQS_PARAM_MORE_RESULTS            = "more_results"
    static let WS_REQS_PARAM_NAME                    = "name"
    static let WS_REQS_PARAM_PARM                    = "parm"
    static let WS_REQS_PARAM_PASSWORD                = "password"
    static let WS_REQS_PARAM_RATES                   = "rates"
    static let WS_REQS_PARAM_ROOMS                   = "rooms"
}

struct WSResponseParams {
    static let WS_RESP_PARAM_AC                      = "AC"
    static let WS_RESP_PARAM_ACCESS_KEY              = "access_key"
    static let WS_RESP_PARAM_ACCESS_TOKEN            = "access_token"
    static let WS_RESP_PARAM_ADDRESS                 = "address"
    static let WS_RESP_PARAM_AMOUNT                  = "amount"
    static let WS_RESP_PARAM_AMOUNT_BY               = "amount_by"
    static let WS_RESP_PARAM_ARRIVAL_TIME            = "arrivalTime"
    static let WS_RESP_PARAM_SEATS_AVAILABLE         = "availableSeats"
    static let WS_RESP_PARAM_AVAILABLE_TRIPS         = "availableTrips"
    static let WS_RESP_PARAM_BOARDING_DETAIL         = "boarding_details"
    static let WS_RESP_PARAM_BUS_ROUTES              = "busRoutes"
    static let WS_RESP_PARAM_BUS_TYPE                = "busType"
    static let WS_RESP_PARAM_CATEGORY                = "category"
    static let WS_RESP_PARAM_CITY_CODE               = "city_code"
    static let WS_RESP_PARAM_CITY_NAME               = "city_name"
    static let WS_RESP_PARAM_CODE                    = "code"
    static let WS_RESP_PARAM_COUNTRY                 = "country"
    static let WS_RESP_PARAM_DEPARTURE_TIME          = "departureTime"
    static let WS_RESP_PARAM_DESCRIPTION             = "description"
    static let WS_RESP_PARAM_DETAIL                  = "detail"
    static let WS_RESP_PARAM_DOB                     = "dob"
    static let WS_RESP_PARAM_ERRORS                  = "errors"
    static let WS_RESP_PARAM_FACILITIES              = "facilities"
    static let WS_RESP_PARAM_FALSE                   = "false"
    static let WS_RESP_PARAM_FARES_DETAILS           = "fareDetails"
    static let WS_RESP_PARAM_FIRST_NAME              = "first_name"
    static let WS_RESP_PARAM_HOTEL                   = "hotel"
    static let WS_RESP_PARAM_HOTEL_CODE              = "hotel_code"
    static let WS_RESP_PARAM_HOTELS                  = "hotels"
    static let WS_RESP_PARAM_ID                      = "id"
    static let WS_RESP_PARAM_IMAGES                  = "images"
    static let WS_RESP_PARAM_LAST_NAME               = "last_name"
    static let WS_RESP_PARAM_LOGID                   = "logid"
    static let WS_RESP_PARAM_MARKUP                  = "markup"
    static let WS_RESP_PARAM_MESSAGE                 = "message"
    static let WS_RESP_PARAM_MESSAGES                = "messages"
    static let WS_RESP_PARAM_MIN_RATE                = "min_rate"
    static let WS_RESP_PARAM_NON_REFUNDABLE          = "non_refundable"
    static let WS_RESP_PARAM_NUMBER_OF_ADULT         = "no_of_adults"
    static let WS_RESP_PARAM_NUMBER_OF_HOTELS        = "no_of_hotels"
    static let WS_RESP_PARAM_NUMBER_OF_NIGHT         = "no_of_nights"
    static let WS_RESP_PARAM_NUMBER_OF_ROOMS         = "no_of_rooms"
    static let WS_RESP_PARAM_PRICE                   = "price"
    static let WS_RESP_PARAM_RATES                   = "rates"
    static let WS_RESP_PARAM_REGULAR                 = "regular"
    static let WS_RESP_PARAM_RESPONSE                = "response"
    static let WS_RESP_PARAM_RESULTS                 = "results"
    static let WS_RESP_PARAM_SEARCH_ID               = "search_id"
    static let WS_RESP_PARAM_SLEEPER                 = "sleeper"
    static let WS_RESP_PARAM_SOURCES                 = "sources"
    static let WS_RESP_PARAM_STAR_RATTING            = "star_ratting"
    static let WS_RESP_PARAM_STATUS                  = "status"
    static let WS_REPS_PARAM_SUCCESS                 = "success"
    static let WS_RESP_PARAM_TOKEN                   = "token"
    static let WS_RESP_PARAM_TOKEN_TYPE              = "token_type"
    static let WS_RESP_PARAM_TOTAL_FARE              = "totalFare"
    static let WS_RESP_PARAM_TRAVELS                 = "travels"
    static let WS_RESP_PARAM_TRUE                    = 200
    static let WS_RESP_PARAM_URL                     = "url"
    static let WS_RESP_PARAM_USER_ID                 = "user_id"
}
