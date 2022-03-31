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
    func applyFilter(flightTime: Int, flightStop:Int , flightType: [Int], flightAirline: Int, fundType: [Int])
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
    @IBOutlet weak var btnFund1: UIButton!
    @IBOutlet weak var btnFund2: UIButton!
    @IBOutlet weak var txtAirlines: UITextField!
    
    
    var delegate: FlightFilterDelegate?
    var classDropDown = DropDown()
    
    var flightTimesArray = ["MOR", "AFT", "EVE"]
    var flightAirlinesArray = ["All"]
    var flightTime: Int = 0
    var flightStop:Int = 0
    var flightType: [Int] = []
    var flightAirline: Int = 0
    var fundType: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtAirlines.delegate = self
        setupDropDown(txtAirlines)
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setButtonImages(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.setImage(LeaveCasaIcons.CHECKBOX_BLUE, for: .normal)
        } else {
            sender.setImage(LeaveCasaIcons.CHECKBOX_GREY, for: .normal)
        }
    }
    
    func setupData() {
        
        btnFund1.tag = 0
        setButtonImages(btnFund1)
        btnFund2.tag = 0
        setButtonImages(btnFund2)
        btnType1.tag = 0
        setButtonImages(btnType1)
        btnType2.tag = 0
        setButtonImages(btnType2)
        btnType3.tag = 0
        setButtonImages(btnType3)
        btnType4.tag = 0
        setButtonImages(btnType4)
        btnType5.tag = 0
        setButtonImages(btnType5)
        
        
        self.txtAirlines.text = flightAirlinesArray[flightAirline]
        setRadioButton()
        
        for i in fundType {
            if i == 0
            {
                btnFund1.tag = 1
                setButtonImages(btnFund1)
            }else if i == 1
            {
                btnFund2.tag = 1
                setButtonImages(btnFund2)
            }
        }
        
        let buttonArray = [btnType1, btnType2, btnType3, btnType4, btnType5]
        
        for (index, item) in buttonArray.enumerated()
        {
            if let item = item {
                if flightType.contains(index)
                {
                    item.tag = 1
                    setButtonImages(item)
                } else {
                    item.tag = 0
                    setButtonImages(item)
                }
            }
        }
        
    }
    
    func setRadioButton() {
        if flightStop == 0 {
            btnStops1.setImage(LeaveCasaIcons.RADIO_BLUE, for: .normal)
            btnStops2.setImage(LeaveCasaIcons.RADIO_GREY, for: .normal)
        } else {
            btnStops1.setImage(LeaveCasaIcons.RADIO_GREY, for: .normal)
            btnStops2.setImage(LeaveCasaIcons.RADIO_BLUE, for: .normal)
        }
    }
    
    func setupDropDown(_ textfield: UITextField) {
        
        classDropDown.textColor = UIColor.black
        classDropDown.textFont = LeaveCasaFonts.FONT_PROXIMA_NOVA_REGULAR_12 ?? UIFont.systemFont(ofSize: 12)
        classDropDown.backgroundColor = UIColor.white
        classDropDown.anchorView = textfield
        classDropDown.dataSource = self.flightAirlinesArray
        classDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            flightAirline = index
            self.txtAirlines.text = flightAirlinesArray[index]
            
            
        }
    }
    
}

extension FlightFilterViewController {
    
    @IBAction func btnReset(_ sender: UIButton) {
        flightTime = 0
        flightStop = 0
        flightType = []
        flightAirline = 0
        fundType = []
        
        setupData()
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        let buttonTypeArray = [btnType1, btnType2, btnType3, btnType4, btnType5]
        let buttonFundArray = [btnFund1, btnFund2]
        
        flightType.removeAll()
        fundType.removeAll()
        
        for (index, item) in buttonTypeArray.enumerated() {
            if let button = item {
                if button.tag  == 1
                {
                    flightType.append(index)
                }
            }
        }
        for (index, item) in buttonFundArray.enumerated() {
            if let button = item {
                if button.tag  == 1
                {
                    fundType.append(index)
                }
            }
        }
        
        
        
        self.delegate?.applyFilter(flightTime: flightTime, flightStop:flightStop, flightType: flightType, flightAirline: flightAirline, fundType: fundType)
        
    }
    
    @IBAction func btnStop1(_ sender: UIButton) {
        flightStop = 0
        setRadioButton()
    }
    @IBAction func btnStop2(_ sender: UIButton) {
        flightStop = 0
        setRadioButton()
    }
    
    @IBAction func btnTypes(_ sender: UIButton) {
        sender.tag = (sender.tag == 0 ) ? 1 : 0
        setButtonImages(sender)
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension FlightFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flightTimesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.FlightListCollectionCell, for: indexPath) as! FlightListCollectionCell
        
        let date = flightTimesArray[indexPath.row]
        
        if flightTime == indexPath.row
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
        
        flightTime = indexPath.row
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
