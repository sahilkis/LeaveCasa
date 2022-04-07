//
//  BusDetailViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 25/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class BusDetailViewController: UIViewController {
    
    @IBOutlet weak var lblNoOfSeats: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var txtSource: SearchTextField!
    @IBOutlet weak var txtDestination: SearchTextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtBoardingPoint: SearchTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var buses = Bus()
    var markups : Markup?
    var date = Date()
    var searchedParams = [String: AnyObject] ()
    var souceName = ""
    var destinationName = ""
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var busLayout: BusLayout?
    var boardingArray = [BusBoarding]()
    var selectedboardingPointIndex = 0
    var classDropDown = DropDown()
    var selectedSeats = [BusSeat]()
    var seats = [BusSeat]()
    var noOfRows = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setLeftbarButton()
        searchBusLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                self.collectionViewHeightConstraint.constant = newSize.height
                
            }
        }
    }
    
    func setLeftbarButton() {
        self.title = " "
        let leftBarButton = UIBarButtonItem.init(image: LeaveCasaIcons.BLACK_BACK, style: .plain, target: self, action: #selector(backClicked(_:)))
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupData() {
        
        self.txtSource.text = self.souceName
        self.txtDestination.text = self.destinationName
        self.txtDate.text = Helper.convertDate(self.date)
        
        self.collectionView.reloadData()
        
        self.boardingArray = buses.sBusBoardingArr.count > 0 ? buses.sBusBoardingArr : [buses.sBusBoarding]
        self.txtBoardingPoint.text = boardingArray[selectedboardingPointIndex].sLocation
        txtBoardingPoint.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
    }
    
    private func setupPrice() {
        let filter = self.seats.filter({$0.isSelected})
        
        var price: Double = filter.reduce(0) { $0 + $1.sFare }
        
        if let markup = markups as? Markup {
            if markup.amountBy == Strings.PERCENT {
                price += (price * (markup.amount) / 100)
                } else {
                    price += (markup.amount)
                }
        }
        self.lblTotalPrice.text = "Total Fare: ₹\(String(format: "%.0f", price))"
        self.lblNoOfSeats.text = "Seat(s): \(filter.count)"
    }
}

// MARK: - UIBUTTON ACTIONS
extension BusDetailViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.selectedSeats = self.seats.filter({$0.isSelected})

        if selectedSeats.count > 0 {
            if let vc = ViewControllerHelper.getViewController(ofType: .BusBookingViewController) as? BusBookingViewController {
                
                vc.markups = markups
                vc.selectedSeats = selectedSeats
                vc.checkInDate = date
                vc.bus = buses
                vc.selectedboardingPointIndex = selectedboardingPointIndex
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension BusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1//noOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seats.count // /4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.SeatCell, for: indexPath) as! SeatCell
        
        let seat = self.seats[indexPath.row]
        
        if seat.sAvailable {
            cell.image.image = LeaveCasaIcons.SEAT_BLACK
            
            if seat.sLadiesSeat {
                cell.image.image = LeaveCasaIcons.SEAT_RED
            }
            if seat.isSelected {
                cell.image.image = LeaveCasaIcons.SEAT_GREY
            }
        } else {
            cell.image.image = LeaveCasaIcons.SEAT_BLUE
            
            if seat.sLadiesSeat {
                cell.image.image = LeaveCasaIcons.SEAT_YELLOW
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seat = self.seats[indexPath.row]
        
        if seat.sAvailable {
            seat.isSelected = !seat.isSelected
            self.collectionView.reloadData()
            self.setupPrice()
        }
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension BusDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtBoardingPoint {
            
            return true
        }
        else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
    }
}

// MARK: - API CALL
extension BusDetailViewController {
    
    @objc func searchCity(_ sender: SearchTextField) {
        if self.cityName.count > 0 {
            self.cityName.removeAll()
        }
        
        if self.cityCode.count > 0 {
            self.cityCode.removeAll()
        }
        let text = sender.text ?? ""
        let filter: [String] = buses.sBusBoardingArr.filter({$0.sLocation.lowercased().contains(text.lowercased())}).map({$0.sLocation})
        
        setupSearchTextField(filter, textField: txtBoardingPoint)
        
        //fetchCityList(sender)
    }
    
    func setupSearchTextField(_ searchedArray: [String], textField: SearchTextField) {
        DispatchQueue.main.async {
            
            textField.theme = SearchTextFieldTheme.lightTheme()
            textField.theme.font = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
            textField.theme.bgColor = UIColor.white
            textField.theme.fontColor = UIColor.black
            textField.theme.cellHeight = 40
            textField.filterStrings(searchedArray)
            textField.itemSelectionHandler = { filteredResults, itemPosition in
                let item = filteredResults[itemPosition]
                if let index = self.boardingArray.firstIndex(where: {$0.sLocation == item.title})
                {
                self.selectedboardingPointIndex = index
                self.txtBoardingPoint.text = self.boardingArray[index].sLocation
                self.txtBoardingPoint.resignFirstResponder()
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
            self.setupSearchTextField(self.cityName , textField: sender)
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
    
    func searchBusLayout() {
        
        Helper.showLoader(onVC: self, message: "")
        
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [
                WSRequestParams.WS_REQS_PARAM_BUS_ID : buses.sBusId as AnyObject
            ]
            
            WSManager.wsCallFetchBusSeatLayout(params, success: { (layouts) in
                Helper.hideLoader(onVC: self)
                
                self.busLayout = layouts
                self.seats = (self.busLayout?.sSeats ?? []).sorted(by: { s1, s2 in
                    if let r1 = Int(s1.sName), let r2 = Int(s2.sName) {
                        return r1 < r2
                    }
                    return s1.sName < s2.sName
                })
                    .sorted(by: { s1, s2 in
                        if let r1 = Int(s1.sRow), let r2 = Int(s2.sRow) {
                            return r1 < r2
                        }
                        return s1.sRow < s2.sRow
                })
                
                self.noOfRows = Array(Set(self.seats.map { bus in
                    bus.sRow
                })).count

                self.collectionView.reloadData()
                
            }, failure: { (error) in
                Helper.hideLoader(onVC: self)
                Helper.showOKAlert(onVC: self, title: Alert.ERROR, message: error.localizedDescription)
            })
        } else {
            Helper.hideLoader(onVC: self)
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: Alert.NO_INTERNET, message: AlertMessages.NO_INTERNET_CONNECTION, btnOkTitle: Alert.TRY_AGAIN, btnCancelTitle: Alert.CANCEL, onOk: {
                Helper.showLoader(onVC: self, message: Alert.LOADING)
                //         self.searchBus()
            })
        }
        
    }
}

