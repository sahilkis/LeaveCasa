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
    @IBOutlet weak var viewDroppingPoint: UIView!
    @IBOutlet weak var txtBoardingPoint: UITextField!
    @IBOutlet weak var txtDroppingPoint: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperSeatsView: UIView!
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var upperCollectionViewHeightConstraint: NSLayoutConstraint!
    
    var bus = Bus()
    var markups : Markup?
    var date = Date()
    var searchedParams = [String: AnyObject] ()
    var souceName = ""
    var destinationName = ""
    var busLayout: BusLayout?
    var boardingArray = [BusBoarding]()
    var droppingArray = [BusBoarding]()
    var selectedboardingPointIndex = 0
    var selecteddroppingPointIndex = 0
    var classDropDown = DropDown()
    var selectedSeats = [BusSeat]()
    var seats = [BusSeat]()
    //    var noOfRows = 1
    //    var noOfColumns = 1
    var rowsOfSeats = [Int]()
    var columnsOfSeats = [Int]()
    var isZIndex = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.upperSeatsView.isHidden = !self.isZIndex
        self.upperCollectionViewHeightConstraint.constant = 0
        self.upperCollectionView.reloadData()
        setupData()
        setLeftbarButton()
        searchBusLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        self.upperCollectionView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collectionView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
        self.upperCollectionView.removeObserver(self, forKeyPath: Strings.CONTENT_SIZE)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[.newKey] {
            if let newSize = newValue as? CGSize {
                if let collection = object as? UICollectionView, collection == self.upperCollectionView  {
//                     self.upperCollectionViewHeightConstraint.constant = newSize.height + 50
                } else {
                    self.collectionViewHeightConstraint.constant = newSize.height
                }
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
        self.upperCollectionView.reloadData()
        
        self.boardingArray = bus.sBusBoardingArr.count > 0 ? bus.sBusBoardingArr : [bus.sBusBoarding]
        self.txtBoardingPoint.text = boardingArray[selectedboardingPointIndex].sLocation
        
        //        self.viewDroppingPoint.isHidden = !bus.sDropPointMandatory
        self.selecteddroppingPointIndex = bus.sBusDroppingArr.count > 0 ? bus.sBusDroppingArr.count - 1 : 0
        self.droppingArray = bus.sBusDroppingArr.count > 0 ? bus.sBusDroppingArr : [bus.sBusDropping]
        self.txtDroppingPoint.text = droppingArray[selecteddroppingPointIndex].sLocation
        //        self.txtBoardingPoint.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
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
    
    func openDropDown(_ textfield: UITextField) {
        var array: [String] = boardingArray.map { bus in
            bus.sLocation
        }
        
        if textfield == self.txtDroppingPoint {
            array = droppingArray.map { bus in
                bus.sLocation
            }
        }
        
        classDropDown.show()
        classDropDown.textColor = UIColor.black
        classDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        classDropDown.backgroundColor = UIColor.white
        classDropDown.anchorView = textfield
        classDropDown.dataSource = array
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textfield.text = item
            textfield.resignFirstResponder()
            if textfield == self.txtBoardingPoint {
                self.selectedboardingPointIndex = index
            }
            else if textfield == self.txtDroppingPoint {
                self.selecteddroppingPointIndex = index
            }
        }
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
                vc.bus = bus
                vc.selectedboardingPointIndex = selectedboardingPointIndex
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            Helper.showOKAlert(onVC: self, title: Alert.ALERT, message: AlertMessages.SELECT_SEAT)
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension BusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == self.upperCollectionView && !self.isZIndex{
            return 0
        }
        return columnsOfSeats.count ?? 0//noOfColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.upperCollectionView && !self.isZIndex{
            return 0
        }
        return rowsOfSeats.count ?? 0//noOfRows//seats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.SeatCell, for: indexPath) as! SeatCell
        
        //        let seat = self.seats[indexPath.row]
        
        var zIndex = 0
        
        if collectionView == self.upperCollectionView && self.isZIndex {
            zIndex = 1
        }
        
        if let seat = self.seats.first(where: { seat in
            seat.sColumn == columnsOfSeats[indexPath.section] && seat.sRow == rowsOfSeats[indexPath.row] && seat.sZIndex == zIndex
        }) {
            
            cell.image.isHidden = false
            if seat.sAvailable {
                cell.image.image = LeaveCasaIcons.SEAT_BLACK
                
                if seat.sLength > 1 {
                    cell.image.image = LeaveCasaIcons.SLEEPER_BLACK
                } else if seat.sWidth > 1 {
                    cell.image.image = LeaveCasaIcons.SLEEPER_BLACK_VERT
                }
                if seat.sLadiesSeat {
                    cell.image.image = LeaveCasaIcons.SEAT_RED
                    
                    if seat.sLength > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_RED
                    } else if seat.sWidth > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_RED_VERT
                    }
                }
                if seat.isSelected {
                    cell.image.image = LeaveCasaIcons.SEAT_GREY
                    
                    if seat.sLength > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_GREY
                    } else if seat.sWidth > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_GREY_VERT
                    }
                }
            } else {
                cell.image.image = LeaveCasaIcons.SEAT_BLUE
                
                if seat.sLength > 1 {
                    cell.image.image = LeaveCasaIcons.SLEEPER_BLUE
                } else if seat.sWidth > 1 {
                    cell.image.image = LeaveCasaIcons.SLEEPER_BLUE_VERT
                }
                
                if seat.sLadiesSeat {
                    cell.image.image = LeaveCasaIcons.SEAT_YELLOW
                    
                    if seat.sLength > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_YELLOW
                    } else if seat.sWidth > 1 {
                        cell.image.image = LeaveCasaIcons.SLEEPER_YELLOW_VERT
                    }
                }
            }
        }
        else{
            cell.image.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var zIndex = 0
        
        if collectionView == self.upperCollectionView && self.isZIndex {
            zIndex = 1
        }
        if let index = self.seats.firstIndex(where: { seat in
            seat.sColumn == columnsOfSeats[indexPath.section] && seat.sRow == rowsOfSeats[indexPath.row] && seat.sZIndex == zIndex
        }) {
            
            if seats[index].sAvailable {
                seats[index].isSelected = !seats[index].isSelected
                self.collectionView.reloadData()
                self.upperCollectionView.reloadData()
                self.setupPrice()
            }
        }
    }
}

