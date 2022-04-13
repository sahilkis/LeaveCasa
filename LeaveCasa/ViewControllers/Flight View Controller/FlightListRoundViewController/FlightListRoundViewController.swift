//
//  FlightListRoundViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 30/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightListRoundViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var returningTableView: UITableView!
    @IBOutlet weak var lblFlight: UILabel!
    @IBOutlet weak var lblRetrunFlight: UILabel!
    @IBOutlet weak var lblDepartDate: UILabel!
    @IBOutlet weak var lblReturnDate: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var logId = 0
    var tokenId = ""
    var traceId = ""
    //var results = [Results]()
    var flights = [Flight]()
    var returningFlights = [Flight]()
    var startDate = Date()
    var returnDate = Date()
    var selectedDate = 0
    var searchParams: [String: AnyObject] = [:]
    var searchedFlight = [FlightStruct]()
    var selectedflightTime: Int = 0
    var selectedflightStop:Int = 0
    var selectedflightType: Int = 0
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var selectedFlightIndex = 0
    var selectedReturnFlightIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        setRightbarButton()
        setUpData()
        
        // Do any additional setup after loading the view.
    }
    
    func setLeftbarButton() {
        self.title = "Flight"
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setRightbarButton() {
        let rightBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.THREE_DOTS, style: .plain, target: self, action: #selector(rightBarButton(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setUpData() {
        if let searchedFlight = searchedFlight.first {
            self.lblFlight.text = "\(searchedFlight.sourceCode.uppercased()) - \(searchedFlight.destinationCode.uppercased())"
            self.lblRetrunFlight.text = "\(searchedFlight.destinationCode.uppercased()) - \(searchedFlight.sourceCode.uppercased())"
            self.lblDepartDate.text = Helper.convertDate(searchedFlight.fromDate, format: "E, MMM d")
            self.lblReturnDate.text = Helper.convertDate(searchedFlight.toDate, format: "E, MMM d")
            
        }
        let flightOne = flights[selectedFlightIndex].sPrice
        let flightTwo = returningFlights[selectedReturnFlightIndex].sPrice
        
        self.lblTotalPrice.text = "₹ \(flightOne + flightTwo)"
        
        self.tableView.reloadData()
        
        self.returningTableView.reloadData()
    }
}

// MARK: - UIBUTTON ACTIONS
extension FlightListRoundViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func bookButton(_ sender: UIButton) {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightDetailViewController) as? FlightDetailViewController {
            vc.flights = self.flights[selectedFlightIndex]
            vc.returningFlights = self.returningFlights[selectedReturnFlightIndex]
            vc.searchedFlight = self.searchedFlight
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfInfants = self.numberOfInfants
            vc.tokenId = self.tokenId
            vc.logId = self.logId
            vc.traceId = self.traceId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightFilterViewController) as? FlightFilterViewController {
            vc.delegate = self
            
            vc.flightTime = selectedflightTime
            vc.flightStop = selectedflightStop
            vc.flightType = selectedflightType
            //            vc.flightAirline = selectedflightAirline
            //            vc.fundType = selectedfundType
            self.present(vc, animated: true, completion: nil)
            // self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FlightListRoundViewController: FlightFilterDelegate {
    func applyFilter(flightTime: Int, flightStop: Int, flightType: Int) {
        selectedflightTime = flightTime
        selectedflightStop = flightStop
        selectedflightType = flightType
        //        selectedfundType = fundType
        //        selectedflightAirline = flightAirline
        
        searchFlight()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - UITABLEVIEW METHODS
extension FlightListRoundViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return flights.count
        } else if tableView == self.returningTableView {
            return returningFlights.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightListRoundCell, for: indexPath) as! FlightListRoundCell
        
        var flight = Flight()
        if tableView == self.tableView {
            flight = flights[indexPath.row]
            
            if indexPath.row == selectedFlightIndex {
                cell.viewBg.borderColor = LeaveCasaColors.PINK_COLOR
                cell.viewBg.borderWidth = 1
            }
            else{
                cell.viewBg.borderColor = UIColor.clear
                cell.viewBg.borderWidth = 0
            }
        } else if tableView == self.returningTableView {
            flight = returningFlights[indexPath.row]
            
            if indexPath.row == selectedReturnFlightIndex {
                cell.viewBg.borderColor = LeaveCasaColors.PINK_COLOR
                cell.viewBg.borderWidth = 1
            }
            else{
                cell.viewBg.borderColor = UIColor.clear
                cell.viewBg.borderWidth = 0
            }
        }
        cell.lblPrice.text = "₹ \(flight.sPrice)"
        cell.lblFLightInfo.text = ""
        
        if let flightSegment = flight.sSegments.first {
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
            
            //                   if flightSegment.count - 1 == stops.count {
            //                       sStops = stops
            //                   }
            
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = Flight()
        if tableView == self.tableView {
            dict = flights[indexPath.row]
            selectedFlightIndex = indexPath.row
        } else if tableView == self.returningTableView {
            dict = returningFlights[indexPath.row]
            selectedReturnFlightIndex = indexPath.row
        }
        setUpData()
        
    }
}

extension FlightListRoundViewController {
    
    func searchFlight() {
        
        if WSManager.isConnectedToInternet() {
            var params = searchParams
            
            
            if selectedflightType > 0 {
                params[WSRequestParams.WS_REQS_PARAM_CLASS] = selectedflightType as AnyObject
            }
            
            if selectedflightStop == 1 {
                params[WSRequestParams.WS_REQS_PARAM_ONESTOP_FLIGHT] = true as AnyObject
            }
            if selectedflightStop == 2 {
                params[WSRequestParams.WS_REQS_PARAM_DIRECT_FLIGHT] = true as AnyObject
            }
            if selectedflightTime > 0 {
                params[WSRequestParams.WS_REQS_PARAM_PREF_DEPART_TIME] = [AppConstants.flightTimes[selectedflightTime-1].lowercased()] as AnyObject
            }
            
            DispatchQueue.main.async {
                
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                WSManager.wsCallFetchFlights(params, success: { (results, logId, tokenId, traceId) in
                    Helper.hideLoader(onVC: self)
                    self.flights = results.first ?? []
                    self.returningFlights = results.last ?? []
                    self.logId = logId
                    self.tokenId = tokenId
                    self.traceId = traceId
                    self.tableView.reloadData()
                    
                }, failure: { (error) in
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
                })
            }
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                // self.searchFlight()
            })
        }
    }
}
