//
//  BusBookingViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 25/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class BusBookingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSeatCount: UILabel!
    @IBOutlet weak var lblstartDate: UILabel!
    @IBOutlet weak var lblPassangerCount: UILabel!
    @IBOutlet weak var lblBoardingPoint: UILabel!
    @IBOutlet weak var lblDroppingPoint: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var txtHolderAddress: UITextField!
    @IBOutlet weak var txtHolderIdType: UITextField!
    @IBOutlet weak var txtHolderIdNumber: UITextField!
    @IBOutlet weak var txtHolderPhone: UITextField!
    @IBOutlet weak var txtHolderEmail: UITextField!
    
    @IBOutlet weak var btnAgreement: UIButton!
    
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var guestDetails = [[String: AnyObject]]()
    var numberOfAdults = 1
    var bus = Bus()
    var markups : Markup?
    var checkInDate = Date()
    var selectedSeats = [BusSeat]()
    var selectedboardingPointIndex = 0
    var selectedDroppingPointIndex = 0
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
        
        self.lblName.text = bus.sTravels
        
        let date = Helper.convertDate(self.checkInDate)
        self.lblstartDate.text = date
        
        self.lblBoardingPoint.text = bus.sBusBoardingArr.count > 0 ? bus.sBusBoardingArr[selectedboardingPointIndex].sLocation : bus.sBusBoarding.sLocation
        self.lblDroppingPoint.text = bus.sBusDroppingArr.count > 0 ? (bus.sBusDroppingArr[selectedDroppingPointIndex].sLocation) : bus.sBusDropping.sLocation //
        var price: Double = selectedSeats.reduce(0) { $0 + $1.sFare }
        
        if let markup = markups as? Markup {
            if markup.amountBy == Strings.PERCENT {
                price += (price * (markup.amount) / 100)
            } else {
                price += (markup.amount)
            }
        }
        self.lblTotalPrice.text = "₹\(String(format: "%.0f", price))"
        self.lblSeatCount.text = "\(selectedSeats.count)"
        self.lblPassangerCount.text = "\(selectedSeats.count)"
        
        for i in 0..<selectedSeats.count {
            guestDetails.append(["title" : (titles.first ?? "") as AnyObject, "gender":  (genders.first ?? "") as AnyObject])
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func openDropDown(_ textfield: UITextField,_ array: [String], _ cellIndex : Int?, _ valueFor: String) {
        titleDropDown.show()
        titleDropDown.textColor = UIColor.black
        titleDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        titleDropDown.backgroundColor = UIColor.white
        titleDropDown.anchorView = textfield
        titleDropDown.dataSource = array
        titleDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
            
            if let row = cellIndex {
                guestDetails[row][valueFor] = item as AnyObject
            }
        }
    }
}

// MARK: - UIBUTTON ACTIONS
extension BusBookingViewController {
    
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
        blockTicket()
    }
}


// MARK: - UITABLEVIEW METHODS
extension BusBookingViewController: UITableViewDataSource, UITableViewDelegate {
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
        
        cell.lblNumber.text = "Seat: \(self.selectedSeats[indexPath.row].sName)"
        
        let detail = guestDetails[indexPath.row]
        
        if let item = detail["name"] as? String {
            cell.txtFirstName.text = item
        }
        if let item = detail["age"] as? String {
            cell.txtLastName.text = item
        }
        if let item = detail["title"] as? String {
            cell.txtTitle.text = item
        }
        if let item = detail["gender"] as? String {
            cell.txtState.text = item
        }
        
        return cell
    }
    
}

// MARK: - UITEXTFIELD DELEGATE
extension BusBookingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let row = textField.tag
        
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookingCell {
            if textField == cell.txtTitle {
                openDropDown(textField, self.titles , row, "title")
                return false
            }
            
            if textField == cell.txtState {
                openDropDown(textField, self.genders , row, "gender")
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let row = textField.tag
        
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? BookingCell
        {
            if textField == cell.txtFirstName {
                guestDetails[row]["name"] = textField.text as AnyObject
            }
            else if textField == cell.txtLastName {
                guestDetails[row]["age"] = textField.text as AnyObject
            }
            else if textField == cell.txtTitle {
                guestDetails[row]["title"] = textField.text as AnyObject
            }
            else if textField == cell.txtState {
                guestDetails[row]["gender"] = textField.text as AnyObject
            }
        }
    }
}

