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
    
    
    //var results = [Results]()
    var flights = [Flight]()
    var returningFlights = [Flight]()
    var startDate = Date()
    var returnDate = Date()
    var selectedDate = 0
    var searchParams: [String: AnyObject] = [:]
    var searchedFlight = FlightStruct()
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
        self.lblFlight.text = "\(searchedFlight.sourceCode.uppercased()) - \(searchedFlight.destinationCode.uppercased())"
        self.lblRetrunFlight.text = "\(searchedFlight.destinationCode.uppercased()) - \(searchedFlight.sourceCode.uppercased())"
        self.lblDepartDate.text = Helper.convertDate(searchedFlight.fromDate, format: "E, MMM d")
        self.lblReturnDate.text = Helper.convertDate(searchedFlight.toDate, format: "E, MMM d")
        
        let flightOne = flights[selectedFlightIndex].sPrice
        let flightTwo = returningFlights[selectedReturnFlightIndex].sPrice
        
        self.lblTotalPrice.text = "\(flightOne + flightTwo)"
        
        self.tableView.reloadData()
        
        self.returningTableView.reloadData()
    }
}

// MARK: - UIBUTTON ACTIONS
extension FlightListRoundViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func bookButton(_ sender: UIButton) {
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightDetailViewController) as? FlightDetailViewController {
            //                    vc.flights = dict
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfInfants = self.numberOfInfants
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        } else if tableView == self.returningTableView {
            flight = returningFlights[indexPath.row]
        }
        
        cell.lblStartTime.text = Helper.convertStoredDate(flight.sStartTime, "HH:mm a")
        cell.lblEndTime.text = Helper.convertStoredDate(flight.sEndTime, "HH:mm a")
        cell.lblSource.text = "\(flight.sSourceCode.uppercased()), \(Helper.convertStoredDate(flight.sStartTime, "E").uppercased())"
        cell.lblDestination.text = "\(flight.sDestinationCode.uppercased()), \(Helper.convertStoredDate(flight.sEndTime, "E").uppercased())"
        cell.lblPrice.text = "₹ \(flight.sPrice)"
        cell.lblDuration.text = Helper.getDuration(minutes: flight.sAccDuration)
        cell.lblRoute.text = flight.sStopsCount == 0 ? "Non-stop" : "\(flight.sStopsCount) stop(s)"
        cell.lblAirline.text = flight.sAirlineName
        
        var stops = ""
        
        if flight.sStops.count == 1
        {
            stops = flight.sStops[0].sCityName
        } else if flight.sStops.count > 1
        {
            stops = "\(flight.sStops[0].sCityName) + \(flight.sStops.count)"
        }
        
        cell.lblStops.text = stops
        
        cell.lblFLightInfo.text = ""
        
        if let startTime = Helper.getStoredDate(flight.sStartTime) {
            let components = Calendar.current.dateComponents([ .hour, .minute], from: Date(), to: startTime)
            
            let hour = components.hour ?? 0
            let minute = components.minute ?? 0
            
            if hour < 5 && hour > 0 {
                cell.lblFLightInfo.text = "< \(hour) hours"
            } else if hour < 5 && minute > 0 {
                cell.lblFLightInfo.text = "< \(minute) minutes"
            }
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
            
            
            DispatchQueue.main.async {
                
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                WSManager.wsCallFetchFlights(params, success: { (results) in
                    Helper.hideLoader(onVC: self)
                    self.flights = results.first ?? []
                    self.returningFlights = results.last ?? []
                    
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
