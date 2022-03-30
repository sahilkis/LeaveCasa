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
    static let SeatCell                     = "SeatCell"

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
    static let BLACK_BACK = UIImage.init(named: "ic_back_black")
    static let THREE_DOTS = UIImage.init(named: "ic_three_dots")
    static let CHECKBOX_BLUE = UIImage.init(named: "ic_square_tick_blue")
    static let CHECKBOX_GREY = UIImage.init(named: "ic_square_tick_grey")
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
}

// Strings
struct Strings {
    static let PERCENT                      = "percent"
    static let CONTENT_SIZE                 = "contentSize"
    static let NON_REFUNDABLE               = "Non Refundable"
    static let REFUNDABLE                   = "Refundable"
    static let FACILITIES                   = "Facilities"
    static let YES                          = "Yes"
    static let NO                           = "No"
    static let FALSE                        = "false"
}