// MARK: - API CALL
extension BusBookingViewController {
    
    func blockTicket() {
        let holderAddress = self.txtHolderAddress.text ?? ""
        let holderIdType = self.txtHolderIdType.text ?? ""
        let holderIdNumber = self.txtHolderIdNumber.text ?? ""
        let holderEmail = self.txtHolderEmail.text ?? ""
        let holderPhone = self.txtHolderPhone.text ?? ""
        
        if holderEmail.isEmpty || holderPhone.isEmpty {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.Fill_FIELDS_REQUIRED)
            return
        } else if !Validator().isValid(email: holderEmail) {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.WRONG_EMAIL_FORMAT)
            return
        } else if btnAgreement.tag == 0 {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.AGREE_TERMS)
            return
        }
        
        var bookingItems = [[String: AnyObject]]()
        
        for (index, item) in selectedSeats.enumerated() {
            var passenger: [String: AnyObject] = guestDetails[index]
            
            if index == 0 {
                passenger[WSRequestParams.WS_RESP_PARAM_ID_TYPE] = holderIdType as AnyObject
                passenger[WSRequestParams.WS_RESP_PARAM_ID_NUMBER] = holderIdNumber as AnyObject
                passenger[WSResponseParams.WS_RESP_PARAM_ADDRESS] = holderAddress as AnyObject
                passenger[WSRequestParams.WS_REQS_PARAM_MOBILE] = holderPhone as AnyObject
                passenger[WSRequestParams.WS_REQS_PARAM_EMAIL] = holderEmail as AnyObject
                passenger[WSRequestParams.WS_REQS_PARAM_PRIMARY] = true as AnyObject
            }
            
            let inventoryItems: [String: AnyObject] = [
                WSResponseParams.WS_RESP_PARAM_FARE: item.sFare as AnyObject,
                WSResponseParams.WS_RESP_PARAM_LADIES_SEAT:   item.sLadiesSeat as AnyObject,
                WSRequestParams.WS_REQS_PARAM_SEAT_NAME: item.sName as AnyObject,
                WSRequestParams.WS_REQS_PARAM_PASSENGER: passenger as AnyObject,
            ]
            
            bookingItems.append(inventoryItems)
        }
        
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [
                WSRequestParams.WS_REQS_PARAM_AVAILABLE_TRIP_ID: bus.sBusId as AnyObject,
                WSRequestParams.WS_REQS_PARAM_BOARDING_POINT_ID: (bus.sBusBoardingArr.count > 0 ? bus.sBusBoardingArr[selectedboardingPointIndex].sBpId : bus.sBusBoarding.sBpId) as AnyObject,
                WSRequestParams.WS_RESP_PARAM_DESTINATION: bus.sDestinationCode as AnyObject,
                WSRequestParams.WS_RESP_PARAM_SOURCE: bus.sSourceCode as AnyObject,
                WSRequestParams.WS_REQS_PARAM_INVENTORY_ITEMS: bookingItems as AnyObject
            ]
            
            Helper.showLoader(onVC: self, message: "")
            WSManager.wsCallBusTicketBlock(params) { blockKey in
                Helper.hideLoader(onVC: self)
                
                if let vc = ViewControllerHelper.getViewController(ofType: .WalletPaymentViewController) as? WalletPaymentViewController {
                    
                    let params: [String: AnyObject] = [
                        WSRequestParams.WS_REQS_PARAM_BLOCK_KEY: blockKey as AnyObject,
                    ]
                    
                    var price: Double = self.selectedSeats.reduce(0) { $0 + $1.sFare }
                    
                    if let markup = self.markups as? Markup {
                        if markup.amountBy == Strings.PERCENT {
                            price += (price * (markup.amount) / 100)
                        } else {
                            price += (markup.amount)
                        }
                    }
                    
                    vc.screenFrom = .bus
                    vc.params = params
                    vc.totalPayable = price
                    vc.bookingType = Strings.BUS_BOOK
                     
                    self.navigationController?.pushViewController(vc, animated: true)
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

