//
//  TripsDetailViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 22/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class TripsDetailViewController: UIViewController {
    
    @IBOutlet weak var viewFlights: UIView!
    @IBOutlet weak var viewHotels: UIView!
    @IBOutlet weak var viewBuses: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
       
    var flight = Flight()
    var hotel = Hotels()
    var bus = Bus()
    var selectedTab = ScreenFrom.flight
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        setUpData()
        self.tableView.register(FlightListCell.self, forCellReuseIdentifier: CellIds.FlightListCell)
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
            self.viewBuses.isHidden = false
        case .flight:
//            self.viewFlights.isHidden = false
            break
        case .hotel:
            self.viewHotels.isHidden = false
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
            return flight.sSegments.count
        case .bus:
            return 0
        case .hotel:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightBookingCell, for: indexPath) as! FlightBookingCell
//
//
//        return cell
        
        switch selectedTab
        {
        case .flight:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightListCell, for: indexPath) as? FlightListCell {
                
                cell.lblPrice.text = "₹ \(flight.sPrice)"
                cell.lblFLightInfo.text = ""
                
                cell.lblFLightInfo.isHidden = true
                cell.lblPrice.isHidden = true
                cell.topSpace.constant = 0
                
                if indexPath.row == 0
                {
                    cell.lblFLightInfo.isHidden = false
                    cell.lblPrice.isHidden = false
                    cell.topSpace.constant = 16
                }
                
                if let flightSegment = flight.sSegments[indexPath.row] as? [FlightSegment]{
                    if let firstSeg = flightSegment.first {
                        let sSource = firstSeg.sOriginAirport.sCityName
                        let sSourceCode = firstSeg.sOriginAirport.sCityCode
                        let sAirlineName = firstSeg.sAirline.sAirlineName
                        let sStartTime = firstSeg.sOriginDeptTime
                        let sDuration = firstSeg.sDuration
                        let sStopsCount = flightSegment.count - 1
                        
                        if let secondSeg = flightSegment.last {
                            let sEndTime = secondSeg.sDestinationArrvTime
                            let sDestination = secondSeg.sDestinationAirport.sCityName
                            let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                            let sAccDuration = secondSeg.sAccDuration == 0 ? firstSeg.sDuration : secondSeg.sAccDuration
                            
                            cell.lblStartTime.text = Helper.convertStoredDate(sStartTime, "HH:mm")
                            cell.lblEndTime.text = Helper.convertStoredDate(sEndTime, "HH:mm")
                            cell.lblSource.text = "\(sSourceCode.uppercased()), \(Helper.convertStoredDate(sStartTime, "E").uppercased())"
                            cell.lblDestination.text = "\(sDestinationCode.uppercased()), \(Helper.convertStoredDate(sEndTime, "E").uppercased())"
                            
                            cell.lblDuration.text = Helper.getDuration(minutes: sAccDuration)
                            cell.lblRoute.text = sStopsCount == 0 ? "Non-stop" : "\(sStopsCount) stop(s)"
                            cell.lblAirline.text = sAirlineName
                            
                            if let startTime = Helper.getStoredDate(sStartTime) {
                                let components = Calendar.current.dateComponents([ .hour, .minute], from: Date(), to: startTime)
                                
                                let hour = components.hour ?? 0
                                let minute = components.minute ?? 0
                                
                                if hour < 5 && hour > 0 {
                                    cell.lblFLightInfo.text = "< \(hour) hours"
                                } else if hour < 5 && minute > 0 {
                                    cell.lblFLightInfo.text = "< \(minute) minutes"
                                }
                            }
                        }
                    }
                    var sStops = [FlightAirport]()
                    
                    for i in 1..<flightSegment.count {
                        sStops.append(flightSegment[i].sOriginAirport)
                    }
                    
                    var stops = ""
                    
                    if sStops.count == 1
                    {
                        stops = sStops[0].sCityName
                    } else if sStops.count > 1
                    {
                        stops = "\(sStops[0].sCityName) + \(sStops.count)"
                    }
                    
                    cell.lblStops.text = stops
                }
                
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
            WSManager.wsCallFetchTrips(success: { (hotels, buses, flights) in
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

