import UIKit
import SearchTextField
import DropDown

class SearchHotelViewController: UIViewController {

    @IBOutlet weak var txtCity: SearchTextField!
    @IBOutlet weak var txtCheckIn: UITextField!
    @IBOutlet weak var txtCheckOut: UITextField!
//    @IBOutlet weak var lblRoom: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
//    var numberOfRooms = 1
//    var numberOfAdults = [1]
//    var numberOfChilds = [""]
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    var finalRooms = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        setDates()
        
        txtCity.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }

//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == Strings.CONTENT_SIZE {
//            if let newvalue = change?[.newKey] {
//                let newsize  = newvalue as! CGSize
//                tableViewHeightConstraint.constant = newsize.height
//            }
//        }
//    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupSearchTextField(_ searchedCities: [String]) {
        txtCity.theme = SearchTextFieldTheme.lightTheme()
        txtCity.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        txtCity.theme.bgColor = UIColor.white
        txtCity.theme.fontColor = UIColor.black
        txtCity.theme.cellHeight = 40
        txtCity.filterStrings(searchedCities)
        txtCity.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.txtCity.text = item.title
            self.cityCodeStr = self.cityCode[itemPosition]
            self.txtCity.resignFirstResponder()
        }
    }
    
    func setDates() {
        checkinDate = Date()
        checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        txtCheckIn.text = Helper.setCheckInDate()
        txtCheckOut.text = Helper.setCheckOutDate()
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
}

// MARK: - UIBUTTON ACTION
extension SearchHotelViewController {
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchCity(_ sender: UITextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
        fetchCityList()
    }
    
//    @IBAction func roomPlusClicked(_ sender: UIButton) {
//        if numberOfRooms >= 1 {
//            numberOfRooms = numberOfRooms + 1
//            lblRoom.text = "\(numberOfRooms)"
//
//            numberOfAdults.append(1)
//            numberOfChilds.append("")
//
//            tableView.reloadData()
//        }
//    }
//
//    @IBAction func adultPlusClicked(_ sender: UIButton) {
//        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
//            var value = Int(cell.lblAdultCount.text ?? "") ?? 1
//
//            if value < 5 {
//                value += 1
//
//                numberOfAdults.remove(at: sender.tag)
//                numberOfAdults.insert(value, at: sender.tag)
//
//                cell.lblAdultCount.text = "\(value)"
//            }
//        }
//    }
//
//    @IBAction func childPlusClicked(_ sender: UIButton) {
//        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
//            var value = Int(cell.lblChildCount.text ?? "0") ?? 0
//
//            if value < 5 {
//                value += 1
//
//                numberOfChilds.remove(at: sender.tag)
//                numberOfChilds.insert("\(value)", at: sender.tag)
//
//                cell.lblChildCount.text = "\(value)"
//            }
//        }
//    }
//
//    @IBAction func roomMinusClicked(_ sender: UIButton) {
//        if numberOfRooms > 1 {
//            numberOfRooms = numberOfRooms - 1
//            lblRoom.text = "\(numberOfRooms)"
//
//            numberOfAdults.removeLast()
//            numberOfChilds.removeLast()
//
//            tableView.reloadData()
//        }
//    }
//
//    @IBAction func adultMinusClicked(_ sender: UIButton) {
//        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
//            var value = Int(cell.lblAdultCount.text ?? "1") ?? 1
//
//            if value > 1 {
//                value -= 1
//
//                numberOfAdults.remove(at: sender.tag)
//                numberOfAdults.insert(value, at: sender.tag)
//
//                cell.lblAdultCount.text = "\(value)"
//            }
//        }
//    }
//
//    @IBAction func childMinusClicked(_ sender: UIButton) {
//        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
//            var value = Int(cell.lblChildCount.text ?? "0") ?? 0
//
//            if value > 0 {
//                value -= 1
//
//                numberOfChilds.remove(at: sender.tag)
//                numberOfChilds.insert("\(value)", at: sender.tag)
//
//                cell.lblChildCount.text = "\(value)"
//            }
//        }
//    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        if txtCity.text?.isEmpty ?? true || cityCodeStr.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_CITY)
        } else {
            var params: [String: AnyObject] = [:]
            
            params[WSRequestParams.WS_REQS_PARAM_ADULTS] = "01" as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES] = [] as AnyObject
            self.finalRooms.append(params)
            
