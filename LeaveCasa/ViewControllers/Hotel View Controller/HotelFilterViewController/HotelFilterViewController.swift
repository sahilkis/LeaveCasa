//
//  HotelFilterViewController.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 05/04/22.
//  Copyright © 2022 Apple. All rights reserved.
//


import UIKit

protocol HotelFilterDelegate {
    func applyFilter(rating: [Int])
}

class HotelFilterViewController: UIViewController {
    
    @IBOutlet weak var btnType1: UIButton!
    @IBOutlet weak var btnType2: UIButton!
    @IBOutlet weak var btnType3: UIButton!
    @IBOutlet weak var btnType4: UIButton!
    @IBOutlet weak var btnType5: UIButton!
    
    var delegate: HotelFilterDelegate?
    
    var selectedRatings = [Int]()  //  count 0 - No filter, 1 or more - rating
    
    var hotelRatingButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        
        hotelRatingButtons = [btnType5, btnType4, btnType3, btnType2, btnType1]
        
        setButtons(hotelRatingButtons, selectedIndex: selectedRatings)
        
    }
    
    func setButtons(_ buttons: [UIButton], selectedIndex : [Int] ) {
        
        for (index, item) in buttons.enumerated()
        {
            item.tag = 0
            setButtonImages(item)
            
            if selectedIndex.contains(index + 1)
            {
                item.tag = 1
                setButtonImages(item)
            } else {
                item.tag = 0
                setButtonImages(item)
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
}

extension HotelFilterViewController {
    
    @IBAction func btnReset(_ sender: UIButton) {
        selectedRatings = []
        
        setupData()
    }
    
    @IBAction func btnApply(_ sender: UIButton) {
        
        self.delegate?.applyFilter(rating: selectedRatings)
        
    }
    
    @IBAction func btnTypes(_ sender: UIButton) {
        sender.tag = (sender.tag == 0 ) ? 1 : 0
        
        for (index, button) in hotelRatingButtons.enumerated() {
            if sender == button {
                if sender.tag == 0 {
                    if let firstIndex = selectedRatings.firstIndex(where: ({ $0 == index+1})) {
                        selectedRatings.remove(at: firstIndex)
                    }
                } else {
                    selectedRatings.append(index + 1)
                    selectedRatings = Array(Set(selectedRatings))
                }
                break
            }
        }
        
        setButtons(hotelRatingButtons, selectedIndex: selectedRatings)
    }
}
