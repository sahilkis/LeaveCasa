//
//  HotelBookingViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 23/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class HotelBookingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var stackInclusions: UIStackView!
    @IBOutlet weak var hotelRatingView: FloatRatingView!
    @IBOutlet weak var txtCheckIn: UITextField!
    @IBOutlet weak var txtCheckOut: UITextField!
    @IBOutlet weak var txtRoomCount: UITextField!
    @IBOutlet weak var txtRoomType: UITextField!
    @IBOutlet weak var lblAdultCount: UILabel!
    @IBOutlet weak var lblChildCount: UILabel!
    @IBOutlet weak var lblNumOfNights: UILabel!
    @IBOutlet weak var lblHotelRoomPrice: UILabel!
    @IBOutlet weak var lblHotelDiscount: UILabel!
    @IBOutlet weak var lblHotelGST: UILabel!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var txtHolderTitle: UITextField!
    @IBOutlet weak var txtHolderFirstName: UITextField!
    @IBOutlet weak var txtHolderLastName: UITextField!
    @IBOutlet weak var txtHolderPhone: UITextField!
    @IBOutlet weak var txtHolderEmail: UITextField!
    @IBOutlet weak var btnAgreement: UIButton!

    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var hotelDetail = HotelDetail()
    var selectedRoomRate = 0
    var markups = [Markup]()
    var prices = [[String: AnyObject]]()
    var searchId = ""
    var logId = 0
    var checkIn = ""
    var checkOut = ""
    var titleDropDown = DropDown()
    var titles = ["Mr", "Ms", "Mrs", "Mstr", "Miss"]
    var finalRooms = [[String: AnyObject]]()
    var guestDetails = [[String: AnyObject]]()
    var numberOfRooms = 1
    var numberOfAdults = 1
    var numberOfChild = 0
    var numberOfNights = 1
    var ageOfChildren: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtHolderTitle.delegate = self
        self.txtHolderTitle.text = titles[0]
        
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
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupData() {
        let hotel: HotelDetail?
        hotel = self.hotelDetail
        
        if let address = hotel?.sAddress {
            self.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            self.lblHotelName.text = name
        }
        if let rate = hotel?.rates {
            let minRate = rate[selectedRoomRate]
            
            var price = minRate.sPrice
            for i in 0..<markups.count {
                let markup: Markup?
                markup = markups[i]
                if markup?.starRating == hotel?.iCategory {
                    if markup?.amountBy == Strings.PERCENT {
                        price += (price * (markup?.amount ?? 0) / 100)
                    } else {
                        price += (markup?.amount ?? 0)
                    }
                }
            }
            self.lblTotalPrice.text = "₹\(String(format: "%.0f", price))"
            self.lblHotelRoomPrice.text = "₹\(String(minRate.sNetPrice))"
            self.lblHotelGST.text = "₹\(String(minRate.sGSTPrice))"
            
            if let roomtype = minRate.sRooms.first?.sRoomType {
                txtRoomType.text = roomtype
            }
            
            let otherinclusion = minRate.sOtherInclusions
            if otherinclusion.isEmpty {
                self.lblDescription.text = ""
                self.stackInclusions.isHidden = true
            }
            else {
                self.stackInclusions.isHidden = false
                self.lblDescription.text = "\(otherinclusion.joined(separator: "\n"))\n"
            }
            
            let availability = minRate.sAvailabiltyStatus.capitalized
            if !availability.isEmpty {
                self.lblAvailability.text = availability
            }
        }
        if let rating = hotel?.iCategory {
            self.hotelRatingView.rating = Double(rating)
        }
        
        txtCheckIn.text = checkIn
        txtCheckOut.text = checkOut
        
        txtRoomCount.text = "\(numberOfRooms)"
        
        lblAdultCount.text = "Adults: \(numberOfAdults)"
        lblChildCount.text = "Child: \(ageOfChildren.count)"
        
        lblNumOfNights.text = "\(numberOfNights)"
        
        for i in 0..<numberOfAdults {
            guestDetails.append(["title" : (titles.first ?? "") as AnyObject, "type": "AD" as AnyObject])
            
            // TODO: Pending
        }
        
        self.tableView.reloadData()
    }
    
    func openDropDown(_ textfield: UITextField, _ cellIndex : Int?) {
        titleDropDown.show()
        titleDropDown.textColor = UIColor.black
        titleDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        titleDropDown.backgroundColor = UIColor.white
        titleDropDown.anchorView = textfield
        titleDropDown.dataSource = self.titles
        titleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
            
            if let row = cellIndex {
                guestDetails[row]["title"] = item as AnyObject
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension HotelBookingViewController {
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
        recheckBooking()
    }
}


// MARK: - UITABLEVIEW METHODS
extension HotelBookingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guestDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.BookingCell, for: indexPath) as! BookingCell
        
        cell.txtTitle.delegate = self
        cell.txtFirstName.delegate = self
        cell.txtLastName.delegate = self
        cell.txtState.delegate = self
        
        cell.txtTitle.tag = indexPath.row
        cell.txtFirstName.tag = indexPath.row
        cell.txtLastName.tag = indexPath.row
        cell.txtState.tag = indexPath.row
        
        //        cell.txtState.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        //        // TODO: Pending - search state only
        let detail = guestDetails[indexPath.row]
        
        if let item = detail["name"] as? String {
            cell.txtFirstName.text = item
        }
        if let item = detail["surname"] as? String {
            cell.txtLastName.text = item
        }
        if let item = detail["title"] as? String {
            cell.txtTitle.text = item
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
        
        if !(sender.text?.isEmpty ?? true) {
            fetchCityList(sender)
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension HotelBookingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let row = textField.tag
        
        if textField == self.txtHolderTitle {
            openDropDown(textField, nil)
            return false
        }
        else if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookingCell {
            if textField == cell.txtTitle {
                openDropDown(textField, row)
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let row = textField.tag
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! BookingCell
        
        if textField == cell.txtFirstName {
            guestDetails[row]["name"] = textField.text as AnyObject
        }
        else if textField == cell.txtLastName {
            guestDetails[row]["surname"] = textField.text as AnyObject
        }
        else if textField == cell.txtTitle {
            guestDetails[row]["title"] = textField.text as AnyObject
        }
        //        else if textField == cell.txtState {
        //            guestDetails[row]["state"] = textField.text as AnyObject
        //        }
    }
}

// MARK: - API CALL
extension HotelBookingViewController {
    func setupSearchTextField(_ searchedArray: [String], textField: SearchTextField) {
        DispatchQueue.main.async {
            let row = textField.tag
            if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookingCell {
                if textField == cell.txtState {
                    textField.theme = SearchTextFieldTheme.lightTheme()
                    textField.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
                    textField.theme.bgColor = UIColor.white
                    textField.theme.fontColor = UIColor.black
                    textField.theme.cellHeight = 40
                    textField.filterStrings(searchedArray)
                    textField.itemSelectionHandler = { filteredResults, itemPosition in
                        let item = filteredResults[itemPosition]
                        
                        self.guestDetails[row]["state"] = item
                        self.cityCodeStr = self.cityCode[itemPosition]
                        cell.txtState.text = self.cityName[itemPosition]
                        cell.txtState.resignFirstResponder()
                    }
                }
            }
        }
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
    
    func recheckBooking() {
        let holderTitle = self.txtHolderTitle.text ?? ""
        let holderFName = self.txtHolderFirstName.text ?? ""
        let holderLName = self.txtHolderLastName.text ?? ""
        let holderEmail = self.txtHolderEmail.text ?? ""
        let holderPhone = self.txtHolderPhone.text ?? ""
        
        if holderTitle.isEmpty || holderEmail.isEmpty || holderFName.isEmpty || holderLName.isEmpty || holderPhone.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.Fill_FIELDS_REQUIRED)
            return
        } else if !Validator().isValid(email: holderEmail) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
            return
        } else if btnAgreement.tag == 0 {
           Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.AGREE_TERMS)
           return
        }
        
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [
                WSRequestParams.WS_REQS_PARAM_SEARCH_ID: searchId as AnyObject,
                WSRequestParams.WS_REQS_PARAM_RATE_KEY: hotelDetail.rates[selectedRoomRate].sRateKey as AnyObject,
                WSRequestParams.WS_REQS_PARAM_GROUP_CODE: hotelDetail.rates[selectedRoomRate].sGroupCode as AnyObject,
                WSResponseParams.WS_RESP_PARAM_LOGID: logId as AnyObject
            ]
            Helper.showLoader(onVC: self, message: "")
            WSManager.wsCallRecheckBooking(params) { recheckedHotelDetail, searchId in
                Helper.hideLoader(onVC: self)
                
                if let str = recheckedHotelDetail.sRate.sAvailabiltyStatus as? String, !str.isEmpty {
                    self.searchId = searchId
                    if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentViewController) as? WalletPaymentViewController {
                        
                        let holder: [String: AnyObject] = [
                            WSRequestParams.WS_REQS_PARAM_TITLE: holderTitle as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_NAME: holderFName as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_SURNAME: holderLName as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_EMAIL: holderEmail as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_PHONE_NUMBER: holderPhone as AnyObject,
                            WSResponseParams.WS_RESP_PARAM_CLIENT_NATIONALITY: "IN" as AnyObject
                        ]
                        
                        let bookingItem: [[String: AnyObject]] = [[
                            WSResponseParams.WS_RESP_PARAM_ROOM_CODE: self.hotelDetail.rates[self.selectedRoomRate].sRoomCode as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_RATE_KEY: self.hotelDetail.rates[self.selectedRoomRate].sRateKey as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_ROOMS: [
                                WSRequestParams.WS_REQS_PARAM_PAXES: self.guestDetails as AnyObject,
                            ] as AnyObject,
                        ]]
                        
                        let params: [String: AnyObject] = [
                            WSResponseParams.WS_RESP_PARAM_LOGID: self.logId as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_SEARCH_ID: self.searchId as AnyObject,
                            WSResponseParams.WS_RESP_PARAM_HOTEL_CODE: self.hotelDetail.sHotelCode as AnyObject,
                            WSResponseParams.WS_RESP_PARAM_CITY_CODE: self.hotelDetail.sCityCode as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_GROUP_CODE: self.hotelDetail.rates[self.selectedRoomRate].sGroupCode as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_CHECKIN: self.checkIn as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_CHECKOUT: self.checkOut as AnyObject,
                            WSResponseParams.WS_RESP_PARAM_PAYMENT_TYPE: (self.hotelDetail.rates[self.selectedRoomRate].sPaymentTypes.first ?? "") as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_HOLDER: holder as AnyObject,
                            WSRequestParams.WS_REQS_PARAM_BOOKING_ITEMS: bookingItem as AnyObject
                        ]
                        
                        vc.params = params
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: "Room Not Available!")
                }
            } failure: { error in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: error.localizedDescription)
            }
        }
        
        else {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.NO_INTERNET_CONNECTION)
            
        }
    }
}