//            for i in 0..<numberOfRooms {
//                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SearchRoomsCell {
//                    let childCount = Int(cell.lblChildCount.text ?? "0") ?? 0
//
//                    params[WSRequestParams.WS_REQS_PARAM_ADULTS] = cell.lblAdultCount.text as AnyObject
//
//                    if childCount > 0 {
//                        params[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES] = [] as AnyObject
//                    }
//
//                    self.finalRooms.append(params)
//                }
//            }
            
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            searchHotel()
        }
    }
}

//// MARK: - UITABLEVIEW METHODS
//extension SearchHotelViewController: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return numberOfRooms
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchRoomsCell, for: indexPath) as! SearchRoomsCell
//
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .spellOut
//        let roomNumber = formatter.string(from: NSNumber(value: indexPath.row + 1))
//
//        cell.lblRoomCount.text = "In room \(roomNumber ?? "")"
//        cell.lblAdultCount.text = "\(numberOfAdults[indexPath.row])"
//        cell.lblChildCount.text = "\(numberOfChilds[indexPath.row])"
//
//        cell.btnPlusAdult.tag = indexPath.row
//        cell.btnMinusAdult.tag = indexPath.row
//        cell.btnPlusChild.tag = indexPath.row
//        cell.btnMinusChild.tag = indexPath.row
//
//        cell.btnPlusAdult.addTarget(self, action: #selector(adultPlusClicked(_:)), for: .touchUpInside)
//        cell.btnMinusAdult.addTarget(self, action: #selector(adultMinusClicked(_:)), for: .touchUpInside)
//        cell.btnPlusChild.addTarget(self, action: #selector(childPlusClicked(_:)), for: .touchUpInside)
//        cell.btnMinusChild.addTarget(self, action: #selector(childMinusClicked(_:)), for: .touchUpInside)
//
//        return cell
//    }
//}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension SearchHotelViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if isFromCheckin {
            checkinDate = date
            checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? Date()
            txtCheckIn.text = Helper.convertDate(date)
            txtCheckOut.text = Helper.nextCheckOutDate(date)
        } else {
            checkoutDate = date
            txtCheckOut.text = Helper.convertDate(date)
        }
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

// MARK: - UITEXTFIELD DELEGATE
extension SearchHotelViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCity {
            return true
        }
        else if textField == txtCheckIn {
            isFromCheckin = true
            openDateCalendar()
            return false
        }
        else if textField == txtCheckOut {
            isFromCheckin = false
            openDateCalendar()
            return false
        }
        else {
            return false
        }
    }
}

// MARK: - API CALL
extension SearchHotelViewController {
    func fetchCityList() {
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallGetCityCodes(txtCity.text ?? "", success: { (response, message) in
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
                self.setupSearchTextField(self.cityName)
            }, failure: { (error) in
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                self.fetchCityList()
            })
        }
    }
    
    func searchHotel() {
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_DESTINATION_CODE: cityCodeStr as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKIN: txtCheckIn.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKOUT: txtCheckOut.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject
            ]
            WSManager.wsCallFetchHotels(params, success: { (results, markup, hotelCount, logId) in
                Helper.hideLoader(onVC: self)
                if let vc = ViewControllerHelper.getViewController(ofType: .HotelListViewController) as? HotelListViewController {
                    vc.results = results
                    vc.markups = markup
                    vc.hotelCount = "\(hotelCount)"
                    vc.logId = logId
                    vc.checkInDate = Helper.convertCheckinDate(self.txtCheckIn.text ?? "")
                    vc.checkIn = self.txtCheckIn.text ?? ""
                    vc.checkOut = self.txtCheckOut.text ?? ""
                    vc.finalRooms = self.finalRooms
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                self.searchHotel()
            })
        }
    }
}
