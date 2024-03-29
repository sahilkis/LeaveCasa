//
//  AppConstants.swift
//  LeaveCasa
//
//  Created by Apple on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

struct CurrentDevice {
    static let isiPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let iPhone4S = isiPhone && UIScreen.main.bounds.size.height == 480
    static let iPhone5  = isiPhone && UIScreen.main.bounds.size.height == 568.0
    static let iPhone6  = isiPhone && UIScreen.main.bounds.size.height == 667.0
    static let iPhone6P = isiPhone && UIScreen.main.bounds.size.height == 736.0
    static let iPhoneX  = isiPhone && UIScreen.main.bounds.size.height == 812.0
    static let iPhoneXR = isiPhone && UIScreen.main.bounds.size.height == 896.0
    
    static let isiPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let iPadMini = isiPad && UIScreen.main.bounds.size.height <= 1024
}

// App constants
struct AppConstants {
    static let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
    static let PORTRAIT_SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let PORTRAIT_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let CURRENT_IOS_VERSION = UIDevice.current.systemVersion
    static let errSomethingWentWrong  = NSError(domain: Alert.ALERT_SOMETHING_WENT_WRONG, code: 0, userInfo: nil)
    
    static let flightTypes = ["All", "Economy", "Premium Economy", "Business", "Premium Business", "First"]
    static let flightTimes = ["MOR", "AFT", "EVE"]
    
}

// App custom cells name
struct CellIds {
    static let HotelListCell                = "HotelListCell"
    static let ImagesCell                   = "ImagesCell"
    static let RoomsCell                    = "RoomsCell"
    static let BusListCell                  = "BusListCell"
    static let FacilitiesCell               = "FacilitiesCell"
    static let SearchRoomsCell              = "SearchRoomsCell"
    static let SearchFlightCell             = "SearchFlightCell"
    static let FlightListCell               = "FlightListCell"
    static let FlightListCollectionCell     = "FlightListCollectionCell"
    static let FlightListRoundCell          = "FlightListRoundCell"
    static let BookingCell                  = "BookingCell"
    static let FlightDetailCell             = "FlightDetailCell"
    static let FlightBookingCell            = "FlightBookingCell"
    static let SeatCell                     = "SeatCell"
    static let TripsCell                    = "TripsCell"
    static let SettingsCell                 = "SettingsCell"
    static let TripsFlightDetailsCell       = "TripsFlightDetailsCell"
}

// Color Constants
struct LeaveCasaColors {
    static let BLUE_COLOR                   = UIColor.init(hex: "2CB7F2")
    static let LIGHT_GRAY_COLOR             = UIColor.init(hex: "BEC2CE")
    static let NAVIGATION_COLOR             = UIColor.init(hex: "F8F8F8")
    static let PINK_COLOR                   = UIColor.init(hex: "FF2D55")
    static let VIEW_BG_COLOR                = UIColor.init(hex: "F1F2F6")
}

// Font Constants
struct LeaveCasaFonts {
    static let FONT_PROXIMA_NOVA_REGULAR_12 = UIFont.init(name: "ProximaNova-Regular", size: 12)
    static let FONT_PROXIMA_NOVA_REGULAR_18 = UIFont.init(name: "ProximaNova-Regular", size: 18)
    static let FONT_PROXIMA_NOVA_BOLD_18    = UIFont.init(name: "ProximaNova-Bold", size: 18)
}

