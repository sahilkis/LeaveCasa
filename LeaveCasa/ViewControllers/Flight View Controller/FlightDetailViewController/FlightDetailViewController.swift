//
//  FlightDetailViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 24/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblFlightImage: UIImageView!
    @IBOutlet weak var lblFlightName: UILabel!
    @IBOutlet weak var lblFlightTime: UILabel!
    @IBOutlet weak var lblFlightType: UILabel!
    
    var flightsArray = [[FlightSegment]]()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = Flight()
    var returningFlights = Flight()
    var searchedFlight = [FlightStruct]()
    
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var flightType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setLeftbarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if (object as? UITableView) != nil {
                    //  self.tableViewHeightConstraint.constant = newSize.height
                }
                
            }
        }
        
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    private func setupData() {
        
        self.flightType = self.returningFlights.sSegments.count > 0 ? 1: 0
        self.lblFlightImage.image = UIImage()
        if flightType == 1 {
            flightsArray = flights.sSegments + returningFlights.sSegments
                        }
            else {
                    flightsArray = flights.sSegments
                }
        
        var flightNameString = ""
        var flightDatesString = ""
        var flightClassString = ""
        
        for flightStruct in searchedFlight {
            flightClassString  += "\(flightStruct.flightClass) - "
        }
        
        for (flightIndex, flightSegment) in flightsArray.enumerated() {
        if let firstSeg = flightSegment.first {
            let sSourceCode = firstSeg.sOriginAirport.sCityCode
            let sStartTime = firstSeg.sOriginDeptTime
            
            flightNameString += "\(sSourceCode.uppercased()) - "
            flightDatesString += "\(Helper.convertStoredDate(sStartTime, "E, MMM d, yyyy")) - "
            
            if let secondSeg = flightSegment.last, flightIndex == flightsArray.count - 1 {
                let sDestinationCode = secondSeg.sDestinationAirport.sCityCode
                
                flightNameString += "\(sDestinationCode.uppercased())"
                
//                if let returnflightSegment = returningFlights.sSegments.first, let returnfirstSeg = returnflightSegment.first , flightType == 1 {
//                    let deptDate = Helper.convertStoredDate(sStartTime, "E, MMM d, yyyy")
//                    let retDate = Helper.convertStoredDate(returnfirstSeg.sOriginDeptTime, "E, MMM d, yyyy")
//                    flightDatesString = "\(deptDate) - \(retDate)"
//
//                    flightsArray = flights.sSegments + returningFlights.sSegments
//                }
//                else {
//                    flightsArray = flights.sSegments
//                    flightDatesString = Helper.convertStoredDate(sStartTime, "E, MMM d, yyyy")
//                }
            }
        }
        
//            flightClassString  = searchedFlight.flightClass//"\(numberOfAdults + numberOfChildren + numberOfInfants) passengers"
            
        }
        self.lblFlightName.text = flightNameString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)//.dropLast()
        self.lblFlightTime.text = String(flightDatesString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).dropLast())
        self.lblFlightType.text = String(flightClassString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).dropLast())
        
        self.tableView.reloadData()
        
    }
}

// MARK: - UIBUTTON ACTIONS
extension FlightDetailViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBookNowAction(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightBookingViewController) as? FlightBookingViewController {
            
            vc.flights = self.flights
            vc.returningFlights = self.returningFlights
            vc.tokenId = self.tokenId
            vc.logId = self.logId
            vc.traceId = self.traceId
            vc.searchedFlight = self.searchedFlight
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfInfants = self.numberOfInfants
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITABLEVIEW METHODS
extension FlightDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return flightsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.flightsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightDetailCell, for: indexPath) as! FlightDetailCell
        
        let item = self.flightsArray[indexPath.section][indexPath.row]
        
//        if indexPath.section == 0 {
//            cell.lblTitle.text = "Flight To"
//        }
//        else {
//            cell.lblTitle.text = "Flight Return"
//        }
        
        //        if let item = item.first {
        cell.lblAirline.text = item.sAirline.sAirlineName
        cell.lblSource.text = item.sOriginAirport.sCityName
        cell.lblSourceCode.text = item.sOriginAirport.sCityCode
        cell.lblDestination.text = item.sDestinationAirport.sCityName
        cell.lblDestinationCode.text = item.sDestinationAirport.sCityCode
        
        cell.lblStartDate.text = Helper.convertStoredDate(item.sOriginDeptTime, "E, MMM d, yyyy")
        cell.lblStartTime.text = Helper.convertStoredDate(item.sOriginDeptTime, "HH:mm")
        cell.lblEndDate.text = Helper.convertStoredDate(item.sDestinationArrvTime, "E, MMM d, yyyy")
        cell.lblEndTime.text = Helper.convertStoredDate(item.sDestinationArrvTime, "HH:mm")
        
        cell.lblDuration.text = Helper.getDuration(minutes: item.sDuration)
        
        cell.lblFlightNo.text = item.sAirline.sFlightNumber
        cell.lblTerminal.text = item.sOriginAirport.sTerminal
        
        //        }
        
        cell.btnFareRules.tag = (indexPath.section * 1000) + indexPath.row
        cell.btnFareRules.addTarget(self, action: #selector(btnFareRules(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnFareRules(_ sender: UIButton) {
        //        let row: Int = sender.tag % 1000
        let section: Int = sender.tag / 1000
        
        let item = flightsArray[section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightFareRulesViewController) as? FlightFareRulesViewController {
            
            vc.flights = (section >= flights.sSegments.count) ? returningFlights : flights
            vc.tokenId = self.tokenId
            vc.logId = self.logId
            vc.traceId = self.traceId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - API CALL
extension FlightDetailViewController {
    
    
}

