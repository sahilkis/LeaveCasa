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
    static let forgotPassword                        = "\(baseUrl)/forgot-passwordss"
    static let customerId                            = "\(baseUrl)/user"

    // MARK: HOTEL
    static let citySearch                            = "\(baseUrl)/hotel-city-search/"
    static let hotelSearch                           = "\(baseUrl)/advance-search/hotel"
    static let hotelDetail                           = "\(baseUrl)/hotel_detail"
    static let hotelImages                           = "\(baseUrl)/hotel_images/"
    static let hotelCancellationPolicy               = "\(baseUrl)/hotel-cancellation-policy"
    
    // MARK: FLIGHT
    static let airportCityCode                       = "\(baseUrl)/airport/codes/"
    static let flightSearch                          = "\(baseUrl)/flight/advance_flight_search"
    static let flightFareDetails                     = "\(baseUrl)/flight/fare_rule_quote_ssr"
    static let flightTicket                          = "\(baseUrl)/flight/lcc-ticket"
    
    // MARK: BUS
    static let busSourceSearch                       = "\(baseUrl)/bus/cities/"
    static let busDestinationSearch                  = "\(baseUrl)/bus/destination/"
    static let busSearch                             = "\(baseUrl)/bus/search"
    static let busSeatLayout                         = "\(baseUrl)/bus/seat/layout"
    static let busTicketBlock                        = "\(baseUrl)/bus/ticket/block"
    static let busTicketFinal                        = "\(baseUrl)/bus/ticket/final"
    
    // MARK: WALLET
    static let checkWalletBalance                    = "\(baseUrl)/wallet-balance"
    static let recheckBooking                        = "\(baseUrl)/recheck"
    static let finalBooking                          = "\(baseUrl)/final-book"
}

