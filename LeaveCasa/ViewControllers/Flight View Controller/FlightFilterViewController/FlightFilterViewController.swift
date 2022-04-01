//
//  FlightFilterViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 31/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import DropDown

protocol FlightFilterDelegate {
    func applyFilter(flightTime: Int, flightStop:Int , flightType: Int)
}

class FlightFilterViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnStops1: UIButton!
    @IBOutlet weak var btnStops2: UIButton!
    @IBOutlet weak var btnType1: UIButton!
    @IBOutlet weak var btnType2: UIButton!
    @IBOutlet weak var btnType3: UIButton!
    @IBOutlet weak var btnType4: UIButton!
    @IBOutlet weak var btnType5: UIButton!
    @IBOutlet weak var btnType6: UIButton!
    @IBOutlet weak var btnFund1: UIButton!
    @IBOutlet weak var btnFund2: UIButton!
    @IBOutlet weak var txtAirlines: UITextField!
    
    
    var delegate: FlightFilterDelegate?
    var classDropDown = DropDown()
    
//    var flightAirlinesArray = ["All"]
    var flightTime = 0  // 0 - No filter, 1 - mor, 2 - aft, 3 - eve
    var flightStop = 0  // 0 - No filter, 1 - One stop only, 2 - No stops
    var flightType = 0  // 0 - No filter, 1-6 for Appconstants.filterTypes
    
    var flightStopButtons = [UIButton]()
    var flightTypeButtons = [UIButton]()
//    var flightType: [Int] = []
//    var flightAirline: Int = 0
//    var fundType: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        txtAirlines.delegate = self
//        setupDropDown(txtAirlines)
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        
        flightStopButtons = [btnStops1, btnStops2]
        flightTypeButtons = [btnType1, btnType2, btnType3, btnType4, btnType5, btnType6]
                
        setButtons(flightStopButtons, selectedIndex: flightStop)
        setButtons(flightTypeButtons, selectedIndex: flightType)
        
        self.collectionView.reloadData()
//        self.txtAirlines.text = flightAirlinesArray[flightAirline]
//        setRadioButton()
    }
    
    func setButtons(_ buttons: [UIButton], selectedIndex : Int ) {
        
        for (index, item) in buttons.enumerated()
        {
                item.tag = 0
                setButtonImages(item)
                
                if selectedIndex - 1 == index
                {
                    item.tag = 1
                    setButtonImages(item)
                } else {
                    item.tag = 0
                    setButtonImages(item)
                }
            
            if buttons == flightTypeButtons {
                item.setTitle(" " + AppConstants.flightTypes[index], for: .normal)
            }
        }
    }
    
    func setButtonImages(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.setImage(LeaveCasaIcons.CHECKBOX_BLUE, for: .normal)
        } else {
            sender.setImage(LeaveCasaIcons.CHECKBOX_GREY, for: .normal)
        }
    }
//
//    func setRadioButton() {
//        if flightStop == 0 {
//            btnStops1.setImage(LeaveCasaIcons.RADIO_BLUE, for: .normal)
//            btnStops2.setImage(LeaveCasaIcons.RADIO_GREY, for: .normal)
//        } else {
//            btnStops1.setImage(LeaveCasaIcons.RADIO_GREY, for: .normal)
//            btnStops2.setImage(LeaveCasaIcons.RADIO_BLUE, for: .normal)
//        }
//    }
    
//    func setupDropDown(_ textfield: UITextField) {
//
//        classDropDown.textColor = UIColor.black
//        classDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
//        classDropDown.backgroundColor = UIColor.white
//        classDropDown.anchorView = textfield
//        classDropDown.dataSource = self.flightAirlinesArray
//        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//            flightAirline = index
//            self.txtAirlines.text = flightAirlinesArray[index]
//
//
//        }
//    }
    
}

extension FlightFilterViewController {
    
    @IBAction func btnReset(_ sender: UIButton) {
        flightTime = 0
        flightStop = 0
        flightType = 0
//        flightType = []
//        flightAirline = 0
//        fundType = []
        
        setupData()
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
       
        
        for (index, button) in flightTypeButtons.enumerated() {
           
                if button.tag  == 1
                {
                    flightType = index + 1
                }
            
        }
        for (index, button) in flightStopButtons.enumerated() {
           if button.tag  == 1
                {
                    flightStop = index + 1
                }
            
        }
        
        
        
        self.delegate?.applyFilter(flightTime: flightTime, flightStop:flightStop, flightType: flightType)
        
    }
    
    @IBAction func btnStop1(_ sender: UIButton) {
        flightStop = 1
        setButtons(flightStopButtons, selectedIndex: flightStop)
    }
    @IBAction func btnStop2(_ sender: UIButton) {
        flightStop = 2
        setButtons(flightStopButtons, selectedIndex: flightStop)
    }
    
    @IBAction func btnTypes(_ sender: UIButton) {
        sender.tag = (sender.tag == 0 ) ? 1 : 0
        
        for (index, button) in flightTypeButtons.enumerated() {
            if sender == button {
                flightType = index + 1
                break
            }
        }
        
        setButtons(flightTypeButtons, selectedIndex: flightType)
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension FlightFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return AppConstants.flightTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.FlightListCollectionCell, for: indexPath) as! FlightListCollectionCell
        
        let date = AppConstants.flightTimes[indexPath.row]
        
        if flightTime - 1 == indexPath.row
        {
            cell.viewBg.backgroundColor = LeaveCasaColors.PINK_COLOR
            cell.lblMonth.textColor = .clear
            cell.lblDay.textColor = .white
        }else{
            cell.viewBg.backgroundColor = LeaveCasaColors.VIEW_BG_COLOR
            cell.lblMonth.textColor = .clear
            cell.lblDay.textColor = LeaveCasaColors.LIGHT_GRAY_COLOR
        }
        
        cell.lblMonth.text = ""
        cell.lblDay.text = date.uppercased()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        flightTime = indexPath.row + 1
        collectionView.reloadData()
    }
}

// MARK: - UITEXTFIELD DELEGATE
extension FlightFilterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtAirlines {
            classDropDown.show()
            return false
        }
        else {
            return false
        }
    }
}
