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

struct FlightStruct {
    var source = ""
    var destination = ""
    var sourceCode = ""
    var destinationCode = ""
    var from = ""
    var to = ""
    var fromDate = Date()
    var toDate = Date()
    var flightClassIndex = 0
    var flightClass = ""
    var passengers = 1
}

class SearchFlightViewController: UIViewController {
    
    @IBOutlet weak var btnOneWay: UIButton!
    @IBOutlet weak var underlineOneWay: UIView!
    @IBOutlet weak var btnRoundTrip: UIButton!
    @IBOutlet weak var underlineRoundTrip: UIView!
    @IBOutlet weak var underlineMultiCity: UIView!
    @IBOutlet weak var btnMultiCity: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblAdults: UILabel!
    @IBOutlet weak var lblChildren: UILabel!
    @IBOutlet weak var lblInfants: UILabel!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    var selectedTab = 0 // 0 - One way, 1 - Round Trip, 2 - mutli city
    var array = [FlightStruct]()
    var selectedIndex = 0 // selected cell in the array
    var numberOfRows = 1
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    var classDropDown = DropDown()
    var flightTypes = ["All", "Economy", "Premium Economy", "Business", "Premium Business", "First"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var first = FlightStruct()
        first.flightClass = flightTypes[first.flightClassIndex]
        
        array.append(first)
        // Do any additional setup after loading the view.
        setUpTab()
        setLeftbarButton()
        
        lblInfants.text = "\(numberOfInfants)"
        lblAdults.text = "\(numberOfAdults)"
        lblChildren.text = "\(numberOfChildren)"
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
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
        array[selectedIndex].fromDate = checkinDate
        array[selectedIndex].toDate = checkoutDate
        array[selectedIndex].from = Helper.setCheckInDate()
        array[selectedIndex].to = Helper.setCheckOutDate()
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
    
    func setupSearchTextField(_ searchedCities: [String], _ searchedCodes: [String], textField: SearchTextField) {
        DispatchQueue.main.async {
            var cities = [String]()
            
            let row = textField.tag
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SearchFlightCell
            
            for i in 0..<searchedCities.count {
                cities.append("\(searchedCities[i]) - \(searchedCodes[i].uppercased())")
            }
            
            if textField == cell.txtSource {
                
                cell.txtSource.theme = SearchTextFieldTheme.lightTheme()
                cell.txtSource.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
                cell.txtSource.theme.bgColor = UIColor.white
                cell.txtSource.theme.fontColor = UIColor.black
                cell.txtSource.theme.cellHeight = 40
                cell.txtSource.filterStrings(cities)
                cell.txtSource.itemSelectionHandler = { filteredResults, itemPosition in
                    self.array[row].source = self.cityName[itemPosition]
                    self.array[row].sourceCode = self.cityCode[itemPosition]
                    cell.txtSource.resignFirstResponder()
                    self.tableView.reloadData()
                }
            } else if textField == cell.txtDestination {
                
                cell.txtDestination.theme = SearchTextFieldTheme.lightTheme()
                cell.txtDestination.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
                cell.txtDestination.theme.bgColor = UIColor.white
                cell.txtDestination.theme.fontColor = UIColor.black
                cell.txtDestination.theme.cellHeight = 40
                cell.txtDestination.filterStrings(cities)
                cell.txtDestination.itemSelectionHandler = { filteredResults, itemPosition in
                    
                    self.array[row].destination = self.cityName[itemPosition]
                    self.array[row].destinationCode = self.cityCode[itemPosition]
                    cell.txtDestination.resignFirstResponder()
                    self.tableView.reloadData()
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
        var alertMessage = ""
        
        for item in array {
            if item.source.isEmpty || item.sourceCode.isEmpty {
                alertMessage = AlertMessages.SELECT_FROM_CITY
                break
            } else if item.destination.isEmpty || item.destinationCode.isEmpty {
                alertMessage = AlertMessages.SELECT_CITY
                break
            } else if item.from.isEmpty {
                alertMessage = AlertMessages.SELECT_DEPARUTRE_DATE
                break
            } else if item.to.isEmpty {
                alertMessage = AlertMessages.SELECT_RETURNING_DATE
                break
            }
        }
        
        if !alertMessage.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: alertMessage)
        } else {
            searchFlight()
        }
    }
    
    @objc func btnCloseClicked(_ sender: UIButton) {
        let index = sender.tag
        
        array.remove(at: index)
        tableView.reloadData()
        
    }
    
    @objc func btnAddCityClicked(_ sender: UIButton) {
        let index = sender.tag
        var obj = FlightStruct()
        
        let last = array[index]
        
        obj.source = last.destination
        obj.sourceCode = last.destinationCode
        obj.passengers = last.passengers
        obj.from = last.to
        obj.fromDate = last.toDate
        
        array.append(obj) // add new city
        tableView.reloadData()
    }
    
    @IBAction func infantsPlusClicked(_ sender: UIButton) {
        if numberOfInfants >= 0 {
            numberOfInfants = numberOfInfants + 1
            lblInfants.text = "\(numberOfInfants)"
        }
        updatePassenger()
    }
    
    @IBAction func adultPlusClicked(_ sender: UIButton) {
        if numberOfAdults >= 1 {
            numberOfAdults = numberOfAdults + 1
            lblAdults.text = "\(numberOfAdults)"
        }
        updatePassenger()
    }
    
    @IBAction func childPlusClicked(_ sender: UIButton) {
        if numberOfChildren >= 0 {
            numberOfChildren = numberOfChildren + 1
            lblChildren.text = "\(numberOfChildren)"
        }
        updatePassenger()
    }
    
    @IBAction func infantMinusClicked(_ sender: UIButton) {
        if numberOfInfants > 0 {
            numberOfInfants = numberOfInfants - 1
            lblInfants.text = "\(numberOfInfants)"
        }
        updatePassenger()
    }
    
    @IBAction func adultMinusClicked(_ sender: UIButton) {
        if numberOfAdults > 1 {
            numberOfAdults = numberOfAdults - 1
            lblAdults.text = "\(numberOfAdults)"
        }
        updatePassenger()
    }
    
    @IBAction func childMinusClicked(_ sender: UIButton) {
        if numberOfChildren > 0 {
            numberOfChildren = numberOfChildren - 1
            lblChildren.text = "\(numberOfChildren)"
        }
        updatePassenger()
    }
    
    func updatePassenger() {
        let passengers = numberOfAdults + numberOfChildren + numberOfInfants
        
        for i in 0..<array.count {
            array[i].passengers = passengers
        }
        
        self.tableView.reloadData()
        
    }
    
    func openDropDown(_ textfield: UITextField) {
        let indexPathRow = textfield.tag
        
        classDropDown.show()
        classDropDown.textColor = UIColor.black
        classDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        classDropDown.backgroundColor = UIColor.white
        classDropDown.anchorView = textfield
        classDropDown.dataSource = self.flightTypes
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.array[indexPathRow].flightClassIndex = index
            self.array[indexPathRow].flightClass = flightTypes[index]
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension SearchFlightViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButton(_ sender: UIBarButtonItem) {
        
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
        
        if textField == cell.txtSource || textField == cell.txtDestination {
            return true
        } else if textField == cell.txtClass {
            openDropDown(textField)
            return false
        } else if textField == cell.txtFrom {
            isFromCheckin = true
            openDateCalendar()
            return false
        } else if textField == cell.txtTo {
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
            array[selectedIndex].fromDate = checkinDate
            array[selectedIndex].toDate = checkoutDate
            array[selectedIndex].from = Helper.convertDate(date)
            array[selectedIndex].to = Helper.nextCheckOutDate(date)
            
        } else {
            checkoutDate = date
            array[selectedIndex].toDate = checkoutDate
            array[selectedIndex].to = Helper.convertDate(date)
            
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
        return selectedTab == 2 ? array.count : numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchFlightCell, for: indexPath) as! SearchFlightCell
        let row = indexPath.row
        let items = array[row]
        cell.setUpIndex(indexpath: indexPath)
        cell.setUpUI(indexpath: indexPath, selectedTab: selectedTab, isLast: array.count == row + 1)
        
        cell.txtSource.delegate = self
        cell.txtDestination.delegate = self
        cell.txtFrom.delegate = self
        cell.txtTo.delegate = self
        cell.txtClass.delegate = self
        
        cell.txtClass.tag = row
        cell.btnClose.tag = row
        cell.btnAddCity.tag = row
        
        cell.btnClose.addTarget(self, action: #selector(btnCloseClicked(_:)), for: .touchUpInside)
        cell.btnAddCity.addTarget(self, action: #selector(btnAddCityClicked(_:)), for: .touchUpInside)
        cell.txtSource.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        cell.txtDestination.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
        cell.txtSource.text = items.source
        cell.txtDestination.text = items.destination
        cell.txtFrom.text = items.from
        cell.txtTo.text = items.to
        cell.txtClass.text = items.flightClass
        
        
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
            WSManager.wsCallGetCityAirportCodes(sender.text ?? "", success: { (response, message) in
                if self.cityName.count > 0 {
                    self.cityName.removeAll()
                }
                if self.cityCode.count > 0 {
                    self.cityCode.removeAll()
                }
                for i in 0..<response.count {
                    let dict = response[i]
                    self.cityName.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? "")
                    self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? String ?? "")
                }
                self.setupSearchTextField(self.cityName, self.cityCode , textField: sender)
            }, failure: { (error) in
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                self.fetchCityList(sender)
            })
        }
    }
    
    func searchFlight() {
        
        if WSManager.isConnectedToInternet() {
            var params: [String: AnyObject] = [:]
            
            params = [
                WSRequestParams.WS_REQS_PARAM_ADULTS: numberOfAdults as AnyObject,
                WSRequestParams.WS_REQS_PARAM_CHILDS: numberOfChildren as AnyObject,
                WSRequestParams.WS_REQS_PARAM_INFANT: numberOfInfants as AnyObject,
                
            ]
            
            var sourceArray = [String]()
            var destinationArray = [String]()
            var departDateArray = [String]()
            
            for obj in array {
                if selectedTab == 0 {
                    params[WSRequestParams.WS_REQS_PARAM_TRIP_TYPE] = "one_way" as AnyObject
                    sourceArray.append(obj.sourceCode)
                    destinationArray.append(obj.destinationCode)
                    departDateArray.append(obj.from)
                } else if selectedTab == 1 {
                    params[WSRequestParams.WS_REQS_PARAM_TRIP_TYPE] = "round" as AnyObject
                    sourceArray.append(obj.sourceCode)
                    sourceArray.append(obj.destinationCode)
                    destinationArray.append(obj.destinationCode)
                    destinationArray.append(obj.sourceCode)
                    departDateArray.append(obj.from)
                    departDateArray.append(obj.to)
                } else if selectedTab == 2 {
                    params[WSRequestParams.WS_REQS_PARAM_TRIP_TYPE] = "multi_city" as AnyObject
                    sourceArray.append(obj.sourceCode)
                    destinationArray.append(obj.destinationCode)
                    departDateArray.append(obj.from)
                }
                
                params[WSRequestParams.WS_REQS_PARAM_CLASS] = obj.flightClassIndex + 1 as AnyObject
                
            }
            
            params[WSRequestParams.WS_REQS_PARAM_FROM] = sourceArray as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_TO] = destinationArray as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_DEPARTING] = departDateArray as AnyObject
            
            DispatchQueue.main.async {
                
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                WSManager.wsCallFetchFlights(params, success: { (results) in
                    Helper.hideLoader(onVC: self)
                    
                    if self.selectedTab != 1 { //Not round trip
                        if let vc = ViewControllerHelper.getViewController(ofType: .FlightListViewController) as? FlightListViewController {
                            vc.flights = results.first ?? []
                            vc.startDate = self.array[self.selectedIndex].fromDate
                            vc.searchParams = params
                            vc.searchedFlight = self.array[self.selectedIndex]
                            vc.numberOfChildren = self.numberOfChildren
                            vc.numberOfAdults = self.numberOfAdults
                            vc.numberOfInfants = self.numberOfInfants
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else if self.selectedTab == 1 { //round trip
                        if let vc = ViewControllerHelper.getViewController(ofType: .FlightListRoundViewController) as? FlightListRoundViewController {
                            vc.flights = results.first ?? []
                            vc.returningFlights = results.last ?? []
                            vc.startDate = self.array[self.selectedIndex].fromDate
                            vc.returnDate = self.array[self.selectedIndex].toDate
                            vc.searchedFlight = self.array[self.selectedIndex]
                            vc.searchParams = params
                            
                            vc.numberOfChildren = self.numberOfChildren
                            vc.numberOfAdults = self.numberOfAdults
                            vc.numberOfInfants = self.numberOfInfants
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }, failure: { (error) in
                    Helper.hideLoader(onVC: self)
                    Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
                })
            }
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                self.searchFlight()
            })
        }
    }
}