extension BusDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = UIScreen.main.bounds.width//collectionView.bounds.width
        var length = 1.0
        var width = 1.0
        
        var zIndex = 0
        
        if collectionView == self.upperCollectionView && self.isZIndex {
            zIndex = 1
        }
        
        if collectionView == self.collectionView {
            if let index = self.seats.firstIndex(where: { seat in
                seat.sColumn == indexPath.section && seat.sRow == indexPath.row && seat.sZIndex == zIndex
            }) {
                length = Double(seats[index].sLength)
                width = Double(seats[index].sWidth)
            }
            
            if length == width {
                return CGSize(width: 25, height: 25)
            }
            else if length > width {
                return CGSize(width: 50, height: 25)
            }
            else {
                return CGSize(width: 25, height: 50)
            }
        }
        else {
            if let index = self.seats.firstIndex(where: { seat in
                seat.sColumn == indexPath.section && seat.sRow == indexPath.row && seat.sZIndex == zIndex
            }) {
                length = Double(seats[index].sLength)
                width = Double(seats[index].sWidth)
            }
            
            return CGSize(width: (collectionWidth/CGFloat(columnsOfSeats.count))*length, height: (collectionWidth/CGFloat(columnsOfSeats.count))*width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension BusDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtBoardingPoint || textField == self.txtDroppingPoint {
            openDropDown(textField)
            return false
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
    
    func searchBusLayout() {
        
        Helper.showLoader(onVC: self, message: "")
        
        if WSManager.isConnectedToInternet() {
            let params: [String: AnyObject] = [
                WSRequestParams.WS_REQS_PARAM_BUS_ID : bus.sBusId as AnyObject
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
                        return s1.sRow < s2.sRow
                    })
                    .sorted(by: { s1, s2 in
                        return s1.sColumn < s2.sColumn
                    })
                
                //                self.noOfRows = Array(Set(self.seats.map { bus in
                //                    bus.sRow
                //                })).count
                //                self.noOfColumns = Array(Set(self.seats.map { bus in
                //                    bus.sColumn
                //                })).count
                self.rowsOfSeats = Array(Set(self.seats.map { bus in
                    bus.sRow
                })).sorted(by: { s1, s2 in
                    return s1 < s2
                })
                self.columnsOfSeats = Array(Set(self.seats.map { bus in
                    bus.sColumn
                })).sorted(by: { s1, s2 in
                    return s1 < s2
                })
                let zindex = Array(Set(self.seats.map { bus in
                    bus.sZIndex
                })).sorted(by: { s1, s2 in
                    return s1 < s2
                }).count
                
                self.collectionView.reloadData()
                
                self.isZIndex = zindex > 1 ? true: false
                self.upperSeatsView.isHidden = !self.isZIndex
                self.upperCollectionViewHeightConstraint.constant = self.isZIndex ? 200 : 0

                self.upperCollectionView.reloadData()
                
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

