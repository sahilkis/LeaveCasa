//
//  SearchHotelViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 19/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class SearchHotelViewController: UIViewController {

    @IBOutlet weak var txtCity: SearchTextField!
    @IBOutlet weak var txtCheckIn: UITextField!
    @IBOutlet weak var txtCheckOut: UITextField!
    @IBOutlet weak var txtRooms: UITextField!
    @IBOutlet weak var btnPlusAdultRoomOne: UIButton!
    @IBOutlet weak var btnMinusAdultRoomOne: UIButton!
    @IBOutlet weak var btnPlusChildrenRoomOne: UIButton!
    @IBOutlet weak var btnMinusChildrenRoomOne: UIButton!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var roomsDropDown = DropDown()
    var isFromCheckin = true
    var checkinDate = Date()
    var checkoutDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftbarButton()
        setDates()
        setRoomsDropDown()
        hideMinusButton()
        txtCity.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.btnPlusAdultRoomOne.roundedButton()
        self.btnMinusAdultRoomOne.roundedButton()
        self.btnPlusChildrenRoomOne.roundedButton()
        self.btnMinusChildrenRoomOne.roundedButton()
    }
    
    func setLeftbarButton() {
        self.title = "Hotel Search"
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
    
    func setRoomsDropDown() {
        txtRooms.text = "01"
        roomsDropDown.anchorView = txtRooms
        roomsDropDown.dataSource = ["01", "02", "03"]
        roomsDropDown.selectionAction = { [weak self] (index, item) in
            self?.txtRooms.text = item
        }
    }
    
    func setDates() {
        checkinDate = Date()
        checkoutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        txtCheckIn.text = Helper.setCheckInDate()
        txtCheckOut.text = Helper.setCheckOutDate()
    }
    
    func hideMinusButton() {
        btnMinusAdultRoomOne.isHidden = true
        btnMinusChildrenRoomOne.isHidden = true
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
    
    @IBAction func searchClicked(_ sender: UIButton) {
        if txtCity.text?.isEmpty ?? true || cityCodeStr.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_CITY)
        } else {
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            searchHotel()
        }
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
        } else if textField == txtRooms {
            roomsDropDown.show()
            return false
        } else if textField == txtCheckIn {
            isFromCheckin = true
            openDateCalendar()
            return false
        } else if textField == txtCheckOut {
            isFromCheckin = false
            openDateCalendar()
            return false
        } else {
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
                                               WSRequestParams.WS_REQS_PARAM_CLIENT_NATIONALITY: "IN" as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_CUTOFF_TIME: 40000 as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_MORE_RESULTS: true as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_HOTEL_INFO: true as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_RATES: "concise" as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_HOTEL_CATEGORY: [2, 7] as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_ROOMS: [[WSRequestParams.WS_REQS_PARAM_ADULTS: "1"]] as AnyObject]
            WSManager.wsCallFetchHotels(params, success: { (response, markup, hotelCount, logId, searchId) in
                Helper.hideLoader(onVC: self)
                if let vc = ViewControllerHelper.getViewController(ofType: .HotelListViewController) as? HotelListViewController {
                    vc.hotels = response
                    vc.markups = markup
                    vc.hotelCount = String(hotelCount)
                    vc.logId = logId
                    vc.searchId = searchId
                    vc.checkInDate = Helper.convertCheckinDate(self.txtCheckIn.text ?? "")
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
