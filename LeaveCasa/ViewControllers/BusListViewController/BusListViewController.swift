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
    @IBOutlet weak var lblBusCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var buses = [Bus]()
    var checkInDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        lblBusCount.text = "\(buses.count) Buses found"
        lblDate.text = checkInDate
        tableView.register(UINib.init(nibName: CellIds.BusListCell, bundle: nil), forCellReuseIdentifier: CellIds.BusListCell)
    }

    func setLeftbarButton() {
        self.title = "Buses"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
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
                arrivalTime = String((Int(arrivalTime) ?? 60) / 60)
                departureTime = String((Int(departureTime) ?? 60) / 60)
                cell.lblTimings.text = "\(String(departureTime)) - \(String(arrivalTime))"
            }
        }
        
        if let price = bus?.fareDetails {
            for i in 0..<price.count {
                let dict = price[i]
                if let fare = dict[WSResponseParams.WS_RESP_PARAM_TOTAL_FARE] as? String {
                    cell.lblPrice.text = "₹ \(fare)"
                }
            }
        }
        
        if let travels = bus?.sTravels {
            cell.lblBusName.text = travels
        }
        
        if let busType = bus?.sBusType {
            cell.lblBusType.text = busType
        }
        
        return cell
    }
}
