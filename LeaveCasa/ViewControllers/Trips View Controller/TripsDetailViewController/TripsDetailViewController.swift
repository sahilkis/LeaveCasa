//
//  TripsDetailViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 22/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class TripsDetailViewController: UIViewController {
    
    @IBOutlet weak var lblBusSeats: UILabel!
    @IBOutlet weak var viewFlights: UIView!
    @IBOutlet weak var viewHotels: UIView!
    @IBOutlet weak var viewBuses: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewPayment: UIView!
    @IBOutlet weak var viewImpInfo: UIView!
    @IBOutlet weak var viewRefund: UIView!
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    @IBOutlet weak var lblImpInfo: UILabel!
    @IBOutlet weak var lblRefund: UILabel!
    
    @IBOutlet weak var lblBusPrice: UILabel!
    //    @IBOutlet weak var lblTimings: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
    //    @IBOutlet weak var lblBusType: UILabel!
    @IBOutlet weak var lblBusJourneyDate: UILabel!
    @IBOutlet weak var lblBusCondition: UILabel!
    @IBOutlet weak var lblBusStartTime: UILabel!
    @IBOutlet weak var lblBusSource: UILabel!
    @IBOutlet weak var lblBusEndTime: UILabel!
    @IBOutlet weak var lblBusDestination: UILabel!
    
    var flight = FlightBooking()
    var hotel = HotelBooking()
    var bus = BusBooking()
    var selectedTab = ScreenFrom.flight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.tableView.register(FlightListCell.self, forCellReuseIdentifier: CellIds.FlightListCell)
        setLeftbarButton()
        setUpData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if (object as? UITableView) != nil {
                    self.tableViewHeightConstraint.constant = newSize.height
                }
            }
        }
    }
    
    func setLeftbarButton() {
        self.title = ""
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setUpData() {
        
        self.viewFlights.isHidden = true
        self.viewHotels.isHidden = true
        self.viewBuses.isHidden = true
        
        switch selectedTab {
        case .bus:
            self.setUpBus()
            self.viewBuses.isHidden = false
            self.lblHeading.text = "Hope you have a NICE JOURNEY"
            self.lblImpInfo.text = ""
            self.lblRefund.text = ""
            self.lblPrice.text = self.lblBusPrice.text
            self.lblPaidAmount.text = self.lblBusPrice.text
            
            self.lblBusSource.text = self.bus.sBus.sSourceCity
            self.lblBusDestination.text = self.bus.sBus.sDestinationCity
            
            var bookingIdStr = ""
            
            if !self.bus.sBookingId.isEmpty
            {
                bookingIdStr = Strings.BOOKING_ID + ": " + self.bus.sBookingId
            }
            
            if !self.bus.sPNR.isEmpty
            {
                if !bookingIdStr.isEmpty {
                    bookingIdStr += ", "
                }
                bookingIdStr += Strings.PNR + ": " + self.bus.sPNR
            }
            
            self.lblBookingId.text = bookingIdStr
            
        case .flight:
            //            self.viewFlights.isHidden = false
            self.lblHeading.text = "Hope you have a GOOD EXPERIENCE"
            self.lblHeading.text = "Hope you have a NICE JOURNEY"
            self.lblImpInfo.text = ""
            self.lblRefund.text = ""
            self.lblPrice.text = "₹ \(self.flight.sFlight.sPrice)"
            self.lblPaidAmount.text = "₹ \(self.flight.sFlight.sPrice)"
            
            let fareRules = self.flight.sFlight.sFareRules
            self.lblImpInfo.attributedText = fareRules.htmlToAttributedString
            
            var bookingIdStr = ""
            
            if self.flight.sBookingId != 0
            {
                bookingIdStr = Strings.BOOKING_ID + ": " + "\(self.flight.sBookingId)"
            }
            
            if !self.flight.sPNR.isEmpty
            {
                if !bookingIdStr.isEmpty {
                    bookingIdStr += ", "
                }
                bookingIdStr += Strings.PNR + ": " + self.flight.sPNR
            }
            
            self.lblBookingId.text = bookingIdStr
            
            break
        case .hotel:
            self.viewHotels.isHidden = false
            self.lblHeading.text = "Hope you have a GOOD STAY"
            self.lblHeading.text = "Hope you have a NICE JOURNEY"
            self.lblImpInfo.text = ""
            self.lblRefund.text = ""
            //            self.lblPrice.text = self.hotel.sHotel
            //                        self.lblPaidAmount.text = self.lblBusPrice.text
            
            var bookingIdStr = ""
            
            if self.hotel.sBookingId != 0
            {
                bookingIdStr = Strings.BOOKING_ID + ": " + "\(self.hotel.sBookingId)"
            }
            
            if !self.hotel.sPNR.isEmpty
            {
                if !bookingIdStr.isEmpty {
                    bookingIdStr += ", "
                }
                bookingIdStr += Strings.PNR + ": " + self.hotel.sPNR
            }
            
            self.lblBookingId.text = bookingIdStr
        }
        
        self.tableView.reloadData()
        self.setupUI()
    }
    
    func setUpBus() {
        let bus: Bus? = bus.sBus
        
        if let seats = bus?.sSeats {
            self.lblBusSeats.text = "\(seats) Seats"
        }
        
        var ac = Strings.NO
        var sleeper = Strings.NO
        if !(bus?.sAC ?? false) {
            ac = Strings.NO
        } else {
            ac = Strings.YES
        }
        if !(bus?.sSleeper ?? false) {
            sleeper = Strings.NO
        } else {
            sleeper = Strings.YES
        }
        self.lblBusCondition.text = "Ac: \(ac) | Sleeper: \(sleeper)"
        
        if var arrivalTime = bus?.sArrivalTime {
            if var departureTime = bus?.sDepartureTime {
                arrivalTime = Helper.getTimeString(time:arrivalTime)
                departureTime = Helper.getTimeString(time: departureTime)
                self.lblBusStartTime.text = departureTime
                self.lblBusEndTime.text = arrivalTime
            }
        }
        
        if var arrivalTime = bus?.sDropTime {
            if var departureTime = bus?.sPickUpTime {
                arrivalTime = Helper.getTimeString(time:arrivalTime)
                departureTime = Helper.getTimeString(time: departureTime)
                self.lblBusStartTime.text = departureTime
                self.lblBusEndTime.text = arrivalTime
            }
        }
        
        if let doj = bus?.sDOJ {
            let date = Helper.convertDateFormat(doj, formatTo: "E, MMM d, yyyy")
            self.lblBusJourneyDate.text = date
        }
        
        if let price = bus?.fareDetails {
            var farePrice = 0.0
            
            if let fare = price[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                farePrice = Double(fare) ?? 0
            }
            
            if let priceArray = bus?.fareDetailsArray {
                for i in 0..<priceArray.count {
                    let dict = priceArray[i]
                    if let fare = dict[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                        farePrice = Double(fare) ?? 0
                        break
                    }
                }
            }
            
            //            if let markup = markups as? Markup {
            //                if markup.amountBy == Strings.PERCENT {
            //                    farePrice += (farePrice * (markup.amount) / 100)
            //                } else {
            //                    farePrice += (markup.amount)
            //                }
            //            }
            self.lblBusPrice.text = "₹\(String(format: "%.0f", farePrice))"
        }
        
        if let fare = self.bus.sPassengers.first?.sFare {
            self.lblBusPrice.text = "₹\(fare)"
        }
        
        if let travels = bus?.sTravels {
            self.lblBusName.text = travels
        }
        
        self.lblBusSource.text = bus?.sSourceCode
        self.lblBusDestination.text = bus?.sDestinationCode
        
    }
    
    func setupUI() {
        if self.lblImpInfo.text?.isEmpty ?? false {
            self.viewImpInfo.isHidden = true
        } else {
            self.viewImpInfo.isHidden = false
        }
        
        if self.lblRefund.text?.isEmpty ?? false {
            self.viewRefund.isHidden = true
        } else {
            self.viewRefund.isHidden = false
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension TripsDetailViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRaiseReqForRefundAction(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func btnDownloadInvokeAction(_ sender: UIButton) {
    }
    
    @IBAction func btnContactPropertyAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnPropertDetailsAction(_ sender: UIButton) {
        
    }
}

// MARK: - UITABLEVIEW METHODS
extension TripsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab
        {
        case .flight:
            return flight.sFlight.sSegments.count
        case .bus:
            return 0
        case .hotel:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedTab
        {
        case .flight:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.TripsFlightDetailsCell, for: indexPath) as? TripsFlightDetailsCell {
                
                cell.setUp(indexPath: indexPath, flight: flight.sFlight)
                
                return cell
            }
        case .bus:
            break
        case .hotel:
            break
        }
        return UITableViewCell()
    }
}


// MARK: - API CALL
extension TripsDetailViewController {
    func fetchTrips() {
        if WSManager.isConnectedToInternet() {
            Helper.showLoader(onVC: self, message: "")
            WSManager.wsCallFetchTrips(success: { (bookings) in
                Helper.hideLoader(onVC: self)
                
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                self.fetchTrips()
            })
        }
    }
}

