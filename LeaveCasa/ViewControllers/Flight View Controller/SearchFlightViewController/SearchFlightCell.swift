//
//  SearchFlightCell.swift
//  LeaveCasa
//
//  Created by macmini-2020 on 14/03/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown

class SearchFlightCell: UITableViewCell {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCloseHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSouce: UIView!
    @IBOutlet weak var viewDestination: UIView!
    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var viewTo: UIView!
    @IBOutlet weak var viewClass: UIView!
    @IBOutlet weak var txtSource: SearchTextField!
    @IBOutlet weak var txtDestination: SearchTextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var txtClass: UITextField!
    @IBOutlet weak var btnAddCity: UIButton!
    @IBOutlet weak var btnAddCityHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpIndex(indexpath: IndexPath)
    {
        btnClose.tag = indexpath.row
        btnAddCity.tag = indexpath.row
        txtSource.tag = indexpath.row
        txtDestination.tag = indexpath.row
        txtFrom.tag = indexpath.row
        txtTo.tag = indexpath.row
        txtClass.tag = indexpath.row
        
    }
    
    func setUpUI(indexpath: IndexPath, selectedTab : Int, isLast : Bool) {
        switch selectedTab
        {
        case 0:
             btnClose.isHidden  = true
             btnCloseHeight.constant = 0
             btnAddCity.isHidden  = true
             btnAddCityHeight.constant = 0
             viewTo.isHidden  = true
        case 1:
             btnClose.isHidden  = true
             btnCloseHeight.constant = 0
             btnAddCity.isHidden  = true
             btnAddCityHeight.constant = 0
             viewTo.isHidden  = false
        case 2:
            if indexpath.row == 0 {
                 btnClose.isHidden  = true
                 btnCloseHeight.constant = 0
            }
            else {
                 btnClose.isHidden  = false
                 btnCloseHeight.constant = 35
            }
            if !isLast || indexpath.row >= 4
            {
                btnAddCity.isHidden  = true
                btnAddCityHeight.constant = 0
            }
            else {
                btnAddCity.isHidden  = false
                btnAddCityHeight.constant = 44
            }
             viewTo.isHidden  = true
        default:
            break
        }
    }
}
