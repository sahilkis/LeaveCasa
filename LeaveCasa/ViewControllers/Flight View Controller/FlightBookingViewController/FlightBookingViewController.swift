//
//  FlightBookingViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 25/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown
import ObjectMapper

struct BookingDetail {
    var title = String()
    var firstName = String()
    var lastName = String()
    var paxType = String()
    var dob = String()
    var gender = String()
    var genderValue = Int()
    var passportNo = String()
    var passportExpiryDate = String()
    var addressLine1 = String()
    var addressLine2 = String()
    var city = String()
    var countryName = String()
    var countryCode = String()
    var nationality = String()
    var contactNo = String()
    var email = String()
    var panNo = String()
}

class FlightBookingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var btnAgreement: UIButton!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    //    @IBOutlet weak var txtGuestName: UITextField!
    //    @IBOutlet weak var txtGuestPhone: UITextField!
    //    @IBOutlet weak var txtGuestEmail: UITextField!
    
    var flights = Flight()
    var returningFlights = Flight()
    var searchedFlight = [FlightStruct]()
    var logId = 0
    var tokenId = ""
    var traceId = ""
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var guestDetails = [BookingDetail]()
    var isDoB = false
    var selectedIndex = 0
    var numberOfAdults = 1
    var numberOfChildren = 0
    var numberOfInfants = 0
    var flightFare = FlightFare()
    var returningflightFare = FlightFare()
    var titleDropDown = DropDown()
    var titles = ["Mr", "Ms", "Mrs", "Mstr", "Miss"]
    var genders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupData()
        setLeftbarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if (object as? UITableView) != nil {
                    self.tableViewHeightConstraint.constant = newSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupData() {
        
        for i in 0..<numberOfAdults {
            var obj = BookingDetail()
            
            obj.title = titles.first ?? ""
            obj.gender = genders.first ?? ""
            obj.genderValue = 0
            obj.paxType = "1"
            obj.nationality = "IN"
            obj.countryCode = "IN"
            obj.countryName = "India"
            
            guestDetails.append(obj) // TODO: Pending
        }
        
        self.tableView.reloadData()
        
        let totalFares: [FlightFare] = [flights.sFare, returningFlights.sFare]
        let basefare = totalFares.map({$0.sBaseFare}).reduce(0, +)
        let publishedfare = totalFares.map({$0.sPublishedFare}).reduce(0, +)
        let tax = totalFares.map({$0.sTax}).reduce(0, +)
        
        lblPrice.text = "₹ \(basefare)"
        lblFee.text = "₹ \(tax)"
        lblTotalPrice.text = "₹ \(publishedfare)"
        
        var baseTitle = "Adults * \(numberOfAdults)"
        if numberOfChildren > 0 {
            baseTitle += ", Children * \(numberOfChildren)"
        }
        if numberOfInfants > 0 {
            baseTitle += ", Infants * \(numberOfInfants)"
        }
        
        lblPriceTitle.text = baseTitle
        
        searchFlightFare()
        
        if returningFlights.sSegments.count > 0 {
            searchFlightFare(true)
        }
    }
    
    func openDateCalendar(_ textField: UITextField) {
        if let calendar = ViewControllerHelper.getViewController(ofType: .WWCalendarTimeSelector) as? WWCalendarTimeSelector {
            calendar.delegate = self
            
            calendar.optionCurrentDate = Date.date(year: Date().year - 12, month: Date().month, day: Date().day)
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            present(calendar, animated: true, completion: nil)
        }
    }
    
    func openDropDown(_ textfield: UITextField,_ array: [String], _ cellIndex : Int?, _ isTitle: Bool = true) {
        titleDropDown.show()
        titleDropDown.textColor = UIColor.black
        titleDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        titleDropDown.backgroundColor = UIColor.white
        titleDropDown.anchorView = textfield
        titleDropDown.dataSource = array
        titleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
            
            if let row = cellIndex {
                if isTitle {
                    guestDetails[row].title = item
                }
                else{
                    guestDetails[row].gender = item
                    guestDetails[row].genderValue = index
                }
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension FlightBookingViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAgreeTermsAction(_ sender: UIButton) {
        if sender.tag == 0
        {
            sender.tag = 1
            sender.setImage(LeaveCasaIcons.CHECKBOX_BLUE, for: .normal)
        }
        else{
            sender.tag = 0
            sender.setImage(LeaveCasaIcons.CHECKBOX_GREY, for: .normal)
        }
    }
    
    @IBAction func btnProceedToPaymentAction(_ sender: UIButton) {
        
        self.view.resignFirstResponder()
        bookFlightTicket()
        //        if let vc = ViewControllerHelper.getViewController(ofType: .FlightBookingViewController) as? FlightBookingViewController {
        //            vc.hotels = self.hotels
        //            vc.markups = self.markups
        //
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
}

// MARK: - WWCALENDARTIMESELECTOR DELEGATE
extension FlightBookingViewController: WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        if isDoB {
            guestDetails[selectedIndex].dob = Helper.convertDate(date)
        } else {
            guestDetails[selectedIndex].passportExpiryDate = Helper.convertDate(date)
        }
        
        self.tableView.reloadData()
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        if isDoB  && date > Date.date(year: Date().year - 12, month: Date().month, day: Date().day) {
            return false
        } else if !isDoB  && date < Date() {
            return false
        }
        else {
            return true
        }
    }
}

// MARK: - UITABLEVIEW METHODS
extension FlightBookingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guestDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.FlightBookingCell, for: indexPath) as! FlightBookingCell
        
        let detail = guestDetails[indexPath.row]
        
        cell.lblNumber.text = "Traveler \(indexPath.row + 1): "
        
        cell.txtTitle.text = detail.title
        cell.txtFirstName.text = detail.firstName
        cell.txtLastName.text = detail.lastName
        cell.txtGender.text = detail.gender
        cell.txtDOB.text = detail.dob
        cell.txtPassportNo.text = detail.passportNo
        cell.txtPassportExpiry.text = detail.passportExpiryDate
        cell.txtAddress1.text = detail.addressLine1
        cell.txtAddress2.text = detail.addressLine2
        cell.txtCity.text = detail.city
        cell.txtEmail.text = detail.email
        cell.txtPhone.text = detail.contactNo
        cell.txtPanNo.text = detail.panNo
        
        cell.txtTitle.delegate = self
        cell.txtFirstName.delegate = self
        cell.txtLastName.delegate = self
        cell.txtGender.delegate = self
        cell.txtDOB.delegate = self
        cell.txtPassportNo.delegate = self
        cell.txtPassportExpiry.delegate = self
        cell.txtAddress1.delegate = self
        cell.txtAddress2.delegate = self
        cell.txtCity.delegate = self
        cell.txtEmail.delegate = self
        cell.txtPhone.delegate = self
        cell.txtPanNo.delegate = self
        
        cell.txtTitle.tag = indexPath.row
        cell.txtFirstName.tag = indexPath.row
        cell.txtLastName.tag = indexPath.row
        cell.txtGender.tag = indexPath.row
        cell.txtDOB.tag = indexPath.row
        cell.txtPassportNo.tag = indexPath.row
        cell.txtPassportExpiry.tag = indexPath.row
        cell.txtAddress1.tag = indexPath.row
        cell.txtAddress2.tag = indexPath.row
        cell.txtCity.tag = indexPath.row
        cell.txtEmail.tag = indexPath.row
        cell.txtPhone.tag = indexPath.row
        cell.txtPanNo.tag = indexPath.row
        
        
        cell.txtPassportNo.isHidden = true
        cell.txtPassportExpiry.isHidden = true
        cell.txtPanNo.isHidden = true
        
        if flights.sIsPassportRequiredAtTicket || flights.sIsPassportRequiredAtBook {
            cell.txtPassportNo.isHidden = false
            cell.txtPassportExpiry.isHidden = false
        }
        
        if flights.sIsPanRequiredAtBook || flights.sIsPanRequiredAtTicket {
            cell.txtPanNo.isHidden = false
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
    
    @objc func selectTitle(_ sender: SearchTextField) {
        setupSearchTextField(["Mr", "Mrs", "Ms"], textField: sender)
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension FlightBookingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let row = textField.tag
        selectedIndex = row
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! FlightBookingCell
        
        if textField == cell.txtTitle {
            openDropDown(textField, titles, selectedIndex)
            return false
        } else if textField == cell.txtGender {
            openDropDown(textField, genders, selectedIndex)
            return false
        } else if textField == cell.txtDOB {
            isDoB = true
            self.view.resignFirstResponder()
            openDateCalendar(textField)
            return false
        } else if textField == cell.txtPassportExpiry {
            isDoB = false
            self.view.resignFirstResponder()
            openDateCalendar(textField)
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let row = textField.tag
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! FlightBookingCell
        
        if textField == cell.txtFirstName {
            guestDetails[row].firstName = textField.text ?? ""
        } else if textField == cell.txtLastName {
            guestDetails[row].lastName = textField.text ?? ""
        } else if textField == cell.txtTitle {
            guestDetails[row].title = textField.text ?? ""
        } else if textField == cell.txtGender {
            guestDetails[row].gender = textField.text ?? ""
        } else if textField == cell.txtDOB {
            guestDetails[row].dob = textField.text ?? ""
        } else if textField == cell.txtPanNo {
            guestDetails[row].panNo = textField.text ?? ""
        } else if textField == cell.txtPassportNo {
            guestDetails[row].passportNo = textField.text ?? ""
        } else if textField == cell.txtPassportExpiry {
            guestDetails[row].passportExpiryDate = textField.text ?? ""
        } else if textField == cell.txtCity {
            guestDetails[row].city = textField.text ?? ""
        } else if textField == cell.txtAddress1 {
            guestDetails[row].addressLine1 = textField.text ?? ""
        } else if textField == cell.txtAddress2 {
            guestDetails[row].addressLine2 = textField.text ?? ""
        } else if textField == cell.txtEmail {
            guestDetails[row].email = textField.text ?? ""
        } else if textField == cell.txtPhone {
            guestDetails[row].contactNo = textField.text ?? ""
        }
    }
}

// MARK: - API CALL
extension FlightBookingViewController {
    
    func setupSearchTextField(_ searchedArray: [String], textField: SearchTextField) {
        //        DispatchQueue.main.async {
        //
        //            let row = textField.tag
        //
        //            let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! BookingCell
        //
        //            if textField == cell.txtTitle {
        //
        //                textField.theme = SearchTextFieldTheme.lightTheme()
        //                textField.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        //                textField.theme.bgColor = UIColor.white
        //                textField.theme.fontColor = UIColor.black
        //                textField.theme.cellHeight = 40
        //                textField.filterStrings(searchedArray)
        //                textField.itemSelectionHandler = { filteredResults, itemPosition in
        //                    let item = filteredResults[itemPosition]
        //
        //                    self.guestDetails[row]["title"] = item
        //                    cell.txtTitle.resignFirstResponder()
        //                }
        //            } else if textField == cell.txtState {
        //
        //                textField.theme = SearchTextFieldTheme.lightTheme()
        //                textField.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        //                textField.theme.bgColor = UIColor.white
        //                textField.theme.fontColor = UIColor.black
        //                textField.theme.cellHeight = 40
        //                textField.filterStrings(searchedArray)
        //                textField.itemSelectionHandler = { filteredResults, itemPosition in
        //                    let item = filteredResults[itemPosition]
        //
        //                    self.guestDetails[row]["state"] = item
        //                    self.cityCodeStr = self.cityCode[itemPosition]
        //                    cell.txtState.resignFirstResponder()
        //                }
        //            }
        //        }
    }
    
    
    func fetchCityList(_ sender: SearchTextField) {
        let string = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20") ?? ""
        
        if string.isEmpty
        {
            self.cityName.removeAll()
            self.cityCode.removeAll()
            self.setupSearchTextField(self.cityName, textField: sender)
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
    
    func bookFlightTicket() {
        
        if btnAgreement.tag == 0 {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.AGREE_TERMS)
            return
        }
        var isLCC = self.flights.sIsLCC
        
        if returningFlights.sSegments.count > 0 {
            isLCC = self.flights.sIsLCC || self.returningFlights.sIsLCC
        }
       
        if WSManager.isConnectedToInternet() {
            
            var passengers = [[String: AnyObject]]()
            
            for i in guestDetails {
                if i.title.isEmpty || i.firstName.isEmpty || i.lastName.isEmpty || i.dob.isEmpty || i.gender.isEmpty || i.addressLine1.isEmpty || i.addressLine2.isEmpty || i.city.isEmpty || i.contactNo.isEmpty || i.email.isEmpty || ((flights.sIsPassportRequiredAtTicket || flights.sIsPassportRequiredAtBook) && (i.passportNo.isEmpty || i.passportExpiryDate.isEmpty)) || ((flights.sIsPanRequiredAtBook || flights.sIsPanRequiredAtTicket) && (i.panNo.isEmpty)) {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.Fill_All_FIELDS)
                    return
                } else if !Validator().isValid(email: i.email) {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
                    return
                } else if i.contactNo.count < 7 || i.contactNo.count > 15 {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.VALID_PHONE_NUMBER)
                    return
                }
                
                let fare : [String:AnyObject] = [
                    "Currency": flightFare.sCurrency as AnyObject,
                    "BaseFare": (flightFare.sBaseFare + returningflightFare.sBaseFare) as AnyObject,
                    "Tax": (flightFare.sTax + returningflightFare.sTax) as AnyObject,
                    "YQTax": (flightFare.sYQTax + returningflightFare.sYQTax) as AnyObject,
                    "AdditionalTxnFeePub": (flightFare.sAdditionalTxnFeePub + returningflightFare.sAdditionalTxnFeePub) as AnyObject,
                    "AdditionalTxnFeeOfrd": (flightFare.sAdditionalTxnFeeOfrd + returningflightFare.sAdditionalTxnFeeOfrd) as AnyObject,
                    "OtherCharges": (flightFare.sOtherCharges + returningflightFare.sOtherCharges) as AnyObject,
                    "Discount": (flightFare.sDiscount + returningflightFare.sDiscount) as AnyObject,
                    "PublishedFare": (flightFare.sPublishedFare + returningflightFare.sPublishedFare) as AnyObject,
                    "OfferedFare": (flightFare.sOfferedFare + returningflightFare.sOfferedFare) as AnyObject,
                    "TdsOnCommission": (flightFare.sTdsOnCommission + returningflightFare.sTdsOnCommission) as AnyObject,
                    "TdsOnPLB": (flightFare.sTdsOnPLB + returningflightFare.sTdsOnPLB) as AnyObject,
                    "TdsOnIncentive": (flightFare.sTdsOnIncentive + returningflightFare.sTdsOnIncentive) as AnyObject,
                    "ServiceFee": (flightFare.sServiceFee + returningflightFare.sServiceFee) as AnyObject
                ]
                
                var passenger: [String:AnyObject] = [
                    
                    "Title": i.title as AnyObject,
                    "FirstName": i.firstName as AnyObject,
                    "LastName": i.lastName as AnyObject,
                    "PaxType": i.paxType as AnyObject,
                    "DateOfBirth": i.dob as AnyObject,
                    "Gender": (i.genderValue + 1) as AnyObject, //i.gender as AnyObject,
                    "PassportNo": i.passportNo as AnyObject,
                    "PassportExpiry": i.passportExpiryDate as AnyObject,
                    "AddressLine1": i.addressLine1 as AnyObject,
                    "AddressLine2": i.addressLine2 as AnyObject,
                    "City": i.city as AnyObject,
                    "CountryCode": i.countryCode as AnyObject,
                    "CountryName": i.countryName as AnyObject,
                    "Nationality": i.nationality as AnyObject,
                    "ContactNo": i.contactNo as AnyObject,
                    "Email": i.email as AnyObject,
                    "Fare" : fare as AnyObject,
                    "IsLeadPax": true as AnyObject,
                    "FFAirlineCode": "" as AnyObject,
                    "FFNumber": "" as AnyObject,
                ]
                
                // TODO: Pending - Using static GST values for now
                if flights.sIsGSTMandatory || flights.sGSTAllowed || returningFlights.sIsGSTMandatory || returningFlights.sGSTAllowed {
                    passenger["GSTCompanyAddress"] = "2ND FLOOR, F-562 A, LADO SARAI, DELHI, South Delhi, Delhi, 110030" as AnyObject
                    passenger["GSTCompanyContactNumber"] = "7042457803" as AnyObject
                    passenger["GSTCompanyName"] = "LEAVECASA TRAVEL PRIVATE LIMITED" as AnyObject
                    passenger["GSTNumber"] = "07AADCL9221G1ZL" as AnyObject
                    passenger["GSTCompanyEmail"] = "nikhilg@acmemedia.in" as AnyObject
                }
                
                passengers.append(passenger)
            }
            
            var params: [String: AnyObject] = [
                WSResponseParams.WS_RESP_PARAM_TRACE_ID : self.traceId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_TOKEN : self.tokenId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_LOGID : self.logId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX : self.flights.sResultIndex as AnyObject,
                WSRequestParams.WS_REQS_PARAM_PASSENGERS: passengers as AnyObject
            ]
            
            params[WSResponseParams.WS_RESP_PARAM_LOGID] = 1480 as AnyObject //TODO: Pending
            
            
                   if isLCC {
                       
                       if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentViewController) as? WalletPaymentViewController {
                           
                           let totalFares: [FlightFare] = [self.flights.sFare, self.returningFlights.sFare]
                           
                           let price = totalFares.map({$0.sPublishedFare}).reduce(0, +)
                           
                           //                        if let markup = self.markups as? Markup {
                           //                            if markup.amountBy == Strings.PERCENT {
                           //                                price += (price * (markup.amount) / 100)
                           //                            } else {
                           //                                price += (markup.amount)
                           //                            }
                           //                        }
                           
                           vc.screenFrom = .flight
                           vc.isLCC = true
                           vc.params = params
                           vc.totalPayable = price
                           vc.bookingType = Strings.FLIGHT_BOOK
                           
                           self.navigationController?.pushViewController(vc, animated: true)
                       }
                   } else {
                       
                       Helper.showLoader(onVC: self, message: Alert.LOADING)
                       WSManager.wsCallFlightBookNonLCC(params, success: { (result) in
                           Helper.hideLoader(onVC: self)
                           
                           if let response = result[WSResponseParams.WS_RESP_PARAM_RESPONSE_CAP] as? [String:AnyObject] {
                               if let bookingId = response[WSResponseParams.WS_RESP_PARAM_BOOKING_ID] as? Int, let pnr = response[WSResponseParams.WS_RESP_PARAM_PNR] as? String  {

                                   if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentViewController) as? WalletPaymentViewController {
                                       
                                       let totalFares: [FlightFare] = [self.flights.sFare, self.returningFlights.sFare]
                                       
                                       let price = totalFares.map({$0.sPublishedFare}).reduce(0, +)
                                       
                                       //                        if let markup = self.markups as? Markup {
                                       //                            if markup.amountBy == Strings.PERCENT {
                                       //                                price += (price * (markup.amount) / 100)
                                       //                            } else {
                                       //                                price += (markup.amount)
                                       //                            }
                                       //                        }
                                       
                                       vc.screenFrom = .flight
                                       vc.params = [WSResponseParams.WS_RESP_PARAM_TRACE_ID : self.traceId as AnyObject,
                                                    WSResponseParams.WS_RESP_PARAM_TOKEN : self.tokenId as AnyObject,
                                                    WSResponseParams.WS_RESP_PARAM_BOOKING_ID: bookingId as AnyObject,
                                                    WSResponseParams.WS_RESP_PARAM_PNR: pnr
                                        as AnyObject,
                                                    WSResponseParams.WS_RESP_PARAM_LOGID: self.logId
                                                                                            as AnyObject]
                                       vc.totalPayable = price
                                       vc.bookingType = Strings.FLIGHT_BOOK
                                       
                                       self.navigationController?.pushViewController(vc, animated: true)
                                   }
                                   
                               }
                           }
                           else if let error = result[WSResponseParams.WS_RESP_PARAM_ERROR] as? [String:AnyObject], let errorMessage = error[WSResponseParams.WS_RESP_PARAM_ERROR_MESSAGE] as? String  {
                               Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: errorMessage)
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
                // self.searchFlight()
            })
        }
    }
    
    func searchFlightFare(_ isReturning: Bool = false) {
        
        var flightDetail = self.flights
        
        if isReturning {
            flightDetail = self.returningFlights
        }
        
        if WSManager.isConnectedToInternet() {
            var params: [String: AnyObject] = [
                WSResponseParams.WS_RESP_PARAM_TRACE_ID : self.traceId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_TOKEN : self.tokenId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_LOGID : self.logId as AnyObject,
                WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX : flightDetail.sResultIndex as AnyObject
            ]
            
            params[WSResponseParams.WS_RESP_PARAM_LOGID] = 1480 as AnyObject //TODO: Pending
            
            DispatchQueue.main.async {
                
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                WSManager.wsCallFetchFlightFareDetails(params, success: { (resultFareRules, resultFareQuotes) in
                    Helper.hideLoader(onVC: self)
                    
                    if let results = resultFareQuotes[WSResponseParams.WS_RESP_PARAM_RESULTS_CAP] as? [String:AnyObject], let fareQuotesObj = results[WSResponseParams.WS_RESP_PARAM_FARE_CAP] as? [String:AnyObject], let fareQuotes = Mapper<FlightFare>().map(JSON: fareQuotesObj) as FlightFare? {
                        if isReturning {
                            self.returningflightFare = fareQuotes
                        } else {
                            self.flightFare = fareQuotes
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
                // self.searchFlight()
            })
        }
    }
}