struct WSRequestParams {
    static let WS_REQS_PARAM_ADULT                   = "adult"
    static let WS_REQS_PARAM_ADULTS                  = "adults"
    static let WS_REQS_PARAM_AGE                     = "age"
    static let WS_REQS_PARAM_AVAILABLE_TRIP_ID       = "availableTripId"
    static let WS_REQS_PARAM_BOARDING_POINT_ID       = "boardingPointId"
    static let WS_REQS_PARAM_BOOKING_ITEMS           = "booking_items"
    static let WS_REQS_PARAM_BLOCK_KEY               = "block_key"
    static let WS_REQS_PARAM_BUS_ID                  = "bus_id"
    static let WS_REQS_PARAM_BUS_FROM                = "bus_from"
    static let WS_REQS_PARAM_BUS_TO                  = "bus_to"
    static let WS_REQS_PARAM_CHECKIN                 = "checkin"
    static let WS_REQS_PARAM_CHECKOUT                = "checkout"
    static let WS_REQS_PARAM_CHILD                   = "child"
    static let WS_REQS_PARAM_CHILDS                  = "childs"
    static let WS_REQS_PARAM_CHILDREN                = "children"
    static let WS_REQS_PARAM_CHILDREN_AGES           = "children_ages"
    static let WS_REQS_PARAM_CLIENT_NATIONALITY      = "client_nationality"
    static let WS_REQS_PARAM_CLASS                   = "class"
    static let WS_REQS_PARAM_CURRENT_REQUEST         = "current_request"
    static let WS_REQS_PARAM_CUSTOMER_ID             = "customer_id"
    static let WS_REQS_PARAM_CUTOFF_TIME             = "cutoff_tim"
    static let WS_REQS_PARAM_DEPART                  = "depart"
    static let WS_REQS_PARAM_DEPARTING               = "departing"
    static let WS_RESP_PARAM_DESTINATION             = "destination"
    static let WS_REQS_PARAM_DESTINATION_CODE        = "destination_code"
    static let WS_REQS_PARAM_DIRECT_FLIGHT           = "DirectFlight"
    static let WS_REQS_PARAM_EMAIL                   = "email"
    static let WS_REQS_PARAM_FROM                    = "from"
    static let WS_REQS_PARAM_GENDER                  = "gender"
    static let WS_REQS_PARAM_GROUP_CODE              = "group_code"
    static let WS_REQS_PARAM_HOLDER                  = "holder"
    static let WS_REQS_PARAM_HOTEL_CATEGORY          = "hotel_category"
    static let WS_REQS_PARAM_HOTEL_INFO              = "hotel_info"
    static let WS_RESP_PARAM_ID_TYPE                 = "idType"
    static let WS_RESP_PARAM_ID_NUMBER               = "idNumber"
    static let WS_REQS_PARAM_INFANT                  = "infant"
    static let WS_REQS_PARAM_INFANTS                 = "infants"
    static let WS_REQS_PARAM_INVENTORY_ITEMS         = "inventoryItems"
    static let WS_REQS_PARAM_JOURNEY_DATE            = "journey_date"
    static let WS_REQS_PARAM_MOBILE                  = "mobile"
    static let WS_REQS_PARAM_MORE_RESULTS            = "more_results"
    static let WS_REQS_PARAM_NAME                    = "name"
    static let WS_REQS_PARAM_ONESTOP_FLIGHT          = "OneStopFlight"
    static let WS_REQS_PARAM_PARM                    = "parm"
    static let WS_REQS_PARAM_PASSWORD                = "password"
    static let WS_REQS_PARAM_PAXES                   = "paxes"
    static let WS_REQS_PARAM_PASSENGER               = "passenger"
    static let WS_REQS_PARAM_PASSENGERS              = "Passengers"
    static let WS_REQS_PARAM_PHONE_NUMBER            = "phone_number"
    static let WS_REQS_PARAM_PREF_AIRLINE            = "PreferredAirlines"
    static let WS_REQS_PARAM_PREF_DEPART_TIME        = "preference_departure_time"
    static let WS_REQS_PARAM_PRIMARY                 = "primary"
    static let WS_REQS_PARAM_RATE_KEY                = "rate_key"
    static let WS_REQS_PARAM_RATES                   = "rates"
    static let WS_REQS_PARAM_RETURNING               = "returning"
    static let WS_REQS_PARAM_ROOMS                   = "rooms"
    static let WS_REQS_PARAM_SEARCH_ID               = "search_id"
    static let WS_RESP_PARAM_SOURCE                  = "source"
    static let WS_REQS_PARAM_STAR_RATING             = "star_rating"
    static let WS_REQS_PARAM_SEAT_NAME               = "seatName"
    static let WS_REQS_PARAM_SURNAME                 = "surname"
    static let WS_REQS_PARAM_TITLE                   = "title"
    static let WS_REQS_PARAM_TO                      = "to"
    static let WS_REQS_PARAM_TRIP_TYPE               = "trip_type"
}

