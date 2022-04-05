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

    @IBOutlet weak var txtSource: SearchTextField!
    @IBOutlet weak var txtDestination: SearchTextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtBoardingPoint: SearchTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    var buses = Bus()
        var checkInDate = ""
    var date = Date()
        var searchedParams = [String: AnyObject] ()
        var souceName = ""
        var destinationName = ""
    lazy var cityCode = [String]()
    lazy var cityName = [String]()
    lazy var cityCodeStr = ""
    var busDetails = [[String: AnyObject]]()
    var numberOfSeats = 1
    var boardingArray = [BusBoarding]()
    var selectedboardingPoint = ""
    var classDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setLeftbarButton()
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
        
        for i in 0..<numberOfSeats {
            busDetails.append(["id" : i as AnyObject])
        }
        
        self.collectionView.reloadData()
        
        self.boardingArray = buses.sBusBoarding
        self.txtBoardingPoint.text = boardingArray.first?.sLocation ?? ""
        txtBoardingPoint.addTarget(self, action: #selector(searchCity(_:)), for: .editingChanged)
        
    }
    
}

// MARK: - UIBUTTON ACTIONS
extension BusDetailViewController {
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
                if let vc = ViewControllerHelper.getViewController(ofType: .BusBookingViewController) as? BusBookingViewController {
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension BusDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(busDetails.count/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.SeatCell, for: indexPath) as! SeatCell
         
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
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
        let filter: [String] = buses.sBusBoarding.filter({$0.sLocation.lowercased().contains(text.lowercased())}).map({$0.sLocation})
        
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
                    
                   // textField.text = item
                    self.txtBoardingPoint.resignFirstResponder()
               
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
}

