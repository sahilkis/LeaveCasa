//
//  SearchFlightViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 16/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class SearchFlightViewController: UIViewController {

    @IBOutlet weak var btnOneWay: UIButton!
    @IBOutlet weak var underlineOneWay: UIView!
    @IBOutlet weak var btnRoundTrip: UIButton!
    @IBOutlet weak var underlineRoundTrip: UIView!
    @IBOutlet weak var underlineMultiCity: UIView!
    @IBOutlet weak var btnMultiCity: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var selectedTab = 0 // 0 - One way, 1 - Round Trip, 2 - mutli city
    var array = [["Source": "New Delhi", "Destination": "Chandigarh" ,"From": "", "To" : "", "Class": "Economy", "Passengers": "1"]]
    var selectedIndex = 0 // selected cell in the array
    var numberOfRooms = 1
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTab()
    }
    
    private func setUpTab() {
        let selectedColor = LeaveCasaColors.PINK_COLOR
        let unselectedColor = LeaveCasaColors.LIGHT_GRAY_COLOR
        let clearColor = UIColor.clear

        switch selectedTab
        {
        case 0:
            btnOneWay.setTitleColor(selectedColor, for: .normal)
            underlineOneWay.backgroundColor = selectedColor
            
            btnRoundTrip.titleLabel?.textColor = unselectedColor
            underlineRoundTrip.backgroundColor = clearColor
            
            btnMultiCity.titleLabel?.textColor = unselectedColor
            underlineMultiCity.backgroundColor = clearColor
            break
            
        case 1:
            btnOneWay.titleLabel?.textColor = unselectedColor
            underlineOneWay.backgroundColor = clearColor
            
            btnRoundTrip.setTitleColor(selectedColor, for: .normal)
            underlineRoundTrip.backgroundColor = selectedColor
            
            btnMultiCity.titleLabel?.textColor = unselectedColor
            underlineMultiCity.backgroundColor = clearColor
            break
            
        case 2:
            btnOneWay.titleLabel?.textColor = unselectedColor
            underlineOneWay.backgroundColor = clearColor
            
            btnRoundTrip.titleLabel?.textColor = unselectedColor
            underlineRoundTrip.backgroundColor = clearColor
            
            btnMultiCity.setTitleColor(selectedColor, for: .normal)
            underlineMultiCity.backgroundColor = selectedColor
           break
        default: break
            
        }
        
        setDates()
        setUpTable()
        
    }
    
    private func setUpTable() {
        
        tableView.reloadData()
    }
    
    func setDates() {
        checkinDate = Date()
        checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        array[selectedIndex]["From"] = Helper.setCheckInDate()
        array[selectedIndex]["To"] = Helper.setCheckOutDate()
    }
    
    func openDateCalendar() {
        if let calendar = ViewControllerHelper.getViewController(ofType: .WWCalendarTimeSelector) as? WWCalendarTimeSelector {
            calendar.delegate = self
            if isFromCheckin {
                calendar.optionCurrentDate = checkinDate
            } else {
                calendar.optionCurrentDate = checkoutDate
            }
            
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            present(calendar, animated: true, completion: nil)
        }
    }
    
    func setupSearchTextField(_ searchedCities: [String], textField: SearchTextField) {
        DispatchQueue.main.async {
           
        let row = textField.tag
        
            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SearchFlightCell
        
        if textField == cell.txtSource {
        
            cell.txtSource.theme = SearchTextFieldTheme.lightTheme()
            cell.txtSource.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
            cell.txtSource.theme.bgColor = UIColor.white
            cell.txtSource.theme.fontColor = UIColor.black
            cell.txtSource.theme.cellHeight = 40
            cell.txtSource.filterStrings(searchedCities)
            cell.txtSource.itemSelectionHandler = { filteredResults, itemPosition in
                let item = filteredResults[itemPosition]
            
                self.array[row]["Source"] = item.title
                self.cityCodeStr = self.cityCode[itemPosition]
                cell.txtSource.resignFirstResponder()
            }
        } else if textField == cell.txtDestination {
            
            cell.txtDestination.theme = SearchTextFieldTheme.lightTheme()
            cell.txtDestination.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
            cell.txtDestination.theme.bgColor = UIColor.white
            cell.txtDestination.theme.fontColor = UIColor.black
            cell.txtDestination.theme.cellHeight = 40
            cell.txtDestination.filterStrings(searchedCities)
            cell.txtDestination.itemSelectionHandler = { filteredResults, itemPosition in
                let item = filteredResults[itemPosition]
                
                self.array[row]["Destination"] = item.title
                self.cityCodeStr = self.cityCode[itemPosition]
                cell.txtDestination.resignFirstResponder()

            }
        }
        }
    }
    
    @IBAction func btnOneWayAction(_ sender: UIButton) {
        selectedTab = 0
        setUpTab()
    }
    
    @IBAction func btnRoundTripAction(_ sender: UIButton) {
        selectedTab = 1
        setUpTab()
    }
    
    @IBAction func btnMultiCityAction(_ sender: UIButton) {
        selectedTab = 2
        setUpTab()
    }
    
    @IBAction func btnSearchAction(_ sender: UIButton) {
//        if txtCity.text?.isEmpty ?? true || cityCodeStr.isEmpty {
//            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_CITY)
//        } else {
//        }
    }
    
    @objc func btnCloseClicked(_ sender: UIButton) {
        let index = sender.tag
        
        array.remove(at: index)
        tableView.reloadData()
        
    }
    
    @objc func btnAddCityClicked(_ sender: UIButton) {
        let index = sender.tag
        var obj = ["Source": "", "Destination": "" ,"From": "", "To" : "", "Class": "Economy", "Passengers": "1"]
        
        if let lastDestination = array[index]["Destination"], let lastClass = array[index]["Class"], let lastPassengers = array[index]["Passengers"], let lastTo = array[index]["To"] {
            obj["Source"] = lastDestination
            obj["Class"] = lastClass
            obj["Passengers"] = lastPassengers
            obj["From"] = lastTo
        }
        
        array.append(obj) // add new city
        tableView.reloadData()
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension SearchFlightViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let row = textField.tag
        selectedIndex = row
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SearchFlightCell
        
        if textField == cell.txtSource || textField == cell.txtDestination || textField == cell.txtClass{
            return true
        }
        else if textField == cell.txtFrom {
            isFromCheckin = true
            openDateCalendar()
            return false
        }
        else if textField == cell.txtTo {
            isFromCheckin = false
            openDateCalendar()
            return false
        }
        else {
            return false
        }
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension SearchFlightViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if isFromCheckin {
            checkinDate = date
            checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            array[selectedIndex]["From"] = Helper.convertDate(date)
            array[selectedIndex]["To"] = Helper.nextCheckOutDate(date)
            
        } else {
            checkoutDate = date
            array[selectedIndex]["To"] = Helper.convertDate(date)
        }
        
        setUpTable()
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        } else {
            if date < checkinDate {
                return false
            } else {
                return true
            }
        }
    }
}
// MARK: - UITABLEVIEW METHODS
extension SearchFlightViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTab == 2 ? array.count : numberOfRooms
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchFlightCell, for: indexPath) as! SearchFlightCell
        let row = indexPath.row
        
        cell.setUpIndex(indexpath: indexPath)
        cell.setUpUI(indexpath: indexPath, selectedTab: selectedTab, isLast: array.count == row + 1)
        
        cell.txtSource.delegate = self
        cell.txtDestination.delegate = self
        cell.txtFrom.delegate = self
        cell.txtTo.delegate = self
        cell.txtClass.delegate = self

        cell.btnClose.addTarget(self, action: #selector(btnCloseClicked(_:)), for: .touchUpInside)
        cell.btnAddCity.addTarget(self, action: #selector(btnAddCityClicked(_:)), for: .touchUpInside)
//        cell.txtSource.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
//        cell.txtDestination.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)

        if let source = array[row]["Source"], let destination = array[row]["Destination"], let flightClass = array[row]["Class"], let passengers = array[row]["Passengers"], let from = array[row]["From"] , let to = array[row]["To"] {
            cell.txtSource.text = source
            cell.txtDestination.text = destination
            cell.txtFrom.text = from
            cell.txtTo.text = to
            cell.txtClass.text = "\(passengers), \(flightClass)"
        }

        return cell
    }
    
    @objc func searchCity(_ sender: SearchTextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
        fetchCityList(sender)
    }
}

// MARK: - API CALL
extension SearchFlightViewController {
    func fetchCityList(_ sender: SearchTextField) {
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallGetCityCodes(sender.text ?? "", success: { (response, message) in
                if self.cityName.count > 0 {
                    self.cityName.removeAll()
                }
                if self.cityCode.count > 0 {
                    self.cityCode.removeAll()
                }
                for i in 0..<response.count {
                    let dict = response[i]
                    self.cityName.append(dict[WSRequestParams.WS_REQS_PARAM_NAME] as? String ?? "")
                    self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CODE] as? String ?? "")
                }
                self.setupSearchTextField(self.cityName, textField: sender)
            }, failure: { (error) in
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                self.fetchCityList(sender)
            })
        }
    }
    
}