struct WSResponseParams {
    static let WS_RESP_PARAM_AC                      = "AC"
    static let WS_RESP_PARAM_ACCESS_KEY              = "access_key"
    static let WS_RESP_PARAM_ACCESS_TOKEN            = "access_token"
    static let WS_RESP_PARAM_ADDRESS                 = "address"
    static let WS_RESP_PARAM_AIRLINE                 = "Airline"
    static let WS_RESP_PARAM_AIRLINE_CODE            = "AirlineCode"
    static let WS_RESP_PARAM_AIRLINE_NAME            = "AirlineName"
    static let WS_RESP_PARAM_AIRPORT                 = "Airport"
    static let WS_RESP_PARAM_AIRPORT_CODE            = "AirportCode"
    static let WS_RESP_PARAM_AIRPORT_NAME            = "AirportName"
    static let WS_RESP_PARAM_ALLOTMENT               = "allotment"
    static let WS_RESP_PARAM_ARR_TIME                = "ArrTime"
    static let WS_RESP_PARAM_AMOUNT                  = "amount"
    static let WS_RESP_PARAM_AMOUNT_BY               = "amount_by"
    static let WS_RESP_PARAM_AMOUNT_OR_PERCENT       = "amount_or_percent"
    static let WS_RESP_PARAM_AMOUNT_TYPE             = "amount_type"
    static let WS_RESP_PARAM_ARRIVAL_TIME            = "arrivalTime"
    static let WS_RESP_PARAM_AVAILABLE               = "available"
    static let WS_RESP_PARAM_AVAILABLE_BALANCE       = "available_balance"
    static let WS_RESP_PARAM_SEATS_AVAILABLE         = "availableSeats"
    static let WS_RESP_PARAM_AVAILABLE_TRIPS         = "availableTrips"
    static let WS_RESP_PARAM_AVAILABLITY_STATUS      = "availability_status"
    static let WS_RESP_PARAM_BASE_FARE               = "BaseFare"
    static let WS_RESP_PARAM_BLOCK_KEY               = "BlockKey"
    static let WS_RESP_PARAM_BOARDING_DETAIL         = "boarding_details"
    static let WS_RESP_PARAM_BOARDING_TIMES          = "boardingTimes"
    static let WS_RESP_PARAM_BP_ID                   = "bpId"
    static let WS_RESP_PARAM_BP_NAME                 = "bpName"
    static let WS_RESP_PARAM_BUS_ROUTES              = "busRoutes"
    static let WS_RESP_PARAM_BUS_TYPE                = "busType"
    static let WS_RESP_PARAM_CATEGORY                = "category"
    static let WS_RESP_PARAM_CANCELLATION_POLICY     = "cancellation_policy"
    static let WS_RESP_PARAM_CANCEL_BY_DATE          = "cancel_by_date"
    static let WS_RESP_PARAM_CITES                   = "cities"
    static let WS_RESP_PARAM_CITY_CODE               = "city_code"
    static let WS_RESP_PARAM_CITYCODE_CAP            = "CityCode"
    static let WS_RESP_PARAM_CITY_NAME               = "city_name"
    static let WS_RESP_PARAM_CITYNAME_CAP            = "CityName"
    static let WS_RESP_PARAM_CODE                    = "code"
    static let WS_RESP_PARAM_CLIENT_NATIONALITY      = "client_nationality"
    static let WS_RESP_PARAM_COLUMN                  = "column"
    static let WS_RESP_PARAM_CONTACT_NO              = "contactNumber"
    static let WS_RESP_PARAM_COUNTRY                 = "country"
    static let WS_RESP_PARAM_COUNTRYCODE_CAP         = "CountryCode"
    static let WS_RESP_PARAM_COUNTRYNAME_CAP         = "CountryName"
    static let WS_RESP_PARAM_CURRENCY                = "Currency"
    static let WS_RESP_PARAM_DEP_TIME                = "DepTime"
    static let WS_RESP_PARAM_DEPARTURE_TIME          = "departureTime"
    static let WS_RESP_PARAM_DESCRIPTION             = "description"
    static let WS_RESP_PARAM_DESTINATION             = "Destination"
    static let WS_RESP_PARAM_DROPPING_TIME           = "droppingTimes"
    static let WS_RESP_PARAM_DURATION                = "Duration"
    static let WS_RESP_PARAM_DURATION_ACCUM          = "AccumulatedDuration"
    static let WS_RESP_PARAM_DETAIL                  = "detail"
    static let WS_RESP_PARAM_DETAILS                 = "details"
    static let WS_RESP_PARAM_DOB                     = "dob"
    static let WS_RESP_PARAM_DOUBLE_BIRTH            = "doubleBirth"
    static let WS_RESP_PARAM_DROP_MANDATORY          = "dropPointMandatory"
    static let WS_RESP_PARAM_FROM                    = "from"
    static let WS_RESP_PARAM_ERRORS                  = "errors"
    static let WS_RESP_PARAM_FACILITIES              = "facilities"
    static let WS_RESP_PARAM_FALSE                   = "false"
    static let WS_RESP_PARAM_FARE_CAP                = "Fare"
    static let WS_RESP_PARAM_FARE                    = "fare"
    static let WS_RESP_PARAM_FARES_DETAILS           = "fareDetails"
    static let WS_RESP_PARAM_FARES_QUOTES            = "fare_quote"
    static let WS_RESP_PARAM_FARES_RULES             = "fare_rule"
    static let WS_RESP_PARAM_FARES_RULES_CAP         = "FareRules"
    static let WS_RESP_PARAM_FARES_RULE_DETAIL       = "FareRuleDetail"
    static let WS_RESP_PARAM_FIRST_NAME              = "first_name"
    static let WS_RESP_PARAM_FLAT_FEE                = "flat_fee"
    static let WS_RESP_PARAM_FLIGHT_NO               = "FlightNumber"
    static let WS_RESP_PARAM_GROUP_CODE              = "group_code"
    static let WS_RESP_PARAM_GST                     = "GST"
    static let WS_RESP_PARAM_HOTEL                   = "hotel"
    static let WS_RESP_PARAM_HOTEL_CODE              = "hotel_code"
    static let WS_RESP_PARAM_HOTELS                  = "hotels"
    static let WS_RESP_PARAM_ID                      = "id"
    static let WS_RESP_PARAM_IMAGES                  = "images"
    static let WS_RESP_PARAM_ISLCC                   = "IsLCC"
    static let WS_RESP_PARAM_IS_GST_MANDATORY        = "IsGSTMandatory"
    static let WS_RESP_PARAM_IS_PAN_REQ_AT_BOOK      = "IsPanRequiredAtBook"
    static let WS_RESP_PARAM_IS_PAN_REQ_AT_TICKET    = "IsPanRequiredAtTicket"
    static let WS_RESP_PARAM_IS_PASSPORT_REQ_AT_BOOK = "IsPassportRequiredAtBook"
    static let WS_RESP_PARAM_IS_PASSPORT_REQ_AT_TICKET = "IsPassportRequiredAtTicket"
    static let WS_RESP_PARAM_GST_ALLOWED             = "GSTAllowed"
    static let WS_RESP_PARAM_LADIES_SEAT             = "ladiesSeat"
    static let WS_RESP_PARAM_LAST_NAME               = "last_name"
    static let WS_RESP_PARAM_LANDMARK                = "landmark"
    static let WS_RESP_PARAM_LAYOUT                  = "layout"
    static let WS_RESP_PARAM_LENGTH                  = "length"
    static let WS_RESP_PARAM_LOCATION                = "location"
    static let WS_RESP_PARAM_LOGID                   = "logid"
    static let WS_RESP_PARAM_MALES_SEAT              = "malesSeat"
    static let WS_RESP_PARAM_MARKUP                  = "markup"
    static let WS_RESP_PARAM_MAX_SEATS               = "maxSeatsPerTicket"
    static let WS_RESP_PARAM_MESSAGE                 = "message"
    static let WS_RESP_PARAM_MESSAGES                = "messages"
    static let WS_RESP_PARAM_MIN_RATE                = "min_rate"
    static let WS_RESP_PARAM_NET                     = "net"
    static let WS_RESP_PARAM_NON_REFUNDABLE          = "non_refundable"
    static let WS_RESP_PARAM_NUMBER_OF_ADULT         = "no_of_adults"
    static let WS_RESP_PARAM_NUMBER_OF_CHILDREN      = "no_of_children"
    static let WS_RESP_PARAM_NUMBER_OF_FLIGHTS       = "no_of_flight"
    static let WS_RESP_PARAM_NUMBER_OF_HOTELS        = "no_of_hotels"
    static let WS_RESP_PARAM_NUMBER_OF_NIGHT         = "no_of_nights"
    static let WS_RESP_PARAM_NUMBER_OF_ROOMS         = "no_of_rooms"
    static let WS_RESP_PARAM_NUMBER_OF_SEATS         = "NoOfSeatAvailable"
    static let WS_RESP_PARAM_NO_SEAT_LAYOUT_ENABLED  = "noSeatLayoutEnabled"
    static let WS_RESP_PARAM_NO_SHOW_FEE             = "no_show_fee"
    static let WS_RESP_PARAM_ORIGIN                  = "Origin"
    static let WS_RESP_PARAM_OTHER_INCLUSIONS        = "other_inclusions"
    static let WS_RESP_PARAM_PERCENT                 = "percent"
    static let WS_RESP_PARAM_PRICE                   = "price"
    static let WS_RESP_PARAM_PRICE_DETAILS           = "price_details"
    static let WS_RESP_PARAM_PAYMENT_TYPE            = "payment_type"
    static let WS_RESP_PUBLISHED_FARE                = "PublishedFare"
    static let WS_RESP_PARAM_RATE_KEY                = "rate_key"
    static let WS_RESP_PARAM_RATE_TYPE               = "rate_type"
    static let WS_RESP_PARAM_RATES                   = "rates"
    static let WS_RESP_PARAM_RATE                    = "rate"
    static let WS_RESP_PARAM_REGULAR                 = "regular"
    static let WS_RESP_PARAM_RESPONSE                = "response"
    static let WS_RESP_PARAM_RESPONSE_CAP            = "Response"
    static let WS_RESP_PARAM_RESULTS                 = "results"
    static let WS_RESP_PARAM_RESULTS_CAP             = "Results"
    static let WS_RESP_PARAM_RESULTS_INDEX           = "ResultIndex"
    static let WS_RESP_PARAM_RESERVED_FOR_SOCIAL_DIS = "reservedForSocialDistancing"
    static let WS_RESP_PARAM_ROOM_CODE               = "room_code"
    static let WS_RESP_PARAM_ROOM_TYPE               = "room_type"
    static let WS_RESP_PARAM_ROW                     = "row"
    static let WS_RESP_PARAM_SEARCH_ID               = "search_id"
    static let WS_RESP_PARAM_SEATS                   = "seats"
    static let WS_RESP_PARAM_SEATER                  = "seater"
    static let WS_RESP_PARAM_SEGMENTS                = "Segments"
    static let WS_RESP_PARAM_SLEEPER                 = "sleeper"
    static let WS_RESP_PARAM_SOURCES                 = "sources"
    static let WS_RESP_PARAM_STAR_RATTING            = "star_ratting"
    static let WS_RESP_PARAM_STATUS                  = "status"
    static let WS_REPS_PARAM_SUCCESS                 = "success"
    static let WS_RESP_PARAM_SUPPORTS_CANCELLATION   = "supports_cancellation"
    static let WS_RESP_PARAM_TAX                     = "Tax"
    static let WS_RESP_PARAM_TIME                    = "time"
    static let WS_RESP_PARAM_TIN                     = "tin"
    static let WS_RESP_PARAM_TRACE_ID                = "TraceId"
    static let WS_RESP_PARAM_TERMINAL                = "Terminal"
    static let WS_RESP_PARAM_TOKEN                   = "token"
    static let WS_RESP_PARAM_TOKEN_ID                = "token_id"
    static let WS_RESP_PARAM_TOKEN_TYPE              = "token_type"
    static let WS_RESP_PARAM_TOTAL_FARE              = "totalFare"
    static let WS_RESP_PARAM_TOTAL_NUM_OF_REQUEST    = "total_num_of_request"
    static let WS_RESP_PARAM_TRAVELS                 = "travels"
    static let WS_RESP_PARAM_TRUE                    = 200
    static let WS_RESP_PARAM_URL                     = "url"
    static let WS_RESP_PARAM_USER_ID                 = "user_id"
    static let WS_RESP_PARAM_VACCINATED_BUS          = "vaccinatedBus"
    static let WS_RESP_PARAM_VACCINATED_STAFF        = "vaccinatedStaff"
    static let WS_RESP_PARAM_ZINDEX                  = "zIndex"
    static let WS_RESP_PARAM_WIDTH                   = "width"
}

