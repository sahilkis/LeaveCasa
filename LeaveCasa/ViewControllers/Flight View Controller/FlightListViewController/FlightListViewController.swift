//
//  FlightListViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 15/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit

class FlightListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //var results = [Results]()
    var flights = [Flight]()
    var startDate = Date()
    var dates = [Date]()
    var selectedDate = 0
    var searchParams: [String: AnyObject] = [:]
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        setRightbarButton()
        setDates()
        
        self.collectionView.reloadData()
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
    
    func setDates()
    {
        dates.removeAll()
        
        var dateObj = self.startDate
        
        dates.append(dateObj)
        
        for _ in 1..<7
        {
            let nextDate = Helper.setWeekDates(dateObj)
            
            dateObj = nextDate
            dates.append(nextDate)
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension FlightListViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        
    }
}


// MARK: - UITABLEVIEW METHODS
extension FlightListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightListCell, for: indexPath) as! FlightListCell
        
        let flight = flights[indexPath.row]
        
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
        let dict = flights[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightDetailViewController) as? FlightDetailViewController {
            vc.flights = dict
            vc.numberOfChildren = self.numberOfChildren
            vc.numberOfAdults = self.numberOfAdults
            vc.numberOfInfants = self.numberOfInfants
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension FlightListViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.FlightListCollectionCell, for: indexPath) as! FlightListCollectionCell
        
        let date = dates[indexPath.row]
        
        if selectedDate == indexPath.row
        {
            cell.viewBg.backgroundColor = LeaveCasaColors.PINK_COLOR
            cell.lblMonth.textColor = .white
            cell.lblDay.textColor = .white
        }else{
            cell.viewBg.backgroundColor = LeaveCasaColors.VIEW_BG_COLOR
            cell.lblMonth.textColor = LeaveCasaColors.LIGHT_GRAY_COLOR
            cell.lblDay.textColor = LeaveCasaColors.LIGHT_GRAY_COLOR
        }
        
        cell.lblMonth.text = Helper.getWeekMonth(date)
        cell.lblDay.text = Helper.getWeekDay(date)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchFlight(index: indexPath.row)
        
        //collectionView.reloadData()
    }
}

extension FlightListViewController {
    
    func searchFlight(index: Int) {
        
        if WSManager.isConnectedToInternet() {
            let date = self.dates[index]
            var params = searchParams
            
            params[WSRequestParams.WS_REQS_PARAM_DEPART] = Helper.convertDate(date) as AnyObject
            
            DispatchQueue.main.async {
                
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                WSManager.wsCallFetchFlights(params, success: { (results) in
                    Helper.hideLoader(onVC: self)
                    self.flights = results
                    self.selectedDate = index
                    self.startDate = date
                    
                    self.collectionView.reloadData()
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
