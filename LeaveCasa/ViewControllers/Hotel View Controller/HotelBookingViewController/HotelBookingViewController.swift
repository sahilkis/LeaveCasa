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
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var txtGuestName: UITextField!
    @IBOutlet weak var txtGuestPhone: UITextField!
    @IBOutlet weak var txtGuestEmail: UITextField!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var hotels: Hotels?
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
    var ageOfChildren: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setLeftbarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
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
    
    func setLeftbarButton() {
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupData() {
        let hotel: Hotels?
        hotel = self.hotels
        
        if let address = hotel?.sAddress {
            self.lblHotelAddress.text = address
        }
        if let name = hotel?.sName {
            self.lblHotelName.text = name
        }
        if let minRate = hotel?.iMinRate {
            if let nonRefundable = minRate[WSResponseParams.WS_RESP_PARAM_NON_REFUNDABLE] as? Bool {
                //                if nonRefundable {
                //                    self.lblRefundable.text = Strings.NON_REFUNDABLE
                //                } else {
                //                    self.lblRefundable.text = Strings.REFUNDABLE
                //                }
            }
            if var price = minRate[WSResponseParams.WS_RESP_PARAM_PRICE] as? Double {
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
            }
        }
        if let rating = hotel?.iCategory {
            self.hotelRatingView.rating = Double(rating)
        }
    
        
        txtCheckIn.text = checkIn
        txtCheckOut.text = checkOut
        
        txtRoomCount.text = "\(numberOfRooms)"
        txtRoomType.text = "Deluxe" // TODO: Pending
        
        lblAdultCount.text = "Adults: \(numberOfAdults)"
        lblChildCount.text = "Child: \(ageOfChildren.count)"
        
        lblNumOfNights.text = "1" // TODO: Pending
        
        lblHotelRoomPrice.text = lblTotalPrice.text // TODO: Pending

        for i in 0..<numberOfAdults {
            guestDetails.append(["id" : i+1 as AnyObject]) // TODO: Pending
        }
    }
    
    func openDropDown(_ textfield: UITextField) {
        titleDropDown.show()
        titleDropDown.textColor = UIColor.black
        titleDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        titleDropDown.backgroundColor = UIColor.white
        titleDropDown.anchorView = textfield
        titleDropDown.dataSource = self.titles
        titleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
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
        if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentViewController) as? WalletPaymentViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        
        cell.txtState.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        // TODO: Pending - search state only
        
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
        
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookingCell {
            if textField == cell.txtTitle {
                openDropDown(textField)
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let row = textField.tag
        
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! BookingCell
        
        if textField == cell.txtFirstName {
            guestDetails[row]["first_name"] = textField.text as AnyObject
        }
        else if textField == cell.txtLastName {
            guestDetails[row]["last_name"] = textField.text as AnyObject
        }
        else if textField == cell.txtTitle {
            guestDetails[row]["title"] = textField.text as AnyObject
        }
        else if textField == cell.txtState {
            guestDetails[row]["state"] = textField.text as AnyObject
        }
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
