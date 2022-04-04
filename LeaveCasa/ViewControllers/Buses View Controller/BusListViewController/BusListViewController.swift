//
//  BusListViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 20/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BusListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var lblBusCount: UILabel!
    //    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var buses = [Bus]()
    var checkInDate = ""
    var dates = [Date]()
    var selectedDate = 0
    var searchedParams = [String: AnyObject] ()
    var souceName = ""
    var destinationName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        setDates()
        
        //        lblBusCount.text = "\(buses.count) Buses found"
        //        lblDate.text = checkInDate
    }
    
    func setLeftbarButton() {
        self.title = "Buses"
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    func setDates()
    {
        dates.removeAll()
        
        var dateObj = Date()
        
        dates.append(dateObj)
        
        for _ in 1..<7
        {
            let nextDate = Helper.setWeekDates(dateObj)
            
            dateObj = nextDate
            dates.append(nextDate)
        }
        
        self.collectionView.reloadData()
    }
}

// MARK: - UIBUTTON ACTIONS
extension BusListViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITABLEVIEW METHODS
extension BusListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.BusListCell, for: indexPath) as! BusListCell
        let bus: Bus?
        bus = buses[indexPath.row]
        
        if let seats = bus?.sSeats {
            cell.lblSeats.text = "\(seats) Seats"
        }
        
        if var ac = bus?.sAC {
            if ac == Strings.FALSE {
                ac = Strings.NO
            } else {
                ac = Strings.YES
            }
            if var sleeper = bus?.sSleeper {
                if sleeper == Strings.FALSE {
                    sleeper = Strings.NO
                } else {
                    sleeper = Strings.YES
                }
                cell.lblBusCondition.text = "Ac: \(ac) | Sleeper: \(sleeper)"
            }
        }
        
        if var arrivalTime = bus?.sArrivalTime {
            if var departureTime = bus?.sDepartureTime {
                arrivalTime = Helper.getTimeString(time:arrivalTime)
                departureTime = Helper.getTimeString(time: departureTime)
                cell.lblStartTime.text = departureTime
                cell.lblEndTime.text = arrivalTime
                
            }
        }
        
        if let price = bus?.fareDetails {
            for i in 0..<price.count {
                let dict = price[i]
                if let fare = dict[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                    cell.lblPrice.text = "₹\(fare)"
                    break
                }
            }
        }
        
        if let travels = bus?.sTravels {
            cell.lblBusName.text = travels
        }
        
        cell.lblSource.text = souceName
        cell.lblDestination.text = destinationName
        
        //        if let busType = bus?.sBusType {
        //            cell.lblBusType.text = busType
        //        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BusDetailViewController) as? BusDetailViewController {
            
            vc.numberOfSeats = 50
            vc.buses = self.buses[indexPath.row]
            vc.searchedParams = self.searchedParams
            vc.souceName = self.souceName
            vc.destinationName = self.destinationName
            vc.date = self.dates[selectedDate]
             
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension BusListViewController: UICollectionViewDelegate, UICollectionViewDataSource
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
        
        searchBus(index: indexPath.row)
        
    }
    
    
    func searchBus(index: Int) {
        
        Helper.hideLoader(onVC: self)
        
        
        if WSManager.isConnectedToInternet() {
            var params: [String: AnyObject] = searchedParams
            
            let date = Helper.convertDate(self.dates[index])
            params[WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE] = date as AnyObject
            
            WSManager.wsCallFetchBuses(params, success: { (response) in
                Helper.hideLoader(onVC: self)
                
                self.buses = response
                self.selectedDate = index
                self.collectionView.reloadData()
                
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                //         self.searchBus()
            })
        }
        
    }
}

