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
    
    var results = [Results]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLeftbarButton()
        tableView.register(UINib.init(nibName: CellIds.FlightListCell, bundle: nil), forCellReuseIdentifier: CellIds.FlightListCell)
        // Do any additional setup after loading the view.
    }
    
    func setLeftbarButton() {
        self.title = "Flight"
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

}
// MARK: - UIBUTTON ACTIONS
extension FlightListViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITABLEVIEW METHODS
extension FlightListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[section].hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightListCell, for: indexPath) as! FlightListCell
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = results[indexPath.section]
        
//        if let vc = ViewControllerHelper.getViewController(ofType: .HotelDetailViewController) as? HotelDetailViewController {
//            vc.hotels = dict.hotels[indexPath.row]
//            vc.searchId = dict.searchId
//            vc.logId = logId
//            vc.markups = markups
//            vc.checkIn = checkIn
//            vc.checkOut = checkOut
//            vc.finalRooms = finalRooms
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
