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
    var logId = 0
    var tokenId = ""
    var traceId = ""
    var flights = [Flight]()
    var startDate = Date()
    var dates = [Date]()
    var selectedDate = 0
    var searchParams: [String: AnyObject] = [:]
    var searchedFlight = [FlightStruct]()
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    
    var selectedflightTime: Int = 0
    var selectedflightStop:Int = 0
    var selectedflightType: Int = 0
    //    var selectedflightAirline: Int = 0
    //    var selectedfundType: [Int] = []
    
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

extension FlightListViewController: FlightFilterDelegate {
    func applyFilter(flightTime: Int, flightStop: Int, flightType: Int) {
        selectedflightTime = flightTime
        selectedflightStop = flightStop
        selectedflightType = flightType
        //        selectedfundType = fundType
        //        selectedflightAirline = flightAirline
        
        searchFlight(index: selectedDate)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


// MARK: - UITABLEVIEW METHODS
extension FlightListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights[section].sSegments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightListCell, for: indexPath) as! FlightListCell
        
        let flight = flights[indexPath.section]
        
        cell.setUp(indexPath: indexPath, flight: flight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = flights[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightDetailViewController) as? FlightDetailViewController {
            vc.flights = dict
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
            var params = searchParams
            
            if let dept = params[WSRequestParams.WS_REQS_PARAM_DEPARTING] as? [String] {
                let date = Helper.convertDate(self.dates[index])
                var deptArry = dept
                
                deptArry[0] = date
                params[WSRequestParams.WS_REQS_PARAM_DEPARTING] = dept as AnyObject
            }
            
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
                    self.selectedDate = index
                    self.startDate = self.dates[index]
                    self.logId = logId
                    self.tokenId = tokenId
                    self.traceId = traceId
                    
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
