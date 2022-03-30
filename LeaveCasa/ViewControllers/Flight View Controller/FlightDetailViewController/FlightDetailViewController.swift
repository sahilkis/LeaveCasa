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
    
    var flightsArray = [Flight]()
    
    var flights = Flight()
    var returningFlights = Flight()
    var searchedFlight = FlightStruct()
    
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
        self.lblFlightName.text = "\(flights.sSourceCode.uppercased()) - \(flights.sDestinationCode.uppercased())"
        
        if flightType == 1 {
            let deptDate = Helper.convertStoredDate(flights.sStartTime, "E, MMM d, yyyy")
            let retDate = Helper.convertStoredDate(returningFlights.sStartTime, "E, MMM d, yyyy")
            self.lblFlightTime.text = "\(deptDate) - \(retDate)"
            
            flightsArray = [flights, returningFlights]
        }
        else {
            flightsArray = [flights]
            self.lblFlightTime.text = Helper.convertStoredDate(flights.sStartTime, "E, MMM d, yyyy")
        }
        self.lblFlightType.text = searchedFlight.flightClass//"\(numberOfAdults + numberOfChildren + numberOfInfants) passengers"
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
        
        return self.flightsArray[section].sSegments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightDetailCell, for: indexPath) as! FlightDetailCell
        
        let item = self.flightsArray[indexPath.section].sSegments[indexPath.row]
        
        if indexPath.section == 0 {
            cell.lblTitle.text = "Flight To"
        }
        else {
            cell.lblTitle.text = "Flight Return"
        }
        cell.lblSource.text = item.sOriginAirport.sCityName
        cell.lblSourceCode.text = item.sOriginAirport.sCityCode
        cell.lblDestination.text = item.sDestinationAirport.sCityName
        cell.lblDestinationCode.text = item.sDestinationAirport.sCityCode
        
        cell.lblStartDate.text = Helper.convertStoredDate(item.sOriginDeptTime, "E, MMM d, yyyy")
        cell.lblStartTime.text = Helper.convertStoredDate(item.sOriginDeptTime, "HH:mm a")
        cell.lblEndDate.text = Helper.convertStoredDate(item.sDestinationArrvTime, "E, MMM d, yyyy")
        cell.lblEndTime.text = Helper.convertStoredDate(item.sDestinationArrvTime, "HH:mm a")
        
        cell.lblDuration.text = Helper.getDuration(minutes: item.sDuration)
        
        cell.lblFlightNo.text = item.sAirline.sFlightNumber
        cell.lblTerminal.text = item.sOriginAirport.sTerminal
        
        return cell
    }
}


// MARK: - API CALL
extension FlightDetailViewController {
    
    
}