// Icons Constants
struct LeaveCasaIcons {
    static let BLACK_BACK                    = UIImage.init(named: "ic_back_black")
    static let THREE_DOTS                    = UIImage.init(named: "ic_three_dots")
    static let CHECKBOX_BLUE                 = UIImage.init(named: "ic_square_tick_blue")
    static let CHECKBOX_GREY                 = UIImage.init(named: "ic_square_tick_grey")
    static let RADIO_BLUE                    = UIImage.init(named: "ic_radio_unselected")
    static let RADIO_GREY                    = UIImage.init(named: "ic_radio_unselected")
    static let SEARCH                        = UIImage.init(named: "ic_search")
    static let SIDE_MENU                     = UIImage.init(named: "ic_side_menu")
    static let HOME_FLIGHT                   = UIImage.init(named: "ic_home_flight")
    static let HOME_HOTEL                    = UIImage.init(named: "ic_home_hotel")
    static let HOME_BUS                      = UIImage.init(named: "ic_home_bus")
    static let SEAT_BLACK                    = UIImage.init(named: "ic_seat_black")
    static let SEAT_BLUE                     = UIImage.init(named: "ic_seat_blue")
    static let SEAT_GREY                     = UIImage.init(named: "ic_seat_grey")
    static let SEAT_RED                      = UIImage.init(named: "ic_seat_red")
    static let SEAT_YELLOW                   = UIImage.init(named: "ic_seat_yellow")
    static let SLEEPER_BLACK                 = UIImage.init(named: "ic_sleeper_black")
    static let SLEEPER_BLUE                  = UIImage.init(named: "ic_sleeper_blue")
    static let SLEEPER_GREY                  = UIImage.init(named: "ic_sleeper_grey")
    static let SLEEPER_RED                   = UIImage.init(named: "ic_sleeper_red")
    static let SLEEPER_YELLOW                = UIImage.init(named: "ic_sleeper_yellow")
    static let SLEEPER_BLACK_VERT            = UIImage.init(named: "ic_sleeper_black_vertical")
    static let SLEEPER_BLUE_VERT             = UIImage.init(named: "ic_sleeper_blue_vertical")
    static let SLEEPER_GREY_VERT             = UIImage.init(named: "ic_sleeper_grey_vertical")
    static let SLEEPER_RED_VERT              = UIImage.init(named: "ic_sleeper_red_vertical")
    static let SLEEPER_YELLOW_VERT           = UIImage.init(named: "ic_sleeper_yellow_vertical")
    static let SIDE_MENU_USER                = UIImage.init(named: "ic_user_blue")
    static let SIDE_MENU_WALLET              = UIImage.init(named: "ic_wallet")
    static let SIDE_MENU_RATE                = UIImage.init(named: "ic_rating")
    static let SIDE_MENU_REFER               = UIImage.init(named: "ic_refer")
    static let SIDE_MENU_NOTIFICATION        = UIImage.init(named: "ic_notification")
    static let USER_PLACEHOLDER              = UIImage.init(named: "ic_user")
    @available(iOS 13.0, *)
    static let USER_PLACEHOLDER_GRAY         = UIImage.init(systemName: "person.circle.fill")

}

// Alert Titles
struct Alert {
    static let OK                           = "Ok"
    static let YES                          = "Yes"
    static let NO                           = "No"
    static let CANCEL                       = "Cancel"
    static let ERROR                        = "Error"
    static let SUCCESS                      = "Success"
    static let LOADING                      = "Loading..."
    static let ALERT                        = "Alert"
    static let LOGOUT                       = "Logout"
    static let TRY_AGAIN                    = "Try Again"
    static let NO_INTERNET                  = "No Internet Connection"
    static let ALERT_SOMETHING_WENT_WRONG   = "Whoops, something went wrong. Please refresh and try again."
    static let SUCCESS_ON_UPDATE_PROFILE    = "Successfully Updated Profile"

}

// Strings
struct Strings {
    static let BOOKING_ID                   = "Booking ID"
    static let PERCENT                      = "percent"
    static let CONTENT_SIZE                 = "contentSize"
    static let NON_REFUNDABLE               = "Non Refundable"
    static let REFUNDABLE                   = "Refundable"
    static let FACILITIES                   = "Facilities"
    static let YES                          = "Yes"
    static let NO                           = "No"
    static let FALSE                        = "false"
    static let TRUE                         = "true"
    static let HOTEL_BOOK                   = "hotel_book"
    static let FLIGHT_BOOK                  = "flight_book"
    static let BUS_BOOK                     = "Bus_book"
    static let HOTEL_CANCEL                 = "hotel_cancel"
    static let FLIGHT_CANCEL                = "flight_cancel"
    static let BUS_CANCEL                   = "Bus_cancel"
    static let MY_TRIPS                     = "My Trips"
    static let PNR                          = "PNR"
    static let SAVE                         = "Save"
    static let SUCCESS_ON_UPDATE_PROFILE    = "successfully_update_profile"
    static let SUCCESSFULLY_UPLOAD_PROFILE_PIC    = "successfully_upload_profile_pic"

}

