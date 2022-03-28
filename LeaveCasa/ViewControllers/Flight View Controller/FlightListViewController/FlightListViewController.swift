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
    var dates = [Date]()
    var selectedDate = 0

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
        
        var dateObj = Date()
        
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
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = flights[indexPath.section]
        
        if let vc = ViewControllerHelper.getViewController(ofType: .FlightDetailViewController) as? FlightDetailViewController {
            
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
        
        selectedDate = indexPath.row
        
        collectionView.reloadData()
    }
}
