import UIKit
import SearchTextField
import DropDown

class SearchHotelViewController: UIViewController {

    @IBOutlet weak var txtCity: SearchTextField!
    @IBOutlet weak var txtCheckIn: UITextField!
    @IBOutlet weak var txtCheckOut: UITextField!
    @IBOutlet weak var lblRoom: UILabel!
    @IBOutlet weak var lblAdults: UILabel!
    @IBOutlet weak var lblChildren: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChildren = 0
    var ageOfChildren: [Int] = []
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    var finalRooms = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        setDates()
        
        lblRoom.text = "\(numberOfRooms)"
        lblAdults.text = "\(numberOfAdults)"
        lblChildren.text = "\(numberOfChildren)"
        txtCity.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                tableViewHeightConstraint.constant = newsize.height
            }
        }
    }
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
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
        
        if !(sender.text?.isEmpty ?? true) {
            fetchCityList()
        }
    }
    
    @IBAction func roomPlusClicked(_ sender: UIButton) {
        if numberOfRooms >= 1 {
            numberOfRooms = numberOfRooms + 1
            lblRoom.text = "\(numberOfRooms)"
        }
    }

    @IBAction func adultPlusClicked(_ sender: UIButton) {
        if numberOfAdults >= 1 {
            numberOfAdults = numberOfAdults + 1
            lblAdults.text = "\(numberOfAdults)"
        }
    }

    @IBAction func childPlusClicked(_ sender: UIButton) {
        if numberOfChildren >= 0 {
            numberOfChildren = numberOfChildren + 1
            lblChildren.text = "\(numberOfChildren)"
            
            ageOfChildren.append(1)
            
            tableView.reloadData()
        }
    }

    @IBAction func childAgePlusClicked(_ sender: UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
            var value = Int(cell.lblChildCount.text ?? "0") ?? 0

            if value < 12 {
                value += 1
                ageOfChildren[sender.tag] = value
                
                cell.lblChildCount.text = "\(value)"
            }
        }
    }

    @IBAction func roomMinusClicked(_ sender: UIButton) {
        if numberOfRooms > 1 {
            numberOfRooms = numberOfRooms - 1
            lblRoom.text = "\(numberOfRooms)"

        }
    }

    @IBAction func adultMinusClicked(_ sender: UIButton) {
        if numberOfAdults > 1 {
            numberOfAdults = numberOfAdults - 1
            lblAdults.text = "\(numberOfAdults)"

        }
    }
    
    @IBAction func childMinusClicked(_ sender: UIButton) {
        if numberOfChildren > 0 {
            numberOfChildren = numberOfChildren - 1
            lblChildren.text = "\(numberOfChildren)"

            ageOfChildren.removeLast()
            tableView.reloadData()
        }
    }
    
    @IBAction func childAgeMinusClicked(_ sender: UIButton) {
        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? SearchRoomsCell {
            var value = Int(cell.lblChildCount.text ?? "0") ?? 0

            if value > 1 {
                value -= 1

                ageOfChildren[sender.tag] = value
                cell.lblChildCount.text = "\(value)"
            }
        }
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        if txtCity.text?.isEmpty ?? true || cityCodeStr.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_CITY)
        } else {
            var params: [String: AnyObject] = [:]
            
            params[WSRequestParams.WS_REQS_PARAM_ADULTS] = numberOfAdults as AnyObject
            params[WSRequestParams.WS_REQS_PARAM_CHILDREN_AGES] = ageOfChildren as AnyObject
            self.finalRooms.append(params)
            
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            searchHotel()
        }
    }
}

//// MARK: - UITABLEVIEW METHODS
extension SearchHotelViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfChildren
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.SearchRoomsCell, for: indexPath) as! SearchRoomsCell

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut

        cell.lblChildCount.text = "\(ageOfChildren[indexPath.row])"
        cell.labelTitle.text = "Age of Child \(indexPath.row + 1)"

        cell.btnPlusChild.tag = indexPath.row
        cell.btnMinusChild.tag = indexPath.row

        cell.btnPlusChild.addTarget(self, action: #selector(childAgePlusClicked(_:)), for: .touchUpInside)
        cell.btnMinusChild.addTarget(self, action: #selector(childAgeMinusClicked(_:)), for: .touchUpInside)

        return cell
    }
}

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
        } else if !isFromCheckin {
            if date < checkinDate {
                return false
            } else {
                return true
            }
        }
        else {
            return true
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
        let string = txtCity.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
                
                if string.isEmpty
                {
                    self.cityName.removeAll()
                    self.cityCode.removeAll()
                    self.setupSearchTextField(self.cityName)
                    return
                }
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallGetCityCodes(string, success: { (response, message) in
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
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_CURRENT_REQUEST: 0 as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_DESTINATION_CODE: cityCodeStr as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKIN: txtCheckIn.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CHECKOUT: txtCheckOut.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_ROOMS: finalRooms as AnyObject
            ]
            WSManager.wsCallFetchHotels(params, success: { (results, markup, logId) in
                Helper.hideLoader(onVC: self)
                if let vc = ViewControllerHelper.getViewController(ofType: .HotelListViewController) as? HotelListViewController {
                    vc.results = results
                    vc.markups = markup
                    vc.hotelCount = "\(results.reduce(0) {$0 + $1.numberOfHotels })"
                    vc.logId = logId
                    vc.checkInDate = Helper.convertCheckinDate(self.txtCheckIn.text ?? "")
                    vc.checkIn = self.txtCheckIn.text ?? ""
                    vc.checkOut = self.txtCheckOut.text ?? ""
                    vc.cityCodeStr = self.cityCodeStr
                    vc.finalRooms = self.finalRooms
                    vc.numberOfRooms = self.numberOfRooms
                    vc.numberOfAdults = self.numberOfAdults
                    vc.ageOfChildren = self.ageOfChildren
                    vc.totalRequest = results[0].totalRequests
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
