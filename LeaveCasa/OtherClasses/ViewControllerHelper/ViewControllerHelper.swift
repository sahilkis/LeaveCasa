//
//  ViewControllerHelper.swift
//  LeaveCasa
//
//  Created by Apple on 17/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

struct ViewControllerIdentifiers {
    static let MainViewController                   = "MainViewController"
    static let LoginViewController                  = "LoginViewController"
    static let SignupViewController                 = "SignupViewController"
    static let SWRevealViewController               = "SWRevealViewController"
    static let HomeViewController                   = "HomeViewController"
    static let SearchHotelViewController            = "SearchHotelViewController"
    static let HotelListViewController              = "HotelListViewController"
    static let HotelDetailViewController            = "HotelDetailViewController"
    static let WWCalendarTimeSelector               = "WWCalendarTimeSelector"
    static let SearchFlightViewController           = "SearchFlightViewController"
    static let FlightListViewController             = "FlightListViewController"
    static let FlightDetailViewController           = "FlightDetailViewController"
    static let FlightBookingViewController          = "FlightBookingViewController"
    static let SearchBusViewController              = "SearchBusViewController"
    static let BusListViewController                = "BusListViewController"
    static let FacilitiesViewController             = "FacilitiesViewController"
    static let HotelBookingViewController           = "HotelBookingViewController"
}

import UIKit

enum ViewControllerType {
    case MainViewController
    case LoginViewController
    case SignupViewController
    case SWRevealViewController
    case HomeViewController
    case SearchHotelViewController
    case HotelListViewController
    case HotelDetailViewController
    case HotelBookingViewController
    case WWCalendarTimeSelector
    case SearchFlightViewController
    case FlightListViewController
    case FlightDetailViewController
    case FlightBookingViewController
    case SearchBusViewController
    case BusListViewController
    case FacilitiesViewController
}

class ViewControllerHelper: NSObject {
    
    // This is used to retirve view controller and intents to reutilize the common code.
    
    class func getViewController(ofType viewControllerType: ViewControllerType) -> UIViewController {
        var viewController: UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let flightStoryboard = UIStoryboard(name: "Flight", bundle: nil)
        let busStoryboard = UIStoryboard(name: "Bus", bundle: nil)
        let hotelStoryboard = UIStoryboard(name: "Hotel", bundle: nil)

        if viewControllerType == .MainViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.MainViewController) as! MainViewController
        } else if viewControllerType == .LoginViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.LoginViewController) as! LoginViewController
        } else if viewControllerType == .SignupViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SignupViewController) as! SignupViewController
        } else if viewControllerType == .SWRevealViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SWRevealViewController) as! SWRevealViewController
        } else if viewControllerType == .HomeViewController {
            viewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HomeViewController) as! HomeViewController
        } else if viewControllerType == .WWCalendarTimeSelector {
            viewController = UIStoryboard.init(name: ViewControllerIdentifiers.WWCalendarTimeSelector, bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        }
        // Flight Storyboard
        else if viewControllerType == .SearchFlightViewController {
            viewController = flightStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SearchFlightViewController) as! SearchFlightViewController
        } else if viewControllerType == .FlightListViewController {
            viewController = flightStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.FlightListViewController) as! FlightListViewController
        } else if viewControllerType == .FlightDetailViewController {
            viewController = flightStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.FlightDetailViewController) as! FlightDetailViewController
        } else if viewControllerType == .FlightBookingViewController {
            viewController = flightStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.FlightBookingViewController) as! FlightBookingViewController
        }
        // Bus Storyboard
        else if viewControllerType == .SearchBusViewController {
           viewController = busStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SearchBusViewController) as! SearchBusViewController
       } else if viewControllerType == .BusListViewController {
           viewController = busStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.BusListViewController) as! BusListViewController
       }
        // Hotel storyboard
        else if viewControllerType == .SearchHotelViewController {
           viewController = hotelStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.SearchHotelViewController) as! SearchHotelViewController
       }  else if viewControllerType == .HotelListViewController {
           viewController = hotelStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HotelListViewController) as! HotelListViewController
       } else if viewControllerType == .HotelDetailViewController {
           viewController = hotelStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HotelDetailViewController) as! HotelDetailViewController
       } else if viewControllerType == .FacilitiesViewController {
           viewController = hotelStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.FacilitiesViewController) as! FacilitiesViewController
       } else if viewControllerType == .HotelBookingViewController {
           viewController = hotelStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.HotelBookingViewController) as! HotelBookingViewController
       } else {
            print("Unknown view controller type")
        }
        
        if let vc = viewController {
            return vc
        } else {
            return UIViewController()
        }
    }
}
