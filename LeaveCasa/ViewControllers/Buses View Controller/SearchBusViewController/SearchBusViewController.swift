//
//  SearchBusViewController.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 16/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class SearchBusViewController: UIViewController {
    
    @IBOutlet weak var txtSource: SearchTextField!
    @IBOutlet weak var txtDestination: SearchTextField!
    @IBOutlet weak var txtDate: UITextField!
    
    lazy var cityCode = [Int]()
    lazy var cityName = [String]()
    lazy var destinationCode = [String]()
    lazy var destinationName = [String]()
    lazy var searchedDestinationCode = [String]()
    lazy var searchedDestinationName = [String]()
    lazy var sourceCityCode = Int()
    lazy var destinationCityCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtDate.text = Helper.setCheckInDate()
        setLeftbarButton()
        //        fetchSourceCityList()
        
        txtSource.addTarget(self, action: #selector(searchSourceCity(_:)), for: .editingChanged)
        txtDestination.addTarget(self, action: #selector(searchDestinationCity(_:)), for: .editingChanged)
        
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setupSourceSearchTextField(_ searchedCities: [String]) {
        txtSource.theme = SearchTextFieldTheme.lightTheme()
        txtSource.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        txtSource.theme.bgColor = UIColor.white
        txtSource.theme.fontColor = UIColor.black
        txtSource.theme.cellHeight = 40
        txtSource.filterStrings(searchedCities)
        txtSource.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.txtSource.text = item.title
            for i in 0..<self.cityName.count {
                if item.title == self.cityName[i] {
                    self.sourceCityCode = self.cityCode[i]
                }
            }
            self.txtSource.resignFirstResponder()
            self.fetchDestinationCityList()
        }
    }
    
    func setupDestinationSearchTextField(_ searchedCities: [String]) {
        txtDestination.theme = SearchTextFieldTheme.lightTheme()
        txtDestination.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        txtDestination.theme.bgColor = UIColor.white
        txtDestination.theme.fontColor = UIColor.black
        txtDestination.theme.cellHeight = 40
        txtDestination.filterStrings(searchedCities)
        txtDestination.itemSelectionHandler = { filteredResults, itemPosition in
            let item = filteredResults[itemPosition]
            self.txtDestination.text = item.title
            for i in 0..<self.destinationName.count {
                if item.title == self.destinationName[i] {
                    self.destinationCityCode = self.destinationCode[i]
                }
            }
            self.txtDestination.resignFirstResponder()
        }
    }
    
    func openDateCalendar() {
        if let calendar = ViewControllerHelper.getViewController(ofType: .WWCalendarTimeSelector) as? WWCalendarTimeSelector {
            calendar.delegate = self
            calendar.optionCurrentDate = Date()
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            present(calendar, animated: true, completion: nil)
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension SearchBusViewController {
    
    @objc func searchSourceCity(_ sender: UITextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        
        if !(sender.text?.isEmpty ?? true) {
            fetchSourceCityList()
        }
    }
    
    @objc func searchDestinationCity(_ sender: UITextField) {
        
        if self.searchedDestinationCode.count > 0 {
            self.searchedDestinationCode.removeAll()
        }
        
        if self.searchedDestinationName.count > 0 {
            self.searchedDestinationName.removeAll()
        }
        
        if (txtSource.text?.isEmpty ?? false) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_SOURCE_CITY)
            return
        }
        
        let city = sender.text ?? ""
        if !(city.isEmpty ) {
            
            for (index, item) in destinationName.enumerated() {
                
                if item.lowercased().contains(city.lowercased()) {
                    searchedDestinationName.append(destinationName[index])
                    searchedDestinationCode.append(destinationCode[index])
                }
            }
        } else {
            searchedDestinationCode = destinationCode
            searchedDestinationName = destinationName
        }
        
        setupDestinationSearchTextField(searchedDestinationName)
    }
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        if txtSource.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_SOURCE_CITY)
        } else if txtDestination.text?.isEmpty ?? true {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_CITY)
        } else {
            Helper.showLoader(onVC: self, message: Alert.LOADING)
            self.searchBus()
        }
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension SearchBusViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        txtDate.text = Helper.convertDate(date)
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if date < Date() {
            return false
        } else {
            return true
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension SearchBusViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtDate {
            openDateCalendar()
            return false
        } else {
            return true
        }
    }
}

// MARK: - API CALLS
extension SearchBusViewController {
    func fetchSourceCityList() {
        let city = self.txtSource.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        if WSManager.isConnectedToInternet() {
            WSManager.wsCallGetBusSourceCityCodes(city, success: { (response, message) in
                if self.cityName.count > 0 {
                    self.cityName.removeAll()
                }
                if self.cityCode.count > 0 {
                    self.cityCode.removeAll()
                }
                for i in 0..<response.count {
                    let dict = response[i]
                    self.cityName.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_NAME] as? String ?? "")
                    self.cityCode.append(dict[WSResponseParams.WS_RESP_PARAM_CITY_CODE] as? Int ?? 0)
                }
                self.setupSourceSearchTextField(self.cityName)
            }, failure: { (error) in
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                self.fetchSourceCityList()
            })
        }
    }
    
    func fetchDestinationCityList() {
        if WSManager.isConnectedToInternet() {
            //            let city = self.txtDestination.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
            
            WSManager.wsCallGetBusDestinationCityCodes(String(sourceCityCode), success: { (response, message) in
                
                if let results = response[WSResponseParams.WS_RESP_PARAM_CITES] as? [[String: AnyObject]] {
                    for i in 0..<results.count {
                        let dict = results[i]
                        self.destinationName.append(dict[WSRequestParams.WS_REQS_PARAM_NAME] as? String ?? "")
                        self.destinationCode.append(dict[WSResponseParams.WS_RESP_PARAM_ID] as? String ?? "")
                    }
                }
                self.setupDestinationSearchTextField(self.destinationName)
            }, failure: { (error) in
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                self.fetchDestinationCityList()
            })
        }
    }
    
    func searchBus() {
        Helper.hideLoader(onVC: self)
        
        
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [WSRequestParams.WS_REQS_PARAM_JOURNEY_DATE: txtDate.text as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_BUS_FROM: sourceCityCode as AnyObject,
                                               WSRequestParams.WS_REQS_PARAM_BUS_TO: destinationCityCode as AnyObject]
            WSManager.wsCallFetchBuses(params, success: { (response) in
                Helper.hideLoader(onVC: self)
                if let vc = ViewControllerHelper.getViewController(ofType: .BusListViewController) as? BusListViewController {
                    vc.buses = response
                    vc.searchedParams = params
                    vc.souceName = self.txtSource.text ?? ""
                    vc.destinationName = self.txtDestination.text ?? ""
                    vc.checkInDate = Helper.convertCheckinDate(self.txtDate.text ?? "")
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
                self.searchBus()
            })
        }
        
    }
}
